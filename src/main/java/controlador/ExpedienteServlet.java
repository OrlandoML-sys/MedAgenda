package controlador;

import datos.DAO.expedienteDAO;
import modelo.Expediente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ExpedienteServlet")
public class ExpedienteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idCitaStr = request.getParameter("idCita");
        String diagnostico = request.getParameter("diagnostico");
        String tratamiento = request.getParameter("tratamiento");
        String alergias = request.getParameter("alergias");

        try {
            int idCita = Integer.parseInt(idCitaStr);
            String notasJSONStr = "{\"alergias_reportadas\":\"" + (alergias != null ? alergias : "Ninguna") + "\"}";

            Expediente nuevoExp = new Expediente();
            nuevoExp.setIdCita(idCita);
            nuevoExp.setDiagnostico(diagnostico);
            nuevoExp.setTratamiento(tratamiento);
            nuevoExp.setNotasJSON(notasJSONStr);

            expedienteDAO expDAO = new expedienteDAO();
            boolean exito = expDAO.guardarExpediente(nuevoExp);

            if (exito) {
                response.sendRedirect("dashboardDoctor.jsp?expedienteGuardado=1");
            } else {
                response.sendRedirect("crearExpediente.jsp?idCita=" + idCita + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboardDoctor.jsp");
        }
    }
}
