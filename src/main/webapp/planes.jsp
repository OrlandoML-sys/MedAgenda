<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // CONTROL DE ACCESO: Protege la ruta verificando la sesión activa y restringiendo al rol Doctor
    modelo.Usuario usuarioLogueado = (modelo.Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !"DOCTOR".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Planes de Suscripción</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/planes.css">
</head>
<body>

<div class="container py-5">
    <%-- Presentación de la estrategia de monetización Freemium detallada en el reporte --%>
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold text-medagenda">Modelo Freemium</h1>
        <p class="lead text-muted max-width-600 mx-auto" style="font-size: 16px;">
            Modelo B2B escalonado diseñado para abarcar desde médicos recién egresados hasta policlínicas establecidas.
        </p>
    </div>

    <div class="row g-4 justify-content-center align-items-stretch">

        <div class="col-md-4 d-flex">
            <div class="card plan-card p-4 w-100 d-flex flex-column justify-content-between">
                <div>
                    <div class="text-center mb-3">
                        <span class="fs-1">🎁</span>
                        <h3 class="fw-bold mt-2 h4">Plan Básico</h3>
                        <p class="text-muted small italic">Gancho de atracción.</p>
                    </div>
                    <div class="text-center my-4">
                        <div class="price text-success">Gratuito</div>
                    </div>
                    <hr>
                    <ul class="list-unstyled space-y-2 text-secondary" style="font-size: 14px; line-height: 2;">
                        <li><i class="fa-solid fa-check text-success me-2"></i> Gestión para 1 médico.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Límite de 50 citas al mes.</li>
                        <li class="text-danger"><i class="fa-solid fa-xmark me-2"></i> Sin recordatorios automáticos.</li>
                    </ul>
                </div>
                <div class="d-grid mt-4">
                    <button class="btn btn-outline-secondary disabled fw-bold">Plan Activo por Defecto</button>
                </div>
            </div>
        </div>

        <div class="col-md-4 d-flex">
            <div class="card plan-card plan-destacado p-4 w-100 d-flex flex-column justify-content-between">
                <span class="badge-estrella">⭐ Producto Estrella</span>
                <div>
                    <div class="text-center mb-3 mt-2">
                        <span class="fs-1">👨‍⚕️</span>
                        <h3 class="fw-bold mt-2 h4 text-medagenda">Plan Profesional</h3>
                        <p class="text-muted small">El producto estrella.</p>
                    </div>
                    <div class="text-center my-4">
                        <div class="price">$500 <span>MXN / mes</span></div>
                    </div>
                    <hr>
                    <ul class="list-unstyled space-y-2 text-secondary" style="font-size: 14px; line-height: 2;">
                        <li><i class="fa-solid fa-check text-success me-2"></i> Citas y pacientes ilimitados.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Recordatorios por WhatsApp.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Expedientes clínicos completos.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Acceso para 2 usuarios.</li>
                    </ul>
                </div>
                <div class="d-grid mt-4">
                    <%-- Mensaje controlado que delimita el alcance de la fase de desarrollo actual --%>
                    <button onclick="alert('Módulo de pasarela de pago (Stripe/PayPal) en desarrollo comercial.')" class="btn bg-medagenda text-white fw-bold shadow-sm">
                        Contratar Plan Profesional
                    </button>
                </div>
            </div>
        </div>

        <div class="col-md-4 d-flex">
            <div class="card plan-card p-4 w-100 d-flex flex-column justify-content-between">
                <div>
                    <div class="text-center mb-3">
                        <span class="fs-1">🏥</span>
                        <h3 class="fw-bold mt-2 h4">Plan Clínica</h3>
                        <p class="text-muted small">Para policlínicas.</p>
                    </div>
                    <div class="text-center my-4">
                        <div class="price">$1,200 <span>MXN / mes</span></div>
                    </div>
                    <hr>
                    <ul class="list-unstyled space-y-2 text-secondary" style="font-size: 14px; line-height: 2;">
                        <li><i class="fa-solid fa-check text-success me-2"></i> Múltiples médicos en una agenda.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Reportes financieros avanzados.</li>
                        <li><i class="fa-solid fa-check text-success me-2"></i> Personalización con logotipo.</li>
                    </ul>
                </div>
                <div class="d-grid mt-4">
                    <button onclick="alert('Módulo de pasarela de pago (Stripe/PayPal) en desarrollo comercial.')" class="btn btn-outline-dark fw-bold">
                        Contratar Plan Clínica
                    </button>
                </div>
            </div>
        </div>

    </div>

    <div class="text-center mt-5">
        <a href="dashboardDoctor.jsp" class="btn btn-link text-decoration-none text-secondary">
            <i class="fa-solid fa-arrow-left me-2"></i> Volver al Panel de Control
        </a>
    </div>
</div>

</body>
</html>