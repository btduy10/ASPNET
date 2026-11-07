using System;
using System.Web;
using System.Web.UI;

public partial class Admin_AdminMaster : MasterPage
{
    // Page_Init chạy trước Page_Load của trang con:
    // chặn truy cập nếu chưa đăng nhập hoặc không phải Admin
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Session["Username"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/DangNhap.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lblHoTen.Text = Server.HtmlEncode(Session["HoTen"].ToString());
        if (!IsPostBack)
        {
            // Lấy các trang con của nút gốc trong Web.sitemap để tạo menu
            rptMenu.DataSource = SiteMap.RootNode.ChildNodes;
            rptMenu.DataBind();
            if (Request.Path.EndsWith("/Admin/Default.aspx")) hlTongQuan.CssClass = "selected";
        }
    }

    protected void lbtDangXuat_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/DangNhap.aspx");
    }
}
