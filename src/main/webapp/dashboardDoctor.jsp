<%
    // Recuperamos el objeto de la sesión
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");

    // Si no hay sesión iniciada, o si el rol NO es DOCTOR, lo pateamos de vuelta al login
    if (usuarioLogueado == null || !"DOCTOR".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return; // El return es vital para que la página deje de cargar inmediatamente
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <a href="#" class="menu-item active">Vista general</a>
    <a href="#" class="menu-item">Mis Citas</a>
    <a href="#" class="menu-item">Pacientes</a>
    <a href="#" class="menu-item">Editar perfil</a>
    <a href="#" class="menu-item">Configurar horarios</a>
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
    <a href="#" class="menu-item">Mi cuenta</a>
</div>

<div class="main-content">
    <div class="top-banner">
        <span>Convierte el interés de los pacientes en agendamientos</span>
        <button class="btn-outline">Descubrir planes</button>
    </div>

    <h2>Hola, Orlando Madrigal Lagunes</h2>
    <span class="subtitle">Algunas métricas y acciones recomendadas para ti</span>

    <div class="card-container">
        <!-- Tarjeta 1 -->
        <div class="card highlight">
            <h3>Completar perfil</h3>
            <p>Mejora tu posición en MedAgenda agregando más información a tu perfil público.</p>
            <button style="background: white; border: 1px solid #00796b; color: #00796b; padding: 8px 15px; border-radius: 5px; cursor: pointer;">Agregar información</button>
        </div>

        <!-- Tarjeta 2 -->
        <div class="card">
            <h3>Interés del paciente <span style="font-size: 12px; font-weight: normal; color: #999; float: right;">Últimos 30 días</span></h3>
            <div class="metric-row">
                <span>👁️ Vistas al perfil</span>
                <span class="metric-value">0</span>
            </div>
            <div class="metric-row">
                <span>📅 Intentos de cita</span>
                <span class="metric-value">0</span>
            </div>
            <div class="metric-row">
                <span>📞 Clics en contacto</span>
                <span class="metric-value">0</span>
            </div>
        </div>
    </div>
</div>

</body>
</html>