package datos;

import java.sql.*;
import javax.sql.DataSource;
import org.apache.commons.dbcp2.BasicDataSource;

/**
 * Gestor de Conexiones a la Base de Datos (PostgreSQL).
 * Implementa el patrón Singleton sobre un Pool de Conexiones (Apache Commons DBCP)
 * para optimizar el rendimiento y evitar la saturación del servidor al no tener que
 * abrir y cerrar conexiones físicas en cada petición.
 */
public class conection {

    // CREDENCIALES Y CONFIGURACIÓN JDBC
    private static String user = "rlndmdrgl";
    private static String pswd = "ekkssixx0";
    private static String bd = "medagenda_db";
    private static String server = "jdbc:postgresql://localhost:5432/" + bd;
    private static String driver = "org.postgresql.Driver";

    // OBJETO POOL: Mantiene un conjunto de conexiones abiertas listas para usarse
    private static BasicDataSource ds;

    /**
     * Inicializa y configura el Pool de Conexiones si no existe (Patrón Singleton).
     */
    public static DataSource getDataSource() {
        if (ds == null) {
            ds = new BasicDataSource();
            ds.setUrl(server);
            ds.setUsername(user);
            ds.setPassword(pswd);
            // INICIALIZACIÓN: Prepara 50 conexiones inactivas en memoria para respuesta inmediata
            ds.setInitialSize(50);
            ds.setDriverClassName(driver);
        }
        return ds;
    }

    /**
     * Extrae una conexión activa del Pool para ejecutar una transacción.
     */
    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    /* ==========================================================
       SOBRECARGA DE MÉTODOS CLOSE:
       Garantizan la liberación de memoria y el retorno de la
       conexión al pool para evitar fugas de memoria (Memory Leaks).
       ========================================================== */

    public static void close(ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
    }

    public static void close(PreparedStatement ps) {
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
    }

    public static void close(Connection conn) {
        try {
            if (conn != null) {
                conn.close(); // NO cierra la conexión física, la devuelve al Pool de DBCP
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
    }
}