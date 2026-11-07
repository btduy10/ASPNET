using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_QLNguoiDung : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadNguoiDung();
    }

    private void LoadNguoiDung()
    {
        string sql = @"SELECT u.Username, u.HoTen, u.Email, u.DienThoai, u.Role, u.TrangThai,
                              (SELECT COUNT(*) FROM tblDonHang d WHERE d.Username = u.Username) AS SoDon
                       FROM tblUser u WHERE 1 = 1";
        List<SqlParameter> thamSo = new List<SqlParameter>();
        if (txtTim.Text.Trim() != "")
        {
            sql += " AND (u.Username LIKE @TuKhoa OR u.HoTen LIKE @TuKhoa OR u.Email LIKE @TuKhoa)";
            thamSo.Add(new SqlParameter("@TuKhoa", "%" + txtTim.Text.Trim() + "%"));
        }
        if (ddlRole.SelectedValue != "")
        {
            sql += " AND u.Role = @Role";
            thamSo.Add(new SqlParameter("@Role", ddlRole.SelectedValue));
        }
        sql += " ORDER BY u.NgayTao DESC";
        gvUser.DataSource = KetNoi.LayDuLieu(sql, thamSo.ToArray());
        gvUser.DataBind();
    }

    // Xử lý các nút lệnh tự định nghĩa trong TemplateField (sự kiện RowCommand)
    protected void gvUser_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Page" || e.CommandName == "Delete") return;
        string username = e.CommandArgument.ToString();
        if (username == Session["Username"].ToString())
        {
            HienThongBao("Không thể thao tác trên tài khoản đang đăng nhập.", false);
            return;
        }

        SqlParameter p = new SqlParameter("@Username", username);
        switch (e.CommandName)
        {
            case "KhoaMo":
                KetNoi.ThucThi("UPDATE tblUser SET TrangThai = CASE WHEN TrangThai = 1 THEN 0 ELSE 1 END WHERE Username = @Username", p);
                HienThongBao("Đã đổi trạng thái tài khoản " + username + ".", true);
                break;
            case "DoiQuyen":
                KetNoi.ThucThi(@"UPDATE tblUser SET Role = CASE WHEN Role = 'Admin' THEN 'KhachHang' ELSE 'Admin' END
                                 WHERE Username = @Username", p);
                HienThongBao("Đã đổi vai trò tài khoản " + username + ".", true);
                break;
            case "DatLaiMK":
                KetNoi.ThucThi("UPDATE tblUser SET Password = @Password WHERE Username = @Username",
                    new SqlParameter("@Password", BaoMat.MaHoaSHA256("123456")), p);
                HienThongBao("Đã đặt lại mật khẩu của " + username + " thành 123456.", true);
                break;
        }
        LoadNguoiDung();
    }

    protected void gvUser_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string username = gvUser.DataKeys[e.RowIndex].Value.ToString();
        if (username == Session["Username"].ToString())
        {
            HienThongBao("Không thể xóa tài khoản đang đăng nhập.", false);
        }
        else
        {
            try
            {
                KetNoi.ThucThi("DELETE FROM tblUser WHERE Username = @Username", new SqlParameter("@Username", username));
                HienThongBao("Đã xóa tài khoản " + username + ".", true);
            }
            catch (SqlException ex)
            {
                HienThongBao(ex.Number == 547
                    ? "Không thể xóa: tài khoản đã có đơn hàng. Hãy dùng chức năng Khóa."
                    : "Lỗi: " + ex.Message, false);
            }
        }
        LoadNguoiDung();
    }

    protected void gvUser_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow) return;
        LinkButton lbtXoa = (LinkButton)e.Row.FindControl("lbtXoa");
        lbtXoa.OnClientClick = "return confirm('Bạn chắc chắn muốn xóa tài khoản này?');";
    }

    protected void btnLoc_Click(object sender, EventArgs e)
    {
        gvUser.PageIndex = 0;
        LoadNguoiDung();
    }

    protected void gvUser_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvUser.PageIndex = e.NewPageIndex;
        LoadNguoiDung();
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
