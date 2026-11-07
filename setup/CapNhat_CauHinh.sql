/* =====================================================================
   CẬP NHẬT CSDL: bảng tblCauHinh – lưu mọi thông tin hiển thị trên website
   (tên cửa hàng, liên hệ, tài khoản ngân hàng, banner, giới thiệu, chính sách...)
   Quản trị viên chỉnh sửa tại trang Admin > Cấu hình website.
   ===================================================================== */
USE QLLinhKien;
GO
IF OBJECT_ID('tblCauHinh', 'U') IS NULL
BEGIN
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
END
GO

-- Dữ liệu mặc định (chỉ thêm các mục chưa có)
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
PRINT N'Cập nhật bảng tblCauHinh thành công!';
GO
