package modelo;

import java.io.Serializable;

public class CedulaSEP implements Serializable {
    private static final long serialVersionUID = 1L;

    private String num_cedula;
    private String nombre;
    private String paterno;
    private String materno;
    private String especialidad;
    private String institucion;

    public CedulaSEP(){}

    public CedulaSEP(String num_cedula, String nombre, String paterno, String materno, String especialidad, String institucion) {
        this.num_cedula = num_cedula;
        this.nombre = nombre;
        this.paterno = paterno;
        this.materno = materno;
        this.especialidad = especialidad;
        this.institucion = institucion;
    }

    public String getNum_cedula() {return num_cedula;}

    public void setNum_cedula(String num_cedula) {this.num_cedula = num_cedula;}

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPaterno() {
        return paterno;
    }

    public void setPaterno(String paterno) {
        this.paterno = paterno;
    }

    public String getMaterno() {
        return materno;
    }

    public void setMaterno(String materno) {
        this.materno = materno;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getInstitucion() {
        return institucion;
    }

    public void setInstitucion(String institucion) {
        this.institucion = institucion;
    }
}
