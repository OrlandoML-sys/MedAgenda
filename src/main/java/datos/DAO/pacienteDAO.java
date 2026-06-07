package datos.DAO;

import datos.conection;
import modelo.Paciente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class pacienteDAO {
    private static String sql = "INSERT INTO Paciente (curp, nombre, fechaNacimiento, idUsuario) VALUES (?, ROW(?, ?, ?), ?, ?)";
    private static String listado = "SELECT idPaciente, curp, (PersonaNombre).nombrePila, (PersonaNombre).paterno, (PersonaNombre).materno, fechaNacimiento FROM Paciente";

    public boolean registrar(Paciente p){
        try(Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1, p.getCurp());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getPaterno());
            ps.setString(4, p.getMaterno());
            ps.setDate(5, p.getFechaNacimiento());
            ps.setInt(6, p.getIdUsuario());

            int registro = ps.executeUpdate();
            return registro > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar paciente: " + e.getMessage());
            return false;
        }
    }
}
