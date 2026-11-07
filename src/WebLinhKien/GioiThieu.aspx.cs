using System;
using System.Web.UI;

public partial class GioiThieu : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Mỗi con số là một câu lệnh ExecuteScalar thông qua lớp KetNoi
            lblSoSP.Text = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblSanPham WHERE TrangThai = 1")).ToString();
            lblSoLoai.Text = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblLoaiSP")).ToString();
            lblSoHang.Text = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblHangSX")).ToString();
            lblSoDon.Text = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblDonHang WHERE TrangThai = N'Hoàn thành'")).ToString();
        }
    }
}
