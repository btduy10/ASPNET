using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class DatHang : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.HienCotTrai = false;   // trang thanh toán dùng toàn bộ chiều ngang

        // Bắt buộc đăng nhập trước khi đặt hàng
        if (Session["Username"] == null)
        {
            Response.Redirect("DangNhap.aspx?ReturnUrl=DatHang.aspx");
            return;
        }
        if (!IsPostBack)
        {
            if (GioHang.LayGioHang().Rows.Count == 0)
            {
                Response.Redirect("GioHang.aspx");
                return;
            }
            // Điền sẵn thông tin người nhận từ tài khoản
            DataTable dt = KetNoi.LayDuLieu(
                "SELECT HoTen, Email, DienThoai, DiaChi FROM tblUser WHERE Username = @Username",
                new SqlParameter("@Username", Session["Username"].ToString()));
            if (dt.Rows.Count > 0)
            {
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtHoTen.Text = dt.Rows[0]["HoTen"].ToString();
                txtDienThoai.Text = dt.Rows[0]["DienThoai"].ToString();
                txtDiaChi.Text = dt.Rows[0]["DiaChi"].ToString();
            }
            HienThiDonHang();
        }
    }

    private void HienThiDonHang()
    {
        rptDonHang.DataSource = GioHang.LayGioHang();
        rptDonHang.DataBind();
        lblSoSP.Text = GioHang.TongSoLuong().ToString();
        lblTamTinh.Text = TienIch.Tien(GioHang.TongTien());
        lblTongTien.Text = lblTamTinh.Text;   // miễn phí vận chuyển
    }

    // Chọn hình thức thanh toán: hiện thông tin tài khoản (Chuyển khoản) hoặc mô tả COD
    protected void rblHinhThuc_SelectedIndexChanged(object sender, EventArgs e)
    {
        bool chuyenKhoan = rblHinhThuc.SelectedValue == "Chuyển khoản";
        pnlThongTinCK.Visible = chuyenKhoan;
        pnlThongTinCOD.Visible = !chuyenKhoan;
    }

    // Lưu đơn hàng: dùng SqlTransaction để bảo đảm tính toàn vẹn.
    // Nếu một sản phẩm không đủ tồn kho thì hủy (Rollback) toàn bộ đơn hàng.
    protected void btnThanhToan_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        DataTable gio = GioHang.LayGioHang();
        if (gio.Rows.Count == 0) { Response.Redirect("GioHang.aspx"); return; }
        int maDH = 0;

        using (SqlConnection conn = new SqlConnection(KetNoi.ChuoiKetNoi))
        {
            conn.Open();
            SqlTransaction tran = conn.BeginTransaction();
            try
            {
                // 1. Thêm đơn hàng, lấy mã đơn vừa tạo bằng SCOPE_IDENTITY()
                SqlCommand cmdDH = new SqlCommand(
                    @"INSERT INTO tblDonHang (Username, HoTenNhan, DienThoaiNhan, EmailNhan, DiaChiGiao, TongTien, GhiChu, HinhThucTT)
                      VALUES (@Username, @HoTen, @DienThoai, @Email, @DiaChi, @TongTien, @GhiChu, @HinhThucTT);
                      SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, tran);
                cmdDH.Parameters.AddWithValue("@Username", Session["Username"].ToString());
                cmdDH.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
                cmdDH.Parameters.AddWithValue("@DienThoai", txtDienThoai.Text.Trim());
                cmdDH.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                cmdDH.Parameters.AddWithValue("@TongTien", GioHang.TongTien());
                cmdDH.Parameters.AddWithValue("@GhiChu", txtGhiChu.Text.Trim());
                cmdDH.Parameters.AddWithValue("@HinhThucTT", rblHinhThuc.SelectedValue);
                cmdDH.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                maDH = (int)cmdDH.ExecuteScalar();

                foreach (DataRow dong in gio.Rows)
                {
                    // 2. Trừ tồn kho (chỉ trừ được khi còn đủ hàng)
                    SqlCommand cmdKho = new SqlCommand(
                        @"UPDATE tblSanPham SET SoLuongTon = SoLuongTon - @SoLuong
                          WHERE MaSP = @MaSP AND SoLuongTon >= @SoLuong AND TrangThai = 1", conn, tran);
                    cmdKho.Parameters.AddWithValue("@SoLuong", dong["SoLuong"]);
                    cmdKho.Parameters.AddWithValue("@MaSP", dong["MaSP"]);
                    if (cmdKho.ExecuteNonQuery() == 0)
                        throw new Exception("Sản phẩm \"" + dong["TenSP"] + "\" không đủ số lượng tồn kho.");

                    // 3. Thêm chi tiết đơn hàng
                    SqlCommand cmdCT = new SqlCommand(
                        @"INSERT INTO tblChiTietDH (MaDH, MaSP, SoLuong, DonGia)
                          VALUES (@MaDH, @MaSP, @SoLuong, @DonGia)", conn, tran);
                    cmdCT.Parameters.AddWithValue("@MaDH", maDH);
                    cmdCT.Parameters.AddWithValue("@MaSP", dong["MaSP"]);
                    cmdCT.Parameters.AddWithValue("@SoLuong", dong["SoLuong"]);
                    cmdCT.Parameters.AddWithValue("@DonGia", dong["DonGia"]);
                    cmdCT.ExecuteNonQuery();
                }

                tran.Commit();
                GioHang.XoaHet();
            }
            catch (Exception ex)
            {
                tran.Rollback();
                HienThongBao("Thanh toán không thành công: " + ex.Message, false);
                return;
            }
        }
        // Chuyển sang trang xác nhận: hiển thị thông tin nhận hàng + thông tin chuyển khoản.
        // (Redirect đặt ngoài try/catch để không bị bắt nhầm ThreadAbortException)
        Response.Redirect("XacNhanDonHang.aspx?madh=" + maDH);
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
