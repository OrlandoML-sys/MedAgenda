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

/**
 * Capa de Persistencia para la Gestión de Citas.
 * Orquesta la lógica de negocio de calendarios, prevención de colisiones (concurrencia)
 * y cruce de horarios laborales con citas activas.
 */
public class citaDAO {

    // PREVENCIÓN DE CONCURRENCIA: Verifica que el "slot" de tiempo no haya sido tomado milisegundos antes
    public boolean verificarDisponibilidad(int idDoctor, Timestamp fechaHora) {
        String sql = "SELECT COUNT(*) FROM cita WHERE iddoctor = ? AND fechahora = ? AND estado != 'CANCELADA'";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idDoctor);
            ps.setTimestamp(2, fechaHora);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int conteo = rs.getInt(1);
                    return conteo == 0; // Libre si el count es exactamente 0
                }
            }
        } catch (SQLException ex) {
            System.err.println("Error al verificar disponibilidad: " + ex.getMessage());
            ex.printStackTrace(System.out);
        }
        return false; // Fail-Safe: Bloquea el horario ante fallos de conexión
    }

    /**
     * Registra una cita aplicando la validación de estado previa.
     */
    public boolean agendarCita(Cita nuevaCita) {
        // 1. Interrogación del escudo de disponibilidad
        boolean estaLibre = verificarDisponibilidad(
                nuevaCita.getIdDoctor(),
                nuevaCita.getFechaHora()
        );

        if (!estaLibre) {
            System.out.println("No se puede agendar: El horario ya está ocupado.");
            return false;
        }

        // 2. Si la transacción es segura, inyecta la cita
        String sql = "INSERT INTO cita (idpaciente, iddoctor, fechahora, motivo, estado) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nuevaCita.getIdPaciente());
            ps.setInt(2, nuevaCita.getIdDoctor());
            ps.setTimestamp(3, nuevaCita.getFechaHora());
            ps.setString(4, nuevaCita.getMotivo());
            ps.setString(5, "PENDIENTE"); // Estado por defecto de la máquina de estados

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException ex) {
            System.err.println("Error al agendar cita: " + ex.getMessage());
            ex.printStackTrace(System.out);
            return false;
        }
    }

    /**
     * Motor de Cálculo de Agendas: Cruza el horario base del médico contra las citas ya asignadas
     * para devolver exclusivamente los "huecos" libres.
     */
    public List<LocalTime> getHorariosDisponibles(int idDoctor, LocalDate fechaConsulta) {
        List<LocalTime> horariosDisponibles = new ArrayList<>();
        int diaSemanaJava = fechaConsulta.getDayOfWeek().getValue();

        System.out.println("--- DEPURANDO: Doctor " + idDoctor + " Fecha " + fechaConsulta + " DíaSemana " + diaSemanaJava + " ---");

        try (Connection conn = conection.getConnection()) {
            // FASE A: Extraer la plantilla base del horario laboral
            String sqlHorario = "SELECT horaentrada, horasalida FROM horariolaboral WHERE iddoctor = ? AND diasemana::integer = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlHorario)) {
                ps.setInt(1, idDoctor);
                ps.setInt(2, diaSemanaJava);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        LocalTime entrada = rs.getTime("horaentrada").toLocalTime();
                        LocalTime salida = rs.getTime("horasalida").toLocalTime();
                        System.out.println("Horario laboral hallado: " + entrada + " a " + salida);

                        // Generación paramétrica de fragmentos de 1 hora
                        LocalTime horaActual = entrada;
                        while (horaActual.isBefore(salida)) {
                            horariosDisponibles.add(horaActual);
                            horaActual = horaActual.plusHours(1);
                        }
                    } else {
                        System.out.println("¡ALERTA! No se encontró horario laboral para este día.");
                    }
                }
            }

            // FASE B: Sustracción de horarios ya ocupados en la fecha solicitada
            String sqlCitas = "SELECT fechahora FROM cita WHERE iddoctor = ? AND DATE(fechahora) = ? AND estado != 'CANCELADA'";
            try (PreparedStatement psCitas = conn.prepareStatement(sqlCitas)) {
                psCitas.setInt(1, idDoctor);
                psCitas.setDate(2, java.sql.Date.valueOf(fechaConsulta));
                try (ResultSet rsCitas = psCitas.executeQuery()) {
                    while (rsCitas.next()) {
                        LocalTime horaOcupada = rsCitas.getTimestamp("fechahora").toLocalDateTime().toLocalTime();
                        System.out.println("Cita encontrada ocupada a las: " + horaOcupada);
                        // Elimina el bloque si ya existe una coincidencia
                        horariosDisponibles.remove(horaOcupada);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Horarios finales enviados al JSON: " + horariosDisponibles);
        return horariosDisponibles;
    }

    /**
     * DTO (Data Transfer Object) ensamblado mediante JOINs para poblar la tabla principal del Doctor.
     */
    public List<modelo.Cita> obtenerCitasPorDoctor(int idDoctor) {
        List<modelo.Cita> lista = new ArrayList<>();
        // INNER JOIN optimizado para cruzar el estado clínico con los datos demográficos del paciente
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