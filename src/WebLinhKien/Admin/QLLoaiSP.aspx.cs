using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_QLLoaiSP : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadLoai();
    }

    private void LoadLoai()
    {
        gvLoai.DataSource = KetNoi.LayDuLieu(
            @"SELECT l.MaLoai, l.TenLoai, l.MoTa, COUNT(s.MaSP) AS SoSP
              FROM tblLoaiSP l LEFT JOIN tblSanPham s ON s.MaLoai = l.MaLoai
              GROUP BY l.MaLoai, l.TenLoai, l.MoTa ORDER BY l.MaLoai");
        gvLoai.DataBind();
    }

    // ===== THÊM =====
    protected void btnThem_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        try
        {
            KetNoi.ThucThi("INSERT INTO tblLoaiSP (TenLoai, MoTa) VALUES (@TenLoai, @MoTa)",
                new SqlParameter("@TenLoai", txtTenLoai.Text.Trim()),
                new SqlParameter("@MoTa", txtMoTa.Text.Trim()));
            HienThongBao("Đã thêm loại \"" + txtTenLoai.Text.Trim() + "\".", true);
            txtTenLoai.Text = txtMoTa.Text = "";
        }
        catch (SqlException ex)
        {
            // 2627: vi phạm ràng buộc UNIQUE
            HienThongBao(ex.Number == 2627 ? "Tên loại đã tồn tại." : "Lỗi: " + ex.Message, false);
        }
        LoadLoai();
    }

    // ===== SỬA =====
    protected void gvLoai_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvLoai.EditIndex = e.NewEditIndex;
        LoadLoai();
    }

    protected void gvLoai_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvLoai.EditIndex = -1;
        LoadLoai();
    }

    protected void gvLoai_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int maLoai = (int)gvLoai.DataKeys[e.RowIndex].Value;
        GridViewRow dong = gvLoai.Rows[e.RowIndex];
        string ten = ((TextBox)dong.FindControl("txtSuaTen")).Text.Trim();
        string moTa = ((TextBox)dong.FindControl("txtSuaMoTa")).Text.Trim();
        try
        {
            KetNoi.ThucThi("UPDATE tblLoaiSP SET TenLoai = @TenLoai, MoTa = @MoTa WHERE MaLoai = @MaLoai",
                new SqlParameter("@TenLoai", ten),
                new SqlParameter("@MoTa", moTa),
                new SqlParameter("@MaLoai", maLoai));
            gvLoai.EditIndex = -1;
            HienThongBao("Đã cập nhật loại mã " + maLoai + ".", true);
        }
        catch (SqlException ex)
        {
            HienThongBao(ex.Number == 2627 ? "Tên loại đã tồn tại." : "Lỗi: " + ex.Message, false);
        }
        LoadLoai();
    }

    // ===== XÓA =====
    protected void gvLoai_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int maLoai = (int)gvLoai.DataKeys[e.RowIndex].Value;
        // Kiểm tra ràng buộc toàn vẹn: loại đang có sản phẩm thì không cho xóa
        int soSP = KetNoi.SoNguyen(KetNoi.LayGiaTri("SELECT COUNT(*) FROM tblSanPham WHERE MaLoai = @MaLoai",
            new SqlParameter("@MaLoai", maLoai)));
        if (soSP > 0)
        {
            HienThongBao("Không thể xóa: loại này đang có " + soSP + " sản phẩm.", false);
        }
        else
        {
            KetNoi.ThucThi("DELETE FROM tblLoaiSP WHERE MaLoai = @MaLoai", new SqlParameter("@MaLoai", maLoai));
            HienThongBao("Đã xóa loại mã " + maLoai + ".", true);
        }
        gvLoai.EditIndex = -1;
        LoadLoai();
    }

    protected void gvLoai_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvLoai.PageIndex = e.NewPageIndex;
        gvLoai.EditIndex = -1;
        LoadLoai();
    }

    protected void gvLoai_RowDataBound(object sender, GridViewRowEventArgs e)
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
