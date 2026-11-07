using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DangKy : Page
{
    // CustomValidator kiểm tra trùng tên đăng nhập phía server (Chương 3 - Bài 3 - V)
    protected void cvUsername_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int dem = KetNoi.SoNguyen(KetNoi.LayGiaTri(
            "SELECT COUNT(*) FROM tblUser WHERE Username = @Username",
            new SqlParameter("@Username", args.Value.Trim())));
        args.IsValid = (dem == 0);
    }

    protected void cvEmail_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int dem = KetNoi.SoNguyen(KetNoi.LayGiaTri(
            "SELECT COUNT(*) FROM tblUser WHERE Email = @Email",
            new SqlParameter("@Email", args.Value.Trim())));
        args.IsValid = (dem == 0);
    }

    protected void btnDangKy_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string sql = @"INSERT INTO tblUser (Username, Password, HoTen, Email, DienThoai, DiaChi, Role)
                       VALUES (@Username, @Password, @HoTen, @Email, @DienThoai, @DiaChi, 'KhachHang')";
        try
        {
            int kq = KetNoi.ThucThi(sql,
                new SqlParameter("@Username", txtUsername.Text.Trim()),
                new SqlParameter("@Password", BaoMat.MaHoaSHA256(txtPassword.Text)),
                new SqlParameter("@HoTen", txtHoTen.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@DienThoai", txtDienThoai.Text.Trim()),
                new SqlParameter("@DiaChi", txtDiaChi.Text.Trim()));
            if (kq > 0)
            {
                HienThongBao("Đăng ký thành công! <a href='DangNhap.aspx'>Đăng nhập ngay »</a>", true);
                XoaForm();
            }
        }
        catch (SqlException ex)
        {
            HienThongBao("Lỗi khi đăng ký: " + ex.Message, false);
        }
    }

    protected void btnNhapLai_Click(object sender, EventArgs e)
    {
        XoaForm();
    }

    private void XoaForm()
    {
        txtUsername.Text = txtHoTen.Text = txtEmail.Text = txtDienThoai.Text = txtDiaChi.Text = "";
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
