/* =====================================================================
   ĐỒ ÁN CHUYÊN ĐỀ ASP.NET
   Đề tài : Xây dựng website bán linh kiện điện tử
   Script : Tạo cơ sở dữ liệu QLLinhKien (SQL Server 2019 Express trở lên)
   Cách chạy: Mở SSMS -> New Query -> dán toàn bộ script -> Execute (F5)
   ===================================================================== */

USE master;
GO
IF DB_ID(N'QLLinhKien') IS NOT NULL
BEGIN
    ALTER DATABASE QLLinhKien SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLLinhKien;
END
GO
CREATE DATABASE QLLinhKien;
GO
USE QLLinhKien;
GO

/* ---------------------------------------------------------------------
   1. BẢNG LOẠI SẢN PHẨM
   --------------------------------------------------------------------- */
CREATE TABLE tblLoaiSP
(
    MaLoai   INT IDENTITY(1,1) NOT NULL,
    TenLoai  NVARCHAR(100)     NOT NULL,
    MoTa     NVARCHAR(255)     NULL,
    CONSTRAINT PK_tblLoaiSP PRIMARY KEY (MaLoai),
    CONSTRAINT UQ_tblLoaiSP_TenLoai UNIQUE (TenLoai)
);
GO

/* ---------------------------------------------------------------------
   2. BẢNG HÃNG SẢN XUẤT
   --------------------------------------------------------------------- */
CREATE TABLE tblHangSX
(
    MaHang   INT IDENTITY(1,1) NOT NULL,
    TenHang  NVARCHAR(100)     NOT NULL,
    QuocGia  NVARCHAR(50)      NULL,
    CONSTRAINT PK_tblHangSX PRIMARY KEY (MaHang),
    CONSTRAINT UQ_tblHangSX_TenHang UNIQUE (TenHang)
);
GO

/* ---------------------------------------------------------------------
   3. BẢNG SẢN PHẨM (LINH KIỆN)
   --------------------------------------------------------------------- */
CREATE TABLE tblSanPham
(
    MaSP         INT IDENTITY(1,1) NOT NULL,
    TenSP        NVARCHAR(200)     NOT NULL,
    MaLoai       INT               NOT NULL,
    MaHang       INT               NOT NULL,
    DonGia       DECIMAL(18,0)     NOT NULL,
    SoLuongTon   INT               NOT NULL CONSTRAINT DF_tblSanPham_SoLuongTon DEFAULT 0,
    HinhAnh      NVARCHAR(200)     NULL,
    ThongSo      NVARCHAR(500)     NULL,
    MoTa         NVARCHAR(MAX)     NULL,
    NgayCapNhat  DATETIME          NOT NULL CONSTRAINT DF_tblSanPham_NgayCapNhat DEFAULT GETDATE(),
    TrangThai    BIT               NOT NULL CONSTRAINT DF_tblSanPham_TrangThai DEFAULT 1,
    CONSTRAINT PK_tblSanPham PRIMARY KEY (MaSP),
    CONSTRAINT FK_tblSanPham_tblLoaiSP FOREIGN KEY (MaLoai) REFERENCES tblLoaiSP(MaLoai),
    CONSTRAINT FK_tblSanPham_tblHangSX FOREIGN KEY (MaHang) REFERENCES tblHangSX(MaHang),
    CONSTRAINT CK_tblSanPham_DonGia     CHECK (DonGia >= 0),
    CONSTRAINT CK_tblSanPham_SoLuongTon CHECK (SoLuongTon >= 0)
);
GO

/* ---------------------------------------------------------------------
   4. BẢNG NGƯỜI DÙNG (Admin và Khách hàng)
   Mật khẩu lưu dạng băm SHA-256 (chuỗi HEX in hoa 64 ký tự)
   --------------------------------------------------------------------- */
CREATE TABLE tblUser
(
    Username   VARCHAR(50)    NOT NULL,
    Password   VARCHAR(64)    NOT NULL,
    HoTen      NVARCHAR(100)  NOT NULL,
    Email      VARCHAR(100)   NULL,
    DienThoai  VARCHAR(15)    NULL,
    DiaChi     NVARCHAR(200)  NULL,
    Role       VARCHAR(20)    NOT NULL CONSTRAINT DF_tblUser_Role DEFAULT 'KhachHang',
    TrangThai  BIT            NOT NULL CONSTRAINT DF_tblUser_TrangThai DEFAULT 1,
    NgayTao    DATETIME       NOT NULL CONSTRAINT DF_tblUser_NgayTao DEFAULT GETDATE(),
    CONSTRAINT PK_tblUser PRIMARY KEY (Username),
    CONSTRAINT UQ_tblUser_Email UNIQUE (Email),
    CONSTRAINT CK_tblUser_Role CHECK (Role IN ('Admin', 'KhachHang'))
);
GO

