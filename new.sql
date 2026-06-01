USE master;
GO

IF DB_ID(N'ClothesShop') IS NULL
    CREATE DATABASE ClothesShop;
GO

USE ClothesShop;
GO

/* ================= ROLE ================= */
CREATE TABLE Role (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    status INT NOT NULL DEFAULT 1
);

/* ================= ACCOUNT ================= */
CREATE TABLE Account (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(200) NOT NULL,
    email NVARCHAR(200) NOT NULL,
    phone NVARCHAR(50),
    username NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(500) NOT NULL,
    role INT NOT NULL,
    date DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    status INT NOT NULL DEFAULT 1,
    avatar NVARCHAR(500),
    FOREIGN KEY (role) REFERENCES Role(ID)
);

/* ================= SIZE GROUP ================= */
CREATE TABLE SizeGroup (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    sortOrder INT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1
);

/* ================= SIZE OPTION ================= */
CREATE TABLE SizeOption (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(50),
    label NVARCHAR(100) NOT NULL,
    sortOrder INT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1,
    sizeGroupID INT NOT NULL,
    FOREIGN KEY (sizeGroupID) REFERENCES SizeGroup(ID)
);

/* ================= COLOR OPTION ================= */
CREATE TABLE ColorOption (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    hexCode CHAR(7),
    sortOrder INT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1
);

/* ================= CATEGORY ================= */
CREATE TABLE Category (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    slug NVARCHAR(220),
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    status INT NOT NULL DEFAULT 1,
    sizeGroupID INT NOT NULL,
    FOREIGN KEY (sizeGroupID) REFERENCES SizeGroup(ID)
);

/* ================= BRAND ================= */
CREATE TABLE Brand (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    img NVARCHAR(500),
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    status INT NOT NULL DEFAULT 1
);

/* ================= PRODUCER ================= */
CREATE TABLE Producer (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    status INT NOT NULL DEFAULT 1
);

/* ================= PRODUCT ================= */
CREATE TABLE Product (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(500) NOT NULL,
    slug NVARCHAR(320),
    description NVARCHAR(MAX),
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    mainImg NVARCHAR(500),
    status INT NOT NULL DEFAULT 1,
    model NVARCHAR(200),
    priority INT NOT NULL DEFAULT 0,
    categoryID INT NOT NULL,
    producerID INT NOT NULL,
    brandID INT NOT NULL,
    FOREIGN KEY (categoryID) REFERENCES Category(ID),
    FOREIGN KEY (producerID) REFERENCES Producer(ID),
    FOREIGN KEY (brandID) REFERENCES Brand(ID)
);

/* ================= PRODUCT VARIANT - ĐÃ BỎ SOLD ================= */
CREATE TABLE ProductVariant (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    productID INT NOT NULL,
    sizeOptionID INT NOT NULL,
    colorOptionID INT NOT NULL,
    sku NVARCHAR(80) NOT NULL UNIQUE,
    barcode NVARCHAR(80),
    oldPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    newPrice DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    variantImg NVARCHAR(500),
    weightGrams INT,
    isDefault BIT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1,
    dateCreated DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdated DATETIME2(3),
    FOREIGN KEY (productID) REFERENCES Product(ID) ON DELETE CASCADE,
    FOREIGN KEY (sizeOptionID) REFERENCES SizeOption(ID),
    FOREIGN KEY (colorOptionID) REFERENCES ColorOption(ID),
    CONSTRAINT CK_ProductVariant_price CHECK (newPrice >= 0 AND oldPrice >= 0),
    CONSTRAINT CK_ProductVariant_qty CHECK (quantity >= 0)
);

/* ================= IMG DESCRIPTION ================= */
CREATE TABLE imgDescription (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    imgUrl NVARCHAR(500) NOT NULL,
    productID INT NOT NULL,
    sortOrder INT NOT NULL DEFAULT 0,
    FOREIGN KEY (productID) REFERENCES Product(ID) ON DELETE CASCADE
);

/* ================= CART ================= */
CREATE TABLE Cart (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    accountID INT NOT NULL,
    productVariantID INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    dateAdded DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (accountID) REFERENCES Account(ID) ON DELETE CASCADE,
    FOREIGN KEY (productVariantID) REFERENCES ProductVariant(ID) ON DELETE CASCADE,
    CONSTRAINT UX_Cart_user_variant UNIQUE(accountID, productVariantID),
    CONSTRAINT CK_Cart_qty CHECK(quantity > 0)
);

