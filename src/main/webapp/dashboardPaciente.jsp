<%@ page import="java.util.List" %>
<%@ page import="modelo.Expediente" %>
<%@ page import="datos.DAO.expedienteDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String nombrePaciente = "Paciente Registrado";
    try (java.sql.Connection conn = datos.conection.getConnection();
         java.sql.PreparedStatement ps = conn.prepareStatement("SELECT nombre FROM paciente WHERE idpaciente = ?")) {

        ps.setInt(1, usuarioLogueado.getIdUsuario());
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String nomRaw = rs.getString("nombre");
                if (nomRaw != null) {
                    nombrePaciente = nomRaw.replaceAll("[\"(),]", " ").trim();
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
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
    <a href="dashboardPaciente.jsp?q=Ginecología" class="category-tag">Ginecólogo</a>
    <a href="dashboardPaciente.jsp?q=Dermatología" class="category-tag">Dermatólogo</a>
    <a href="dashboardPaciente.jsp?q=Oftalmología" class="category-tag">Oftalmólogo</a>
    <a href="dashboardPaciente.jsp?q=Pediatría" class="category-tag">Pediatra</a>
</div>

<div style="max-width: 1000px; margin: 40px auto;">
    <%
        // 1. Capturamos AMBOS parámetros del formulario
        String queryBusqueda = request.getParameter("q");
        String ubicacionBusqueda = request.getParameter("ubicacion");

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
            <th style="padding: 15px 10px; color: #333; width: 15%;">Fecha</th>
            <th style="padding: 15px 10px; color: #333; width: 20%;">Doctor</th>
            <th style="padding: 15px 10px; color: #333; width: 30%;">Diagnóstico</th>
            <th style="padding: 15px 10px; color: #333; width: 25%;">Tratamiento / Receta</th>
            <th style="padding: 15px 10px; color: #333; text-align: center; width: 10%;">Acción</th>
        </tr>
        </thead>
        <tbody>
        <% if (misExpedientes == null || misExpedientes.isEmpty()) { %>
        <tr>
            <td colspan="5" style="padding: 30px; text-align: center; color: #888; font-style: italic;">
                Aún no tienes un historial médico o recetas registradas en el sistema.
            </td>
        </tr>
        <% } else {
            for (Expediente e : misExpedientes) {
                String doctorLimpio = e.getNombreDoctor() != null ? e.getNombreDoctor().replaceAll("[\"(),]", " ").trim() : "Especialista";
                String fechaFormateada = e.getFechaCita() != null ? sdf.format(e.getFechaCita()) : "---";

                // Limpieza rápida de seguridad para evitar que comillas dobles rompan el HTML del atributo
                String diagSeguro = e.getDiagnostico() != null ? e.getDiagnostico().replace("\"", "&quot;") : "";
                String tratSeguro = e.getTratamiento() != null ? e.getTratamiento().replace("\"", "&quot;") : "";
        %>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 15px 10px; color: #666; font-size: 14px;"><%= fechaFormateada %></td>
            <td style="padding: 15px 10px; color: #333; font-weight: bold; font-size: 14px;">Dr(a). <%= doctorLimpio %></td>
            <td style="padding: 15px 10px; color: #555;"><%= e.getDiagnostico() %></td>
            <td style="padding: 15px 10px; color: #00796b; font-weight: bold;"><%= e.getTratamiento() %></td>
            <td style="padding: 15px 10px; text-align: center;">
                <button onclick="imprimirRecetaUnica(this)"
                        data-fecha="<%= fechaFormateada %>"
                        data-doctor="Dr(a). <%= doctorLimpio %>"
                        data-paciente="<%= nombrePaciente %>"
                        data-diagnostico="<%= diagSeguro %>"
                        data-tratamiento="<%= tratSeguro %>"
                        style="background-color: #17a2b8; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-size: 13px; font-weight: bold;">
                    🖨️ Imprimir
                </button>
            </td>
        </tr>
        <%  }
        } %>
        </tbody>
    </table>
</div>
<script>
    function imprimirRecetaUnica(boton) {
        const fecha = boton.getAttribute('data-fecha');
        const doctor = boton.getAttribute('data-doctor');
        const paciente = boton.getAttribute('data-paciente');
        const diagnostico = boton.getAttribute('data-diagnostico');
        const tratamiento = boton.getAttribute('data-tratamiento');

        const ventanaImpresion = window.open('', '_blank', 'height=600,width=800');

        ventanaImpresion.document.write('<html><head><title>Receta Médica - MedAgenda</title>');
        ventanaImpresion.document.write('<style>');
        ventanaImpresion.document.write(`
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #2c3e50; margin: 40px; padding: 0; }
        .header { text-align: center; border-bottom: 3px double #00796b; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { margin: 0; color: #00796b; font-size: 28px; letter-spacing: 1px; }
        .header p { margin: 5px 0 0 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .meta-container { display: flex; justify-content: space-between; margin-bottom: 40px; font-size: 15px; background: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #e2e8f0; }
        .meta-block p { margin: 4px 0; }
        .meta-block strong { color: #00796b; }
        .section { margin-bottom: 35px; }
        .section-title { font-size: 16px; font-weight: bold; color: #00796b; border-bottom: 1px solid #cbd5e1; padding-bottom: 4px; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .section-content { font-size: 15px; line-height: 1.6; color: #334155; white-space: pre-line; padding-left: 5px; }
        .treatment { font-weight: bold; color: #1e293b; background: #f0fdfa; padding: 15px; border-radius: 4px; border-left: 4px solid #00796b; }
        .footer-firma { margin-top: 90px; text-align: center; }
        .linea-firma { width: 250px; border-top: 1px solid #94a3b8; margin: 0 auto 8px auto; }
        .firma-texto { font-size: 13px; color: #64748b; }
        @media print {
            body { margin: 20px; }
            .meta-container { background: #ffffff !important; border: 1px solid #cbd5e1; }
            .treatment { background: #ffffff !important; border-left: 4px solid #00796b; }
        }
    `);
        ventanaImpresion.document.write('</style></head><body>');

        ventanaImpresion.document.write('<div class="header">');
        ventanaImpresion.document.write('<h1>⚕️ MEDAGENDA</h1>');
        ventanaImpresion.document.write('<p>Plataforma Integral de Gestión y Control Médico</p>');
        ventanaImpresion.document.write('</div>');

        ventanaImpresion.document.write('<div class="meta-container">');
        ventanaImpresion.document.write('<div class="meta-block">');
        ventanaImpresion.document.write('<p><strong>Paciente:</strong> ' + paciente + '</p>');
        ventanaImpresion.document.write('<p><strong>Médico Atendió:</strong> ' + doctor + '</p>');
        ventanaImpresion.document.write('</div>');
        ventanaImpresion.document.write('<div class="meta-block" style="text-align: right;">');
        ventanaImpresion.document.write('<p><strong>Fecha y Hora:</strong> ' + fecha + '</p>');
        ventanaImpresion.document.write('<p><strong>Documento:</strong> Expediente Clínico de Consulta</p>');
        ventanaImpresion.document.write('</div>');
        ventanaImpresion.document.write('</div>');

        ventanaImpresion.document.write('<div class="section">');
        ventanaImpresion.document.write('<div class="section-title">Valoración Diagnóstica</div>');
        ventanaImpresion.document.write('<div class="section-content">' + diagnostico + '</div>');
        ventanaImpresion.document.write('</div>');

        ventanaImpresion.document.write('<div class="section">');
        ventanaImpresion.document.write('<div class="section-title">Tratamiento e Indicaciones Médicas</div>');
        ventanaImpresion.document.write('<div class="section-content treatment">' + tratamiento + '</div>');
        ventanaImpresion.document.write('</div>');

        ventanaImpresion.document.write('<div class="footer-firma">');
        ventanaImpresion.document.write('<div class="linea-firma"></div>');
        ventanaImpresion.document.write('<div class="firma-texto">' + doctor + '<br>Firma y Sello del Especialista</div>');
        ventanaImpresion.document.write('</div>');

        ventanaImpresion.document.write('</body></html>');

        ventanaImpresion.document.close();
        ventanaImpresion.focus();

        setTimeout(function() {
            ventanaImpresion.print();
            ventanaImpresion.close();
        }, 250);
    }
</script>
</body>
</html>