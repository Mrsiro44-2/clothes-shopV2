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
    public static final String PAYOS_CLIENT_ID = "2f038996-996a-4516-a95c-19d0d09794f4";
    public static final String PAYOS_API_KEY = "e23cd862-6a8b-43b9-87fe-91beacb2f04b";
    public static final String PAYOS_CHECKSUM_KEY = "5b8c2bcaab2e6d0dc238b3799e5f5851d35265a33df0bc4453b09f9037589ae0";

    // Môi trường API
    public static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";

    public static final String BASE_URL = "http://localhost:2003/clothes-shop";

    // Nơi PayOS sẽ gọi về (hoặc người dùng được chuyển hướng về)
    public static final String PAYOS_RETURN_URL = BASE_URL + "/payos/return";
    public static final String PAYOS_CANCEL_URL = BASE_URL + "/payos/return";
}
