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

    // ==========================================
    // 4. CẤU HÌNH GIAO HÀNG NHANH (GHN)
    // ==========================================
    public static final String GHN_TOKEN = "beef37b6-f4d2-11ef-bb13-2a342a4da1fb"; // Thay bằng token thật của shop
    public static final String GHN_SHOP_ID = "196056"; // Thay bằng ShopID thật
    public static final String GHN_BASE_API = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/";
    public static final String GHN_BASE_A5_API = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/a5/";

    // Thông số mặc định khi đẩy đơn sang GHN
    public static final int GHN_PAYMENT_TYPE_ID = 1; 
    public static final String GHN_NOTE = "Gửi đơn hàng qua GHN";
    public static final String GHN_REQUIRED_NOTE = "KHONGCHOXEMHANG";
    public static final String GHN_FROM_NAME = "Clothes Shop";
    public static final String GHN_FROM_PHONE = "0987654321";
    public static final String GHN_FROM_ADDRESS = "600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ";
    public static final String GHN_FROM_WARD_NAME = "An Binh";
    public static final String GHN_FROM_DISTRICT_NAME = "Ninh Kiều";
    public static final String GHN_FROM_PROVINCE_NAME = "Cần Thơ";
    public static final String GHN_RETURN_PHONE = "0987654321";
    public static final String GHN_RETURN_ADDRESS = "600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ";

    public static final String BASE_URL = "http://localhost:2003/clothes-shop";

    // Nơi PayOS sẽ gọi về (hoặc người dùng được chuyển hướng về)
    public static final String PAYOS_RETURN_URL = BASE_URL + "/payos/return";
    public static final String PAYOS_CANCEL_URL = BASE_URL + "/payos/return";
}