/* ---------------------------------------------------------------------
   5. BẢNG ĐƠN HÀNG
   --------------------------------------------------------------------- */
CREATE TABLE tblDonHang
(
    MaDH          INT IDENTITY(1,1) NOT NULL,
    Username      VARCHAR(50)       NOT NULL,
    NgayDat       DATETIME          NOT NULL CONSTRAINT DF_tblDonHang_NgayDat DEFAULT GETDATE(),
    HoTenNhan     NVARCHAR(100)     NOT NULL,
    DienThoaiNhan VARCHAR(15)       NOT NULL,
    EmailNhan     VARCHAR(100)      NULL,
    DiaChiGiao    NVARCHAR(200)     NOT NULL,
    TongTien      DECIMAL(18,0)     NOT NULL CONSTRAINT DF_tblDonHang_TongTien DEFAULT 0,
    TrangThai     NVARCHAR(30)      NOT NULL CONSTRAINT DF_tblDonHang_TrangThai DEFAULT N'Chờ xử lý',
    GhiChu        NVARCHAR(255)     NULL,
    HinhThucTT    NVARCHAR(30)      NOT NULL CONSTRAINT DF_tblDonHang_HinhThucTT DEFAULT N'COD',
    CONSTRAINT PK_tblDonHang PRIMARY KEY (MaDH),
    CONSTRAINT FK_tblDonHang_tblUser FOREIGN KEY (Username) REFERENCES tblUser(Username),
    CONSTRAINT CK_tblDonHang_TrangThai CHECK (TrangThai IN (N'Chờ xử lý', N'Đang giao', N'Hoàn thành', N'Đã hủy')),
    CONSTRAINT CK_tblDonHang_HinhThucTT CHECK (HinhThucTT IN (N'COD', N'Chuyển khoản'))
);
GO

/* ---------------------------------------------------------------------
   6. BẢNG CHI TIẾT ĐƠN HÀNG
   --------------------------------------------------------------------- */
CREATE TABLE tblChiTietDH
(
    MaDH     INT            NOT NULL,
    MaSP     INT            NOT NULL,
    SoLuong  INT            NOT NULL,
    DonGia   DECIMAL(18,0)  NOT NULL,
    CONSTRAINT PK_tblChiTietDH PRIMARY KEY (MaDH, MaSP),
    CONSTRAINT FK_tblChiTietDH_tblDonHang FOREIGN KEY (MaDH) REFERENCES tblDonHang(MaDH) ON DELETE CASCADE,
    CONSTRAINT FK_tblChiTietDH_tblSanPham FOREIGN KEY (MaSP) REFERENCES tblSanPham(MaSP),
    CONSTRAINT CK_tblChiTietDH_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CK_tblChiTietDH_DonGia  CHECK (DonGia >= 0)
);
GO

/* ---------------------------------------------------------------------
   7. BẢNG CẤU HÌNH WEBSITE (thông tin hiển thị, chỉnh sửa từ trang Admin)
   --------------------------------------------------------------------- */
CREATE TABLE tblCauHinh
(
    MaCH     VARCHAR(50)    NOT NULL,
    Nhom     NVARCHAR(50)   NOT NULL,
    TenCH    NVARCHAR(100)  NOT NULL,
    GiaTri   NVARCHAR(MAX)  NULL,
    KieuNhap VARCHAR(10)    NOT NULL CONSTRAINT DF_tblCauHinh_KieuNhap DEFAULT 'text',
    GhiChu   NVARCHAR(200)  NULL,
    ThuTu    INT            NOT NULL CONSTRAINT DF_tblCauHinh_ThuTu DEFAULT 0,
    CONSTRAINT PK_tblCauHinh PRIMARY KEY (MaCH),
    CONSTRAINT CK_tblCauHinh_KieuNhap CHECK (KieuNhap IN ('text', 'multi'))
);
GO

/* =====================================================================
   THỦ TỤC LƯU TRỮ (Stored Procedure) – dùng cho chức năng thống kê
   ===================================================================== */
CREATE PROCEDURE sp_ThongKeDoanhThuTheoThang
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MONTH(NgayDat)      AS Thang,
           COUNT(*)            AS SoDonHang,
           SUM(TongTien)       AS DoanhThu
    FROM   tblDonHang
    WHERE  YEAR(NgayDat) = @Nam AND TrangThai = N'Hoàn thành'
    GROUP BY MONTH(NgayDat)
    ORDER BY Thang;
