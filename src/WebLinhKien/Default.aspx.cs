using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadSanPhamMoi();
            LoadSanPhamBanChay();
        }
    }

    // 8 sản phẩm được cập nhật gần nhất
    private void LoadSanPhamMoi()
    {
        string sql = @"SELECT TOP 8 MaSP, TenSP, DonGia, SoLuongTon, HinhAnh
                       FROM tblSanPham
                       WHERE TrangThai = 1
                       ORDER BY NgayCapNhat DESC, MaSP DESC";
        dlSanPhamMoi.DataSource = KetNoi.LayDuLieu(sql);
        dlSanPhamMoi.DataBind();
    }

    // 4 sản phẩm có tổng số lượng bán (đơn Hoàn thành) cao nhất
    private void LoadSanPhamBanChay()
    {
        string sql = @"SELECT TOP 4 s.MaSP, s.TenSP, s.DonGia, s.HinhAnh, SUM(ct.SoLuong) AS DaBan
                       FROM tblSanPham s
                       JOIN tblChiTietDH ct ON ct.MaSP = s.MaSP
                       JOIN tblDonHang dh ON dh.MaDH = ct.MaDH AND dh.TrangThai = N'Hoàn thành'
                       WHERE s.TrangThai = 1
                       GROUP BY s.MaSP, s.TenSP, s.DonGia, s.HinhAnh
                       ORDER BY DaBan DESC";
        dlBanChay.DataSource = KetNoi.LayDuLieu(sql);
        dlBanChay.DataBind();
    }

    // Bấm biểu tượng giỏ hàng trên thẻ sản phẩm (sự kiện ItemCommand của DataList)
    protected void dsSanPham_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "ThemGio")
        {
            Master.ThemNhanhVaoGio(int.Parse(e.CommandArgument.ToString()));
        }
    }
}
