package Controllers.Admin;

import DAO.BillDAO;
import Model.Bill;
import Model.BillDetail;
import Utils.ServletPaths;
import Utils.Validation;
import Utils.AppConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders/*"})
public class AdminOrderController extends HttpServlet {

    private BillDAO billDao;
    private Validation validate;
    private DAO.AccountDAO accountDao;

    @Override
    public void init() throws ServletException {
        billDao = new BillDAO();
        validate = new Validation();
        accountDao = new DAO.AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/orders") || relative.equals("/admin/orders/")) {
            String q = request.getParameter("q");
            String status = request.getParameter("status");
            String sort = request.getParameter("sort");
            String customerID = request.getParameter("customerID");
            int page = 1;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            }
            int limit = 10;
            if (request.getParameter("limit") != null) {
                try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) {}
            }
            int totalRows = billDao.count(q, status, customerID);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Bill> orders = billDao.getPaginated(q, status, customerID, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("customerID", customerID);
            request.setAttribute("sort", sort);
            request.setAttribute("orders", orders);
            request.setAttribute("customers", accountDao.allAccountByStaff());
            request.setAttribute("isOrder", true);
            request.setAttribute("pageTitle", "Quản lý đơn hàng");
            request.getRequestDispatcher("/admin/order/index.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/orders/detail/")) {
            int id = ServletPaths.idAfter(request, "/admin/orders/detail");
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            Bill order = billDao.getBillById(id);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            List<BillDetail> details = billDao.getBillDetails(id);
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + id);
            request.getRequestDispatcher("/admin/order/detail.jsp").forward(request, response);
        } else if (relative.equals("/admin/orders/get-ghn-bill")) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            JsonObject res = new JsonObject();
            try {
                String orderCode = request.getParameter("orderCode");
                if (orderCode == null || orderCode.isEmpty()) {
                    res.addProperty("success", false);
                    res.addProperty("message", "Thiếu mã đơn hàng");
                    out.print(res.toString());
                    return;
                }
                String token = getGHNToken(orderCode);
                if (token != null) {
                    res.addProperty("success", true);
                    res.addProperty("invoiceUrl", "https://dev-online-gateway.ghn.vn/a5/public-api/printA5?token=" + token);
                } else {
                    res.addProperty("success", false);
                    res.addProperty("message", "Không thể lấy hóa đơn từ GHN");
                }
            } catch (Exception e) {
                res.addProperty("success", false);
                res.addProperty("message", e.getMessage());
            }
            out.print(res.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        if (relative.startsWith("/admin/orders/update-status/")) {
            int id = ServletPaths.idAfter(request, "/admin/orders/update-status");
            int status = validate.getInt(request.getParameter("status"));

            if (id > 0 && status >= 0 && status <= 8) {
                Bill order = billDao.getBillById(id);
                if (order != null) {
                    int currentStatus = order.getStatus();
                    boolean validTransition = false;
                    
                    if (currentStatus == 0) {
                        validTransition = (status == 4 && order.getPayment() == 1) || (status == 8) || status == 2 || status == 0;
                    } else if (currentStatus == 4) {
                        validTransition = (status == 8 || status == 2 || status == 4);
                    } else if (currentStatus == 8) {
                        validTransition = (status == 5 || status == 2 || status == 8);
                    } else if (currentStatus == 5) {
                        validTransition = (status == 6 || status == 1 || status == 2 || status == 5);
                    } else if (currentStatus == 6) {
                        validTransition = (status == 1 || status == 2 || status == 6);
                    } else if (currentStatus == 1) {
                        validTransition = (status == 3 || status == 2 || status == 1);
                    } else if (currentStatus == 3) {
                        validTransition = (status == 3);
                    } else if (currentStatus == 2) {
                        validTransition = (status == 2 || (status == 7 && order.getPayment() == 1));
                    } else if (currentStatus == 7) {
                        validTransition = (status == 7);
                    }
                    
                    if (validTransition) {
                        if (status == 8 || status == 5 || status == 1 || status == 6) {
                            Model.Bill currentBill = billDao.getBillById(id);
                            if (currentBill != null && (currentBill.getStatus() == 0 || currentBill.getStatus() == 4)) {
                                boolean hasEnoughStock = true;
                                String outOfStockItem = "";
                                DAO.ProductVariantDAO pvDao = new DAO.ProductVariantDAO();
                                java.util.List<Model.BillDetail> details = billDao.getBillDetails(id);
                                for (Model.BillDetail d : details) {
                                    if (d.getProductVariantID() != null) {
                                        Model.ProductVariant pv = pvDao.findById(d.getProductVariantID());
                                        if (pv == null || pv.getQuantity() < d.getNumberOfProduct()) {
                                            hasEnoughStock = false;
                                            outOfStockItem = d.getNameProduct() + " (Màu: " + d.getColorLabelSnapshot() + ", Size: " + d.getSizeLabelSnapshot() + ")";
                                            break;
                                        }
                                    }
                                }
                                if (!hasEnoughStock) {
                                    request.getSession().setAttribute("adminFlash", "Không đủ số lượng trong kho cho sản phẩm: " + outOfStockItem);
                                    request.getSession().setAttribute("adminFlashType", "danger");
                                    response.sendRedirect(request.getContextPath() + "/admin/orders/detail/" + id);
                                    return;
                                }
                            }
                        }

                        String cancelReason = request.getParameter("cancelReason");
                        boolean success;
                        if (status == 2 && cancelReason != null && !cancelReason.trim().isEmpty()) {
                            success = billDao.updateStatusWithReason(id, status, "Hủy bởi QTV: " + cancelReason.trim());
                        } else {
                            success = billDao.updateStatus(id, status);
                        }
                        if (success) {
                            request.getSession().setAttribute("adminFlash", "Đã cập nhật trạng thái đơn hàng #" + id + " thành công.");
                            request.getSession().setAttribute("adminFlashType", "success");
                        } else {
                            request.getSession().setAttribute("adminFlash", "Cập nhật trạng thái thất bại.");
                            request.getSession().setAttribute("adminFlashType", "danger");
                        }
                    } else {
                        request.getSession().setAttribute("adminFlash", "Trạng thái chuyển đổi không hợp lệ. Vui lòng cập nhật tuần tự không nhảy cóc.");
                        request.getSession().setAttribute("adminFlashType", "danger");
                    }
                } else {
                    request.getSession().setAttribute("adminFlash", "Không tìm thấy đơn hàng.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                }
            } else {
                request.getSession().setAttribute("adminFlash", "Trạng thái không hợp lệ.");
                request.getSession().setAttribute("adminFlashType", "danger");
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders/detail/" + id);
        } else if (relative.equals("/admin/orders/sendtoghn")) {
            handleSendToGHN(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void handleSendToGHN(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject res = new JsonObject();

        try {
            int orderId = validate.getInt(request.getParameter("orderId"));
            String toWardCode = request.getParameter("to_ward_code");
            int toDistrictId = validate.getInt(request.getParameter("to_district_id"));

            if (orderId <= 0 || toWardCode == null || toWardCode.isEmpty() || toDistrictId <= 0) {
                res.addProperty("status", "error");
                res.addProperty("message", "Thiếu thông tin địa chỉ Phường/Xã hoặc Quận/Huyện.");
                out.print(res.toString());
                return;
            }

            Bill order = billDao.getBillById(orderId);
            if (order == null) {
                res.addProperty("status", "error");
                res.addProperty("message", "Đơn hàng không tồn tại.");
                out.print(res.toString());
                return;
            }

            List<BillDetail> details = billDao.getBillDetails(orderId);

            JsonObject payload = new JsonObject();
            payload.addProperty("payment_type_id", Utils.AppConfig.GHN_PAYMENT_TYPE_ID);
            payload.addProperty("note", Utils.AppConfig.GHN_NOTE);
            payload.addProperty("required_note", Utils.AppConfig.GHN_REQUIRED_NOTE);
            payload.addProperty("from_name", Utils.AppConfig.GHN_FROM_NAME);
            payload.addProperty("from_phone", Utils.AppConfig.GHN_FROM_PHONE);
            payload.addProperty("from_address", Utils.AppConfig.GHN_FROM_ADDRESS);
            payload.addProperty("from_ward_name", Utils.AppConfig.GHN_FROM_WARD_NAME);
            payload.addProperty("from_district_name", Utils.AppConfig.GHN_FROM_DISTRICT_NAME);
            payload.addProperty("from_province_name", Utils.AppConfig.GHN_FROM_PROVINCE_NAME);
            payload.addProperty("return_phone", Utils.AppConfig.GHN_RETURN_PHONE);
            payload.addProperty("return_address", Utils.AppConfig.GHN_RETURN_ADDRESS);
            payload.addProperty("client_order_code", "ORD-" + orderId);
            payload.addProperty("to_name", order.getCustomerName());
            payload.addProperty("to_phone", order.getPhone());
            payload.addProperty("to_address", order.getDetailAddress());
            payload.addProperty("to_ward_code", toWardCode);
            payload.addProperty("to_district_id", toDistrictId);
            payload.addProperty("cod_amount", order.getPayment() == 1 ? 0 : (int) order.getTotal());
            payload.addProperty("content", "Đơn hàng từ Clothes Shop");
            payload.addProperty("weight", 200);
            payload.addProperty("length", 10);
            payload.addProperty("width", 15);
            payload.addProperty("height", 5);
            payload.addProperty("insurance_value", (int) order.getTotal());
            payload.addProperty("service_type_id", 2);
            
            JsonArray items = new JsonArray();
            for (BillDetail d : details) {
                JsonObject item = new JsonObject();
                item.addProperty("name", d.getNameProduct());
                item.addProperty("code", "SP-" + d.getProductID());
                item.addProperty("quantity", d.getNumberOfProduct());
                item.addProperty("price", (int) d.getPriceProduct());
                item.addProperty("length", 10);
                item.addProperty("width", 10);
                item.addProperty("height", 10);
                item.addProperty("weight", 500);
                items.add(item);
            }
            payload.add("items", items);

            URL url = new URL(AppConfig.GHN_BASE_API + "shipping-order/create");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("ShopId", AppConfig.GHN_SHOP_ID);
            conn.setRequestProperty("Token", AppConfig.GHN_TOKEN);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int httpCode = conn.getResponseCode();
            JsonObject result;
            try (InputStreamReader reader = new InputStreamReader(httpCode >= 400 ? conn.getErrorStream() : conn.getInputStream(), StandardCharsets.UTF_8)) {
                result = new Gson().fromJson(reader, JsonObject.class);
            }

            if (httpCode == 200 && result != null && result.get("code").getAsInt() == 200) {
                String orderCode = result.getAsJsonObject("data").get("order_code").getAsString();
                billDao.updateGHNOrderCode(orderId, orderCode);
                billDao.updateStatus(orderId, 6); // Trạng thái 6: Đã giao ĐVVC
                res.addProperty("status", "success");
                res.addProperty("message", "Đơn hàng đã được đẩy sang GHN thành công.");
                res.add("data", result);
            } else {
                res.addProperty("status", "error");
                res.addProperty("message", "Đẩy đơn GHN thất bại.");
                res.add("response", result);
            }
        } catch (Exception e) {
            res.addProperty("status", "error");
            res.addProperty("message", "Lỗi server: " + e.getMessage());
        }
        out.print(res.toString());
    }

    private String getGHNToken(String orderCode) {
        try {
            URL url = new URL(AppConfig.GHN_BASE_A5_API + "gen-token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", AppConfig.GHN_TOKEN);
            conn.setDoOutput(true);

            JsonObject payload = new JsonObject();
            JsonArray orderCodes = new JsonArray();
            orderCodes.add(orderCode);
            payload.add("order_codes", orderCodes);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int httpCode = conn.getResponseCode();
            if (httpCode == 200) {
                try (InputStreamReader reader = new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)) {
                    JsonObject result = new Gson().fromJson(reader, JsonObject.class);
                    if (result.get("code").getAsInt() == 200) {
                        return result.getAsJsonObject("data").get("token").getAsString();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting GHN Token: " + e.getMessage());
        }
        return null;
    }
}
