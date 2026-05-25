package modelo;

import java.lang.String;

import java.io.Serializable;

public class Expediente implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idExpediente;
    private int idCita;
    private String diagnostico;
    private String tratamiento;
    private String notasJSON;

    public Expediente(){}

    public Expediente(int idExpediente, int idCita, String diagnostico, String tratamiento, String notasJSON) {
        this.idExpediente = idExpediente;
        this.idCita = idCita;
        this.diagnostico = diagnostico;
        this.tratamiento = tratamiento;
        this.notasJSON = notasJSON;
    }

    public int getIdExpediente() {
        return idExpediente;
    }

    public void setIdExpediente(int idExpediente) {
        this.idExpediente = idExpediente;
    }

    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public String getDiagnostico() {
        return diagnostico;
    }

    public void setDiagnostico(String diagnostico) {
        this.diagnostico = diagnostico;
    }

    public String getTratamiento() {
        return tratamiento;
    }

    public void setTratamiento(String tratamiento) {
        this.tratamiento = tratamiento;
    }

    public String getNotasJSON() {
        return notasJSON;
    }

    public void setNotasJSON(String notasJSON) {
        this.notasJSON = notasJSON;
    }
}
