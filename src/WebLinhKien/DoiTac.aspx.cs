using System;
using System.Data;
using System.Web.UI;

public partial class DoiTac : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDoiTac();
        }
    }

    // Lấy danh sách hãng sản xuất kèm số sản phẩm đang kinh doanh của từng hãng
    private void LoadDoiTac()
    {
        string sql = @"SELECT h.MaHang, h.TenHang, COALESCE(h.QuocGia, N'—') AS QuocGia, COUNT(s.MaSP) AS SoSP
                       FROM tblHangSX h
                       LEFT JOIN tblSanPham s ON s.MaHang = h.MaHang AND s.TrangThai = 1
                       GROUP BY h.MaHang, h.TenHang, h.QuocGia
                       ORDER BY SoSP DESC, h.TenHang";
        DataTable dt = KetNoi.LayDuLieu(sql);
        dlDoiTac.DataSource = dt;
        dlDoiTac.DataBind();
        lblSoHang.Text = dt.Rows.Count.ToString();
    }
}