/* ================= WISHLIST ================= */
CREATE TABLE Wishlist (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    accountID INT NOT NULL,
    productVariantID INT NOT NULL,
    dateAdded DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (accountID) REFERENCES Account(ID) ON DELETE CASCADE,
    FOREIGN KEY (productVariantID) REFERENCES ProductVariant(ID) ON DELETE CASCADE,
    CONSTRAINT UX_Wishlist_user_variant UNIQUE(accountID, productVariantID)
);

/* ================= VOUCHER ================= */
CREATE TABLE Voucher (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    code NVARCHAR(80) NOT NULL UNIQUE,
    value DECIMAL(18,2) NOT NULL,
    [start] DATE NOT NULL,
    [end] DATE NOT NULL,
    status INT NOT NULL DEFAULT 1,
    [limit] DECIMAL(18,2),
    used INT NOT NULL DEFAULT 0,
    discountType INT NOT NULL DEFAULT 0,
    minOrderAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    maxDiscount DECIMAL(18,2),
    usageLimit INT
);

/* ================= BILL ================= */
CREATE TABLE Bill (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customerID INT,
    email NVARCHAR(200) NOT NULL,
    customerName NVARCHAR(200) NOT NULL,
    phone NVARCHAR(50) NOT NULL,
    address NVARCHAR(500) NOT NULL,
    detailAddress NVARCHAR(500),
    total DECIMAL(18,2) NOT NULL,
    status INT NOT NULL DEFAULT 0,
    payment INT NOT NULL DEFAULT 0,
    dateOrder DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    transactionCode NVARCHAR(120),
    subtotal DECIMAL(18,2),
    discountAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    voucherID INT,
    voucherCodeSnapshot NVARCHAR(80),
    FOREIGN KEY (customerID) REFERENCES Account(ID),
    FOREIGN KEY (voucherID) REFERENCES Voucher(ID)
);

/* ================= BILL DETAIL ================= */
CREATE TABLE BillDetail (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    billID INT NOT NULL,
    productVariantID INT,
    productID INT NOT NULL,
    skuSnapshot NVARCHAR(80) NOT NULL,
    nameProduct NVARCHAR(500) NOT NULL,
    modelProduct NVARCHAR(200),
    imgProduct NVARCHAR(500),
    sizeLabelSnapshot NVARCHAR(100) NOT NULL,
    colorLabelSnapshot NVARCHAR(100) NOT NULL,
    priceProduct DECIMAL(18,2) NOT NULL,
    numberOfProduct INT NOT NULL,
    lineTotal AS CONVERT(DECIMAL(18,2), priceProduct * numberOfProduct) PERSISTED,
    FOREIGN KEY (billID) REFERENCES Bill(id) ON DELETE CASCADE,
    FOREIGN KEY (productVariantID) REFERENCES ProductVariant(ID),
    CONSTRAINT CK_BillDetail_price CHECK(priceProduct >= 0),
    CONSTRAINT CK_BillDetail_qty CHECK(numberOfProduct > 0)
);

/* ================= FEEDBACK ================= */
CREATE TABLE Feedback (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    productId INT NOT NULL,
    comment NVARCHAR(MAX) NOT NULL,
    star INT NOT NULL DEFAULT 5,
    status INT NOT NULL DEFAULT 1,
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    FOREIGN KEY (userId) REFERENCES Account(ID),
    FOREIGN KEY (productId) REFERENCES Product(ID) ON DELETE CASCADE,
    CONSTRAINT CK_Feedback_star CHECK(star BETWEEN 1 AND 5)
);

/* ================= BLOG ================= */
CREATE TABLE BlogCategory (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    slug NVARCHAR(220) NOT NULL UNIQUE,
    description NVARCHAR(1000),
    coverImg NVARCHAR(500),
    sortOrder INT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1,
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3)
);

