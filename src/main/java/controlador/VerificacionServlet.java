package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controlador encargado de gestionar la activación de cuentas a través del enlace enviado por correo.
 */
@WebServlet("/verificar")
public class VerificacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. CAPTURA DE PARÁMETROS: Obtiene el token único generado en el registro
        String token = request.getParameter("token");

        if (token != null && !token.isEmpty()) {
            datos.DAO.usuarioDAO dao = new datos.DAO.usuarioDAO();

            // 2. CAPA DE DATOS: Busca el token en la BD y cambia el estado 'estaactivo' a true
            boolean cuentaActivada = dao.verificarCuenta(token);

            if (cuentaActivada) {
                // 3. RESPUESTA UX: Inyecta el mensaje de éxito y despacha a la vista principal
                request.setAttribute("mensajeExito", "¡Tu cuenta ha sido activada correctamente! Ya puedes iniciar sesión.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("mensajeError", "El enlace de verificación es inválido o ya ha expirado.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            // Protección de ruta si se accede sin parámetros
            response.sendRedirect("index.jsp");
        }
    }
}