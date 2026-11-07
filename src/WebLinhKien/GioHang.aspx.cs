using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

// Đặt tên lớp GioHangPage để không trùng với lớp GioHang trong App_Code
public partial class GioHangPage : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.HienCotTrai = false;   // trang giỏ hàng dùng toàn bộ chiều ngang
        if (!IsPostBack) HienThiGioHang();
    }

    private void HienThiGioHang()
    {
        DataTable gio = GioHang.LayGioHang();
        gvGioHang.DataSource = gio;
        gvGioHang.DataBind();

        pnlTong.Visible = gio.Rows.Count > 0;
        lblTongSL.Text = GioHang.TongSoLuong().ToString();
        lblTongTien.Text = TienIch.Tien(GioHang.TongTien());
    }

    // Số lượng tồn kho hiện tại của sản phẩm
    private int LayTonKho(int maSP)
    {
        return KetNoi.SoNguyen(KetNoi.LayGiaTri(
            "SELECT SoLuongTon FROM tblSanPham WHERE MaSP = @MaSP", new SqlParameter("@MaSP", maSP)));
    }

    // Đặt số lượng mới cho 1 sản phẩm (giới hạn trong khoảng 1 .. tồn kho)
    private void DatSoLuong(int maSP, int soLuong)
    {
        int ton = LayTonKho(maSP);
        if (soLuong < 1) soLuong = 1;
        if (soLuong > ton)
        {
            soLuong = ton;
            HienThongBao("Sản phẩm chỉ còn " + ton + " trong kho.", false);
        }
        if (soLuong <= 0) GioHang.Xoa(maSP);   // hết hàng thì bỏ khỏi giỏ
        else GioHang.CapNhat(maSP, soLuong);
        HienThiGioHang();
    }

    // Nút − / + trong cột Số lượng (Chương 6 - Sự kiện RowCommand của GridView)
    protected void gvGioHang_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "Tang" && e.CommandName != "Giam") return;
        int maSP = int.Parse(e.CommandArgument.ToString());
        int hienTai = GioHang.SoLuongCuaSP(maSP);
        DatSoLuong(maSP, e.CommandName == "Tang" ? hienTai + 1 : hienTai - 1);
    }

    // Khách gõ số lượng trực tiếp vào ô (AutoPostBack = true)
    protected void txtSoLuong_TextChanged(object sender, EventArgs e)
    {
        TextBox txt = (TextBox)sender;
        GridViewRow dong = (GridViewRow)txt.NamingContainer;
        int maSP = (int)gvGioHang.DataKeys[dong.RowIndex].Value;
        int soLuong;
        if (!int.TryParse(txt.Text, out soLuong))
        {
            HienThongBao("Số lượng không hợp lệ.", false);
            HienThiGioHang();
            return;
        }
        DatSoLuong(maSP, soLuong);
    }

    // Sự kiện xóa 1 dòng của GridView (Chương 6 - 2.3 Sự kiện trong GridView)
    protected void gvGioHang_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int maSP = (int)gvGioHang.DataKeys[e.RowIndex].Value;
        GioHang.Xoa(maSP);
        HienThiGioHang();
        HienThongBao("Đã xóa sản phẩm khỏi giỏ hàng.", true);
    }

    protected void lbtXoaHet_Click(object sender, EventArgs e)
    {
        GioHang.XoaHet();
        HienThiGioHang();
    }

    // Nút "Thanh toán": kiểm tra tồn kho lần cuối rồi chuyển sang trang thanh toán
    protected void btnThanhToan_Click(object sender, EventArgs e)
    {
        DataTable gio = GioHang.LayGioHang();
        if (gio.Rows.Count == 0) { HienThiGioHang(); return; }

        foreach (DataRow dong in gio.Select())
        {
            int maSP = (int)dong["MaSP"];
            if ((int)dong["SoLuong"] > LayTonKho(maSP))
            {
                HienThiGioHang();
                HienThongBao("Sản phẩm \"" + dong["TenSP"] + "\" không đủ số lượng tồn kho, vui lòng điều chỉnh.", false);
                return;
            }
        }
        // Chưa đăng nhập thì chuyển sang trang đăng nhập, sau đó quay lại trang thanh toán
        if (Session["Username"] == null)
            Response.Redirect("DangNhap.aspx?ReturnUrl=DatHang.aspx");
        else
            Response.Redirect("DatHang.aspx");
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
