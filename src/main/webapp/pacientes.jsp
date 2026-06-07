<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.HistorialClinico" %>
<%@ page import="datos.DAO.historialDAO" %>
<%
    modelo.Usuario uLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");
    if (uLogueado == null || !"DOCTOR".equals(uLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }

    int idUsuario = uLogueado.getIdUsuario();
    historialDAO hDAO = new historialDAO();
    List<HistorialClinico> historiales = hDAO.obtenerHistorialPorUsuario(idUsuario);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Directorio de Pacientes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">

<div class="container py-5" style="max-width: 900px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold" style="color: #00796b;"><i class="fa-solid fa-book-medical me-2"></i> Directorio y Registro Clínico</h2>
        <a href="dashboardDoctor.jsp" class="btn btn-outline-secondary">Volver al Dashboard</a>
    </div>

    <% if (historiales.isEmpty()) { %>
    <div class="alert alert-info text-center py-4">
        Aún no tienes consultas en tu registro.
    </div>
    <% } else { %>
    <div class="accordion shadow-sm" id="accordionHistorial">
        <%
            int contador = 0;
            for (HistorialClinico h : historiales) {
                contador++;
                String collapseId = "collapse" + contador;
                String headingId = "heading" + contador;
        %>
        <div class="accordion-item border-0 border-bottom">
            <h2 class="accordion-header" id="<%= headingId %>">
                <button class="accordion-button collapsed py-3" type="button" data-bs-toggle="collapse" data-bs-target="#<%= collapseId %>">
                    <div class="d-flex justify-content-between w-100 pe-3">
                        <strong>👤 <%= h.getNombrePaciente() %></strong>
                        <span class="text-muted small">📅 <%= h.getFechaCita() %></span>
                    </div>
                </button>
            </h2>
            <div id="<%= collapseId %>" class="accordion-collapse collapse" data-bs-parent="#accordionHistorial">
                <div class="accordion-body bg-white p-4">
                    <div class="mb-3">
                        <span class="badge bg-secondary mb-2">Motivo reportado por el paciente</span>
                        <p class="mb-0 text-dark"><%= h.getMotivoCita() != null ? h.getMotivoCita() : "Sin motivo especificado." %></p>
                    </div>

                    <hr class="text-muted opacity-25">

                    <div class="row">
                        <div class="col-md-6 border-end">
                            <h6 class="text-success fw-bold"><i class="fa-solid fa-stethoscope me-1"></i> Diagnóstico Médico</h6>
                            <% if (h.getDiagnostico() != null) { %>
                            <p class="text-muted small"><%= h.getDiagnostico() %></p>
                            <% } else { %>
                            <p class="text-warning small fst-italic">Expediente aún no llenado por el médico.</p>
                            <% } %>
                        </div>
                        <div class="col-md-6 ps-4">
                            <h6 class="text-primary fw-bold"><i class="fa-solid fa-pills me-1"></i> Receta / Tratamiento</h6>
                            <% if (h.getReceta() != null) { %>
                            <p class="text-muted small font-monospace"><%= h.getReceta() %></p>
                            <% } else { %>
                            <p class="text-warning small fst-italic">Sin receta registrada.</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>