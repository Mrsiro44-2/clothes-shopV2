-- Thêm cột ghnOrderCode vào bảng Bill nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Bill' AND COLUMN_NAME = 'ghnOrderCode'
)
BEGIN
    ALTER TABLE Bill ADD ghnOrderCode NVARCHAR(255) NULL;
END
GO
