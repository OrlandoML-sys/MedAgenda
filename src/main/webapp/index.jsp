<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Doctor" %>
<%@ page import="datos.DAO.doctorDAO" %>
<!DOCTYPE html>
<html lang="es" style="scroll-behavior: smooth;">
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Encuentra tu especialista</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-medagenda fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">
            <span class="fs-4">⚕️ MedAgenda</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center">
                <li class="nav-item">
                    <a class="nav-link text-white" href="#aboutUs">Acerca de nosotros</a>
                </li>
                <li class="nav-item ms-3">
                    <button class="btn btn-outline-light border-0" data-bs-toggle="modal" data-bs-target="#modalLogin">Iniciar sesión</button>
                </li>
                <li class="nav-item ms-2">
                    <button class="btn btn-light text-medagenda fw-bold rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#modalRegistro">Crear cuenta</button>
                </li>
            </ul>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-4 fw-bold mb-3">Encuentra tu especialista y pide cita</h1>
                <p class="lead mb-4">Miles de profesionales de la salud están aquí para ayudarte a ti y a tu familia.</p>

                <form action="index.jsp" method="GET" class="bg-white p-2 rounded shadow-sm d-flex w-100">
                    <input type="text" name="q" class="form-control border-0"
                           placeholder="Especialidad o nombre del doctor..."
                           value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" required>
                    <button type="submit" class="btn btn-success bg-medagenda px-4">🔍 Buscar</button>
                </form>
            </div>

            <div class="col-lg-6 d-none d-lg-block position-relative" style="min-height: 400px;">
                <div class="card shadow-lg p-4 border-0 position-absolute floating-card"
                     style="width: 380px; border-radius: 16px; top: 15px; left: 215px; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); z-index: 2;">
                    <div class="d-flex align-items-center mb-3">
                        <div class="bg-success-subtle text-success rounded-circle d-flex align-items-center justify-content-center fw-bold fs-4"
                             style="width: 50px; height: 50px; background-color: #e0f2f1; color: #00796b !important;">
                            SH
                        </div>
                        <div class="ms-3 text-start">
                            <h5 class="mb-0 fw-bold text-dark" style="font-size: 16px;">Dr(a). Sofía Hernández P.</h5>
                            <p class="mb-0 text-muted small">💡 Dermatología · UV</p>
                        </div>
                        <span class="badge ms-auto bg-success" style="background-color: #2ecc71 !important; font-size: 11px;">🟢 Disponible</span>
                    </div>
                    <div class="p-2 rounded mb-3 text-start" style="background-color: #f8f9fa; font-size: 13px; border-left: 3px solid #00796b;">
                        <span class="text-muted d-block small">Última consulta realizada:</span>
                        <strong class="text-dark">"Tratamiento de acné juvenil avanzado"</strong>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted font-monospace small">🛡️ Cédula: 20000004</span>
                        <div class="text-warning small">⭐⭐⭐⭐⭐ <span class="text-muted">(48)</span></div>
                    </div>
                </div>

                <div class="card shadow-sm border-0 position-absolute p-2 d-flex flex-row align-items-center"
                     style="width: 290px; border-radius: 30px; top: 255px; left: 80px; background: rgba(0, 90, 82, 0.9); color: white; z-index: 4;">
                    <span class="fs-5 ms-2 me-2">🦅</span>
                    <div class="text-start">
                        <span class="fw-bold d-block" style="font-size: 12px; letter-spacing: 0.5px;">CONEXIÓN OFICIAL SEP</span>
                        <span class="small text-white-50" style="font-size: 11px;">Validación de identidad biomédica</span>
                    </div>
                </div>

                <div class="card shadow border-0 position-absolute floating-card-delayed p-3"
                     style="width: 250px; border-radius: 14px; bottom: 35px; right: 0px; background: #ffffff; z-index: 3; border-top: 4px solid #00796b;">
                    <div class="d-flex align-items-center">
                        <div class="fs-3 me-3">📅</div>
                        <div class="text-start">
                            <span class="text-muted d-block small" style="font-size: 11px; text-transform: uppercase; font-weight: bold;">Eficiencia MedAgenda</span>
                            <strong class="text-dark" style="font-size: 17px;">+1,240 Citas</strong>
                            <p class="mb-0 text-success small fw-bold" style="font-size: 12px;">📊 Agendadas este mes</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%
    // Intercepta el parámetro de búsqueda y ejecuta la consulta JDBC
    String queryBusqueda = request.getParameter("q");
    if (queryBusqueda != null && !queryBusqueda.trim().isEmpty()) {
        doctorDAO daoDoc = new doctorDAO();
        List<Doctor> resultadosPublicos = daoDoc.buscarDoctores(queryBusqueda.trim(), "");
%>
<section class="container my-5" style="max-width: 900px;">
    <h3 class="text-medagenda fw-bold mb-4">Nordic🩺 Especialistas encontrados para: <span class="text-dark">"<%= queryBusqueda %>"</span></h3>

    <% if (resultadosPublicos.isEmpty()) { %>
    <div class="alert alert-warning text-center border-0 shadow-sm">
        No se encontraron profesionales de la salud que coincidan con los términos ingresados. Intenta con otra especialidad.
    </div>
    <% } else {
        for(Doctor doc : resultadosPublicos) {
    %>
    <div class="doctor-card p-4 mb-3" style="background: white; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; border-left: 5px solid #00796b; display: flex; justify-content: space-between; align-items: center;">
        <div class="text-start">
            <h4 style="margin: 0; color: #00796b; font-weight: bold; font-size: 18px;">
                <%-- Sanitización del tipo compuesto para presentación en interfaz --%>
                Dr(a). <%= doc.getNombre() != null ? doc.getNombre().replaceAll("[\"(),]", " ").trim() : "Especialista" %>
            </h4>
            <p style="margin: 5px 0 0 0; color: #4a5568; font-weight: bold; font-size: 14px;">
                🩺 <%= doc.getNombreEspecialidad() != null ? doc.getNombreEspecialidad().replaceAll("[\"(),]", "") : "Medicina General" %>
            </p>
            <p style="margin: 5px 0 0 0; color: #718096; font-size: 13px;">
                📍 <%= doc.getDireccion() != null ? doc.getDireccion() : "Dirección no especificada" %>
            </p>
        </div>

        <div>
            <%-- Si es Paciente con sesión va directo a agendar; si no, fuerza el login modal --%>
            <% if (session.getAttribute("usuarioLogueado") != null && "PACIENTE".equals(((modelo.Usuario)session.getAttribute("usuarioLogueado")).getRol())) { %>
            <a href="agendar.jsp?idDoctor=<%= doc.getIdDoctor() %>" class="btn btn-success bg-medagenda fw-bold px-4 py-2 rounded-pill text-white" style="text-decoration: none;">
                📅 Pedir Cita
            </a>
            <% } else { %>
            <button class="btn btn-success bg-medagenda fw-bold px-4 py-2 rounded-pill" data-bs-toggle="modal" data-bs-target="#modalLogin">
                📅 Pedir Cita
            </button>
            <% } %>
        </div>
    </div>
    <%
            }
        }
    %>
</section>
<% } %>

