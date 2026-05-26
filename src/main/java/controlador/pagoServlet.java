package controlador;

import datos.DAO.pagoDAO;
import modelo.Pago;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/pagoServlet")
public class pagoServlet extends HttpServlet{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        int idCita = Integer.parseInt(request.getParameter("idCita"));
        double monto = Double.parseDouble(request.getParameter("monto"));
        String metodoPago = request.getParameter("metodoPago");

        Pago pago = new Pago();
        pago.setIdCita(idCita);
        pago.setMonto(monto);
        pago.setMetodoPago(metodoPago);

        pagoDAO pDAo = new pagoDAO();
        boolean pagado = pDAo.registrarPago(pago);

        if(pagado) {
            response.sendRedirect("dashboardDoctor.jsp?pagoRealizado=1");
        } else {
            response.sendRedirect("registrarPago.jsp?idCita=" + idCita + "&error=1");
        }
    }
}
