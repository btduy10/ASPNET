using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

// Trang quản trị: chỉnh sửa thông tin hiển thị của website (bảng tblCauHinh)
public partial class Admin_QLCauHinh : Page
{
    // Nhóm đang chọn được lưu trong ViewState để giữ qua các lần postback
    protected string NhomDangChon
    {
        get { return ViewState["Nhom"] == null ? "" : ViewState["Nhom"].ToString(); }
        set { ViewState["Nhom"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable nhom = LayDanhSachNhom();
            if (nhom.Rows.Count > 0) NhomDangChon = nhom.Rows[0]["Nhom"].ToString();
            HienThi();
        }
    }

    private DataTable LayDanhSachNhom()
    {
        return KetNoi.LayDuLieu("SELECT Nhom, MIN(ThuTu) AS ThuTu FROM tblCauHinh GROUP BY Nhom ORDER BY MIN(ThuTu)");
    }

    private void HienThi()
    {
        rptNhom.DataSource = LayDanhSachNhom();
        rptNhom.DataBind();

        rptCauHinh.DataSource = KetNoi.LayDuLieu(
            "SELECT MaCH, TenCH, GiaTri, KieuNhap, GhiChu FROM tblCauHinh WHERE Nhom = @Nhom ORDER BY ThuTu",
            new SqlParameter("@Nhom", NhomDangChon));
        rptCauHinh.DataBind();
    }

    // Bấm vào tab nhóm (sự kiện ItemCommand của Repeater)
    protected void rptNhom_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "ChonNhom")
        {
            NhomDangChon = e.CommandArgument.ToString();
            lblThongBao.Visible = false;
            HienThi();
        }
    }

    // Lưu tất cả các ô của nhóm đang chọn
    protected void btnLuu_Click(object sender, EventArgs e)
    {
        int dem = 0;
        foreach (RepeaterItem item in rptCauHinh.Items)
        {
            HiddenField hf = (HiddenField)item.FindControl("hfMaCH");
            TextBox txt = (TextBox)item.FindControl("txtGiaTri");
            dem += KetNoi.ThucThi("UPDATE tblCauHinh SET GiaTri = @GiaTri WHERE MaCH = @MaCH",
                new SqlParameter("@GiaTri", txt.Text.Trim()),
                new SqlParameter("@MaCH", hf.Value));
        }
        CauHinh.LamMoi();   // xóa bộ nhớ đệm trong Application để website hiển thị thông tin mới

        lblThongBao.Visible = true;
        lblThongBao.CssClass = "thong-bao tb-ok";
        lblThongBao.Text = "Đã lưu " + dem + " mục của nhóm \"" + Server.HtmlEncode(NhomDangChon) +
                           "\". Website đã cập nhật thông tin mới.";
        HienThi();
    }
}
