package controlador;

import datos.DAO.citaDAO;
import modelo.Cita;
import modelo.Usuario;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * Controlador del Módulo de Agendamiento.
 * Transforma peticiones de fecha/hora plana en objetos Timestamp relacionales.
 */
@WebServlet("/CitaServlet")
public class citaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 1. Extrae el ID del paciente directamente del servidor
        HttpSession session = request.getSession();
        Usuario paciente = (Usuario) session.getAttribute("usuarioLogueado");

        if (paciente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. EXTRACCIÓN DE DATOS DE LA VISTA
        String idDoctorStr = request.getParameter("idDoctor");
        String fechaStr = request.getParameter("fechaSeleccionada");
        String horaStr = request.getParameter("horaSeleccionada");
        String motivo = request.getParameter("motivo");

        // CONVERSIÓN DE TIEMPO: Une las cadenas separadas y parsea al formato admitido por JDBC
        LocalDateTime ldt = LocalDateTime.parse(fechaStr + "T" + horaStr);
        Timestamp timestampFinal = Timestamp.valueOf(ldt);

        try {
            // 3. MAPEO ORM MANUAL
            Cita nuevaCita = new Cita();
            nuevaCita.setIdPaciente(paciente.getIdUsuario());
            nuevaCita.setIdDoctor(Integer.parseInt(idDoctorStr));
            nuevaCita.setFechaHora(timestampFinal);
            nuevaCita.setMotivo(motivo);

            // 4. TRANSACCIÓN DE PERSISTENCIA
            citaDAO cDAO = new citaDAO();
            boolean registrada = cDAO.agendarCita(nuevaCita);

            if (registrada) {
                request.setAttribute("mensaje", "¡Cita agendada con éxito!");
                response.sendRedirect("dashboardPaciente.jsp?citaAgendada=1");
            } else {
                // FALLO POR CONCURRENCIA: Si dos pacientes eligen la misma hora exacta
                request.setAttribute("error", "El horario ya está ocupado. Intenta con otro.");
                response.sendRedirect("agendar.jsp?idDoctor=" + idDoctorStr + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("agendar.jsp?idDoctor=" + idDoctorStr + "&error=formatoInvalido");
        }
    }
}