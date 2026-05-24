package controlador;

import datos.DAO.citaDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/HorariosServlet")
public class horariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 1. Obtenemos los parámetros tal como los envía el fetch
        String idDoctorStr = request.getParameter("idDoctor");
        String fechaStr = request.getParameter("fecha");

        // 2. Validación de seguridad
        if (idDoctorStr == null || idDoctorStr.isEmpty() || fechaStr == null || fechaStr.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            // 3. Convertimos a los tipos necesarios
            int idDoctor = Integer.parseInt(idDoctorStr);
            java.time.LocalDate fecha = java.time.LocalDate.parse(fechaStr);

            // 4. Llamada al DAO
            datos.DAO.citaDAO cDAO = new datos.DAO.citaDAO();
            java.util.List<java.time.LocalTime> horariosLibres = cDAO.getHorariosDisponibles(idDoctor, fecha);

            // 5. Construcción manual del JSON
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
            response.getWriter().write("[]");
        }
    }
}