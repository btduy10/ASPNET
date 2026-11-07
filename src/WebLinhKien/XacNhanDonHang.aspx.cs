using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

// Trang xác nhận sau khi thanh toán: thông tin nhận hàng + thông tin chuyển khoản
public partial class XacNhanDonHang : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.HienCotTrai = false;
        if (Session["Username"] == null)
        {
            Response.Redirect("DangNhap.aspx");
            return;
        }
        if (!IsPostBack) HienThiDonHang();
    }

    private void HienThiDonHang()
    {
        int maDH;
        if (!int.TryParse(Request.QueryString["madh"], out maDH)) { KhongTimThay(); return; }

        // Chỉ cho xem đơn hàng của chính tài khoản đang đăng nhập
        DataTable dt = KetNoi.LayDuLieu(
            "SELECT * FROM tblDonHang WHERE MaDH = @MaDH AND Username = @Username",
            new SqlParameter("@MaDH", maDH), new SqlParameter("@Username", Session["Username"].ToString()));
        if (dt.Rows.Count == 0) { KhongTimThay(); return; }

        DataRow dh = dt.Rows[0];
        string maHienThi = "DH" + maDH.ToString("0000");
        string soTien = TienIch.Tien(dh["TongTien"]);

        lblMaDH.Text = maHienThi;
        lblNgayDat.Text = Convert.ToDateTime(dh["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
        lblTrangThai.Text = dh["TrangThai"].ToString();
        lblHoTen.Text = Server.HtmlEncode(dh["HoTenNhan"].ToString());
        lblDienThoai.Text = dh["DienThoaiNhan"].ToString();
        lblEmail.Text = dh["EmailNhan"] == DBNull.Value ? "(không có)" : Server.HtmlEncode(dh["EmailNhan"].ToString());
        lblDiaChi.Text = Server.HtmlEncode(dh["DiaChiGiao"].ToString());
        lblGhiChu.Text = dh["GhiChu"] == DBNull.Value || dh["GhiChu"].ToString() == "" ? "(không có)" : Server.HtmlEncode(dh["GhiChu"].ToString());
        lblHinhThuc.Text = TienIch.TenHinhThucTT(dh["HinhThucTT"]);
        lblTongTien.Text = soTien;

        bool chuyenKhoan = dh["HinhThucTT"].ToString() == "Chuyển khoản";
        pnlChuyenKhoan.Visible = chuyenKhoan;
        pnlCOD.Visible = !chuyenKhoan;
        if (chuyenKhoan)
        {
            // Thông tin tài khoản đọc từ bảng tblCauHinh (Admin > Cấu hình website)
            lblNganHang.Text = CauHinh.Html("CK_NganHang");
            litSoTK.Text = CauHinh.Html("CK_SoTaiKhoan");
            lblChuTK.Text = CauHinh.Html("CK_ChuTaiKhoan");
            litLuuYCK.Text = CauHinh.Html("CK_LuuY");
            lblSoTien.Text = soTien;
            litNoiDung.Text = maHienThi + " " + dh["DienThoaiNhan"];
        }
        else
        {
            lblSoTienCOD.Text = soTien;
            litMoTaCOD.Text = CauHinh.Html("COD_MoTa");
        }

        gvChiTiet.DataSource = KetNoi.LayDuLieu(
            @"SELECT s.TenSP, s.HinhAnh, ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien
              FROM tblChiTietDH ct JOIN tblSanPham s ON s.MaSP = ct.MaSP
              WHERE ct.MaDH = @MaDH",
            new SqlParameter("@MaDH", maDH));
        gvChiTiet.DataBind();
    }

    private void KhongTimThay()
    {
        pnlXacNhan.Visible = false;
        lblThongBao.Visible = true;
        lblThongBao.Text = "Không tìm thấy đơn hàng. <a href='DonHangCuaToi.aspx'>Xem danh sách đơn hàng của tôi »</a>";
    }
}
