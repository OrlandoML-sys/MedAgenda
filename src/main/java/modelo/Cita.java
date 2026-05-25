package modelo;

import java.io.Serializable;
import java.sql.Timestamp;

public class Cita implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idCita;
    private int idPaciente;
    private int idDoctor;
    private String nombrePaciente;
    private Timestamp fechaHora;
    private String motivo;
    private String estado;

    public Cita(){}

    public Cita(int idCita, int idPaciente, int idDoctor, Timestamp fechaHora, String motivo, String estado) {
        this.idCita = idCita;
        this.idPaciente = idPaciente;
        this.idDoctor = idDoctor;
        this.fechaHora = fechaHora;
        this.motivo = motivo;
        this.estado = estado;
    }

    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public int getIdDoctor() {
        return idDoctor;
    }

    public void setIdDoctor(int idDoctor) {
        this.idDoctor = idDoctor;
    }

    public Timestamp getFechaHora() {return fechaHora;}

    public void setFechaHora(Timestamp fechaHora) {
        this.fechaHora = fechaHora;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombrePaciente() {return nombrePaciente;}

    public void setNombrePaciente(String nombrePaciente) {this.nombrePaciente = nombrePaciente;}
}
