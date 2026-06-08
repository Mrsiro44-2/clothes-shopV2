package Utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeUtility;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Email {

    private static final Logger LOG = Logger.getLogger(Email.class.getName());

    static final String username = AppConfig.EMAIL_USERNAME;
    static final String from = AppConfig.EMAIL_FROM;
    static final String password = AppConfig.EMAIL_PASSWORD;

    public boolean sendEmail(String to, String title, String content, String reply) {
        if (to == null || to.trim().isEmpty()) {
            return false;
        }
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);
        try {
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.setFrom(new InternetAddress(from, username));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to.trim(), false));
            msg.setSubject(MimeUtility.encodeText(title, "UTF-8", "B"));
            msg.setHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.setSentDate(new Date());
            if (reply != null && !reply.trim().isEmpty()) {
                msg.setReplyTo(new InternetAddress[]{new InternetAddress(reply.trim())});
            }
            msg.setContent(content, "text/HTML; charset=UTF-8");
            Transport.send(msg);
            LOG.info("Mail sent to " + to);
            return true;
        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Mail failed: " + e.getMessage());
            return false;
        }
    }

    public static void logResetLink(String link) {
        LOG.severe("========== LINK DAT LAI MAT KHAU (copy de test) ==========");
        LOG.severe(link);
        LOG.severe("===========================================================");
    }
}
