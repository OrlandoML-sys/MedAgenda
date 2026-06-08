package controlador;

import datos.DAO.pagoDAO;
import datos.conection;
import modelo.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Controlador de Transacciones Financieras.
 * Registra ingresos en caja y actualiza la máquina de estados de las citas.
 */
@WebServlet("/pagoServlet")
public class pagoServlet extends HttpServlet{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. MAPEO DE DATOS A ENTIDAD
        int idCita = Integer.parseInt(request.getParameter("idCita"));
        double monto = Double.parseDouble(request.getParameter("monto"));
        String metodoPago = request.getParameter("metodoPago");

        Pago pago = new Pago();
        pago.setIdCita(idCita);
        pago.setMonto(monto);
        pago.setMetodoPago(metodoPago);

        // 2. INSERCIÓN EN TABLA PAGOS
        pagoDAO pDAo = new pagoDAO();
        boolean pagado = pDAo.registrarPago(pago);

        if (pagado) {
            // 3. ACTUALIZACIÓN DE ESTADO LÓGICO EN CASCADA
            String sqlUpdate = "UPDATE cita SET estado = 'PAGADA' WHERE idcita = ?";
            try (Connection conn = conection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setInt(1, idCita);
                ps.executeUpdate();
            } catch(Exception e) {
                e.printStackTrace();
            }

            // Previene duplicidad de pagos al refrescar página
            response.sendRedirect("dashboardDoctor.jsp?pagoExitoso=1");
        } else {
            response.sendRedirect("registrarPago.jsp?idCita=" + idCita + "&error=1");
        }
    }
}