END
GO

CREATE PROCEDURE sp_TopSanPhamBanChay
    @TuNgay  DATE,
    @DenNgay DATE,
    @SoLuong INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@SoLuong)
           sp.MaSP, sp.TenSP,
           SUM(ct.SoLuong)             AS TongSoLuong,
           SUM(ct.SoLuong * ct.DonGia) AS TongTien
    FROM   tblChiTietDH ct
           JOIN tblDonHang dh ON dh.MaDH = ct.MaDH
           JOIN tblSanPham sp ON sp.MaSP = ct.MaSP
    WHERE  dh.TrangThai = N'Hoàn thành'
           AND CAST(dh.NgayDat AS DATE) BETWEEN @TuNgay AND @DenNgay
    GROUP BY sp.MaSP, sp.TenSP
    ORDER BY TongSoLuong DESC;
END
GO

/* =====================================================================
   DỮ LIỆU MẪU
   ===================================================================== */
INSERT INTO tblLoaiSP (TenLoai, MoTa) VALUES
(N'Vi điều khiển & Board',        N'Arduino, ESP32, ESP8266, STM32, Raspberry Pi'),
(N'Cảm biến',                     N'Cảm biến khoảng cách, nhiệt độ, độ ẩm, gia tốc, dò line'),
(N'Module chức năng',             N'Bluetooth, RF, Relay và các module mở rộng'),
(N'Động cơ & Driver',             N'Động cơ DC, servo, bước và mạch điều khiển'),
(N'Linh kiện cơ bản',             N'Điện trở, tụ điện, IC thông dụng'),
(N'Nguồn & Pin',                  N'Pin Li-ion, module hạ áp, nguồn adapter'),
(N'Màn hình & Hiển thị',          N'LCD, OLED, LED 7 đoạn'),
(N'Dụng cụ & Phụ kiện',           N'Breadboard, dây cắm, mỏ hàn');
GO

INSERT INTO tblHangSX (TenHang, QuocGia) VALUES
(N'Arduino',            N'Ý'),
(N'Espressif',          N'Trung Quốc'),
(N'Raspberry Pi',       N'Anh'),
(N'STMicroelectronics', N'Thụy Sĩ'),
(N'Texas Instruments',  N'Mỹ'),
(N'DFRobot',            N'Trung Quốc'),
(N'Bosch Sensortec',    N'Đức'),
(N'OEM',                N'Trung Quốc'),
(N'Samsung',            N'Hàn Quốc');
GO

