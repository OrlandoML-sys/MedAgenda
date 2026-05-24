package datos.DAO;

import datos.conection;
import modelo.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class usuarioDAO {
    private static final String SQL_INSERT = "INSERT INTO Usuario (username, rol, estaActivo, email, password, telefono, token_verificacion) VALUES (?, ?, ?::boolean, ?, ?, ?, ?) RETURNING idUsuario";
    private static final String SQL_LOGIN = "SELECT * FROM Usuario WHERE username = ? AND password = ?";

    public int registrar(Usuario user) {
        int idGenerado = 0;
        try (Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_INSERT)){
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getRol());
            ps.setBoolean(3, false);
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getTelefono());
            ps.setString(7, user.getTokenVerificacion());

            try(ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    idGenerado = rs.getInt(1);
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return idGenerado;
    }

    public Usuario validar(String user, String pass) {
        Usuario us = null;

        try (Connection conn = conection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_LOGIN)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    us = new Usuario();
                    us.setIdUsuario(rs.getInt("idUsuario"));
                    us.setUsername(rs.getString("username"));
                    us.setEmail(rs.getString("email"));
                    us.setRol(rs.getString("rol"));
                    us.setPassword(rs.getString("password"));
                    us.setEstaActivo(rs.getBoolean("estaActivo"));
                    us.setTelefono(rs.getString("telefono"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return us;
    }

    public boolean verificarCuenta(String token) {
        // Cambiamos a true y borramos el token en un solo paso
        String sql = "UPDATE usuario SET estaactivo = true, token_verificacion = NULL WHERE token_verificacion = ?";

        try (Connection con = conection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, token);

            int filasAfectadas = ps.executeUpdate();
            // Si afectó al menos 1 fila, significa que encontró el token y actualizó la cuenta
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al verificar cuenta: " + e.getMessage());
            return false;
        }
    }
}
