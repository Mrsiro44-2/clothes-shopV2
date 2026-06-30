USE ClothesShop;
GO

/* ================= ALTER BILL TABLE ================= */
-- Thêm cột cancelReason để lưu trực tiếp lý do hủy đơn từ list cấu hình trên code
ALTER TABLE Bill
ADD cancelReason NVARCHAR(500) NULL;
GO
