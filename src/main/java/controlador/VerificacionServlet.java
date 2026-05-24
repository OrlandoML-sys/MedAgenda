package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/verificar")
public class VerificacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token != null && !token.isEmpty()) {
            datos.DAO.usuarioDAO dao = new datos.DAO.usuarioDAO();
            boolean cuentaActivada = dao.verificarCuenta(token);

            if (cuentaActivada) {
                request.setAttribute("mensajeExito", "¡Tu cuenta ha sido activada correctamente! Ya puedes iniciar sesión.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("mensajeError", "El enlace de verificación es inválido o ya ha expirado.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}