CREATE TABLE BlogPost (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    blogCategoryID INT,
    authorAccountID INT NOT NULL,
    title NVARCHAR(500) NOT NULL,
    slug NVARCHAR(320) NOT NULL UNIQUE,
    excerpt NVARCHAR(1000),
    contentHtml NVARCHAR(MAX) NOT NULL,
    coverImg NVARCHAR(500),
    status INT NOT NULL DEFAULT 0,
    isFeatured BIT NOT NULL DEFAULT 0,
    publishedAt DATETIME2(3),
    dateCreated DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdated DATETIME2(3),
    viewCount INT NOT NULL DEFAULT 0,
    seoTitle NVARCHAR(320),
    seoDescription NVARCHAR(500),
    readingMinutes SMALLINT,
    FOREIGN KEY (blogCategoryID) REFERENCES BlogCategory(ID) ON DELETE SET NULL,
    FOREIGN KEY (authorAccountID) REFERENCES Account(ID),
    CONSTRAINT CK_BlogPost_views CHECK(viewCount >= 0)
);

CREATE TABLE BlogTag (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(120) NOT NULL,
    slug NVARCHAR(160) NOT NULL UNIQUE
);

CREATE TABLE BlogPostTag (
    blogPostID INT NOT NULL,
    blogTagID INT NOT NULL,
    PRIMARY KEY(blogPostID, blogTagID),
    FOREIGN KEY (blogPostID) REFERENCES BlogPost(ID) ON DELETE CASCADE,
    FOREIGN KEY (blogTagID) REFERENCES BlogTag(ID) ON DELETE CASCADE
);

CREATE TABLE BlogComment (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    blogPostID INT NOT NULL,
    accountID INT,
    guestName NVARCHAR(200),
    guestEmail NVARCHAR(200),
    body NVARCHAR(4000) NOT NULL,
    status INT NOT NULL DEFAULT 0,
    parentCommentID INT,
    datePost DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate DATETIME2(3),
    FOREIGN KEY (blogPostID) REFERENCES BlogPost(ID) ON DELETE CASCADE,
    FOREIGN KEY (accountID) REFERENCES Account(ID) ON DELETE SET NULL,
    FOREIGN KEY (parentCommentID) REFERENCES BlogComment(ID),
    CONSTRAINT CK_BlogComment_author_or_guest
    CHECK(accountID IS NOT NULL OR (guestName IS NOT NULL AND guestEmail IS NOT NULL))
);
GO

/* ================= SEED DATA ================= */
INSERT INTO Role(name) VALUES
(N'admin'), (N'staff'), (N'user');

INSERT INTO SizeGroup(code, name, sortOrder) VALUES
(N'CLOTHING', N'Quần áo', 10),
(N'SHOES', N'Giày dép', 20),
(N'ONESIZE', N'Phụ kiện / đồ chơi', 30);

DECLARE @clothing INT = (SELECT ID FROM SizeGroup WHERE code = N'CLOTHING');
DECLARE @shoes INT = (SELECT ID FROM SizeGroup WHERE code = N'SHOES');
DECLARE @onesize INT = (SELECT ID FROM SizeGroup WHERE code = N'ONESIZE');

INSERT INTO SizeOption(code, label, sortOrder, sizeGroupID) VALUES
(N'FREE', N'Free size', 0, @onesize),
(N'NB', N'Newborn', 10, @clothing),
(N'S', N'S', 20, @clothing),
(N'M', N'M', 30, @clothing),
(N'L', N'L', 40, @clothing),
(N'XL', N'XL', 50, @clothing),
(N'S16', N'16', 10, @shoes),
(N'S17', N'17', 20, @shoes),
(N'S18', N'18', 30, @shoes),
(N'S19', N'19', 40, @shoes),
(N'S20', N'20', 50, @shoes),
(N'S21', N'21', 60, @shoes),
(N'OS', N'One size', 0, @onesize);

INSERT INTO ColorOption(name, hexCode, sortOrder) VALUES
(N'Mặc định', NULL, 0),
(N'Hồng', '#FFB6C1', 10),
(N'Xanh dương', '#4169E1', 20),
(N'Be', '#F5F5DC', 30),
(N'Trắng', '#FFFFFF', 40),
(N'Xám', '#808080', 50);

INSERT INTO Category(name, slug, sizeGroupID) VALUES
(N'Quần áo sơ sinh', N'quan-ao-so-sinh', @clothing),
(N'Đồ bộ bé trai', N'do-bo-be-trai', @clothing),
(N'Đồ bộ bé gái', N'do-bo-be-gai', @clothing),
(N'Giày dép', N'giay-dep', @shoes),
(N'Phụ kiện', N'phu-kien', @onesize),
(N'Đồ chơi', N'do-choi', @onesize);

