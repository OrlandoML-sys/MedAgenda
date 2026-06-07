<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !"PACIENTE".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idDoctorStr = request.getParameter("idDoctor");
    if(idDoctorStr == null || idDoctorStr.isEmpty()){
        response.sendRedirect("dashboardPaciente.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Agendar Cita - MedAgenda</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stylesAgendar.css">
</head>
<body>

<div class="container">
    <h2>Agendar Cita</h2>

    <% if (request.getParameter("error") != null) { %>
    <div style="color: red; padding: 10px; background: #ffebee; border-radius: 5px; margin-bottom: 15px;">
        Hubo un problema al agendar. El horario podría estar ocupado.
    </div>
    <% } %>

    <form action="CitaServlet" method="POST">
        <input type="hidden" id="idDoctor" name="idDoctor" value="<%= idDoctorStr %>">

        <div class="form-group">
            <label for="fecha">1. Selecciona el día de tu consulta:</label>
            <input type="date" id="fecha" name="fechaSeleccionada" required>
        </div>

        <div class="form-group" id="seccionHorarios" style="display: none;">
            <label>2. Horarios disponibles para este día:</label>
            <div id="contenedorBotones" class="horarios-grid">
            </div>
        </div>

        <div class="form-group">
            <label for="motivo">Motivo de la consulta:</label>
            <textarea id="motivo" name="motivo" rows="3" required></textarea>
        </div>

        <button type="submit" class="btn-submit">Confirmar Cita</button>
    </form>
</div>

<script>
    document.getElementById('fecha').addEventListener('change', function() {
        const fechaSeleccionada = this.value;
        const idDoctor = document.getElementById('idDoctor').value;
        const seccionHorarios = document.getElementById('seccionHorarios');
        const contenedorBotones = document.getElementById('contenedorBotones');

        // PUNTO DE CONTROL 1: Consola del navegador
        console.log("1. Detecté cambio de fecha:", fechaSeleccionada);
        console.log("2. ID Doctor:", idDoctor);

        if (!fechaSeleccionada) {
            seccionHorarios.style.display = 'none';
            return;
        }

        const urlFetch = "${pageContext.request.contextPath}/HorariosServlet?idDoctor=" + idDoctor + "&fecha=" + fechaSeleccionada;
        console.log("3. URL corregida y blindada:", urlFetch);

        fetch(urlFetch)
            .then(response => {
                console.log("4. Respuesta HTTP recibida:", response.status);
                if (!response.ok) {
                    throw new Error('La respuesta del servidor no fue correcta');
                }
                return response.json();
            })
            .then(horarios => {
                console.log("5. Datos JSON recibidos del servidor:", horarios);
                contenedorBotones.innerHTML = '';

                if (horarios.length === 0) {
                    contenedorBotones.innerHTML = '<p style="color: #666; grid-column: 1/-1; font-style: italic;">No hay horarios disponibles para este día. Intenta con otra fecha.</p>';
                } else {
                    horarios.forEach(hora => {
                        const horaLimpia = hora.length > 5 ? hora.slice(0, -3) : hora;

                        console.log("Renderizando botón para la hora:", horaLimpia);

                        const label = document.createElement('label');

                        label.innerHTML =
                            '<input type="radio" name="horaSeleccionada" value="' + horaLimpia + '" required>' +
                            '<span class="hora-btn">' + horaLimpia + '</span>';

                        contenedorBotones.appendChild(label);
                    });
                }
                seccionHorarios.style.display = 'block';
            })
            .catch(error => {
                console.error('!!! ERROR EN EL FETCH:', error);
            });
    });
</script>

</body>
</html>