INSERT INTO tblSanPham (TenSP, MaLoai, MaHang, DonGia, SoLuongTon, HinhAnh, ThongSo, MoTa) VALUES
(N'Arduino Uno R3 chính hãng',              1, 1,  650000,  25, 'sp01.png', N'ATmega328P, 16MHz, 14 Digital I/O, 6 Analog, USB-B',          N'Board Arduino Uno R3 chính hãng sản xuất tại Ý, phù hợp cho người mới học lập trình vi điều khiển.'),
(N'Arduino Nano V3 CH340',                  1, 8,   95000,  60, 'sp02.png', N'ATmega328P, 16MHz, cổng Mini USB, chip nạp CH340',            N'Phiên bản nhỏ gọn của Arduino Uno, dễ cắm trực tiếp lên breadboard.'),
(N'ESP32 DevKit V1 WiFi + Bluetooth',       1, 2,  135000,  40, 'sp03.png', N'ESP32-WROOM-32, 240MHz dual-core, WiFi 2.4GHz, BLE 4.2',      N'Kit phát triển ESP32 dùng cho các dự án IoT, hỗ trợ lập trình bằng Arduino IDE và MicroPython.'),
(N'ESP8266 NodeMCU CP2102',                 1, 2,   85000,  35, 'sp04.png', N'ESP-12E, 80MHz, WiFi 802.11 b/g/n, 11 GPIO',                  N'Board WiFi giá rẻ, kết nối Internet cho các dự án nhà thông minh.'),
(N'Raspberry Pi 4 Model B 4GB',             1, 3, 1850000,   8, 'sp05.png', N'Cortex-A72 1.5GHz, RAM 4GB, 2 cổng micro-HDMI, USB 3.0',      N'Máy tính nhúng mạnh mẽ, chạy hệ điều hành Linux, phù hợp cho AI và xử lý ảnh.'),
(N'STM32F103C8T6 Blue Pill',                1, 4,   75000,  30, 'sp06.png', N'ARM Cortex-M3 72MHz, Flash 64KB, SRAM 20KB',                N'Board vi điều khiển 32-bit giá rẻ, hiệu năng cao hơn Arduino.'),
(N'Cảm biến siêu âm HC-SR04',               2, 8,   25000, 120, 'sp07.png', N'Khoảng đo 2cm - 400cm, điện áp 5V, góc quét 15°',             N'Cảm biến đo khoảng cách bằng sóng siêu âm, dùng nhiều trong robot tránh vật cản.'),
(N'Cảm biến nhiệt độ, độ ẩm DHT22',         2, 8,   85000,  45, 'sp08.png', N'Nhiệt độ -40 ~ 80°C (±0.5°C), độ ẩm 0 - 100% (±2%)',          N'Cảm biến nhiệt độ, độ ẩm độ chính xác cao, giao tiếp 1 dây.'),
(N'Cảm biến áp suất BMP280',                2, 7,   45000,  50, 'sp09.png', N'Áp suất 300 - 1100 hPa, giao tiếp I2C/SPI, 3.3V',              N'Cảm biến áp suất khí quyển và nhiệt độ của Bosch, dùng đo độ cao.'),
(N'Cảm biến dò line TCRT5000 5 kênh',       2, 8,   65000,  40, 'sp10.png', N'5 mắt hồng ngoại, ngõ ra Digital/Analog, 5V',                  N'Module dò đường cho robot chạy theo vạch đen, thường dùng trong các cuộc thi robot.'),
(N'Cảm biến gia tốc, con quay MPU6050',     2, 8,   55000,  55, 'sp11.png', N'Gia tốc 3 trục + con quay 3 trục, giao tiếp I2C',             N'Cảm biến chuyển động 6 bậc tự do dùng cho cân bằng robot và drone.'),
(N'Module Bluetooth HC-05',                 3, 8,   95000,  30, 'sp12.png', N'Bluetooth 2.0, giao tiếp UART, chế độ Master/Slave',          N'Module Bluetooth giúp điều khiển thiết bị từ điện thoại.'),
(N'Module thu phát RF NRF24L01+',           3, 8,   35000,  70, 'sp13.png', N'Tần số 2.4GHz, tốc độ tối đa 2Mbps, giao tiếp SPI',           N'Module truyền nhận không dây khoảng cách ngắn, công suất thấp.'),
(N'Module Relay 2 kênh 5V',                 3, 8,   30000,  65, 'sp14.png', N'2 relay 10A/250VAC, cách ly quang, kích mức thấp',             N'Module đóng ngắt thiết bị điện xoay chiều bằng vi điều khiển.'),
(N'Mạch điều khiển động cơ L298N',          4, 8,   45000,  80, 'sp15.png', N'Điều khiển 2 động cơ DC, dòng tối đa 2A/kênh, 5 - 35V',        N'Driver cầu H kép, dùng điều khiển động cơ cho xe robot.'),
(N'Động cơ servo SG90',                     4, 8,   28000, 150, 'sp16.png', N'Góc quay 180°, mô-men 1.8kg.cm, điện áp 4.8 - 6V',            N'Servo mini dùng cho cánh tay robot và các cơ cấu chuyển động nhỏ.'),
(N'Động cơ giảm tốc vàng TT 1:48',          4, 8,   18000, 200, 'sp17.png', N'Điện áp 3 - 6V, tỉ số truyền 1:48, trục đôi',                 N'Động cơ giảm tốc phổ biến cho xe robot 2 bánh và 4 bánh.'),
(N'Động cơ bước NEMA17 kèm driver A4988',   4, 8,  220000,   6, 'sp18.png', N'1.8°/bước, mô-men 4.2kg.cm, driver vi bước 1/16',            N'Bộ động cơ bước dùng cho máy in 3D và máy CNC mini.'),
(N'Bộ điện trở 1/4W 30 giá trị (600 con)',  5, 8,   55000,  40, 'sp19.png', N'Sai số 1%, từ 10Ω đến 1MΩ, mỗi giá trị 20 con',               N'Bộ điện trở thông dụng cho phòng thí nghiệm và học tập.'),
(N'IC ổn áp LM7805',                        5, 5,    5000, 300, 'sp20.png', N'Ngõ ra 5V, dòng 1.5A, vỏ TO-220',                             N'IC ổn áp tuyến tính 5V dùng trong các mạch nguồn.'),
(N'IC định thời NE555',                     5, 5,    4000, 350, 'sp21.png', N'Điện áp 4.5 - 16V, vỏ DIP-8',                                 N'IC tạo xung kinh điển, dùng trong mạch nháy LED, tạo dao động.'),
(N'Pin Li-ion 18650 Samsung 2600mAh',       6, 9,   75000,  90, 'sp22.png', N'3.7V, 2600mAh, dòng xả 5A',                                   N'Pin sạc dung lượng cao dùng cho robot và thiết bị di động.'),
(N'Module hạ áp LM2596',                    6, 5,   25000, 110, 'sp23.png', N'Vào 4 - 40V, ra 1.25 - 37V, dòng 3A',                         N'Mạch giảm áp DC-DC hiệu suất cao, điều chỉnh điện áp bằng biến trở.'),
(N'Màn hình OLED 0.96 inch I2C',            7, 8,   65000,  45, 'sp24.png', N'Độ phân giải 128x64, chip SSD1306, giao tiếp I2C',            N'Màn hình OLED nhỏ gọn, hiển thị sắc nét, tiêu thụ ít điện.'),
(N'Màn hình LCD 1602 kèm module I2C',       7, 8,   55000,   9, 'sp25.png', N'16 ký tự x 2 dòng, đèn nền xanh, giao tiếp I2C',              N'Màn hình ký tự phổ biến dùng hiển thị thông số cảm biến.'),
(N'Breadboard 830 lỗ',                      8, 8,   25000, 100, 'sp26.png', N'Kích thước 16.5 x 5.5cm, 830 lỗ cắm',                         N'Bo mạch thử nghiệm không cần hàn, dùng lắp mạch nhanh.'),
(N'Bộ dây cắm đực - đực 40 sợi 20cm',       8, 8,   15000, 180, 'sp27.png', N'40 sợi nhiều màu, dài 20cm',                                  N'Dây cắm dùng kết nối linh kiện trên breadboard.'),
(N'Mỏ hàn điều chỉnh nhiệt 60W',            8, 8,  180000,   4, 'sp28.png', N'Công suất 60W, nhiệt độ 200 - 450°C, điện 220V',             N'Mỏ hàn chỉnh nhiệt dùng hàn linh kiện điện tử.');
GO

