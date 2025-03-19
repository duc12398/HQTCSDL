CREATE DATABASE QuanLyBenhVien;
GO
USE QuanLyBenhVien;
GO

-- Bảng Bác sĩ
CREATE TABLE BacSi (
    MaBacSi INT PRIMARY KEY IDENTITY, -- Khóa chính
    HoTen NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(15) UNIQUE
);

-- Bảng Chuyên khoa
CREATE TABLE ChuyenKhoa (
    MaChuyenKhoa INT PRIMARY KEY IDENTITY, -- Khóa chính
    TenChuyenKhoa NVARCHAR(100) NOT NULL
);

-- Bảng liên kết Bác sĩ - Chuyên khoa (Khóa chính kép)
CREATE TABLE BacSi_ChuyenKhoa (
    MaBacSi INT,
    MaChuyenKhoa INT,
    PRIMARY KEY (MaBacSi, MaChuyenKhoa), -- Khóa chính kép
    FOREIGN KEY (MaBacSi) REFERENCES BacSi(MaBacSi) ON DELETE CASCADE, -- Khóa ngoại
    FOREIGN KEY (MaChuyenKhoa) REFERENCES ChuyenKhoa(MaChuyenKhoa) ON DELETE CASCADE -- Khóa ngoại
);

-- Bảng Bệnh nhân
CREATE TABLE BenhNhan (
    MaBenhNhan INT PRIMARY KEY IDENTITY, -- Khóa chính
    HoTen NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    CMND VARCHAR(20) UNIQUE
);

-- Bảng Y tá
CREATE TABLE YTa (
    MaYTa INT PRIMARY KEY IDENTITY, -- Khóa chính
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) UNIQUE
);

-- Bảng Điều trị (Bác sĩ điều trị bệnh nhân)
CREATE TABLE DieuTri (
    MaDieuTri INT PRIMARY KEY IDENTITY, -- Khóa chính
    MaBenhNhan INT NOT NULL,
    MaBacSi INT NOT NULL,
    NgayDieuTri DATETIME DEFAULT GETDATE(),
    LieuPhap NVARCHAR(255) NOT NULL,
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan) ON DELETE CASCADE, -- Khóa ngoại
    FOREIGN KEY (MaBacSi) REFERENCES BacSi(MaBacSi) ON DELETE CASCADE -- Khóa ngoại
);

-- Bảng Chăm sóc (Y tá chăm sóc bệnh nhân)
CREATE TABLE ChamSoc (
    MaChamSoc INT PRIMARY KEY IDENTITY, -- Khóa chính
    MaBenhNhan INT NOT NULL,
    MaYTa INT NOT NULL,
    NgayChamSoc DATETIME DEFAULT GETDATE(),
    NoiDung NVARCHAR(255) NOT NULL,
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan) ON DELETE CASCADE, -- Khóa ngoại
    FOREIGN KEY (MaYTa) REFERENCES YTa(MaYTa) ON DELETE CASCADE -- Khóa ngoại
);
-- Bác sĩ
INSERT INTO BacSi (HoTen, DiaChi, SoDienThoai)
VALUES 
('Nguyễn Văn A', 'Hà Nội', '0987654321'),
('Trần Thị B', 'Hồ Chí Minh', '0978123456');

-- Chuyên khoa
INSERT INTO ChuyenKhoa (TenChuyenKhoa)
VALUES 
('Tim mạch'),
('Nội tiết');

-- Liên kết Bác sĩ - Chuyên khoa
INSERT INTO BacSi_ChuyenKhoa (MaBacSi, MaChuyenKhoa)
VALUES 
(1, 1),
(2, 2);

-- Bệnh nhân
INSERT INTO BenhNhan (HoTen, DiaChi, CMND)
VALUES 
('Lê Minh C', 'Đà Nẵng', '123456789'),
('Phạm Thị D', 'Huế', '987654321');

-- Y tá
INSERT INTO YTa (HoTen, SoDienThoai)
VALUES 
('Nguyễn Thị E', '0909123456'),
('Lý Quốc F', '0912345678');

