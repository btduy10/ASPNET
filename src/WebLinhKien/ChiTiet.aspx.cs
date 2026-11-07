using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ChiTiet : Page
{
    // Lấy mã sản phẩm từ QueryString: ChiTiet.aspx?masp=...
    private int MaSP
    {
        get
        {
            int ma;
            return int.TryParse(Request.QueryString["masp"], out ma) ? ma : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadChiTiet();
        }
    }

    private void LoadChiTiet()
    {
        string sql = @"SELECT s.*, l.TenLoai, h.TenHang
                       FROM tblSanPham s
                       JOIN tblLoaiSP l ON l.MaLoai = s.MaLoai
                       JOIN tblHangSX h ON h.MaHang = s.MaHang
                       WHERE s.MaSP = @MaSP AND s.TrangThai = 1";
        DataTable dt = KetNoi.LayDuLieu(sql, new SqlParameter("@MaSP", MaSP));
        fvSanPham.DataSource = dt;
        fvSanPham.DataBind();

        if (dt.Rows.Count == 0)
        {
            pnlMuaHang.Visible = false;
            return;
        }

        DataRow sp = dt.Rows[0];
        Page.Title = sp["TenSP"] + " - Linh Kiện TVU";

        // Số lượng tối đa được mua = tồn kho - số lượng đã có trong giỏ
        int ton = (int)sp["SoLuongTon"];
        int conLai = ton - GioHang.SoLuongCuaSP(MaSP);
        if (conLai <= 0)
        {
            btnThemGio.Enabled = btnMuaNgay.Enabled = false;
            txtSoLuong.Enabled = false;
            rvSoLuong.Enabled = false;
            HienThongBao(ton <= 0 ? "Sản phẩm tạm hết hàng." : "Bạn đã thêm toàn bộ số lượng còn lại vào giỏ.", false);
        }
        else
        {
            rvSoLuong.MaximumValue = conLai.ToString();
            rvSoLuong.ErrorMessage = "Số lượng phải từ 1 đến " + conLai;
        }

        // Sản phẩm cùng loại
        string sqlCungLoai = @"SELECT TOP 4 MaSP, TenSP, DonGia, HinhAnh FROM tblSanPham
                               WHERE MaLoai = @MaLoai AND MaSP <> @MaSP AND TrangThai = 1
                               ORDER BY NEWID()";
        dlCungLoai.DataSource = KetNoi.LayDuLieu(sqlCungLoai,
            new SqlParameter("@MaLoai", sp["MaLoai"]), new SqlParameter("@MaSP", MaSP));
        dlCungLoai.DataBind();
    }

    // Thêm sản phẩm vào giỏ hàng lưu trong Session; trả về true nếu thành công
    private bool ThemVaoGio()
    {
        if (!Page.IsValid) return false;

        DataTable dt = KetNoi.LayDuLieu(
            "SELECT TenSP, HinhAnh, DonGia, SoLuongTon FROM tblSanPham WHERE MaSP = @MaSP AND TrangThai = 1",
            new SqlParameter("@MaSP", MaSP));
        if (dt.Rows.Count == 0) return false;

        DataRow sp = dt.Rows[0];
        int soLuong = int.Parse(txtSoLuong.Text);
        // Kiểm tra lại tồn kho phía server
        if (soLuong + GioHang.SoLuongCuaSP(MaSP) > (int)sp["SoLuongTon"])
        {
            HienThongBao("Số lượng vượt quá tồn kho (còn " + sp["SoLuongTon"] + ").", false);
            return false;
        }

        GioHang.Them(MaSP, sp["TenSP"].ToString(), sp["HinhAnh"].ToString(), (decimal)sp["DonGia"], soLuong);
        return true;
    }

    protected void btnThemGio_Click(object sender, EventArgs e)
    {
        if (ThemVaoGio())
        {
            LoadChiTiet();   // nạp lại để cập nhật số lượng tối đa
            Master.HienPopupDaThem(MaSP);   // hộp thông báo đặt ở Site.master
            txtSoLuong.Text = "1";
        }
    }

    protected void btnMuaNgay_Click(object sender, EventArgs e)
    {
        if (ThemVaoGio()) Response.Redirect("GioHang.aspx");
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }

    // Bấm biểu tượng giỏ hàng trên thẻ sản phẩm (sự kiện ItemCommand của DataList)
    protected void dsSanPham_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "ThemGio")
        {
            Master.ThemNhanhVaoGio(int.Parse(e.CommandArgument.ToString()));
        }
    }
}