/* Tài khoản mẫu: admin / admin123 ; khachhang1, khachhang2 / 123456 */
INSERT INTO tblUser (Username, Password, HoTen, Email, DienThoai, DiaChi, Role, NgayTao) VALUES
('admin',      CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'admin123'), 2), N'Quản trị viên',   'admin@linhkien.vn',       '0909000001', N'Vĩnh Long',                 'Admin',     '2026-08-01'),
('khachhang1', CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', '123456'),   2), N'Nguyễn Văn An',   'nguyenvanan@gmail.com',   '0912345678', N'12 Nguyễn Huệ, TP. Vĩnh Long', 'KhachHang', '2026-08-05'),
('khachhang2', CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', '123456'),   2), N'Trần Thị Bình',   'tranthibinh@gmail.com',   '0987654321', N'45 Điện Biên Phủ, TP. Trà Vinh', 'KhachHang', '2026-08-10');
GO

INSERT INTO tblDonHang (Username, NgayDat, HoTenNhan, DienThoaiNhan, DiaChiGiao, TongTien, TrangThai, GhiChu) VALUES
('khachhang1', '2026-08-12 09:15', N'Nguyễn Văn An', '0912345678', N'12 Nguyễn Huệ, TP. Vĩnh Long',    0, N'Hoàn thành', NULL),
('khachhang2', '2026-08-20 14:30', N'Trần Thị Bình', '0987654321', N'45 Điện Biên Phủ, TP. Trà Vinh', 0, N'Hoàn thành', N'Giao giờ hành chính'),
('khachhang1', '2026-09-03 10:05', N'Nguyễn Văn An', '0912345678', N'12 Nguyễn Huệ, TP. Vĩnh Long',    0, N'Hoàn thành', NULL),
('khachhang2', '2026-09-18 16:45', N'Trần Thị Bình', '0987654321', N'45 Điện Biên Phủ, TP. Trà Vinh', 0, N'Hoàn thành', NULL),
('khachhang1', '2026-10-02 08:20', N'Nguyễn Văn An', '0912345678', N'12 Nguyễn Huệ, TP. Vĩnh Long',    0, N'Hoàn thành', N'Gọi trước khi giao'),
('khachhang2', '2026-10-25 19:10', N'Trần Thị Bình', '0987654321', N'45 Điện Biên Phủ, TP. Trà Vinh', 0, N'Đã hủy',     N'Khách đổi ý'),
('khachhang1', '2026-11-01 11:40', N'Nguyễn Văn An', '0912345678', N'12 Nguyễn Huệ, TP. Vĩnh Long',    0, N'Đang giao',  NULL),
('khachhang2', '2026-11-03 15:00', N'Trần Thị Bình', '0987654321', N'45 Điện Biên Phủ, TP. Trà Vinh', 0, N'Chờ xử lý',  NULL);
GO

INSERT INTO tblChiTietDH (MaDH, MaSP, SoLuong, DonGia) VALUES
(1, 1, 1, 650000), (1, 7, 2, 25000), (1, 26, 1, 25000),
(2, 3, 2, 135000), (2, 8, 1, 85000),
(3, 15, 2, 45000), (3, 17, 4, 18000), (3, 10, 1, 65000),
(4, 5, 1, 1850000), (4, 22, 2, 75000),
(5, 3, 1, 135000), (5, 24, 1, 65000), (5, 27, 2, 15000),
(6, 18, 1, 220000),
(7, 2, 3, 95000), (7, 16, 4, 28000),
(8, 12, 1, 95000), (8, 13, 2, 35000);
GO

/* Cập nhật tổng tiền đơn hàng từ chi tiết */
UPDATE dh
SET    TongTien = t.Tong
FROM   tblDonHang dh
       JOIN (SELECT MaDH, SUM(SoLuong * DonGia) AS Tong
             FROM tblChiTietDH GROUP BY MaDH) t ON t.MaDH = dh.MaDH;
GO

/* Dữ liệu cấu hình website */
INSERT INTO tblCauHinh (MaCH, Nhom, TenCH, GiaTri, KieuNhap, GhiChu, ThuTu)
SELECT v.MaCH, v.Nhom, v.TenCH, v.GiaTri, v.KieuNhap, v.GhiChu, v.ThuTu
FROM (VALUES
('TenCuaHang1', N'Cửa hàng', N'Tên cửa hàng (phần 1)', N'LINH KIỆN', 'text', N'Hiển thị ở logo, chữ trắng', 1),
('TenCuaHang2', N'Cửa hàng', N'Tên cửa hàng (phần 2)', N'TVU', 'text', N'Hiển thị ở logo, chữ màu cam', 2),
('Slogan', N'Cửa hàng', N'Khẩu hiệu dưới logo', N'ĐIỆN TỬ - ROBOTICS - IOT', 'text', N'', 3),
('ThongBaoDauTrang', N'Cửa hàng', N'Dòng thông báo trên cùng', N'Giao hàng toàn quốc', 'text', N'Hiện cạnh Hotline ở thanh trên cùng', 4),
('Hotline', N'Cửa hàng', N'Hotline', N'0909 000 001', 'text', N'', 5),
('Email', N'Cửa hàng', N'Email liên hệ', N'lienhe@linhkientvu.vn', 'text', N'', 6),
('DiaChi', N'Cửa hàng', N'Địa chỉ', N'126 Nguyễn Thiện Thành, Vĩnh Long', 'text', N'', 7),
('GioLamViec', N'Cửa hàng', N'Giờ làm việc', N'Thứ 2 – Thứ 7: 7h30 – 17h00, Chủ Nhật nghỉ', 'text', N'', 8),
('GioiThieuNgan', N'Cửa hàng', N'Giới thiệu ngắn (chân trang)', N'Cung cấp vi điều khiển, cảm biến, động cơ, module và dụng cụ cho học tập, nghiên cứu và thi đấu Robotics của học sinh, sinh viên.', 'multi', N'', 9),
('BanQuyen', N'Cửa hàng', N'Dòng bản quyền (chân trang)', N'© 2026 Linh Kiện TVU – Đồ án Chuyên đề ASP.NET, Trường Kỹ thuật và Công nghệ, Đại học Trà Vinh', 'text', N'', 10),
('Facebook', N'Mạng xã hội', N'Đường dẫn Facebook', N'#', 'text', N'Dán đường dẫn đầy đủ, ví dụ https://facebook.com/...', 11),
('Zalo', N'Mạng xã hội', N'Đường dẫn Zalo', N'#', 'text', N'Ví dụ https://zalo.me/0909000001', 12),
('YouTube', N'Mạng xã hội', N'Đường dẫn YouTube', N'#', 'text', N'', 13),
('BannerTieuDe', N'Trang chủ', N'Tiêu đề banner', N'Linh kiện điện tử cho Robotics & IoT', 'text', N'', 14),
('BannerMoTa', N'Trang chủ', N'Mô tả banner', N'Arduino, ESP32, Raspberry Pi, cảm biến, động cơ, module... giá tốt cho học sinh, sinh viên.', 'text', N'', 15),
('CK_LuuY', N'Thanh toán', N'Lưu ý khi chuyển khoản', N'Xin Quý Khách chờ bộ phận Bán Hàng **xác nhận và kiểm tra tình trạng đơn hàng trước khi chuyển khoản**.', 'multi', N'Hiện sau chữ "Quan trọng!!!"', 16),
('CK_ChuTaiKhoan', N'Thanh toán', N'Tên chủ tài khoản', N'CÔNG TY TNHH LINH KIỆN TVU', 'text', N'', 17),
('CK_SoTaiKhoan', N'Thanh toán', N'Số tài khoản', N'0123456789', 'text', N'', 18),
('CK_NganHang', N'Thanh toán', N'Ngân hàng', N'TMCP Ngoại thương Việt Nam (Vietcombank) - CN Vĩnh Long', 'text', N'', 19),
('COD_MoTa', N'Thanh toán', N'Mô tả thanh toán khi nhận hàng (COD)', N'Quý khách thanh toán tiền mặt cho nhân viên giao hàng khi nhận hàng.', 'multi', N'', 20),
('VC_TenGoi', N'Giao hàng', N'Tên gói vận chuyển', N'Giao hàng tiêu chuẩn (2 – 4 ngày)', 'text', N'Phí vận chuyển luôn là Miễn phí', 21),
('GH_ThoiGianGui', N'Giao hàng', N'Thời gian gửi hàng đi (trang Giỏ hàng)', N'Quý khách xin lưu ý các **đơn hàng đặt sau 15h00, Linh Kiện TVU sẽ gửi hàng vào ngày hôm sau**, cửa hàng nghỉ vào ngày Chủ Nhật. Các yêu cầu giao hàng đặc biệt xin Quý khách liên hệ Hotline 0909 000 001.', 'multi', N'', 22),
('GH_ChinhSach', N'Giao hàng', N'Chính sách giao hàng (trang Giỏ hàng)', N'Miễn phí giao hàng toàn quốc, thời gian nhận hàng từ 2 – 4 ngày.', 'multi', N'', 23),
('GT_MoTaBanner', N'Giới thiệu', N'Mô tả banner trang Giới thiệu', N'Cửa hàng linh kiện điện tử dành cho Robotics, IoT và các dự án STEM của học sinh, sinh viên.', 'text', N'', 24),
('GT_VeChungToi', N'Giới thiệu', N'Về chúng tôi', N'**Linh Kiện TVU** chuyên cung cấp vi điều khiển, cảm biến, động cơ, module chức năng và dụng cụ phục vụ học tập, nghiên cứu và thi đấu Robotics. Sản phẩm được chọn lọc phù hợp với chương trình STEM ở trường phổ thông và các học phần kỹ thuật ở đại học.
Website được xây dựng bằng **ASP.NET Web Forms** và **SQL Server**, cho phép khách hàng tra cứu, đặt hàng trực tuyến và theo dõi đơn hàng mọi lúc.', 'multi', N'Mỗi dòng là một đoạn văn', 25),
('GT_CamKet', N'Giới thiệu', N'Cam kết', N'Sản phẩm chính hãng, kiểm tra trước khi giao.
Giá ưu đãi cho học sinh, sinh viên và câu lạc bộ.
Hỗ trợ kỹ thuật, tư vấn chọn linh kiện cho dự án.
Đổi trả trong 7 ngày nếu lỗi do nhà sản xuất.', 'multi', N'', 26),
('DT_MoTaBanner', N'Đối tác', N'Mô tả banner trang Đối tác', N'Linh Kiện TVU phân phối sản phẩm chính hãng từ các nhà sản xuất uy tín trong và ngoài nước.', 'text', N'', 27),
('DT_MoiHopTac', N'Đối tác', N'Lời mời hợp tác', N'Chúng tôi luôn chào đón các nhà sản xuất, nhà phân phối linh kiện điện tử, các câu lạc bộ Robotics và trung tâm STEM hợp tác cung cấp sản phẩm cho học sinh, sinh viên.
Liên hệ: **hoptac@linhkientvu.vn** – Hotline: **0909 000 001**', 'multi', N'Mỗi dòng là một đoạn văn', 28),
('CS_HuongDan', N'Chính sách', N'Hướng dẫn mua hàng', N'Rà chuột vào sản phẩm, bấm biểu tượng giỏ hàng hoặc vào trang chi tiết để chọn số lượng.
Vào **Giỏ hàng**, điều chỉnh số lượng rồi bấm **Thanh toán** (cần đăng nhập).
Nhập thông tin nhận hàng, chọn hình thức thanh toán và bấm **THANH TOÁN**.
Theo dõi trạng thái đơn tại mục **Tra cứu đơn hàng**.', 'multi', N'', 29),
('CS_GiaoDich', N'Chính sách', N'Điều kiện giao dịch chung', N'Giá niêm yết trên website là giá bán lẻ, đã bao gồm thuế.
Đơn hàng được xác nhận khi cửa hàng kiểm tra đủ tồn kho và thông tin nhận hàng.
Khách hàng có thể hủy đơn khi đơn còn ở trạng thái Chờ xử lý.', 'multi', N'', 30),
('CS_BaoMat', N'Chính sách', N'Chính sách bảo mật thông tin', N'Thông tin cá nhân chỉ dùng để xử lý và giao đơn hàng, không chia sẻ cho bên thứ ba.
Mật khẩu tài khoản được mã hóa (SHA-256) trước khi lưu vào cơ sở dữ liệu.', 'multi', N'', 31),
('CS_ThanhToan', N'Chính sách', N'Chính sách thanh toán', N'**Chuyển khoản ngân hàng:** thông tin tài khoản hiển thị khi chọn hình thức chuyển khoản; ghi đúng nội dung chuyển khoản.
**Thanh toán khi nhận hàng (COD):** trả tiền mặt cho nhân viên giao hàng.', 'multi', N'', 32),
('CS_DoiTra', N'Chính sách', N'Chính sách giao nhận, đổi trả và hoàn tiền', N'Miễn phí giao hàng toàn quốc, thời gian 2 – 4 ngày; đơn đặt sau 15h00 gửi vào ngày hôm sau.
Đổi trả trong 7 ngày nếu sản phẩm lỗi do nhà sản xuất, còn nguyên bao bì.
Hoàn tiền qua chuyển khoản trong 3 ngày làm việc sau khi nhận lại hàng.', 'multi', N'', 33),
('Zalo_HienThi', N'Mạng xã hội', N'Tên/số Zalo hiển thị', N'0909 000 001', 'text', N'Hiện ở trang Liên hệ', 14),
('Facebook_HienThi', N'Mạng xã hội', N'Tên trang Facebook hiển thị', N'Linh Kiện TVU', 'text', N'Hiện ở trang Liên hệ', 15),
('LH_LuuY', N'Liên hệ', N'Lưu ý cuối khung liên hệ', N'Quý khách vui lòng ưu tiên nhắn tin qua **Zalo** để cửa hàng có thời gian kiểm tra thông tin kỹ thuật và hỗ trợ tốt nhất!', 'multi', N'', 40),
('LH_BanDo', N'Liên hệ', N'Từ khóa vị trí trên bản đồ', N'Trường Đại học Trà Vinh', 'text', N'Tên hoặc địa chỉ tìm trên Google Maps; để trống thì dùng Địa chỉ cửa hàng. Bản đồ chỉ hiện khi máy có Internet', 41),
('GioMoCua', N'Cửa hàng', N'Giờ mở cửa (HH:mm)', N'07:30', 'text', N'Dùng để tính trạng thái Đang mở cửa / Đã đóng cửa', 50),
('GioDongCua', N'Cửa hàng', N'Giờ đóng cửa (HH:mm)', N'17:00', 'text', N'', 51),
('NgayLamViec', N'Cửa hàng', N'Các ngày làm việc trong tuần', N'2,3,4,5,6,7', 'text', N'Thứ 2 = 2, Thứ 3 = 3 ... Thứ 7 = 7, Chủ Nhật = 8; cách nhau bằng dấu phẩy', 52),
('Zalo_MoTa', N'Mạng xã hội', N'Lĩnh vực hiển thị trên thẻ Zalo', N'Linh kiện điện tử & Robotics', 'text', N'', 16),
('Zalo_QR', N'Mạng xã hội', N'Ảnh mã QR Zalo', N'', 'text', N'Chép ảnh vào thư mục Images rồi nhập đường dẫn, ví dụ ~/Images/zalo-qr.png. Để trống thì hiện khung chờ', 17)
) AS v (MaCH, Nhom, TenCH, GiaTri, KieuNhap, GhiChu, ThuTu)
WHERE NOT EXISTS (SELECT 1 FROM tblCauHinh c WHERE c.MaCH = v.MaCH);
GO

SELECT N'Tạo CSDL QLLinhKien thành công!' AS KetQua;
GO
