package Utils;

import DAO.BillDAO;
import Model.Bill;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class GHNSyncService {

    private final BillDAO billDao;
    private final Gson gson;

    public GHNSyncService() {
        this.billDao = new BillDAO();
        this.gson = new Gson();
    }

    public void syncOrders() {
        System.out.println("[GHN Sync] Starting sync for active orders...");
        List<Bill> activeOrders = billDao.getActiveGHNOrders();
        
        if (activeOrders.isEmpty()) {
            System.out.println("[GHN Sync] No active orders to sync.");
            return;
        }

        for (Bill order : activeOrders) {
            try {
                String ghnStatus = fetchGHNOrderStatus(order.getGhnOrderCode());
                if (ghnStatus != null) {
                    processGHNStatus(order, ghnStatus);
                }
            } catch (Exception e) {
                System.out.println("[GHN Sync] Error syncing order " + order.getID() + ": " + e.getMessage());
            }
        }
        System.out.println("[GHN Sync] Finished sync for " + activeOrders.size() + " orders.");
    }

    private String fetchGHNOrderStatus(String ghnOrderCode) throws Exception {
        URL url = new URL(AppConfig.GHN_BASE_API + "shipping-order/detail");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("ShopId", AppConfig.GHN_SHOP_ID);
        conn.setRequestProperty("Token", AppConfig.GHN_TOKEN);
        conn.setDoOutput(true);

        JsonObject payload = new JsonObject();
        payload.addProperty("order_code", ghnOrderCode);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int httpCode = conn.getResponseCode();
        if (httpCode == 200) {
            try (InputStreamReader reader = new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)) {
                JsonObject result = gson.fromJson(reader, JsonObject.class);
                if (result != null && result.has("data") && !result.get("data").isJsonNull()) {
                    return result.getAsJsonObject("data").get("status").getAsString();
                }
            }
        } else {
            System.out.println("[GHN Sync] API Error HTTP " + httpCode + " for order " + ghnOrderCode);
        }
        return null;
    }

    private void processGHNStatus(Bill order, String ghnStatus) {
        int currentStatus = order.getStatus();
        int newStatus = currentStatus;
        String cancelReason = null;

        switch (ghnStatus) {
            case "delivering":
            case "money_collect_delivering":
                newStatus = 1;
                break;
            case "delivered":
                newStatus = 3; 
                break;
            case "cancel":
                newStatus = 2; 
                cancelReason = "GHN: Người gửi hủy đơn";
                break;
            case "delivery_fail":
                newStatus = 1; 
                break;
            case "return":
            case "return_transporting":
            case "return_sorting":
            case "returning":
                newStatus = 6;
                break;
            case "returned":
                newStatus = 2;
                cancelReason = "GHN: Đã hoàn hàng về Shop";
                break;
            case "return_fail":
                newStatus = 2; 
                cancelReason = "GHN: Hoàn hàng thất bại";
                break;
            case "ready_to_pick":
            case "picking":
            case "money_collect_picking":
            case "picked":
            case "storing":
            case "transporting":
            case "sorting":
            case "waiting_to_return":
                newStatus = 6; 
                break;
            default:
                break;
        }

        if (newStatus != currentStatus) {
            System.out.println("[GHN Sync] Order ID " + order.getID() + " (" + order.getGhnOrderCode() + ") status changed: " + currentStatus + " -> " + newStatus);
            billDao.updateStatus(order.getID(), newStatus, cancelReason);
        }
    }
}