-- Điều trị
INSERT INTO DieuTri (MaBenhNhan, MaBacSi, NgayDieuTri, LieuPhap)
VALUES 
(1, 1, '2024-03-10', 'Dùng thuốc A'),
(2, 2, '2024-03-11', 'Dùng thuốc B');

-- Chăm sóc
INSERT INTO ChamSoc (MaBenhNhan, MaYTa, NgayChamSoc, NoiDung)
VALUES 
(1, 1, '2024-03-12', 'Theo dõi sức khỏe'),
(2, 2, '2024-03-13', 'Chăm sóc hậu phẫu');

SELECT * FROM BacSi;
SELECT HoTen, DiaChi FROM BenhNhan;

INSERT INTO BenhNhan (HoTen, DiaChi, CMND) VALUES ('Vũ Văn G', 'Hải Phòng', '654321987');

UPDATE BacSi SET DiaChi = 'Hà Nam' WHERE MaBacSi = 1;

DELETE FROM BenhNhan WHERE MaBenhNhan = 3;

SELECT b.HoTen AS BacSi, ck.TenChuyenKhoa
FROM BacSi b
JOIN BacSi_ChuyenKhoa bc ON b.MaBacSi = bc.MaBacSi
JOIN ChuyenKhoa ck ON bc.MaChuyenKhoa = ck.MaChuyenKhoa;

SELECT MaBacSi, COUNT(*) AS SoLuongDieuTri
FROM DieuTri
GROUP BY MaBacSi
HAVING COUNT(*) > 1;

SELECT HoTen 
FROM BenhNhan 
WHERE MaBenhNhan IN (SELECT MaBenhNhan FROM DieuTri WHERE MaBacSi = 1);

CREATE VIEW BacSi_ChuyenKhoa_View AS
SELECT b.HoTen AS BacSi, ck.TenChuyenKhoa
FROM BacSi b
JOIN BacSi_ChuyenKhoa bc ON b.MaBacSi = bc.MaBacSi
JOIN ChuyenKhoa ck ON bc.MaChuyenKhoa = ck.MaChuyenKhoa;

CREATE VIEW v_BacSi_ChuyenKhoa AS
SELECT b.MaBacSi, b.HoTen AS BacSi, ck.TenChuyenKhoa
FROM BacSi b
JOIN BacSi_ChuyenKhoa bc ON b.MaBacSi = bc.MaBacSi
JOIN ChuyenKhoa ck ON bc.MaChuyenKhoa = ck.MaChuyenKhoa;

CREATE VIEW v_BenhNhan_YTa AS
SELECT bn.HoTen AS BenhNhan, y.HoTen AS YTa, cs.NoiDung, cs.NgayChamSoc
FROM BenhNhan bn
JOIN ChamSoc cs ON bn.MaBenhNhan = cs.MaBenhNhan
JOIN YTa y ON cs.MaYTa = y.MaYTa;

CREATE VIEW v_BacSi_Top AS
SELECT b.HoTen, COUNT(dt.MaDieuTri) AS SoLanDieuTri
FROM BacSi b
JOIN DieuTri dt ON b.MaBacSi = dt.MaBacSi
GROUP BY b.HoTen
ORDER BY SoLanDieuTri DESC;

CREATE VIEW v_DieuTri_30Ngay AS
SELECT * FROM DieuTri
WHERE NgayDieuTri >= DATEADD(DAY, -30, GETDATE());

CREATE VIEW v_BenhNhan_ChuaDieuTri AS
SELECT bn.*
FROM BenhNhan bn
LEFT JOIN DieuTri dt ON bn.MaBenhNhan = dt.MaBenhNhan
WHERE dt.MaDieuTri IS NULL;

CREATE VIEW v_BenhNhan_TopDieuTri AS
SELECT bn.HoTen, COUNT(dt.MaDieuTri) AS SoLanDieuTri
FROM BenhNhan bn
JOIN DieuTri dt ON bn.MaBenhNhan = dt.MaBenhNhan
GROUP BY bn.HoTen
ORDER BY SoLanDieuTri DESC;


