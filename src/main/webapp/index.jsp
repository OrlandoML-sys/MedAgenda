<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<!-- NAVBAR ESTILO DOCTORALIA -->
<nav class="navbar navbar-expand-lg navbar-dark bg-medagenda fixed-top">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand fw-bold" href="#">
            <span class="fs-4">⚕️ MedAgenda</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center">
                <li class="nav-item">
                    <!-- Botón que hace scroll suave a la sección inferior -->
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

<!-- HERO SECTION (Sección principal) -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-4 fw-bold mb-3">Encuentra tu especialista y pide cita</h1>
                <p class="lead mb-4">Miles de profesionales de la salud están aquí para ayudarte a ti y a tu familia.</p>
                <!-- Un buscador falso decorativo para dar ese look comercial -->
                <div class="bg-white p-2 rounded shadow-sm d-flex">
                    <input type="text" class="form-control border-0" placeholder="Especialidad o nombre del doctor...">
                    <button class="btn btn-success bg-medagenda px-4">Buscar</button>
                </div>
            </div>
            <div class="col-lg-6 d-none d-lg-block text-center">
                <img src="https://via.placeholder.com/500x300/005a52/ffffff?text=Ilustracion+Medicos" alt="Doctores" class="img-fluid rounded">
            </div>
        </div>
    </div>
</section>

<!-- SECCIÓN ACERCA DE NOSOTROS (About Us) -->
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

<!-- MODAL DE REGISTRO CON VALIDACIÓN (needs-validation) -->
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

                            <input type="tel"
                                   name="phone"
                                   id="phone"
                                   pattern="[0-9]{10}"
                                   title="Por favor, introduce 10 dígitos numéricos"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                   required
                                   class="phone-field">
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

<!-- CONTENEDOR DEL TOAST DE FEEDBACK -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 2000;">
    <% if("1".equals(request.getParameter("registroExitoso"))) { %>
    <div id="toastExito" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">¡Cuenta creada exitosamente! Revisa tu correo.</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorRegistro"))) { %>
    <div id="toastError" class="toast align-items-center text-bg-danger border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">Hubo un problema técnico al crear tu cuenta. Intenta de nuevo.</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorCedula"))) { %>
    <div id="toastCedula" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="6000">
        <div class="d-flex">
            <div class="toast-body fw-bold">
                🚫 Registro Denegado: La Cédula Profesional ingresada no es válida o no existe en el Registro Nacional de Profesionistas (SEP).
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>

    <% if("1".equals(request.getParameter("errorIdentidad"))) { %>
    <div id="toastIdentidad" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="7000">
        <div class="d-flex">
            <div class="toast-body fw-bold">
                🚨 Protección de Identidad: La Cédula Profesional ingresada es válida, pero NO coincide con tu nombre y apellidos. El registro ha sido bloqueado.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Pequeño script para mostrar/ocultar campos según el tipo de usuario
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

            // Doctor: Cédula obligatoria, Paciente opcional
            inputCedula.required = true;
            inputCurp.required = false;
            inputFecNam.required = false;
        } else {
            divDoctor.style.display = "none";
            divPaciente.style.display = "block";

            // Paciente: CURP y Fecha obligatorios, Doctor opcional
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

    // 1. Script para las validaciones de Bootstrap
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

    // 2. Script Inteligente para disparar los Toasts y reabrir modales si hay error
    window.onload = (event) => {
        // Toast de Éxito
        const toastExito = document.getElementById('toastExito');
        if (toastExito) { new bootstrap.Toast(toastExito).show(); }

        // Toast Error Técnico
        const toastError = document.getElementById('toastError');
        if (toastError) { new bootstrap.Toast(toastError).show(); }

        // Toast de Seguridad (Cédula Falsa)
        const toastCedula = document.getElementById('toastCedula');
        if (toastCedula) {
            new bootstrap.Toast(toastCedula).show();

            // Si hubo error de cédula, le reabrimos el modal en automático para que vea el fallo
            const modalRegistro = new bootstrap.Modal(document.getElementById('modalRegistro'));
            modalRegistro.show();
            document.getElementById('selectTipo').value = 'DOCTOR';
            toggleCampos(); // Forzamos mostrar los campos de doctor
        }

        // Toast de Seguridad (Usurpación de Identidad)
        const toastIdentidad = document.getElementById('toastIdentidad');
        if (toastIdentidad) {
            new bootstrap.Toast(toastIdentidad).show();

            const modalRegistro = new bootstrap.Modal(document.getElementById('modalRegistro'));
            modalRegistro.show();
            document.getElementById('selectTipo').value = 'DOCTOR';
            toggleCampos();
        }

        if (window.history.replaceState) {
            const urlLimpia = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({ path: urlLimpia }, '', urlLimpia);
        }
    };
</script>
</body>
</html>