package modelo;

import org.w3c.dom.Text;

import java.io.Serializable;

public class Especialidad implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idEspecialidad;
    private String nombre;
    private Text descripcion;

    public Especialidad(){}

    public Especialidad(int idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    public Especialidad(String nombre, Text descripcion) {
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    public int getIdEspecialidad() {
        return idEspecialidad;
    }

    public String getNombre() {
        return nombre;
    }

    public Text getDescripcion() {
        return descripcion;
    }

    public void setIdEspecialidad(int idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setDescripcion(Text descripcion) {
        this.descripcion = descripcion;
    }
}