<section id="aboutUs" class="py-5 bg-light" style="min-height: 60vh;">
    <div class="container mt-5">
        <h2 class="text-center text-medagenda fw-bold mb-4">Acerca de MedAgenda</h2>
        <div class="row">
            <div class="col-md-4 text-center">
                <h4>Misión</h4>
                <p>Digitalizar y optimizar la gestión de consultorios médicos para ofrecer una mejor atención al paciente.</p>
            </div>
            <div class="col-md-4 text-center">
                <h4>Visión</h4>
                <p>Ser la plataforma SaaS líder en el sector salud en América Latina, conectando a pacientes con los mejores especialistas.</p>
            </div>
            <div class="col-md-4 text-center">
                <h4>Seguridad</h4>
                <p>Tus datos clínicos están protegidos con los más altos estándares de encriptación y privacidad.</p>
            </div>
        </div>
    </div>
</section>

<div class="modal fade" id="modalLogin" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Iniciar Sesión</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="UsuarioServlet" method="POST">
                <input type="hidden" name="accion" value="login">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Usuario</label>
                        <input type="text" name="txtUser" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" name="txtPass" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary w-100">Entrar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalRegistro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title">Registro de Nuevo Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="UsuarioServlet" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="accion" value="registro">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <label class="form-label">¿Qué tipo de usuario eres?</label>
                            <select name="tipoUsuario" class="form-select border-medagenda" id="selectTipo" onchange="toggleCampos()" required>
                                <option value="PACIENTE">Paciente</option>
                                <option value="DOCTOR">Doctor</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <input type="text" name="regUser" class="form-control" placeholder="Nombre de Usuario" required>
                            </div>
                            <div class="col-md-4 mb-3"><input type="email" name="correo" id ="correo" class="form-control" placeholder="Correo Electrónico" required></div>
                            <div class="col-md-4 mb-3">
                                <div class="input-group">
                                    <input type="password" name="regPass" id="regPass" class="form-control"  placeholder="Contraseña" required minlength="6">
                                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('regPass', 'iconReg')">
                                        <i class="fa-solid fa-eye" id="iconReg"></i>
                                    </button>
                                    <div class="invalid-feedback">Mínimo 6 caracteres.</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3"><input type="text" name="nom" class="form-control" placeholder="Nombre" required></div>
                        <div class="col-md-4 mb-3"><input type="text" name="pat" class="form-control" placeholder="A. Paterno" required></div>
                        <div class="col-md-4 mb-3"><input type="text" name="mat" class="form-control" placeholder="A. Materno"></div>
                    </div>

                    <fieldset class="phone-section">
                        <legend class="label">Número de teléfono móvil</legend>
                        <p class="hint">Necesitamos tu teléfono para configurar tu cuenta. No se mostrará en tu perfil.</p>
                        <div class="phone-input-container">
                            <select name="countryCode" class="prefix-select">
                                <option value="+52" selected>🇲🇽 +52</option>
                                <option value="+1">🇺🇸 +1</option>
                                <option value="+34">🇪🇸 +34</option>
                                <option value="+54">🇦🇷 +54</option>
                                <option value="+57">🇨🇴 +57</option>
                            </select>
                            <input type="tel" name="phone" id="phone" pattern="[0-9]{10}" title="Por favor, introduce 10 dígitos" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required class="phone-field">
                        </div>
                    </fieldset>

                    <div id="camposPaciente" style="display:block;" class="border-top pt-3 mt-2">
                        <h6>Información del Paciente</h6>
                        <div class="row">
                            <div class="col-md-12 mb-3"><label class="form-label small">Fecha de Nacimiento</label><input type="date" name="fecnam" class="form-control"></div>
                            <div class="col-md-6 mb-3"><input type="text" name="curp" class="form-control" placeholder="CURP" maxlength="18"></div>
                        </div>
                    </div>

                    <div id="camposDoctor" style="display:none;" class="border-top pt-3 mt-2">
                        <h6>Información Profesional</h6>
                        <div class="row">
                            <div class="col-md-12"><input type="text" name="cedula" class="form-control" placeholder="Número de Cédula Profesional" maxlength="8"></div>
                            <div class="col-md-12">
                                <label class="form-label small">Especialidad</label>
                                <select name="especialidad" class="form-select">
                                    <option value="1">Médico General</option>
                                    <option value="2">Pediatría</option>
                                    <option value="3">Cardiología</option>
                                    <option value="4">Dermatología</option>
                                    <option value="5">Endocrinología</option>
                                    <option value="6">Gastroenterología</option>
                                    <option value="7">Geriatría</option>
                                    <option value="8">Infectología</option>
                                    <option value="9">Medicina Interna</option>
                                    <option value="10">Neumología</option>
                                    <option value="11">Psiquiatría</option>
                                </select>
                            </div>
                            <div class="col-md-12"><input type="text" name="dir" id="dir" class="form-control" placeholder="Dirección"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Finalizar Registro</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 2000; margin-top: 70px;">
    <% if("1".equals(request.getParameter("registroExitoso"))) { %>
    <div id="toastExito" class="toast align-items-center text-bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fs-6">¡Cuenta creada exitosamente! Revisa tu correo.</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorRegistro"))) { %>
    <div id="toastError" class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert">
        <div class="d-flex">
            <div class="toast-body fs-6">Hubo un problem técnico al crear tu cuenta. Intenta de nuevo.</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorCedula"))) { %>
    <div id="toastCedula" class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="6000">
        <div class="d-flex">
            <div class="toast-body fw-bold fs-6">
                🚫 Registro Denegado: La Cédula Profesional ingresada no es válida o no existe en el Registro Nacional de Profesionistas (SEP).
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorIdentidad"))) { %>
    <div id="toastIdentidad" class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="7000">
        <div class="d-flex">
            <div class="toast-body fw-bold fs-6">
                🚨 Protección de Identidad: La Cédula Profesional ingresada es válida, pero NO coincide con tu nombre y apellidos. El registro ha sido bloqueado.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // MANIPULACIÓN DINÁMICA DOM: Commuta la visibilidad y requerimientos de validación según el rol
    function toggleCampos() {
        const tipo = document.getElementById("selectTipo").value;
        const divPaciente = document.getElementById("camposPaciente");
        const divDoctor = document.getElementById("camposDoctor");
        const inputCurp = document.querySelector('input[name="curp"]');
        const inputFecNam = document.querySelector('input[name="fecnam"]');
        const inputCedula = document.querySelector('input[name="cedula"]');
        if (tipo === "DOCTOR") {
            divDoctor.style.display = "block";
            divPaciente.style.display = "none";
            inputCedula.required = true;
            inputCurp.required = false;
            inputFecNam.required = false;
        } else {
            divDoctor.style.display = "none";
            divPaciente.style.display = "block";
            inputCedula.required = false;
            inputCurp.required = true;
            inputFecNam.required = true;
        }
    }

    function togglePassword(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === "password") {
            input.type = "text";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            input.type = "password";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        }
    }

    // VALIDACIÓN INTEGRAL FRONTEND: Intercepta el submit si las restricciones nativas de Bootstrap fallan
    (() => {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()

    // Dispara Toasts y reabre modales de forma inteligente ante fallos de aduana
    window.onload = (event) => {
        const toastExito = document.getElementById('toastExito');
        if (toastExito) { new bootstrap.Toast(toastExito).show(); }

        const toastError = document.getElementById('toastError');
        if (toastError) { new bootstrap.Toast(toastError).show(); }

        const toastCedula = document.getElementById('toastCedula');
        if (toastCedula) {
            new bootstrap.Toast(toastCedula).show();
            const modalRegistro = new bootstrap.Modal(document.getElementById('modalRegistro'));
            modalRegistro.show();
            document.getElementById('selectTipo').value = 'DOCTOR';
            toggleCampos();
        }

        const toastIdentidad = document.getElementById('toastIdentidad');
        if (toastIdentidad) {
            new bootstrap.Toast(toastIdentidad).show();
            const modalRegistro = new bootstrap.Modal(document.getElementById('modalRegistro'));
            modalRegistro.show();
            document.getElementById('selectTipo').value = 'DOCTOR';
            toggleCampos();
        }

        // Modifica de manera asíncrona el historial para mitigar re-inserciones por F5
        if (window.history.replaceState) {
            const urlLimpia = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({ path: urlLimpia }, '', urlLimpia);
        }
    };
</script>
</body>
</html>