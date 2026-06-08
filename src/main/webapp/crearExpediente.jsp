<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Crear Expediente Clínico</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stylesExpediente.css">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-medagenda shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">⚕️ MedAgenda - Panel Médico</a>
    </div>
</nav>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <%-- Notificación visual si el backend falla al procesar el insert --%>
            <% if("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i> Hubo un problema al guardar el expediente. Revisa los datos.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-white border-bottom py-3">
                    <h4 class="card-title mb-0 fw-bold text-medagenda">
                        <i class="fa-solid fa-file-medical me-2"></i>Nueva Nota Médica / Expediente
                    </h4>
                </div>

                <%-- Envía los datos clínicos a ExpedienteServlet vía POST --%>
                <form action="ExpedienteServlet" method="POST" class="needs-validation" novalidate>

                    <%-- Envía de forma oculta el ID de la cita vinculada --%>
                    <input type="hidden" name="idCita" value="<%= request.getParameter("idCita") %>">

                    <div class="card-body p-4">

                        <div class="mb-4">
                            <label class="form-label fw-bold"><i class="fa-solid fa-stethoscope text-muted me-2"></i>Diagnóstico Clínico</label>
                            <textarea name="diagnostico" class="form-control border-medagenda" rows="4"
                                      placeholder="Escribe el diagnóstico detallado del paciente..." required></textarea>
                            <div class="invalid-feedback">Por favor, introduce el diagnóstico.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold"><i class="fa-solid fa-pills text-muted me-2"></i>Tratamiento y Prescripción</label>
                            <textarea name="tratamiento" class="form-control border-medagenda" rows="4"
                                      placeholder="Indica los medicamentos, dosis y duración del tratamiento..." required></textarea>
                            <div class="invalid-feedback">Por favor, introduce el tratamiento recomendado.</div>
                        </div>

                        <div class="p-3 bg-light rounded-3 border mb-4">
                            <h6 class="fw-bold text-secondary mb-3"><i class="fa-solid fa-brackets-curly me-2"></i>Datos Adicionales (Estructura Inteligente)</h6>
                            <div class="row">
                                <div class="col-md-12">
                                    <label class="form-label small fw-bold text-muted">Alergias Reportadas</label>
                                    <%-- Este input se mapeará directamente en el objeto JSON que va a la columna notasjson --%>
                                    <input type="text" name="alergias" class="form-control"
                                           placeholder="Ej: Penicilina, mariscos (dejar vacío si no presenta)">
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="card-footer bg-white border-top p-3 d-flex justify-content-between align-items-center">
                        <a href="dashboardDoctor.jsp" class="btn btn-outline-secondary px-4"><i class="fa-solid fa-arrow-left me-2"></i>Volver</a>
                        <button type="submit" class="btn btn-medagenda px-5 fw-bold shadow-sm">
                            <i class="fa-solid fa-floppy-disk me-2"></i>Guardar Expediente
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Escucha el submit e intercepta el envío si hay campos obligatorios vacíos
    (() => {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated') // Activa los estilos visuales de error de Bootstrap
            }, false)
        })
    })()
</script>
</body>
</html>