CREATE INDEX idx_HoTen_BacSi ON BacSi(HoTen);
CREATE INDEX idx_CMND_BenhNhan ON BenhNhan(CMND);
CREATE INDEX idx_BacSi_HoTen ON BacSi(HoTen);
CREATE INDEX idx_BenhNhan_HoTen ON BenhNhan(HoTen);
CREATE INDEX idx_BenhNhan_CMND ON BenhNhan(CMND);
CREATE INDEX idx_YTa_SoDienThoai ON YTa(SoDienThoai);
CREATE INDEX idx_DieuTri_MaBenhNhan ON DieuTri(MaBenhNhan);
CREATE INDEX idx_ChamSoc_MaBenhNhan ON ChamSoc(MaBenhNhan);
CREATE INDEX idx_DieuTri_NgayDieuTri ON DieuTri(NgayDieuTri);
CREATE INDEX idx_ChamSoc_NgayChamSoc ON ChamSoc(NgayChamSoc);
CREATE INDEX idx_BacSi_ChuyenKhoa ON BacSi_ChuyenKhoa(MaBacSi, MaChuyenKhoa);
CREATE INDEX idx_DieuTri_LieuPhap ON DieuTri(LieuPhap);


CREATE PROCEDURE GetAllBacSi
AS
BEGIN
    SELECT * FROM BacSi;
END;

CREATE PROCEDURE sp_GetAllBacSi
AS
BEGIN
    SELECT * FROM BacSi;
END;

-- có tham số
CREATE PROCEDURE GetBacSiByID
    @MaBacSi INT
AS
BEGIN
    SELECT * FROM BacSi WHERE MaBacSi = @MaBacSi;
END;

CREATE PROCEDURE sp_GetBacSiByID
    @MaBacSi INT
AS
BEGIN
    SELECT * FROM BacSi WHERE MaBacSi = @MaBacSi;
END;


-- có output
CREATE PROCEDURE CountBacSi
    @SoLuong INT OUTPUT
AS
BEGIN
    SELECT @SoLuong = COUNT(*) FROM BacSi;
END;

CREATE PROCEDURE sp_CountBenhNhan
    @Total INT OUTPUT
AS
BEGIN
    SELECT @Total = COUNT(*) FROM BenhNhan;
END;

CREATE PROCEDURE sp_InsertBenhNhan
    @HoTen NVARCHAR(100), 
    @DiaChi NVARCHAR(255), 
    @CMND VARCHAR(20)
AS
BEGIN
    INSERT INTO BenhNhan (HoTen, DiaChi, CMND) VALUES (@HoTen, @DiaChi, @CMND);
END;

CREATE FUNCTION CountBenhNhan()
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM BenhNhan;
    RETURN @count;
END;

CREATE FUNCTION fn_CountBenhNhan()
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM BenhNhan;
    RETURN @count;
END;

CREATE FUNCTION fn_GetBacSiList()
RETURNS TABLE
AS
RETURN
(
    SELECT MaBacSi, HoTen FROM BacSi
);

CREATE FUNCTION fn_BenhNhan_ChuaDieuTri()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM BenhNhan WHERE MaBenhNhan NOT IN (SELECT MaBenhNhan FROM DieuTri)
);

CREATE TRIGGER trg_CheckUniqueCMND
ON BenhNhan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM BenhNhan WHERE CMND = (SELECT CMND FROM inserted))
    BEGIN
        RAISERROR ('CMND đã tồn tại!', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO BenhNhan (HoTen, DiaChi, CMND)
        SELECT HoTen, DiaChi, CMND FROM inserted;
    END;
END;

CREATE TRIGGER trg_InsertDieuTri
ON DieuTri
AFTER INSERT
AS
BEGIN
    PRINT 'Một bệnh nhân đã được điều trị!';
END;

CREATE LOGIN user_bacsi WITH PASSWORD = '12345678';
CREATE USER user_bacsi FOR LOGIN user_bacsi;

-- phân quyền 
GRANT SELECT, INSERT, UPDATE ON BenhNhan TO user_bacsi;
DENY DELETE ON BenhNhan TO user_bacsi;

BACKUP DATABASE QuanLyBenhVien TO DISK = 'D:\Backup\QuanLyBenhVien.bak';
RESTORE DATABASE QuanLyBenhVien FROM DISK = 'D:\Backup\QuanLyBenhVien.bak';
