package datos.DAO;

import datos.conection;
import modelo.CedulaSEP;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class sepDAO {

    public CedulaSEP consultarCedulaOficial(String numCedula) {
        CedulaSEP cedula = null;

        String sql = "SELECT num_cedula, " +
                "       (nombre).nombrepila AS nombre_pila, " +
                "       (nombre).paterno AS ap_paterno, " +
                "       (nombre).materno AS ap_materno, " +
                "       especialidad, institucion " +
                "FROM sep_cedula WHERE num_cedula = ?";

        try (Connection conn = conection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, numCedula);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cedula = new CedulaSEP();
                    cedula.setNum_cedula(rs.getString("num_cedula"));

                    // Extraemos los alias planos que generamos en el SELECT
                    cedula.setNombre(rs.getString("nombre_pila"));
                    cedula.setPaterno(rs.getString("ap_paterno"));
                    cedula.setMaterno(rs.getString("ap_materno"));

                    cedula.setEspecialidad(rs.getString("especialidad"));
                    cedula.setInstitucion(rs.getString("institucion"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error al consultar padrón de la SEP con tipo compuesto: " + e.getMessage());
            e.printStackTrace();
        }
        return cedula;
    }
}