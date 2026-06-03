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

        System.out.println("====== LLEGÓ UNA PETICIÓN A HORARIOS SERVLET ======");
        System.out.println("Param idDoctor recibido: " + request.getParameter("idDoctor"));
        System.out.println("Param fecha recibida: " + request.getParameter("fecha"));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idDoctorStr = request.getParameter("idDoctor");
        String fechaStr = request.getParameter("fecha");

        if (idDoctorStr == null || idDoctorStr.isEmpty() || fechaStr == null || fechaStr.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            int idDoctor = Integer.parseInt(idDoctorStr);
            java.time.LocalDate fecha = java.time.LocalDate.parse(fechaStr);

            datos.DAO.citaDAO cDAO = new datos.DAO.citaDAO();
            java.util.List<java.time.LocalTime> horariosLibres = cDAO.getHorariosDisponibles(idDoctor, fecha);

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