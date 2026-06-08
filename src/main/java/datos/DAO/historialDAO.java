package datos.DAO;

import datos.conection;
import modelo.HistorialClinico;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Capa de Lectura (Read-Only) para reportes de desempeño clínico y seguimiento de pacientes.
 */
public class historialDAO {

    public List<HistorialClinico> obtenerHistorialPorUsuario(int idUsuario) {
        List<HistorialClinico> lista = new ArrayList<>();

        // La sintaxis (p.nombre).nombrepila extrae un atributo específico del tipo estructurado en PGSQL
        String sql = "SELECT (p.nombre).nombrepila AS nombre_p, (p.nombre).paterno AS pat_p, " +
                "c.fechahora AS fecha, c.motivo, e.diagnostico, e.tratamiento " +
                "FROM cita c " +
                "JOIN paciente p ON c.idpaciente = p.idpaciente " +
                "JOIN doctor d ON c.iddoctor = d.iddoctor " +
                "LEFT JOIN expediente e ON c.idcita = e.idcita " +
                "WHERE d.idusuario = ? AND c.estado = 'REALIZADA' OR c.estado = 'PAGADA'" +
                "ORDER BY c.fechahora DESC";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialClinico h = new HistorialClinico();
                    // Concatenación a nivel de vista lógica
                    h.setNombrePaciente(rs.getString("nombre_p") + " " + rs.getString("pat_p"));
                    h.setFechaCita(rs.getString("fecha"));
                    h.setMotivoCita(rs.getString("motivo"));
                    h.setDiagnostico(rs.getString("diagnostico"));
                    h.setReceta(rs.getString("tratamiento"));
                    lista.add(h);
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener historial clínico: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}