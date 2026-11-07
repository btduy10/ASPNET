using System;
using System.Web.UI;

public partial class Admin_Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Dùng ExecuteScalar để lấy các con số tổng hợp (Chương 5 - Bài 2 - 4.2)
            lblSoSP.Text = KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblSanPham WHERE TrangThai = 1").ToString();
            lblDonCho.Text = KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblDonHang WHERE TrangThai = N'Chờ xử lý'").ToString();
            lblSoKH.Text = KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblUser WHERE Role = 'KhachHang'").ToString();
            lblDoanhThu.Text = TienIch.Tien(KetNoi.LayGiaTri(
                @"SELECT SUM(TongTien) FROM tblDonHang
                  WHERE TrangThai = N'Hoàn thành'
                    AND MONTH(NgayDat) = MONTH(GETDATE()) AND YEAR(NgayDat) = YEAR(GETDATE())"));

            gvDonMoi.DataSource = KetNoi.LayDuLieu(
                "SELECT TOP 6 MaDH, HoTenNhan, NgayDat, TongTien, TrangThai FROM tblDonHang ORDER BY NgayDat DESC");
            gvDonMoi.DataBind();

            gvSapHet.DataSource = KetNoi.LayDuLieu(
                "SELECT MaSP, TenSP, SoLuongTon FROM tblSanPham WHERE SoLuongTon < 10 AND TrangThai = 1 ORDER BY SoLuongTon");
            gvSapHet.DataBind();
        }
    }
}
