package controlador;

import datos.DAO.citaDAO;
import modelo.Cita;
import modelo.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/CitaServlet")
public class citaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener el paciente de la sesión (Seguridad)
        HttpSession session = request.getSession();
        Usuario paciente = (Usuario) session.getAttribute("usuarioLogueado");

        if (paciente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Obtener datos del formulario
        String idDoctorStr = request.getParameter("idDoctor");
        String fechaStr = request.getParameter("fechaSeleccionada");
        String horaStr = request.getParameter("horaSeleccionada");
        LocalDateTime ldt = LocalDateTime.parse(fechaStr + "T" + horaStr);
        Timestamp timestampFinal = Timestamp.valueOf(ldt);
        String motivo = request.getParameter("motivo");

        try {

            // 3. Crear objeto Cita
            Cita nuevaCita = new Cita();
            nuevaCita.setIdPaciente(paciente.getIdUsuario());
            nuevaCita.setIdDoctor(Integer.parseInt(idDoctorStr));
            nuevaCita.setFechaHora(timestampFinal);
            nuevaCita.setMotivo(motivo);

            // 4. Llamar al DAO
            citaDAO cDAO = new citaDAO();
            boolean registrada = cDAO.agendarCita(nuevaCita);

            if (registrada) {
                request.setAttribute("mensaje", "¡Cita agendada con éxito!");
                request.getRequestDispatcher("dashboard_paciente.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "El horario ya está ocupado. Intenta con otro.");
                request.getRequestDispatcher("agendar.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("agendar.jsp?error=formatoInvalido");
        }
    }
}