-- Thêm cột wardCode và districtId vào bảng ShippingAddress
ALTER TABLE ShippingAddress ADD wardCode NVARCHAR(255) NULL;
ALTER TABLE ShippingAddress ADD districtId INT NULL;

-- Thêm cột wardCode và districtId vào bảng Bill
ALTER TABLE Bill ADD wardCode NVARCHAR(255) NULL;
ALTER TABLE Bill ADD districtId INT NULL;
