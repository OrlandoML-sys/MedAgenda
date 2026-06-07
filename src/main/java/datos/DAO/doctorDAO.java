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

    public List<modelo.Doctor> buscarDoctores(String parametro, String ubicacionBusqueda) {
        List<modelo.Doctor> lista = new ArrayList<>();

        String sql = "SELECT d.*, e.nombre AS nombre_especialidad " +
                "FROM doctor d " +
                "JOIN especialidad e ON d.idespecialidad = e.idespecialidad " +
                "WHERE (d.nombre::text ILIKE ? OR e.nombre::text ILIKE ?) " +
                "AND d.direccion::text ILIKE ?";

        System.out.println("======= SQL ENVIADO A POSTGRESQL =======");
        System.out.println(sql);
        System.out.println("========================================");

        try (java.sql.Connection conn = datos.conection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {

            String paramLimpio = (parametro == null || parametro.trim().isEmpty()) ? "%" : "%" + parametro.trim() + "%";
            String ubiLimpia = (ubicacionBusqueda == null || ubicacionBusqueda.trim().isEmpty()) ? "%" : "%" + ubicacionBusqueda.trim() + "%";

            ps.setString(1, paramLimpio);
            ps.setString(2, paramLimpio);
            ps.setString(3, ubiLimpia);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    modelo.Doctor d = new modelo.Doctor();
                    d.setIdDoctor(rs.getInt("iddoctor"));
                    d.setIdUsuario(rs.getInt("idusuario"));
                    d.setIdEspecialidad(rs.getInt("idespecialidad"));
                    d.setNombreEspecialidad(rs.getString("nombre_especialidad"));

                    // Mapeo exacto de tu modelo
                    d.setNombre(rs.getString("nombre"));
                    d.setDireccion(rs.getString("direccion"));
                    d.setCedula(rs.getString("cedula"));

                    lista.add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}
