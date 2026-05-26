package datos.DAO;

import datos.conection;
import modelo.Pago;
import java.sql.*;

public class pagoDAO {
    private static final String SQL_INSERT = "INSERT INTO pago (idCita, monto, metodoPago, fechaPago) VALUES (?, ?, ?, ?)";

    public boolean registrarPago(Pago pago) {
        try (Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            ps.setInt(1, pago.getIdCita());
            ps.setDouble(2, pago.getMonto());
            ps.setString(3, pago.getMetodoPago());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar pago: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
