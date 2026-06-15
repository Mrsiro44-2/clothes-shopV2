package Utils;

public class AppConfig {

    // ==========================================
    // 1. CẤU HÌNH CƠ SỞ DỮ LIỆU (DATABASE SQL SERVER)
    // ==========================================
    // Đổi thông số cho khớp SQL Server của bạn (ví dụ: ClothesShop theo script v2).
    public static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ClothesShop;user=sa;password=sa;encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;";

     // ==========================================
    // 2. CẤU HÌNH EMAIL (GỬI THÔNG BÁO, QUÊN MẬT KHẨU)
    // ==========================================
    public static final String EMAIL_USERNAME = "Clothing Shop";
    public static final String EMAIL_FROM = "kimlt.develop@gmail.com";
    public static final String EMAIL_PASSWORD = "xlwizpsnqzazjkry";
    // ==========================================
    // 3. CẤU HÌNH PAYOS (THANH TOÁN ONLINE)
    // ==========================================
    // THAY THẾ CÁC GIÁ TRỊ NÀY BẰNG THÔNG TIN TỪ DASHBOARD PAYOS CỦA BẠN
    public static final String PAYOS_CLIENT_ID = "57dd536b-8764-4438-9a62-1a082e5d0e69";
    public static final String PAYOS_API_KEY = "fa1b1b12-02fe-4040-af30-27fd46c6cb96";
    public static final String PAYOS_CHECKSUM_KEY = "76d014bbabdc699d519148e8405aaaa4b2047b445ff3d537907eec47386b498a";

    // Môi trường API
    public static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";

    public static final String BASE_URL = "http://localhost:2003/clothes-shop";

    // Nơi PayOS sẽ gọi về (hoặc người dùng được chuyển hướng về)
    public static final String PAYOS_RETURN_URL = BASE_URL + "/payos/return";
    public static final String PAYOS_CANCEL_URL = BASE_URL + "/payos/return";
}