using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_QLHangSX : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadHang();
    }

    private void LoadHang()
    {
        gvHang.DataSource = KetNoi.LayDuLieu(
            @"SELECT h.MaHang, h.TenHang, h.QuocGia, COUNT(s.MaSP) AS SoSP
              FROM tblHangSX h LEFT JOIN tblSanPham s ON s.MaHang = h.MaHang
              GROUP BY h.MaHang, h.TenHang, h.QuocGia ORDER BY h.MaHang");
        gvHang.DataBind();
    }

    // ===== THÊM =====
    protected void btnThem_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        try
        {
            KetNoi.ThucThi("INSERT INTO tblHangSX (TenHang, QuocGia) VALUES (@TenHang, @QuocGia)",
                new SqlParameter("@TenHang", txtTenHang.Text.Trim()),
                new SqlParameter("@QuocGia", txtQuocGia.Text.Trim()));
            HienThongBao("Đã thêm hãng \"" + txtTenHang.Text.Trim() + "\".", true);
            txtTenHang.Text = txtQuocGia.Text = "";
        }
        catch (SqlException ex)
        {
            // 2627: vi phạm ràng buộc UNIQUE
            HienThongBao(ex.Number == 2627 ? "Tên hãng đã tồn tại." : "Lỗi: " + ex.Message, false);
        }
        LoadHang();
    }

    // ===== SỬA =====
    protected void gvHang_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvHang.EditIndex = e.NewEditIndex;
        LoadHang();
    }

    protected void gvHang_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvHang.EditIndex = -1;
        LoadHang();
    }

    protected void gvHang_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int maHang = (int)gvHang.DataKeys[e.RowIndex].Value;
        GridViewRow dong = gvHang.Rows[e.RowIndex];
        string ten = ((TextBox)dong.FindControl("txtSuaTen")).Text.Trim();
        string quocGia = ((TextBox)dong.FindControl("txtSuaQuocGia")).Text.Trim();
        try
        {
            KetNoi.ThucThi("UPDATE tblHangSX SET TenHang = @TenHang, QuocGia = @QuocGia WHERE MaHang = @MaHang",
                new SqlParameter("@TenHang", ten),
                new SqlParameter("@QuocGia", quocGia),
                new SqlParameter("@MaHang", maHang));
            gvHang.EditIndex = -1;
            HienThongBao("Đã cập nhật hãng mã " + maHang + ".", true);
        }
        catch (SqlException ex)
        {
            HienThongBao(ex.Number == 2627 ? "Tên hãng đã tồn tại." : "Lỗi: " + ex.Message, false);
        }
        LoadHang();
    }

    // ===== XÓA =====
    protected void gvHang_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int maHang = (int)gvHang.DataKeys[e.RowIndex].Value;
        // Kiểm tra ràng buộc toàn vẹn: hãng đang có sản phẩm thì không cho xóa
        int soSP = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblSanPham WHERE MaHang = @MaHang",
            new SqlParameter("@MaHang", maHang)));
        if (soSP > 0)
        {
            HienThongBao("Không thể xóa: hãng này đang có " + soSP + " sản phẩm.", false);
        }
        else
        {
            KetNoi.ThucThi("DELETE FROM tblHangSX WHERE MaHang = @MaHang", new SqlParameter("@MaHang", maHang));
            HienThongBao("Đã xóa hãng mã " + maHang + ".", true);
        }
        gvHang.EditIndex = -1;
        LoadHang();
    }

    protected void gvHang_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvHang.PageIndex = e.NewPageIndex;
        gvHang.EditIndex = -1;
        LoadHang();
    }

    protected void gvHang_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        TienIch.GanXacNhanXoa(e.Row);
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
