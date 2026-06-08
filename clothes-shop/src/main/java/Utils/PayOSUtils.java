package Utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class PayOSUtils {

    public static String createSignature(String data, String key) throws Exception {
        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
        SecretKeySpec secret_key = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public static String createPaymentLink(int orderCode, int amount, String description) throws Exception {
        // Prepare signature data according to PayOS docs (sorted alphabetically by key)
        String signatureData = "amount=" + amount
                + "&cancelUrl=" + AppConfig.PAYOS_CANCEL_URL
                + "&description=" + description
                + "&orderCode=" + orderCode
                + "&returnUrl=" + AppConfig.PAYOS_RETURN_URL;

        String signature = createSignature(signatureData, AppConfig.PAYOS_CHECKSUM_KEY);

        // Build JSON body
        JsonObject body = new JsonObject();
        body.addProperty("orderCode", orderCode);
        body.addProperty("amount", amount);
        body.addProperty("description", description);
        body.addProperty("returnUrl", AppConfig.PAYOS_RETURN_URL);
        body.addProperty("cancelUrl", AppConfig.PAYOS_CANCEL_URL);
        body.addProperty("signature", signature);

        URL url = new URL(AppConfig.PAYOS_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("x-client-id", AppConfig.PAYOS_CLIENT_ID);
        conn.setRequestProperty("x-api-key", AppConfig.PAYOS_API_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = body.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        BufferedReader in = new BufferedReader(new InputStreamReader(
                (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8));

        StringBuilder response = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) {
            response.append(line);
        }
        in.close();

        if (responseCode >= 200 && responseCode < 300) {
            Gson gson = new Gson();
            JsonObject jsonRes = gson.fromJson(response.toString(), JsonObject.class);
            if (jsonRes.has("code") && "00".equals(jsonRes.get("code").getAsString())) {
                JsonObject data = jsonRes.getAsJsonObject("data");
                return data.get("checkoutUrl").getAsString();
            } else {
                throw new Exception("PayOS API Error: " + response.toString());
            }
        } else {
            throw new Exception("PayOS HTTP Error: " + responseCode + " - " + response.toString());
        }
    }
}
