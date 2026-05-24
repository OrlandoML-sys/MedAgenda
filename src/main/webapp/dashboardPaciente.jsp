<%
    // Recuperamos el objeto de la sesión
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");

    // Si no hay sesión iniciada, o si el rol NO es DOCTOR, lo pateamos de vuelta al login
    if (usuarioLogueado == null || !"PACIENTE".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return; // El return es vital para que la página deje de cargar inmediatamente
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

    <div class="search-box">
        <input type="text" class="search-input" placeholder="Especialidad, enfermedad o nombre">
        <input type="text" class="search-input" placeholder="p. ej. Veracruz">
        <button class="btn-search">🔍 Buscar</button>
    </div>
</div>

<div class="categories">
    <a href="#" class="category-tag">Ginecólogo</a>
    <a href="#" class="category-tag">Dermatólogo</a>
    <a href="#" class="category-tag">Oftalmólogo</a>
    <a href="#" class="category-tag">Pediatra</a>
    <a href="#" class="category-tag">Odontólogo</a>
</div>

<div class="doctor-card">
    <div class="doctor-info">
        <h3>Dr. Armando Casas (Médico Cirujano)</h3>
        <p>📍 Clínica Las Américas, Veracruz</p>
    </div>
    <a href="agendar.jsp?idDoctor=1" class="btn-agendar">📅 Pedir Cita</a>
</div>

</body>
</html>