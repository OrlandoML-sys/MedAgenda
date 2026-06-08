<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // CONTROL DE ACCESO: Verifica que exista una sesión activa y corresponda al rol permitido
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !"PACIENTE".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // VALIDACIÓN DE PARÁMETROS: Asegura recibir el identificador del médico destino
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

    <%-- Se activa si el controlador detecta colisión de horarios --%>
    <% if (request.getParameter("error") != null) { %>
    <div style="color: red; padding: 10px; background: #ffebee; border-radius: 5px; margin-bottom: 15px;">
        Hubo un problema al agendar. El horario podría estar ocupado.
    </div>
    <% } %>

    <%-- Envia la solicitud final de la cita al CitaServlet vía POST --%>
    <form action="CitaServlet" method="POST">
        <%-- Contexto inmutable del médico receptor mediante campo oculto --%>
        <input type="hidden" id="idDoctor" name="idDoctor" value="<%= idDoctorStr %>">

        <div class="form-group">
            <label for="fecha">1. Selecciona el día de tu consulta:</label>
            <%-- Disparador del evento de consulta asíncrona --%>
            <input type="date" id="fecha" name="fechaSeleccionada" required>
        </div>

        <%-- Se poblará dinámicamente según la respuesta del backend --%>
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
    // Escucha los cambios en el input de fecha para validar disponibilidad
    document.getElementById('fecha').addEventListener('change', function() {
        const fechaSeleccionada = this.value;
        const idDoctor = document.getElementById('idDoctor').value;
        const seccionHorarios = document.getElementById('seccionHorarios');
        const contenedorBotones = document.getElementById('contenedorBotones');

        // Auditoría interna en consola de desarrollador
        console.log("1. Detecté cambio de fecha:", fechaSeleccionada);
        console.log("2. ID Doctor:", idDoctor);

        if (!fechaSeleccionada) {
            seccionHorarios.style.display = 'none';
            return;
        }

        // Consulta el servlet encargado de interrogar los límites de la agenda
        const urlFetch = "${pageContext.request.contextPath}/HorariosServlet?idDoctor=" + idDoctor + "&fecha=" + fechaSeleccionada;
        console.log("3. URL corregida y blindada:", urlFetch);

        fetch(urlFetch)
            .then(response => {
                console.log("4. Respuesta HTTP recibida:", response.status);
                if (!response.ok) {
                    throw new Error('La respuesta del servidor no fue correcta');
                }
                return response.json(); // Parsea la matriz de cadenas (LocalTime JSON)
            })
            .then(horarios => {
                console.log("5. Datos JSON recibidos del servidor:", horarios);
                contenedorBotones.innerHTML = ''; // Limpieza de nodos del DOM

                if (horarios.length === 0) {
                    contenedorBotones.innerHTML = '<p style="color: #666; grid-column: 1/-1; font-style: italic;">No hay horarios disponibles para este día. Intenta con otra fecha.</p>';
                } else {
                    // Inyección de Radio Buttons con estilos de botón
                    horarios.forEach(hora => {
                        // Sanitización de formato: Remueve los segundos (:00) si son devueltos por la BD
                        const horaLimpia = hora.length > 5 ? hora.slice(0, -3) : hora;

                        console.log("Renderizando botón para la hora:", horaLimpia);

                        const label = document.createElement('label');
                        label.innerHTML =
                            '<input type="radio" name="horaSeleccionada" value="' + horaLimpia + '" required>' +
                            '<span class="hora-btn">' + horaLimpia + '</span>';

                        contenedorBotones.appendChild(label);
                    });
                }
                seccionHorarios.style.display = 'block'; // Muestra la rejilla con transiciones de Bootstrap
            })
            .catch(error => {
                console.error('!!! ERROR EN EL FETCH:', error);
            });
    });
</script>

</body>
</html>