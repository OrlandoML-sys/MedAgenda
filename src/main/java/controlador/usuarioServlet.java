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

@WebServlet("/UsuarioServlet")
public class usuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        Usuario u = uDAO.validar(user, Seguridad.encriptar(pass));

        if (u != null) {
            // 1. Las credenciales son correctas. Verificamos el estado de la cuenta.
            if (u.isEstaActivo()) {
                // ¡Todo perfecto! Iniciamos la sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", u);

                String rol = u.getRol();
                if("DOCTOR".equals(rol)) {
                    response.sendRedirect("dashboardDoctor.jsp");
                } else if ("PACIENTE".equals(rol)) {
                    response.sendRedirect("dashboardPaciente.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            } else {
                // 2. Credenciales correctas, pero cuenta INACTIVA
                request.setAttribute("errorLogin", "Tu cuenta aún no está activada. Por favor, revisa tu correo electrónico para verificarla.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } else {
            // 3. Credenciales INCORRECTAS (No existe el usuario o la contraseña está mal)
            request.setAttribute("errorLogin", "Usuario o contraseña incorrectos.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private void procesarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            // Captura de datos del formulario
            String user = request.getParameter("regUser");
            String pass = request.getParameter("regPass");
            String tipo = request.getParameter("tipoUsuario");
            String passEncriptada = modelo.Seguridad.encriptar(pass);
            String correo = request.getParameter("correo");
            String phoneNumber = request.getParameter("phone");

            // Validación del teléfono
            if (phoneNumber == null || !phoneNumber.matches("\\d{10}")) {
                request.setAttribute("error", "El número telefónico debe tener 10 dígitos numéricos.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            String nom = request.getParameter("nom");
            String pat = request.getParameter("pat");
            String mat = request.getParameter("mat");
            if ("DOCTOR".equals(tipo)) {
                String cedulaInput = request.getParameter("cedula");

                datos.DAO.sepDAO sDAO = new datos.DAO.sepDAO();
                modelo.CedulaSEP cedulaValidada = sDAO.consultarCedulaOficial(cedulaInput);

                // Filtro 1: ¿La cédula existe en la SEP?
                if (cedulaValidada == null) {
                    System.out.println("⚠️ SEGURIDAD: Intento de registro con cédula inexistente: " + cedulaInput);
                    response.sendRedirect("index.jsp?errorCedula=1");
                    return;
                }

                // Filtro 2: ¿La cédula le pertenece a quien se está registrando?
                // Comparamos ignorando mayúsculas/minúsculas y quitando espacios extra
                boolean coincideNombre = cedulaValidada.getNombre().equalsIgnoreCase(nom.trim());
                boolean coincidePaterno = cedulaValidada.getPaterno().equalsIgnoreCase(pat.trim());

                // El apellido materno a veces es opcional, lo validamos de forma segura
                boolean coincideMaterno = true;
                if (cedulaValidada.getMaterno() != null && !cedulaValidada.getMaterno().trim().isEmpty()) {
                    String matInput = (mat != null) ? mat.trim() : "";
                    coincideMaterno = cedulaValidada.getMaterno().equalsIgnoreCase(matInput);
                }

                // Si al menos un dato no coincide, bloqueamos por usurpación de identidad
                if (!coincideNombre || !coincidePaterno || !coincideMaterno) {
                    System.out.println("🚨 ALERTA ROJA: Posible usurpación de identidad. Cédula " + cedulaInput +
                            " pertenece a " + cedulaValidada.getNombre() + " pero fue usada por " + nom);
                    response.sendRedirect("index.jsp?errorIdentidad=1");
                    return;
                }
            }

            // 1. GENERAMOS EL TOKEN ANTES DE GUARDAR
            String tokenGenerado = java.util.UUID.randomUUID().toString();

            // 2. PREPARAMOS EL USUARIO
            usuarioDAO uDAO = new usuarioDAO();
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setUsername(user);
            nuevoUsuario.setPassword(passEncriptada);
            nuevoUsuario.setEmail(correo);
            nuevoUsuario.setRol(tipo);
            nuevoUsuario.setTelefono(phoneNumber);
            nuevoUsuario.setTokenVerificacion(tokenGenerado);

            // 3. INSERTAMOS EN LA BASE DE DATOS
            int idUsuarioCreado = uDAO.registrar(nuevoUsuario);

            if (idUsuarioCreado > 0) {
                // 4. REGISTRAMOS LOS DETALLES SEGÚN EL ROL
                if ("DOCTOR".equals(tipo)) {
                    registrarDoctor(request, idUsuarioCreado);
                } else {
                    registrarPaciente(request, idUsuarioCreado);
                }

                // 5. ENVIAMOS EL CORREO UNA SOLA VEZ
                boolean correoEnviado = EmailService.enviarCorreoVerificacion(correo, tokenGenerado);

                if (correoEnviado) {
                    // Éxito total: Mandamos al login con mensaje
                    request.setAttribute("mensaje", "Registro exitoso. Por favor revisa tu correo para activar tu cuenta.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                } else {
                    // Se guardó en DB, pero falló el correo
                    request.setAttribute("error", "Registro exitoso, pero hubo un problema al enviar el correo de verificación.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } else {
                // Falló el insert en la DB
                response.sendRedirect("index.jsp?errorRegistro=1");
            }
        } catch (Exception e) {
            System.out.println("ERROR EN REGISTRO: " + e.getMessage());
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