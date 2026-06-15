package Utils;

import Model.Bill;
import Model.BillDetail;
import java.text.DecimalFormat;
import java.util.List;

public class EmailTemplates {
    private static final DecimalFormat df = new DecimalFormat("#,###");

    public static String getEmailHeader(String title) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'>" +
               "<style>" +
               "body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; color: #333; }" +
               ".container { max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }" +
               ".header { background-color: #DB4444; color: #ffffff; padding: 30px 20px; text-align: center; }" +
               ".header h1, .header h2 { margin: 0; font-size: 24px; letter-spacing: 1px; }" +
               ".content { padding: 30px; }" +
               ".footer { background-color: #f8f9fa; text-align: center; padding: 20px; font-size: 13px; color: #8d99ae; border-top: 1px solid #e2e8f0; }" +
               ".table-wrapper { margin-bottom: 30px; }" +
               "table { width: 100%; border-collapse: collapse; }" +
               "th { background-color: #f0f2f5; padding: 12px; text-align: left; font-size: 14px; color: #4a5568; border-bottom: 2px solid #e2e8f0; }" +
               "td { padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 14px; vertical-align: middle; }" +
               ".product-name { font-weight: 600; color: #2b2d42; display: block; }" +
               ".product-meta { font-size: 12px; color: #8d99ae; }" +
               ".text-right { text-align: right; }" +
               ".summary-row { font-weight: 600; }" +
               ".total-row td { font-size: 16px; font-weight: 700; color: #DB4444; border-top: 2px solid #e2e8f0; padding-top: 15px; }" +
               ".otp-box { background-color: #f8f9fa; border: 2px dashed #DB4444; border-radius: 8px; padding: 20px; display: inline-block; margin-bottom: 25px; text-align: center; }" +
               ".otp-code { font-size: 32px; font-weight: 700; color: #DB4444; letter-spacing: 5px; margin: 0; }" +
               ".warning { font-size: 13px; color: #8d99ae; }" +
               "</style></head><body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<h1>" + title + "</h1>" +
               "</div>" +
               "<div class='content'>";
    }

    public static String getEmailFooter() {
        return "</div>" +
               "<div class='footer'>" +
               "<p>&copy; " + java.time.Year.now().getValue() + " Clothing Shop. Bảo lưu mọi quyền.</p>" +
               "</div>" +
               "</div></body></html>";
    }

    public static String getOrderConfirmationTemplate(Bill bill, List<BillDetail> details) {
        StringBuilder sb = new StringBuilder();
        sb.append(getEmailHeader("Xác Nhận Đơn Hàng"));
        
        sb.append("<div style='font-size: 18px; margin-bottom: 20px; color: #2b2d42;'>Xin chào ").append(bill.getCustomerName()).append(",</div>")
          .append("<p>Cảm ơn bạn đã mua sắm tại cửa hàng của chúng tôi! Đơn hàng của bạn đã được nhận và đang trong quá trình xử lý.</p>")
          .append("<div style='background: #f8f9fa; padding: 15px; border-radius: 6px; margin-bottom: 25px; border-left: 4px solid #DB4444;'>")
          .append("<p style='margin: 5px 0; font-size: 14px;'><strong>Mã đơn hàng:</strong> #").append(bill.getID()).append("</p>")
          .append("<p style='margin: 5px 0; font-size: 14px;'><strong>Ngày đặt:</strong> ").append(bill.getDateOrder()).append("</p>")
          .append("<p style='margin: 5px 0; font-size: 14px;'><strong>Số điện thoại:</strong> ").append(bill.getPhone()).append("</p>")
          .append("<p style='margin: 5px 0; font-size: 14px;'><strong>Địa chỉ giao hàng:</strong> ").append(bill.getAddress());
          
        if (bill.getDetailAddress() != null && !bill.getDetailAddress().isEmpty()) {
            sb.append(" (").append(bill.getDetailAddress()).append(")");
        }
        sb.append("</p>")
          .append("<p style='margin: 5px 0; font-size: 14px;'><strong>Phương thức thanh toán:</strong> ").append(bill.getPayment() == 1 ? "PayOS" : "Thanh toán khi nhận hàng (COD)").append("</p>")
          .append("</div>")
          .append("<div class='table-wrapper'>")
          .append("<table>")
          .append("<thead><tr><th>Sản phẩm</th><th>SL</th><th class='text-right'>Giá</th></tr></thead>")
          .append("<tbody>");
          
        for (BillDetail d : details) {
            sb.append("<tr>")
              .append("<td>")
              .append("<span class='product-name'>").append(d.getNameProduct()).append("</span>")
              .append("<span class='product-meta'>").append(d.getColorLabelSnapshot()).append(" / ").append(d.getSizeLabelSnapshot()).append("</span>")
              .append("</td>")
              .append("<td>").append(d.getNumberOfProduct()).append("</td>")
              .append("<td class='text-right'>").append(df.format(d.getPriceProduct())).append("₫</td>")
              .append("</tr>");
        }
        
        sb.append("</tbody>")
          .append("<tfoot>")
          .append("<tr class='summary-row'><td colspan='2' class='text-right'>Tạm tính</td><td class='text-right'>").append(df.format(bill.getSubtotal())).append("₫</td></tr>");
          
        if (bill.getDiscountAmount() > 0) {
            sb.append("<tr class='summary-row'><td colspan='2' class='text-right'>Giảm giá");
            if (bill.getVoucherCodeSnapshot() != null) {
                String code = bill.getVoucherCodeSnapshot().replace("PUB_", "").replace("PRI_", "");
                sb.append(" (").append(code).append(")");
            }
            sb.append("</td><td class='text-right'>-").append(df.format(bill.getDiscountAmount())).append("₫</td></tr>");
        }
        
        sb.append("<tr class='total-row'><td colspan='2' class='text-right'>Tổng cộng</td><td class='text-right'>").append(df.format(bill.getTotal())).append("₫</td></tr>")
          .append("</tfoot>")
          .append("</table>")
          .append("</div>")
          .append("<p>Chúng tôi sẽ sớm liên hệ hoặc gửi thông báo khi đơn hàng bắt đầu được giao. Nếu bạn có bất kỳ câu hỏi nào, vui lòng trả lời trực tiếp email này.</p>");
          
        sb.append(getEmailFooter());
        return sb.toString();
    }

    public static String getOtpEmailTemplate(String otpCode) {
        StringBuilder sb = new StringBuilder();
        sb.append(getEmailHeader("Khôi Phục Mật Khẩu"));
        sb.append("<div style='text-align: center;'>");
        sb.append("<p style='color: #4a5568; font-size: 15px; line-height: 1.6; margin-bottom: 25px;'>Bạn vừa yêu cầu khôi phục mật khẩu. Vui lòng sử dụng mã xác nhận (OTP) dưới đây để tiếp tục. Mã này có hiệu lực trong vòng <strong>10 phút</strong>.</p>");
        sb.append("<div class='otp-box'><p class='otp-code'>").append(otpCode).append("</p></div>");
        sb.append("<p class='warning'>Nếu bạn không yêu cầu thay đổi mật khẩu, vui lòng bỏ qua email này hoặc liên hệ bộ phận hỗ trợ ngay lập tức.</p>");
        sb.append("</div>");
        sb.append(getEmailFooter());
        return sb.toString();
    }
    public static String getRegisterOtpEmailTemplate(String otpCode) {
        StringBuilder sb = new StringBuilder();
        sb.append(getEmailHeader("Xác Nhận Đăng Ký Tài Khoản"));
        sb.append("<div style='text-align: center;'>");
        sb.append("<p style='color: #4a5568; font-size: 15px; line-height: 1.6; margin-bottom: 25px;'>Cảm ơn bạn đã đăng ký tài khoản. Vui lòng sử dụng mã xác nhận (OTP) dưới đây để kích hoạt tài khoản của bạn. Mã này có hiệu lực trong vòng <strong>10 phút</strong>.</p>");
        sb.append("<div class='otp-box'><p class='otp-code'>").append(otpCode).append("</p></div>");
        sb.append("<p class='warning'>Nếu bạn không yêu cầu đăng ký tài khoản, vui lòng bỏ qua email này.</p>");
        sb.append("</div>");
        sb.append(getEmailFooter());
        return sb.toString();
    }
}
