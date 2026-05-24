package modelo;

import java.io.Serializable;
import java.sql.Timestamp;

public class Pago implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idPago;
    private int idCita;
    private double monto;
    private String metodoPago;
    private Timestamp fechaPago;

    public Pago(){}

    public Pago(int idPago, int idCita, double monto, String metodoPago, Timestamp fechaPago) {
        this.idPago = idPago;
        this.idCita = idCita;
        this.monto = monto;
        this.metodoPago = metodoPago;
        this.fechaPago = fechaPago;
    }

    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public Timestamp getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Timestamp fechaPago) {
        this.fechaPago = fechaPago;
    }
}
