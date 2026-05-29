<%@ page import="java.util.List" %>
<%@ page import="modelo.Expediente" %>
<%@ page import="datos.DAO.expedienteDAO" %>
<%
    // Recuperamos el objeto de la sesión
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");

    // Si no hay sesión iniciada, o si el rol NO es DOCTOR, lo pateamos de vuelta al login
    if (usuarioLogueado == null || !"PACIENTE".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    expedienteDAO daoExpediente = new expedienteDAO();
    List<Expediente> misExpedientes = daoExpediente.obtenerExpedientesPorPaciente(usuarioLogueado.getIdUsuario());
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Paciente</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stylesPaciente.css">
</head>
<body>

<nav class="navbar">
    <a href="#" class="logo">⚕️ MedAgenda</a>
    <div>Mi cuenta ▾</div>
</nav>

<div class="hero">
    <h1>Encuentra tu especialista y pide cita</h1>
    <p>Cientos de profesionales de la salud están aquí para ayudarte.</p>

    <form action="dashboardPaciente.jsp" method="GET" class="search-box">
        <input type="text" name="q" class="search-input" placeholder="Especialidad, enfermedad o nombre"
               value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
        <input type="text" name="ubicacion" class="search-input" placeholder="p. ej. Veracruz">
        <button type="submit" class="btn-search">🔍 Buscar</button>
    </form>
</div> <div class="categories">
    <a href="dashboardPaciente.jsp?q=Ginecólogo" class="category-tag">Ginecólogo</a>
    <a href="dashboardPaciente.jsp?q=Dermatólogo" class="category-tag">Dermatólogo</a>
    <a href="dashboardPaciente.jsp?q=Oftalmólogo" class="category-tag">Oftalmólogo</a>
    <a href="dashboardPaciente.jsp?q=Pediatra" class="category-tag">Pediatra</a>
</div>

<div style="max-width: 1000px; margin: 40px auto;">
    <%
        // 1. Capturamos AMBOS parámetros del formulario
        String queryBusqueda = request.getParameter("q");
        String ubicacionBusqueda = request.getParameter("direccion");

        // 2. Si buscó algo en CUALQUIERA de los dos campos, llamamos al DAO
        if ((queryBusqueda != null && !queryBusqueda.trim().isEmpty()) ||
                (ubicacionBusqueda != null && !ubicacionBusqueda.trim().isEmpty())) {

            datos.DAO.doctorDAO daoDoc = new datos.DAO.doctorDAO();

            List<modelo.Doctor> resultados = daoDoc.buscarDoctores(queryBusqueda, ubicacionBusqueda);

            if (resultados.isEmpty()) {
    %>
    <div style="text-align: center; padding: 20px; background: #fff3cd; border-radius: 8px; color: #856404;">
        No encontramos doctores que coincidan con tu búsqueda. Intenta con otros datos.
    </div>
    <%      } else {
        for(modelo.Doctor doc : resultados) {
            // Armamos el nombre completo concatenando los atributos de tu modelo
            String nombreCompleto = (doc.getNombre() != null ? doc.getNombre() : "") + " " +
                    (doc.getPaterno() != null ? doc.getPaterno() : "") + " " +
                    (doc.getMaterno() != null ? doc.getMaterno() : "");
    %>
    <div class="doctor-card" style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; border-left: 4px solid #00796b;">
        <div class="doctor-info">
            <h3 style="margin: 0; color: #00796b;">Dr(a). <%= doc.getNombre() != null ? doc.getNombre().replace("(", "").replace(")", "").replace(",", " ") : "Desconocido" %></h3>
            <p style="margin: 5px 0 0 0; color: #555; font-weight: bold;">🩺 <%= doc.getNombreEspecialidad() != null ? doc.getNombreEspecialidad().replaceAll("[\"(),]", "") : "Medicina General" %></p>
            <p style="margin: 5px 0 0 0; color: #999; font-size: 14px;">📍 <%= doc.getDireccion() != null ? doc.getDireccion() : "Dirección no especificada" %></p>
        </div>

        <a href="agendar.jsp?idDoctor=<%= doc.getIdDoctor() %>" class="btn-agendar" style="background-color: #00796b; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; transition: background 0.3s;">
            📅 Pedir Cita
        </a>
    </div>
    <%          }
    }
    }
    %>
</div>
</div>

<div style="max-width: 1000px; margin: 40px auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
    <h2 style="color: #00796b; margin-bottom: 20px; font-family: sans-serif;">Mi Historial y Recetas</h2>

    <table style="width: 100%; border-collapse: collapse; text-align: left; font-family: sans-serif;">
        <thead>
        <tr style="border-bottom: 2px solid #00796b; background-color: #f8f9fa;">
            <th style="padding: 15px 10px; color: #333;">Diagnóstico</th>
            <th style="padding: 15px 10px; color: #333;">Tratamiento / Receta</th>
            <th style="padding: 15px 10px; color: #333; text-align: center;">Acción</th>
        </tr>
        </thead>
        <tbody>
        <% if (misExpedientes == null || misExpedientes.isEmpty()) { %>
        <tr>
            <td colspan="4" style="padding: 30px; text-align: center; color: #888; font-style: italic;">
                Aún no tienes un historial médico o recetas registradas en el sistema.
            </td>
        </tr>
        <% } else {
            for (Expediente e : misExpedientes) { %>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 15px 10px; color: #555;"><%= e.getDiagnostico() %></td>
            <td style="padding: 15px 10px; color: #00796b; font-weight: bold;"><%= e.getTratamiento() %></td>
            <td style="padding: 15px 10px; text-align: center;">
                <button onclick="window.print()" style="background-color: #17a2b8; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-size: 13px; font-weight: bold;">
                    🖨️ Imprimir
                </button>
            </td>
        </tr>
        <%  }
        } %>
        </tbody>
    </table>
</div>

</body>
</html>