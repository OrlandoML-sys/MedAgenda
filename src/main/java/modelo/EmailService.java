package modelo;

import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;

public class EmailService {

    private static final String RESEND_API_KEY = "re_Vv2hunLX_RANu7ckwTNtYcy8otyHxiGCv";

    public static boolean enviarCorreoVerificacion(String correoDestino, String token) {
        Resend resend = new Resend(RESEND_API_KEY);

        String urlVerificacion = "http://localhost:8080/MedAgenda/verificar?token=" + token;

        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("MedAgenda <no-reply@rlndmdrgl.me>")
                .to(correoDestino)
                .subject("Verifica tu cuenta en MedAgenda")
                .html("<h2>¡Bienvenido a MedAgenda!</h2>" +
                        "<p>Gracias por registrarte. Para activar tu cuenta y poder agendar citas, haz clic en el siguiente enlace:</p>" +
                        "<a href='" + urlVerificacion + "' style='padding: 10px 20px; background-color: #007BFF; color: white; text-decoration: none; border-radius: 5px;'>Verificar mi cuenta</a>")
                .build();

        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println("¡Correo enviado exitosamente! ID: " + data.getId());
            System.out.println("Enviando correo a: " + correoDestino);
            return true;
        } catch (ResendException e) {
            System.err.println("Error al enviar el correo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}