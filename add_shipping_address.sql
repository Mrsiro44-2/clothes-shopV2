USE ClothesShop;
GO

-- 1. Tạo bảng ShippingAddress
CREATE TABLE ShippingAddress (
    id INT IDENTITY(1,1) PRIMARY KEY,
    accountID INT NOT NULL,
    fullName NVARCHAR(200) NOT NULL,
    phone NVARCHAR(50) NOT NULL,
    address NVARCHAR(500) NOT NULL, -- Ví dụ: "Phường A, Quận B, Thành phố C"
    detailAddress NVARCHAR(500), -- Số nhà, tên đường
    isDefault BIT NOT NULL DEFAULT 0,
    createdAt DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (accountID) REFERENCES Account(ID) ON DELETE CASCADE
);
GO

-- 2. Thêm cột shippingAddressID vào bảng Bill
ALTER TABLE Bill
ADD shippingAddressID INT NULL;
GO

-- 3. Tạo Foreign Key từ Bill tới ShippingAddress
ALTER TABLE Bill
ADD CONSTRAINT FK_Bill_ShippingAddress 
FOREIGN KEY (shippingAddressID) REFERENCES ShippingAddress(id) ON DELETE SET NULL;
GO
