-- =====================================================================
-- Cập nhật tên hình sản phẩm (ảnh linh kiện thật) cho CSDL QLLinhKien đã có sẵn.
-- Chỉ chạy file này khi CSDL được tạo từ phiên bản script cũ (hình sp02.png ... sp28.png).
-- Cài mới thì chỉ cần chạy QLLinhKien.sql.
-- =====================================================================
USE QLLinhKien;
GO
UPDATE tblSanPham
SET HinhAnh = REPLACE(HinhAnh, '.png', '.jpg')
WHERE MaSP BETWEEN 2 AND 28
  AND HinhAnh = 'sp' + RIGHT('0' + CAST(MaSP AS VARCHAR(2)), 2) + '.png';
GO
SELECT MaSP, TenSP, HinhAnh FROM tblSanPham ORDER BY MaSP;
PRINT N'Đã cập nhật hình sản phẩm.';
GO
