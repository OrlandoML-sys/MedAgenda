package modelo;
import java.io.Serializable;
import java.sql.Date;

public class Paciente implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idPaciente;
    private int idUsuario;
    private String curp;
    private String nombre;
    private String paterno;
    private String materno;
    private Date fechaNacimiento;

    public Paciente() {}

    public Paciente(int idPaciente){
        this.idPaciente = idPaciente;
    }

    public Paciente(int idUsuario, String curp, String nombre, String paterno, String materno, Date fechaNacimiento){
        this.idUsuario = idUsuario;
        this.curp = curp;
        this.nombre = nombre;
        this.paterno = paterno;
        this.materno = materno;
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getCurp() {
        return curp;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombre() {
        return nombre;
    }

    public String getPaterno() {return paterno;}

    public void setPaterno(String paterno) {this.paterno = paterno;}

    public String getMaterno() {return materno;}

    public void setMaterno(String materno) {this.materno = materno;}

    public Date getFechaNacimiento() {return fechaNacimiento;}

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public void setCurp(String curp) {
        this.curp = curp;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }
}
