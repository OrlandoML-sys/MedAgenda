package controlador;

import datos.DAO.doctorDAO;
import datos.DAO.usuarioDAO;
import modelo.EmailService;
import modelo.Seguridad;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

/**
 * Controlador Frontal de Autenticación y Alta de Usuarios.
 * Orquesta la seguridad, validaciones con la SEP y el despacho de correos transaccionales.
 */
@WebServlet("/UsuarioServlet")
public class usuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Deriva la petición según la acción definida en el formulario (Input hidden)
        String accion = request.getParameter("accion");

        if (accion.equals("login")) {
            procesarLogin(request, response);
        } else if (accion.equals("registro")) {
            procesarRegistro(request, response);
        }
    }

    private void procesarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("txtUser");
        String pass = request.getParameter("txtPass");

        usuarioDAO uDAO = new usuarioDAO();
        // SEGURIDAD: Valida credenciales enviando la contraseña encriptada (SHA/MD5 según modelo)
        Usuario u = uDAO.validar(user, Seguridad.encriptar(pass));

        if (u != null) {
            if (u.isEstaActivo()) {
                // Genera una sesión HTTP y almacena el objeto Usuario global
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", u);

                // CONTROL DE ACCESO BASADO EN ROLES: Despacha al Dashboard correspondiente
                String rol = u.getRol();
                if("DOCTOR".equals(rol)) {
                    response.sendRedirect("dashboardDoctor.jsp");
                } else if ("PACIENTE".equals(rol)) {
                    response.sendRedirect("dashboardPaciente.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                // ADUANA DE ESTADO: Bloquea el acceso si no ha confirmado el correo
                request.setAttribute("errorLogin", "Tu cuenta aún no está activada. Por favor, revisa tu correo electrónico para verificarla.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorLogin", "Usuario o contraseña incorrectos.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private void procesarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            // 1. CAPTURA Y SANITIZACIÓN DE DATOS
            String user = request.getParameter("regUser");
            String pass = request.getParameter("regPass");
            String tipo = request.getParameter("tipoUsuario");
            String passEncriptada = modelo.Seguridad.encriptar(pass);
            String correo = request.getParameter("correo");
            String phoneNumber = request.getParameter("phone");

            if (phoneNumber == null || !phoneNumber.matches("\\d{10}")) {
                request.setAttribute("error", "El número telefónico debe tener 10 dígitos numéricos.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            String nom = request.getParameter("nom");
            String pat = request.getParameter("pat");
            String mat = request.getParameter("mat");

            // 2. ADUANA DE SEGURIDAD SEP (Exclusivo Doctores)
            if ("DOCTOR".equals(tipo)) {
                String cedulaInput = request.getParameter("cedula");
                datos.DAO.sepDAO sDAO = new datos.DAO.sepDAO();
                modelo.CedulaSEP cedulaValidada = sDAO.consultarCedulaOficial(cedulaInput);

                // Filtro 2.1: Existencia de la cédula en el padrón
                if (cedulaValidada == null) {
                    System.out.println("⚠️ SEGURIDAD: Intento de registro con cédula inexistente: " + cedulaInput);
                    response.sendRedirect("index.jsp?errorCedula=1");
                    return;
                }

                // Filtro 2.2: Prevención de Usurpación de Identidad (Match Biográfico)
                boolean coincideNombre = cedulaValidada.getNombre().equalsIgnoreCase(nom.trim());
                boolean coincidePaterno = cedulaValidada.getPaterno().equalsIgnoreCase(pat.trim());

                boolean coincideMaterno = true;
                if (cedulaValidada.getMaterno() != null && !cedulaValidada.getMaterno().trim().isEmpty()) {
                    String matInput = (mat != null) ? mat.trim() : "";
                    coincideMaterno = cedulaValidada.getMaterno().equalsIgnoreCase(matInput);
                }

                if (!coincideNombre || !coincidePaterno || !coincideMaterno) {
                    System.out.println("🚨 ALERTA ROJA: Posible usurpación de identidad detectada.");
                    response.sendRedirect("index.jsp?errorIdentidad=1");
                    return;
                }
            }

            // 3. GENERACIÓN DE TOKEN CRIPTOGRÁFICO
            String tokenGenerado = java.util.UUID.randomUUID().toString();

            // 4. PERSISTENCIA DE ENTIDAD PRINCIPAL (Usuario)
            usuarioDAO uDAO = new usuarioDAO();
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setUsername(user);
            nuevoUsuario.setPassword(passEncriptada);
            nuevoUsuario.setEmail(correo);
            nuevoUsuario.setRol(tipo);
            nuevoUsuario.setTelefono(phoneNumber);
            nuevoUsuario.setTokenVerificacion(tokenGenerado);

            int idUsuarioCreado = uDAO.registrar(nuevoUsuario);

            if (idUsuarioCreado > 0) {
                // 5. DELEGACIÓN DE REGISTROS SECUNDARIOS SEGÚN POLIMORFISMO DE ROL
                if ("DOCTOR".equals(tipo)) {
                    registrarDoctor(request, idUsuarioCreado);
                } else {
                    registrarPaciente(request, idUsuarioCreado);
                }

                // 6. INTEGRACIÓN API EXTERNA (Resend)
                boolean correoEnviado = EmailService.enviarCorreoVerificacion(correo, tokenGenerado);

                if (correoEnviado) {
                    request.setAttribute("mensaje", "Registro exitoso. Por favor revisa tu correo para activar tu cuenta.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Registro exitoso, pero hubo un problema al enviar el correo.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect("index.jsp?errorRegistro=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?errorRegistro=1");
        }
    }

    private void registrarPaciente(HttpServletRequest request, int idUsuario) {
        modelo.Paciente p = new modelo.Paciente();
        p.setIdUsuario(idUsuario);
        p.setNombre(request.getParameter("nom"));
        p.setPaterno(request.getParameter("pat"));
        p.setMaterno(request.getParameter("mat"));
        p.setCurp(request.getParameter("curp"));

        String fechaStr = request.getParameter("fecnam");
        if (fechaStr != null && !fechaStr.isEmpty()) {
            p.setFechaNacimiento(Date.valueOf(fechaStr));
        }

        datos.DAO.pacienteDAO pDAO = new datos.DAO.pacienteDAO();
        pDAO.registrar(p);
    }

    private void registrarDoctor(HttpServletRequest request, int idUsuario) {
        modelo.Doctor d = new modelo.Doctor();
        d.setIdUsuario(idUsuario);
        d.setNombre(request.getParameter("nom"));
        d.setPaterno(request.getParameter("pat"));
        d.setMaterno(request.getParameter("mat"));
        d.setCedula(request.getParameter("cedula"));
        d.setDireccion(request.getParameter("dir"));

        String especialidadId = request.getParameter("especialidad");
        d.setIdEspecialidad(especialidadId != null ? Integer.parseInt(especialidadId) : 1);

        doctorDAO dDAO = new doctorDAO();
        dDAO.registrar(d);
    }
}