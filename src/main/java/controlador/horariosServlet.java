package controlador;

import datos.DAO.citaDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Endpoint API Asíncrono (JSON).
 * Interrogado vía Fetch desde el front-end para devolver los horarios no ocupados.
 */
@WebServlet("/HorariosServlet")
public class horariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configuración de cabeceras para RESTful API
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idDoctorStr = request.getParameter("idDoctor");
        String fechaStr = request.getParameter("fecha");

        // VALIDACIÓN: Evita excepciones si la petición llega incompleta
        if (idDoctorStr == null || idDoctorStr.isEmpty() || fechaStr == null || fechaStr.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            int idDoctor = Integer.parseInt(idDoctorStr);
            java.time.LocalDate fecha = java.time.LocalDate.parse(fechaStr);

            // CÁLCULO DE DISPONIBILIDAD: Cruza HorarioLaboral vs CitasRegistradas
            datos.DAO.citaDAO cDAO = new datos.DAO.citaDAO();
            java.util.List<java.time.LocalTime> horariosLibres = cDAO.getHorariosDisponibles(idDoctor, fecha);

            // SERIALIZACIÓN JSON: Construye un array de strings compatible con JavaScript
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < horariosLibres.size(); i++) {
                json.append("\"").append(horariosLibres.get(i).toString()).append("\"");
                if (i < horariosLibres.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]"); // Respuesta fallback en caso de error
        }
    }
}