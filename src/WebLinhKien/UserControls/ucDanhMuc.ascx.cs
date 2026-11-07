using System;
using System.Data;
using System.Web.UI;

public partial class UserControls_ucDanhMuc : UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Loại sản phẩm kèm số lượng sản phẩm đang kinh doanh
            string sqlLoai = @"SELECT l.MaLoai, l.TenLoai, COUNT(s.MaSP) AS SoSP
                               FROM tblLoaiSP l
                               LEFT JOIN tblSanPham s ON s.MaLoai = l.MaLoai AND s.TrangThai = 1
                               GROUP BY l.MaLoai, l.TenLoai
                               ORDER BY l.MaLoai";
            rptLoai.DataSource = KetNoi.LayDuLieu(sqlLoai);
            rptLoai.DataBind();

            rptHang.DataSource = KetNoi.LayDuLieu("SELECT MaHang, TenHang FROM tblHangSX ORDER BY TenHang");
            rptHang.DataBind();
        }
    }
}
