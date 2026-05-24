package modelo;

import java.io.Serializable;
import java.sql.Time;

public class HorarioLaboral implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idHorario;
    private int idDoctor;
    private String diaSemana;
    private Time horaEntrada;
    private Time horaSalida;

    public HorarioLaboral(){}

    public HorarioLaboral(int idHorario, int idDoctor, String diaSemana, Time horaEntrada, Time horaSalida) {
        this.idHorario = idHorario;
        this.idDoctor = idDoctor;
        this.diaSemana = diaSemana;
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
    }

    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public int getIdDoctor() {
        return idDoctor;
    }

    public void setIdDoctor(int idDoctor) {
        this.idDoctor = idDoctor;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public Time getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(Time horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public Time getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Time horaSalida) {
        this.horaSalida = horaSalida;
    }
}
