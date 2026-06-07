package modelo;

public class HistorialClinico {
    private String nombrePaciente;
    private String fechaCita;
    private String motivoCita;
    private String diagnostico;
    private String receta;

    // Getters y Setters
    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }
    public String getFechaCita() { return fechaCita; }
    public void setFechaCita(String fechaCita) { this.fechaCita = fechaCita; }
    public String getMotivoCita() { return motivoCita; }
    public void setMotivoCita(String motivoCita) { this.motivoCita = motivoCita; }
    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }
    public String getReceta() { return receta; }
    public void setReceta(String receta) { this.receta = receta; }
}