using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class DangNhap : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Đọc Cookie để điền sẵn tên đăng nhập (Chương 7 - 1.2 Cookies)
            HttpCookie cookie = Request.Cookies["TenDangNhap"];
            if (cookie != null)
            {
                txtUsername.Text = cookie.Value;
                chkGhiNho.Checked = true;
            }
        }
    }

    protected void btnDangNhap_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string sql = @"SELECT Username, HoTen, Role, TrangThai FROM tblUser
                       WHERE Username = @Username AND Password = @Password";
        DataTable dt = KetNoi.LayDuLieu(sql,
            new SqlParameter("@Username", txtUsername.Text.Trim()),
            new SqlParameter("@Password", BaoMat.MaHoaSHA256(txtPassword.Text)));

        if (dt.Rows.Count == 0)
        {
            HienLoi("Tên đăng nhập hoặc mật khẩu không đúng.");
            return;
        }
        DataRow user = dt.Rows[0];
        if (!(bool)user["TrangThai"])
        {
            HienLoi("Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.");
            return;
        }

        // Lưu thông tin đăng nhập vào Session (Chương 7 - 1.3 Sessions)
        Session["Username"] = user["Username"].ToString();
        Session["HoTen"] = user["HoTen"].ToString();
        Session["Role"] = user["Role"].ToString();

        // Ghi nhớ tên đăng nhập bằng Cookie trong 7 ngày
        if (chkGhiNho.Checked)
        {
            HttpCookie cookie = new HttpCookie("TenDangNhap", user["Username"].ToString());
            cookie.Expires = DateTime.Now.AddDays(7);
            Response.Cookies.Add(cookie);
        }
        else
        {
            Response.Cookies["TenDangNhap"].Expires = DateTime.Now.AddDays(-1);
        }

        // Chuyển trang: ưu tiên ReturnUrl (chỉ chấp nhận đường dẫn nội bộ)
        string returnUrl = Request.QueryString["ReturnUrl"];
        if (!string.IsNullOrEmpty(returnUrl) && !returnUrl.Contains("://") && !returnUrl.StartsWith("//"))
            Response.Redirect(returnUrl);
        else if (Session["Role"].ToString() == "Admin")
            Response.Redirect("~/Admin/Default.aspx");
        else
            Response.Redirect("~/Default.aspx");
    }

    private void HienLoi(string noiDung)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
    }
}
