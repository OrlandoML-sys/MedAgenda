<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Cita" %>
<%@ page import="datos.DAO.citaDAO" %>
<%
    // Recuperamos el objeto de la sesión
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");

    // Si no hay sesión iniciada, o si el rol NO es DOCTOR, lo pateamos de vuelta al login
    if (usuarioLogueado == null || !"DOCTOR".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }


    // OBTENER LAS CITAS DEL DOCTOR
    citaDAO daoCita = new citaDAO();
    List<Cita> misCitas = daoCita.obtenerCitasPorDoctor(usuarioLogueado.getIdUsuario());

    // NÚMEROS DINÁMICOS PARA LAS MÉTRICAS
    int totalCitas = misCitas.size();
    int vistasPerfil = (int) (Math.random() * 50) + 15;
    int clicsContacto = (int) (Math.random() * 10) + 2;

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String nombreDoctor = "Doctor Registrado";
    try (java.sql.Connection conn = datos.conection.getConnection();
         java.sql.PreparedStatement ps = conn.prepareStatement("SELECT nombre FROM doctor WHERE idusuario = ?")) {

        ps.setInt(1, usuarioLogueado.getIdUsuario());
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String nomRaw = rs.getString("nombre");
                if (nomRaw != null) {
                    nombreDoctor = nomRaw.replaceAll("[\"(),]", " ").trim();
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Panel Médico</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stylesDoctor.css">
</head>
<body>

<div class="sidebar">
    <div class="logo-area">⚕️ MedAgenda</div>
    <a href="dashboardDoctor.jsp" class="menu-item active">Vista general</a>

    <a href="#seccion-agenda" class="menu-item">Mis Citas</a>

    <a href="pacientes.jsp" class="menu-item">Pacientes</a>

    <a href="#" onclick="alert('Módulo de edición de perfil en construcción.'); return false;" class="menu-item">Editar
        perfil</a>

    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>
    <a href="#" class="menu-item"></a>

    <a href="logoutServlet" class="menu-item text-danger fw-bold"><i class="fa-solid fa-right-from-bracket me-2"></i>Cerrar
        sesión</a>
</div>

<div class="main-content">

    <% if ("1".equals(request.getParameter("expedienteGuardado"))) { %>
    <div class="alerta-temporal" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb; transition: all 0.5s ease-in-out;">
        <strong>¡Éxito!</strong> El expediente clínico se guardó correctamente.
    </div>
    <% } %>

    <% if ("1".equals(request.getParameter("pagoExitoso"))) { %>
    <div class="alerta-temporal" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb; transition: all 0.5s ease-in-out;">
        <strong>¡Pago registrado!</strong> La transacción se ha guardado correctamente.
    </div>
    <% } %>

    <div class="top-banner">
        <span>Convierte el interés de los pacientes en agendamientos</span>
        <button class="btn-outline">Descubrir planes</button>
    </div>

    <!-- SALUDO DINÁMICO -->
    <h2>Hola, Dr(a). <%= nombreDoctor %>
    </h2>
    <p style="color: red;">ID de Usuario en Sesión: <%= usuarioLogueado.getIdUsuario() %>
    </p>
    <span class="subtitle">Algunas métricas y acciones recomendadas para ti</span>

    <div class="card-container">
        <!-- Tarjeta 1 -->
        <div class="card highlight">
            <h3>Completar perfil</h3>
            <p>Mejora tu posición en MedAgenda agregando más información a tu perfil público.</p>
            <button style="background: white; border: 1px solid #00796b; color: #00796b; padding: 8px 15px; border-radius: 5px; cursor: pointer;">
                Agregar información
            </button>
        </div>

        <!-- Tarjeta 2 -->
        <div class="card">
            <h3>Interés del paciente <span style="font-size: 12px; font-weight: normal; color: #999; float: right;">Últimos 30 días</span>
            </h3>
            <div class="metric-row">
                <span>👁️ Vistas al perfil</span>
                <span class="metric-value"><%= vistasPerfil %></span>
            </div>
            <div class="metric-row">
                <span>📅 Intentos de cita</span>
                <span class="metric-value"><%= totalCitas %></span>
            </div>
            <div class="metric-row">
                <span>📞 Clics en contacto</span>
                <span class="metric-value"><%= clicsContacto %></span>
            </div>
        </div>
    </div>

    <!-- NUEVA SECCIÓN: AGENDA DE CITAS -->
    <h3 id="seccion-agenda" tyle="margin-top: 40px; color: #333;">Mi Agenda</h3>
    <div class="card" style="width: 100%; padding: 20px; overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
            <tr style="border-bottom: 2px solid #eee;">
                <th style="padding: 12px 8px; color: #666;">Paciente</th>
                <th style="padding: 12px 8px; color: #666;">Fecha y Hora</th>
                <th style="padding: 12px 8px; color: #666;">Motivo</th>
                <th style="padding: 12px 8px; color: #666;">Estado</th>
                <th style="padding: 12px 8px; color: #666; text-align: center;">Acciones</th>
            </tr>
            </thead>
            <tbody>
            <% if (misCitas == null || misCitas.isEmpty()) { %>
            <tr>
                <td colspan="5" style="padding: 20px; text-align: center; color: #999;">No tienes citas agendadas por el
                    momento.
                </td>
            </tr>
            <% } else {
                for (Cita c : misCitas) { %>
            <tr style="border-bottom: 1px solid #eee;">
                <td style="padding: 12px 8px; font-weight: bold; color: #00796b;">
                    <i class="fa-solid fa-user me-2"></i> <%= c.getNombrePaciente() != null ? c.getNombrePaciente().replace("(", "").replace(")", "").replace(",", " ") : "Desconocido" %>
                </td>
                <td style="padding: 12px 8px;"><%= c.getFechaHora() != null ? c.getFechaHora().toString().substring(0, 16) : "Sin asignar" %>
                </td>
                <td style="padding: 12px 8px;"><%= c.getMotivo() %>
                </td>
                <td style="padding: 12px 8px;">
                    <%
                        // Evaluamos dinámicamente el color según el estado real de la DB
                        String estiloBadge = "background-color: #fff3cd; color: #856404;"; // Amarillo por defecto (PENDIENTE / REALIZADA)
                        if ("PAGADA".equals(c.getEstado())) {
                            estiloBadge = "background-color: #d4edda; color: #155724;"; // Verde éxito
                        } else if ("CANCELADA".equals(c.getEstado())) {
                            estiloBadge = "background-color: #f8d7da; color: #721c24;"; // Rojo peligro
                        }
                    %>
                    <span style="padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; <%= estiloBadge %>">
        <%= c.getEstado() %>
    </span>
                </td>
                <td style="padding: 12px 8px; text-align: center;">
                    <a href="crearExpediente.jsp?idCita=<%= c.getIdCita() %>"
                       style="background-color: #00796b; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 13px; margin-right: 5px;">
                        📝 Expediente
                    </a>

                    <% if ("REALIZADA".equals(c.getEstado())) { %>
                    <a href="registrarPago.jsp?idCita=<%= c.getIdCita() %>"
                       style="background-color: #28a745; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 13px;">
                        💰 Cobrar
                    </a>
                    <% } %>
                </td>
            </tr>
            <% }
            } %>
            </tbody>
        </table>
    </div>

</div>
<script>
    // Cuando la página termine de cargar por completo...
    window.addEventListener('DOMContentLoaded', () => {
        const alertas = document.querySelectorAll('.alerta-temporal');

        if (alertas.length > 0) {
            setTimeout(() => {
                alertas.forEach(alerta => {
                    alerta.style.opacity = '0';
                    alerta.style.transform = 'translateY(-10px)';

                    setTimeout(() => {
                        alerta.style.display = 'none';
                    }, 500);
                });
            }, 4000);

            if (window.history.replaceState) {
                const urlLimpia = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({ path: urlLimpia }, '', urlLimpia);
            }
        }
    });
</script>
</body>
</html>