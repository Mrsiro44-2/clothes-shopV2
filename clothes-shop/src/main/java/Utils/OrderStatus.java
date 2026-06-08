package Utils;

public class OrderStatus {
    public static final int PENDING = 0;
    public static final int PAID = 4;
    public static final int PREPARED = 5;
    public static final int SHIPPING = 1;
    public static final int CANCELLED = 2;
    public static final int COMPLETED = 3;

    public static String getStatusLabel(int status) {
        switch (status) {
            case PENDING: return "Chờ xử lý";
            case PAID: return "Đã thanh toán";
            case PREPARED: return "Đã chuẩn bị hàng";
            case SHIPPING: return "Đang giao";
            case CANCELLED: return "Đã hủy";
            case COMPLETED: return "Hoàn thành";
            default: return "Không xác định";
        }
    }

    public static String getStatusBadgeClass(int status) {
        switch (status) {
            case PENDING: return "status-pending";
            case PAID: return "status-paid"; 
            case PREPARED: return "status-prepared"; 
            case SHIPPING: return "status-shipping";
            case CANCELLED: return "status-cancelled";
            case COMPLETED: return "status-completed";
            default: return "";
        }
    }

    public static String getPaymentMethodLabel(int payment) {
        return payment == 1 ? "PayOS" : "COD";
    }
}
