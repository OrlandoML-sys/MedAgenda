package datos.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import datos.conection;
import modelo.Cita;

public class citaDAO {

    // Método escudo: Devuelve TRUE si el horario está LIBRE, FALSE si está OCUPADO
    public boolean verificarDisponibilidad(int idDoctor, Timestamp fechaHora) {
        String sql = "SELECT COUNT(*) FROM cita WHERE id_doctor = ? AND fechaHora = ? AND estado != 'CANCELADA'";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idDoctor);
            ps.setTimestamp(2, fechaHora);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int conteo = rs.getInt(1);
                    return conteo == 0; // Si es 0, no hay citas, está libre.
                }
            }
        } catch (SQLException ex) {
            System.err.println("Error al verificar disponibilidad: " + ex.getMessage());
            ex.printStackTrace(System.out);
        }
        return false; // Por seguridad, si hay error en la DB, decimos que no está disponible
    }

    // Método para registrar la cita
    public boolean agendarCita(Cita nuevaCita) {
        // 1. ANTES de hacer el INSERT, verificamos la regla de negocio
        boolean estaLibre = verificarDisponibilidad(
                nuevaCita.getIdDoctor(),
                nuevaCita.getFechaHora()
        );

        if (!estaLibre) {
            System.out.println("No se puede agendar: El horario ya está ocupado.");
            return false; // Bloqueamos la inserción y devolvemos falso
        }

        // 2. Si pasó el filtro, procedemos con el INSERT
        String sql = "INSERT INTO cita (id_paciente, id_doctor, fechaHora, motivo, estado) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nuevaCita.getIdPaciente());
            ps.setInt(2, nuevaCita.getIdDoctor());
            ps.setTimestamp(3, nuevaCita.getFechaHora());
            ps.setString(4, nuevaCita.getMotivo());
            ps.setString(5, "PENDIENTE"); // Estado inicial por defecto

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException ex) {
            System.err.println("Error al agendar cita: " + ex.getMessage());
            ex.printStackTrace(System.out);
            return false;
        }
    }

    public List<LocalTime> getHorariosDisponibles(int idDoctor, LocalDate fechaConsulta) {
        List<LocalTime> horariosDisponibles = new ArrayList<>();
        int diaSemanaJava = fechaConsulta.getDayOfWeek().getValue();

        LocalTime entrada = null;
        LocalTime salida = null;

        // 1. Consultar el horario forzando absolutamente todo a texto (VARCHAR)
        String sqlHorario = "SELECT CAST(horaentrada AS VARCHAR) as he, CAST(horasalida AS VARCHAR) as hs " +
                "FROM horariolaboral " +
                "WHERE CAST(iddoctor AS VARCHAR) = ? AND CAST(diasemana AS VARCHAR) = ?";

        try (Connection conn = conection.getConnection();
             PreparedStatement psHorario = conn.prepareStatement(sqlHorario)) {

            // Enviamos los parámetros como Strings
            psHorario.setString(1, String.valueOf(idDoctor));
            psHorario.setString(2, String.valueOf(diaSemanaJava));

            try (ResultSet rs = psHorario.executeQuery()) {
                if (rs.next()) {
                    entrada = LocalTime.parse(rs.getString("he"));
                    salida = LocalTime.parse(rs.getString("hs"));
                }
            }

            if (entrada == null || salida == null) {
                return horariosDisponibles;
            }

            // Generamos los bloques de 1 hora
            LocalTime horaActual = entrada;
            while (horaActual.isBefore(salida)) {
                horariosDisponibles.add(horaActual);
                horaActual = horaActual.plusHours(1);
            }

            // 2. Consultar citas ocupadas usando LIKE para ignorar problemas de TIMESTAMP
            String sqlCitas = "SELECT CAST(fechahora AS VARCHAR) as hora_ocupada " +
                    "FROM cita " +
                    "WHERE CAST(iddoctor AS VARCHAR) = ? AND CAST(fechahora AS VARCHAR) LIKE ? AND estado != 'CANCELADA'";

            List<LocalTime> horariosOcupados = new ArrayList<>();

            try (PreparedStatement psCitas = conn.prepareStatement(sqlCitas)) {
                psCitas.setString(1, String.valueOf(idDoctor));
                psCitas.setString(2, fechaConsulta.toString() + "%");
                System.out.println("DAO buscando citas para Doctor: " + idDoctor + " en fecha: " + fechaConsulta);

                try (ResultSet rsCitas = psCitas.executeQuery()) {
                    while (rsCitas.next()) {
                        String fechahoraCompleta = rsCitas.getString("hora_ocupada"); // Ej. "2026-05-28 11:00:00"
                        if (fechahoraCompleta != null && fechahoraCompleta.contains(" ")) {
                            String soloHora = fechahoraCompleta.split(" ")[1]; // Extraemos solo el "11:00:00"
                            horariosOcupados.add(LocalTime.parse(soloHora));
                        }
                    }
                }
            }

            // 3. Restar horarios y devolver
            horariosDisponibles.removeAll(horariosOcupados);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return horariosDisponibles;
    }

    public List<modelo.Cita> obtenerCitasPorDoctor(int idDoctor) {
        List<modelo.Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombre AS nombre_paciente FROM cita c " +
                "JOIN doctor d ON c.iddoctor = d.iddoctor " +
                "JOIN paciente p ON c.idpaciente = p.idpaciente " +
                "WHERE d.idusuario = ? ORDER BY c.fechahora DESC";

        try (java.sql.Connection conn = datos.conection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idDoctor);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    modelo.Cita c = new modelo.Cita();
                    c.setIdCita(rs.getInt("idcita"));
                    c.setIdPaciente(rs.getInt("idpaciente"));
                    c.setIdDoctor(rs.getInt("iddoctor"));
                    c.setFechaHora(rs.getTimestamp("fechahora"));
                    c.setMotivo(rs.getString("motivo"));
                    c.setEstado(rs.getString("estado"));
                    c.setNombrePaciente(rs.getString("nombre_paciente"));
                    lista.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}
