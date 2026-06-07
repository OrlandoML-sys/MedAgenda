package datos.DAO;

import datos.conection;
import modelo.Expediente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class expedienteDAO {
    private static final String SQL_INSERT = "INSERT INTO expediente (idCita, diagnostico, tratamiento, notasJSON) VALUES (?, ?, ?, ?::jsonb)";
    private static final String SQL_LISTADO = "SELECT * FROM expediente WHERE idCita = ?";

    public boolean guardarExpediente(Expediente exp) {
        try (Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            ps.setInt(1, exp.getIdCita());
            ps.setString(2, exp.getDiagnostico());
            ps.setString(3, exp.getTratamiento());

            if (exp.getNotasJSON() == null || exp.getNotasJSON().isEmpty()) {
                ps.setString(4, "{}");
            } else {
                ps.setString(4, exp.getNotasJSON());
            }

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException ex) {
            System.err.println("Error al guardar expediente: " + ex.getMessage());
            ex.printStackTrace(System.out);
            return false;
        }
    }

    public List<modelo.Expediente> obtenerExpedientesPorPaciente(int idPaciente) {
        List<modelo.Expediente> lista = new ArrayList<>();

        String sql = "SELECT e.idexpediente, e.idcita, e.diagnostico, e.tratamiento, e.notasjson, " +
                "       c.fechahora, d.nombre AS nombre_doctor " +
                "FROM expediente e " +
                "JOIN cita c ON e.idcita = c.idcita " +
                "JOIN doctor d ON c.iddoctor = d.iddoctor " +
                "WHERE c.idpaciente = ? " +
                "ORDER BY c.fechahora DESC";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Expediente exp = new Expediente();
                    exp.setIdExpediente(rs.getInt("idexpediente"));
                    exp.setIdCita(rs.getInt("idcita"));
                    exp.setDiagnostico(rs.getString("diagnostico"));
                    exp.setTratamiento(rs.getString("tratamiento"));
                    exp.setNotasJSON(rs.getString("notasjson"));

                    exp.setNombreDoctor(rs.getString("nombre_doctor"));
                    exp.setFechaCita(rs.getTimestamp("fechahora"));

                    lista.add(exp);
                }
            }
        } catch (Exception e) {
            System.err.println("Error en obtenerExpedientesPorPaciente: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}