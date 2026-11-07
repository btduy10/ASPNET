/* =====================================================================
   CẬP NHẬT CSDL: bổ sung cột cho bảng tblDonHang
   - HinhThucTT : hình thức thanh toán (COD / Chuyển khoản), đơn cũ mặc định COD
   - EmailNhan  : email nhận thông tin đơn hàng (khách nhập ở trang Thanh toán)
   Chạy được nhiều lần, không mất dữ liệu cũ.
   ===================================================================== */
USE QLLinhKien;
GO
IF COL_LENGTH('tblDonHang', 'HinhThucTT') IS NULL
BEGIN
    ALTER TABLE tblDonHang ADD HinhThucTT NVARCHAR(30) NOT NULL
        CONSTRAINT DF_tblDonHang_HinhThucTT DEFAULT N'COD'
        CONSTRAINT CK_tblDonHang_HinhThucTT CHECK (HinhThucTT IN (N'COD', N'Chuyển khoản'));
    PRINT N'Đã thêm cột HinhThucTT.';
END
GO
IF COL_LENGTH('tblDonHang', 'EmailNhan') IS NULL
BEGIN
    ALTER TABLE tblDonHang ADD EmailNhan VARCHAR(100) NULL;
    PRINT N'Đã thêm cột EmailNhan.';
END
GO
PRINT N'Cập nhật bảng tblDonHang thành công!';
GO
