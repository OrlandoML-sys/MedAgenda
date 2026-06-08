<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // CONTROL DE ACCESO: Restringe la vista únicamente a usuarios autenticados con el rol de DOCTOR
    modelo.Usuario uLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");
    if (uLogueado == null || !"DOCTOR".equals(uLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Configurar Perfil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/perfil.css">
</head>
<body>
<div class="container py-5" style="max-width: 800px;">
    <div class="card shadow-sm border-0 rounded-3">
        <div class="profile-header"></div>
        <div class="card-body px-5 pb-5">
            <div class="profile-avatar">
                <i class="fa-solid fa-user-doctor"></i>
            </div>
            <h3 class="text-center fw-bold text-dark mb-1">Completar Perfil Profesional</h3>
            <p class="text-center text-muted small mb-4">Esta información será visible para los pacientes en tu perfil público.</p>

            <%-- Intercepta el evento nativo para simular el comportamiento estético detallado en el reporte técnico --%>
            <form action="#" method="POST" onsubmit="alert('✅ Funcionalidad de actualización de perfil programada para la Fase 2 del desarrollo.'); return false;">

                <h6 class="text-medagenda fw-bold mb-3 border-bottom pb-2">Información del Consultorio</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label small text-muted">Teléfono del Consultorio</label>
                        <input type="text" class="form-control" placeholder="Ej. 229 123 4567">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small text-muted">Costo Promedio de Consulta (MXN)</label>
                        <input type="number" class="form-control" placeholder="Ej. 800">
                    </div>
                    <div class="col-md-12">
                        <label class="form-label small text-muted">Aseguradoras Aliadas (Opcional)</label>
                        <input type="text" class="form-control" placeholder="Ej. GNP, MetLife, AXA...">
                    </div>
                </div>

                <h6 class="text-medagenda fw-bold mb-3 border-bottom pb-2">Perfil Clínico</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-12">
                        <label class="form-label small text-muted">Resumen Profesional (Biografía)</label>
                        <textarea class="form-control" rows="4" placeholder="Describe tu experiencia, certificaciones and enfoque médico..."></textarea>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label small text-muted">Enfermedades Tratadas</label>
                        <input type="text" class="form-control" placeholder="Ej. Diabetes, Hipertensión, Asma...">
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-5">
                    <a href="dashboardDoctor.jsp" class="btn btn-outline-secondary px-4">Volver al Panel</a>
                    <button type="submit" class="btn bg-medagenda px-5 fw-bold">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>