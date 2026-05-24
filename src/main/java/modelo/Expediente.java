package modelo;

import org.w3c.dom.Text;

import java.io.Serializable;

public class Expediente implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idExpediente;
    private int idCita;
    private Text diagnostico;
    private Text tratamiento;
    private String notasJSON;

    public Expediente(){}

    public Expediente(int idExpediente, int idCita, Text diagnostico, Text tratamiento, String notasJSON) {
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

    public Text getDiagnostico() {
        return diagnostico;
    }

    public void setDiagnostico(Text diagnostico) {
        this.diagnostico = diagnostico;
    }

    public Text getTratamiento() {
        return tratamiento;
    }

    public void setTratamiento(Text tratamiento) {
        this.tratamiento = tratamiento;
    }

    public String getNotasJSON() {
        return notasJSON;
    }

    public void setNotasJSON(String notasJSON) {
        this.notasJSON = notasJSON;
    }
}
