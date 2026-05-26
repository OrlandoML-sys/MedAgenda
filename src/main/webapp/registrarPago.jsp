<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><
<html lang="es">>
<head>
    <meta charset="UTF-8">
    <title>MedAgenda - Registrar Pago</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white text-center">
                    <h4 class="mb-0">Registrar Pago de Consulta</h4>
                </div>
                <div class="card-body p-4">
                    <form action="PagoServlet" method="POST">
                        <input type="hidden" name="idCita" value="<%= request.getParameter("idCita") %>">

                        <div class="mb-3">
                            <label class="form-label">Monto a cobrar ($)</label>
                            <input type="number" step="0.01" name="monto" class="form-control" required placeholder="0.00">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Método de Pago</label>
                            <select name="metodoPago" class="form-select">
                                <option value="EFECTIVO">Efectivo</option>
                                <option value="TARJETA">Tarjeta de Crédito/Débito</option>
                                <option value="TRANSFERENCIA">Transferencia</option>
                            </select>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-success">Confirmar Pago</button>
                            <a href="dashboardDoctor.jsp" class="btn btn-link mt-2">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
