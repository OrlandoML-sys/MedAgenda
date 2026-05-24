package modelo;

import java.io.Serializable;

public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idUsuario;
    private String username;
    private String email;
    private String password;
    private String rol;
    private boolean estaActivo;
    private String telefono;
    private String tokenVerification;

    public Usuario(){}

    public Usuario(int idUsuario){
        this.idUsuario = idUsuario;
    }

    public Usuario(String username, String email, String password, String rol, boolean estaActivo, String telefono, String tokenVerification) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.rol = rol;
        this.estaActivo = estaActivo;
        this.telefono = telefono;
    }

    public int getIdUsuario(){return idUsuario;}
    public void setIdUsuario(int idUsuario){this.idUsuario = idUsuario;}

    public String getUsername(){return username;}
    public void setUsername(String username){this.username = username;}

    public String getEmail() {return email;}
    public void setEmail(String email) {this.email = email;}

    public String getPassword(){return password;}
    public void setPassword(String password){this.password = password;}

    public String getRol(){return rol;}
    public void setRol(String rol){this.rol = rol;}

    public boolean isEstaActivo(){return estaActivo;}
    public void setEstaActivo(boolean estaActivo){this.estaActivo = estaActivo;}

    public String getTelefono() {return telefono;}
    public void setTelefono(String telefono) {this.telefono = telefono;}

    public String getTokenVerificacion() {return tokenVerification;}
    public void setTokenVerificacion(String tokenVerification) {this.tokenVerification = tokenVerification;}

}
