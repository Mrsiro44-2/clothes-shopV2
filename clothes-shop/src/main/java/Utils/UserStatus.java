package Utils;

public class UserStatus {
    /**
     * Tài khoản chờ kích hoạt (chưa xác thực OTP)
     */
    public static final int PENDING = 0;
    
    /**
     * Tài khoản đang hoạt động bình thường
     */
    public static final int ACTIVE = 1;
    
    /**
     * Tài khoản bị khóa (banned)
     */
    public static final int LOCKED = 2;
}
