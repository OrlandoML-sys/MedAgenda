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

        String plantillaHTML =
                "<html>" +
                        "<body style='font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 0;'>" +
                        "  <table align='center' border='0' cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden; border: 1px solid #e2e8f0;'>" +
                        "    " +
                        "    <tr>" +
                        "      <td bgcolor='#00796b' style='padding: 35px 20px; text-align: center;'>" +
                        "        <h1 style='color: #ffffff; margin: 0; font-size: 26px; font-weight: bold; letter-spacing: 1px;'>⚕️ MedAgenda</h1>" +
                        "        <p style='color: #b2dfdb; margin: 5px 0 0 0; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px;'>Plataforma de Gestión Médica</p>" +
                        "      </td>" +
                        "    </tr>" +
                        "    " +
                        "    <tr>" +
                        "      <td style='padding: 40px 35px; color: #2c3e50;'>" +
                        "        <h2 style='margin: 0 0 15px 0; color: #00796b; font-size: 20px; fw-bold'>¡Hola! Te damos la bienvenida</h2>" +
                        "        <p style='margin: 0 0 25px 0; font-size: 15px; line-height: 1.6; color: #4a5568;'>" +
                        "          Gracias por registrarte en nuestra plataforma. Para activar tu cuenta de forma segura y habilitar todas las funciones de gestión y agendamiento de consultas médicas, por favor confirma tu dirección de correo haciendo clic en el siguiente botón:" +
                        "        </p>" +
                        "        " +
                        "        <table align='center' border='0' cellpadding='0' cellspacing='0'>" +
                        "          <tr>" +
                        "            <td align='center' bgcolor='#00796b' style='border-radius: 6px;'>" +
                        "              <a href='" + urlVerificacion + "' target='_blank' style='display: inline-block; padding: 14px 30px; color: #ffffff; font-size: 15px; font-weight: bold; text-decoration: none; letter-spacing: 0.5px;'>Verificar mi cuenta</a>" +
                        "            </td>" +
                        "          </tr>" +
                        "        </table>" +
                        "        <p style='margin: 30px 0 0 0; font-size: 13px; color: #718096; text-align: center; font-style: italic;'>" +
                        "          Por motivos de seguridad, este enlace de activación solo es válido por tiempo limitado." +
                        "        </p>" +
                        "        " +
                        "        <hr style='border: 0; border-top: 1px solid #edf2f7; margin: 35px 0 20px 0;'>" +
                        "        <p style='margin: 0; font-size: 12px; color: #a0aec0; word-break: break-all; line-height: 1.4;'>" +
                        "          Si tienes problemas con el botón de arriba, copia y pega esta URL en tu navegador habitual:<br>" +
                        "          <a href='" + urlVerificacion + "' style='color: #00796b; text-decoration: underline;'>" + urlVerificacion + "</a>" +
                        "        </p>" +
                        "      </td>" +
                        "    </tr>" +
                        "    " +
                        "    <tr>" +
                        "      <td bgcolor='#f8f9fa' style='padding: 20px 35px; text-align: center; font-size: 12px; color: #718096; border-top: 1px solid #edf2f7;'>" +
                        "        <p style='margin: 0 0 4px 0;'>Este es un mensaje generado de forma automática por el sistema, por favor no lo respondas.</p>" +
                        "        <p style='margin: 0;'>&copy; 2026 MedAgenda. Veracruz, México. Todos los derechos reservados.</p>" +
                        "      </td>" +
                        "    </tr>" +
                        "  </table>" +
                        "</body>" +
                        "</html>";

        CreateEmailOptions params = CreateEmailOptions.builder()
                .from("MedAgenda <no-reply@rlndmdrgl.me>")
                .to(correoDestino)
                .subject("🔒 Asegura tu cuenta - Verifica tu correo en MedAgenda")
                .html(plantillaHTML)
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