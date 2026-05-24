<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% if (request.getAttribute("error") != null) { %>
<div style="color: red; padding: 10px; background: #ffebee; border-radius: 5px; max-width: 600px; margin: 10px auto;">
    <%= request.getAttribute("error") %>
</div>
<% } %>
<!DOCTYPE html>
<html>
<head>
    <title>Agendar Cita - MedAgenda</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stylesAgendar.css">
</head>
<body>

<div class="container">
    <h2>Agendar Cita</h2>

    <form action="CitaServlet" method="POST">
        <!-- El valor se toma dinámicamente del parámetro de la URL -->
        <input type="hidden" id="idDoctor" name="idDoctor" value="1">

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

        console.log("Depurando valores:", { idDoctor, fechaSeleccionada }); // Mira esto en la consola F12

        if (!fechaSeleccionada) {
            seccionHorarios.style.display = 'none';
            return;
        }

        // Petición asíncrona directa al controlador
        fetch(`HorariosServlet?idDoctor=${idDoctor}&fecha=${fechaSeleccionada}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('La respuesta del servidor no fue correcta');
                }
                return response.json();
            })
            .then(horarios => {
                contenedorBotones.innerHTML = '';

                // Si el arreglo viene vacío, significa que el doctor no labora o no tiene disponibilidad
                if (horarios.length === 0) {
                    contenedorBotones.innerHTML = '<p style="color: #666; grid-column: 1/-1; font-style: italic;">No hay horarios disponibles para este día. Intenta con otra fecha.</p>';
                } else {
                    // Mapeamos los horarios reales traídos desde PostgreSQL
                    horarios.forEach(hora => {
                        // Limpieza dinámica de los segundos (:00) si es que vienen incluidos en la cadena
                        const horaLimpia = hora.length > 5 ? hora.slice(0, -3) : hora;

                        const label = document.createElement('label');
                        label.innerHTML = `
                            <input type="radio" name="horaSeleccionada" value="${horaLimpia}" required>
                            <span class="hora-btn">${horaLimpia}</span>
                        `;
                        contenedorBotones.appendChild(label);
                    });
                }

                // Desplegamos la sección de manera interactiva
                seccionHorarios.style.display = 'block';
            })
            .catch(error => {
                console.error('Error al recuperar los horarios:', error);
            });
    });
</script>

</body>
</html>