INSERT INTO Producer(name) VALUES
(N'Công ty TNHH Mẹ & Bé Việt'),
(N'Kids Fashion Import'),
(N'BabyCare Factory'),
(N'Organic Baby Co.');

INSERT INTO Brand(name, img) VALUES
(N'Chicco', N'./uploads/brand/chicco.png'),
(N'Pampers', N'./uploads/brand/pampers.png'),
(N'Huggies', N'./uploads/brand/huggies.png'),
(N'Gerber', N'./uploads/brand/gerber.png'),
(N'Mothercare', N'./uploads/brand/mothercare.png'),
(N'Fisher-Price', N'./uploads/brand/fisher.png'),
(N'Combi', N'./uploads/brand/combi.png'),
(N'Aprica', N'./uploads/brand/aprica.png');

INSERT INTO Account(fullname, email, phone, username, password, role, status, avatar) VALUES
(N'Quản trị viên', N'admin@momandbaby.local', N'0901000001', N'admin', N'123456', 1, 1, NULL),
(N'Nhân viên kho', N'staff@momandbaby.local', N'0901000002', N'staff', N'123456', 2, 1, NULL),
(N'Nguyễn Thị Lan', N'user1@test.com', N'0902000001', N'user1', N'123456', 3, 1, NULL),
(N'Trần Văn Minh', N'user2@test.com', N'0902000002', N'user2', N'123456', 3, 1, NULL),
(N'Lê Thị Hoa', N'user3@test.com', N'0902000003', N'user3', N'123456', 3, 1, NULL);

INSERT INTO Voucher(name, code, value, [start], [end], discountType, minOrderAmount, maxDiscount, usageLimit) VALUES
(N'Giảm 10%', N'MOM10', 10, '2026-05-18', '2027-05-18', 1, 200000, 100000, 500),
(N'Giảm 50.000đ', N'SAVE50K', 50000, '2026-05-18', '2027-05-18', 0, 300000, NULL, 200),
(N'Giảm 20% tân thủ', N'WELCOME20', 20, '2026-05-18', '2026-08-18', 1, 150000, 80000, 100);

/* ================= AUTO SEED PRODUCT + VARIANT ================= */
DECLARE @i INT = 1;

WHILE @i <= 40
BEGIN
    INSERT INTO Product(name, slug, description, mainImg, status, model, priority, categoryID, producerID, brandID)
    VALUES (
        N'Sản phẩm mẫu #' + CAST(@i AS NVARCHAR(10)),
        N'san-pham-mau-' + CAST(@i AS NVARCHAR(10)),
        N'Mô tả chi tiết cho sản phẩm mẫu. Chất liệu cotton mềm, phù hợp bé từ 0–24 tháng.',
        N'./uploads/product/seed-' + RIGHT('00' + CAST(@i AS VARCHAR(2)), 2) + N'.jpg',
        1,
        N'MDL-' + CAST(@i AS NVARCHAR(10)),
        CASE WHEN @i % 5 = 0 THEN 2 ELSE 1 END,
        ((@i - 1) % 6) + 1,
        ((@i - 1) % 4) + 1,
        ((@i - 1) % 8) + 1
    );

    DECLARE @productID INT = SCOPE_IDENTITY();

    INSERT INTO ProductVariant(productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity, isDefault, status)
    VALUES (
        @productID,
        4,
        1,
        N'SKU-' + CAST(@productID AS NVARCHAR(10)) + N'-M-DEF',
        100000 + (@i * 18000),
        95000 + (@i * 15000),
        50 + @i,
        1,
        1
    );

    INSERT INTO ProductVariant(productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity, isDefault, status)
    VALUES (
        @productID,
        5,
        2,
        N'SKU-' + CAST(@productID AS NVARCHAR(10)) + N'-L-PINK',
        95000 + (@i * 17000),
        90000 + (@i * 14000),
        40 + @i,
        0,
        1
    );

    SET @i += 1;
END;
GO

/* ================= VIEW GIÁ + TỒN KHO ================= */
CREATE OR ALTER VIEW vw_ProductPriceStock AS
SELECT
    p.ID AS productID,
    MIN(v.newPrice) AS minPrice,
    MAX(v.newPrice) AS maxPrice,
    SUM(v.quantity) AS totalQuantity
FROM Product p
JOIN ProductVariant v ON v.productID = p.ID
WHERE v.status = 1
GROUP BY p.ID;
GO

PRINT N'ClothesShop full script completed.';
GO