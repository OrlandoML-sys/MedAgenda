package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controlador de Cierre de Sesión.
 * Encargado de destruir los objetos de sesión para liberar memoria del servidor y proteger la ruta.
 */
@WebServlet("/logoutServlet")
public class logoutServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recupera la sesión actual sin crear una nueva (false)
        HttpSession sesion = request.getSession(false);

        if (sesion != null) {
            sesion.invalidate(); // Destruye variables globales y token de usuario
        }

        // Redirige al Landing Page público
        response.sendRedirect("index.jsp");
    }
}