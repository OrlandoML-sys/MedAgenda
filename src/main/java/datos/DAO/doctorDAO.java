package datos.DAO;

import datos.conection;
import modelo.Doctor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class doctorDAO {
    private static String sql = "INSERT INTO Doctor (idUsuario, idEspecialidad, nombre, cedula, direccion) VALUES (?, ?, ROW(?,?,?), ?, ?)";

    public boolean registrar(Doctor d){
        try (Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, d.getIdUsuario());
            ps.setInt(2, d.getIdEspecialidad());
            ps.setString(3, d.getNombre());
            ps.setString(4, d.getPaterno());
            ps.setString(5, d.getMaterno());
            ps.setString(6, d.getCedula());
            ps.setString(7, d.getDireccion() != null ? d.getDireccion() : "");

            int registro = ps.executeUpdate();
            return registro > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar doctor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Método para listar doctores
    public List<Doctor> todos() {
        List<Doctor> lista = new ArrayList<>();
        String sql = "SELECT idDoctor, idUsuario, idEspecialidad, (datos_personales).nombre, (datos_personales).paterno, (datos_personales).materno, direccion, cedula FROM Doctor";

        try (Connection con = conection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor d = new Doctor();
                d.setIdDoctor(rs.getInt("idDoctor"));
                d.setIdUsuario(rs.getInt("idUsuario"));
                d.setIdEspecialidad(rs.getInt("idEspecialidad"));
                d.setNombre(rs.getString("nombrePila"));
                d.setPaterno(rs.getString("paterno"));
                d.setMaterno(rs.getString("materno"));
                d.setCedula(rs.getString("cedula"));
                d.setDireccion(rs.getString("direccion"));

                lista.add(d);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar doctores: " + e.getMessage());
        }
        return lista;
    }
}
