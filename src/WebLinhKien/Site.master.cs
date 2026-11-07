using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Hiển thị thông tin đăng nhập dựa vào biến Session
        if (Session["Username"] != null)
        {
            phChuaDangNhap.Visible = false;
            phDaDangNhap.Visible = true;
            lblHoTen.Text = Server.HtmlEncode(Session["HoTen"].ToString());
            hlQuanTri.Visible = (Session["Role"] != null && Session["Role"].ToString() == "Admin");
        }
        else
        {
            phChuaDangNhap.Visible = true;
            phDaDangNhap.Visible = false;
        }

        // Đếm lượt truy cập lưu trong biến Application (global.asax)
        lblLuotTruyCap.Text = Application["SoLuotTruyCap"] != null ? Application["SoLuotTruyCap"].ToString() : "0";
        lblDangOnline.Text = Application["DangOnline"] != null ? Application["DangOnline"].ToString() : "0";
    }

    // PreRender chạy sau các sự kiện Click của trang con,
    // nên số lượng trong giỏ luôn được cập nhật mới nhất
    protected void Page_PreRender(object sender, EventArgs e)
    {
        lblSoLuongGio.Text = GioHang.TongSoLuong().ToString();
    }

    protected void btnTim_Click(object sender, EventArgs e)
    {
        string tuKhoa = txtTuKhoa.Text.Trim();
        Response.Redirect("~/TimKiem.aspx?tukhoa=" + Server.UrlEncode(tuKhoa));
    }

    protected void lbtDangXuat_Click(object sender, EventArgs e)
    {
        Session.Abandon();   // hủy toàn bộ Session (thông tin đăng nhập + giỏ hàng)
        Response.Redirect("~/Default.aspx");
    }

    // ================= Thêm nhanh vào giỏ hàng + hộp thông báo =================
    // Các trang con (khai báo <%@ MasterType %>) gọi: Master.ThemNhanhVaoGio(maSP)

    // Thêm 1 sản phẩm vào giỏ (kiểm tra tồn kho phía server), sau đó hiện hộp thông báo
    public bool ThemNhanhVaoGio(int maSP)
    {
        DataTable dt = KetNoi.LayDuLieu(
            "SELECT TenSP, HinhAnh, DonGia, SoLuongTon FROM tblSanPham WHERE MaSP = @MaSP AND TrangThai = 1",
            new SqlParameter("@MaSP", maSP));
        if (dt.Rows.Count == 0)
        {
            HienPopupLoi("Sản phẩm này hiện không còn kinh doanh.");
            return false;
        }

        DataRow sp = dt.Rows[0];
        int ton = KetNoi.SoNguyen(sp["SoLuongTon"]);
        if (GioHang.SoLuongCuaSP(maSP) + 1 > ton)
        {
            HienPopupLoi(ton == 0 ? "Sản phẩm đã hết hàng."
                                  : "Giỏ hàng đã có đủ số lượng tồn kho của sản phẩm này (" + ton + ").");
            return false;
        }

        GioHang.Them(maSP, sp["TenSP"].ToString(), sp["HinhAnh"].ToString(), KetNoi.SoThuc(sp["DonGia"]), 1);
        HienPopupDaThem(maSP);
        return true;
    }

    // Hiện hộp thông báo thành công cho sản phẩm vừa thêm (lấy thông tin từ giỏ hàng)
    public void HienPopupDaThem(int maSP)
    {
        DataRow dong = GioHang.LayGioHang().Rows.Find(maSP);
        if (dong == null) return;

        pnlPopupDau.CssClass = "popup-dau";
        litBieuTuong.Text = "&#10003;";
        lblPopupTieuDe.Text = "Thêm vào giỏ hàng thành công";
        imgPopup.ImageUrl = TienIch.Hinh(dong["HinhAnh"]);
        imgPopup.AlternateText = dong["TenSP"].ToString();
        lblPopupTen.Text = Server.HtmlEncode(dong["TenSP"].ToString());
        lblPopupMa.Text = "SP" + maSP.ToString("000");
        lblPopupGia.Text = TienIch.Tien(dong["DonGia"]);
        litPopupThongTin.Text = "Giỏ hàng của bạn hiện có <b>" + GioHang.TongSoLuong() + "</b> sản phẩm";
        phPopupSP.Visible = true;
        hlPopupThanhToan.Visible = true;
        pnlGioPopup.Visible = true;
    }

    // Hiện hộp thông báo lỗi (hết hàng, vượt tồn kho...)
    private void HienPopupLoi(string noiDung)
    {
        pnlPopupDau.CssClass = "popup-dau loi";
        litBieuTuong.Text = "!";
        lblPopupTieuDe.Text = "Không thể thêm vào giỏ hàng";
        litPopupThongTin.Text = Server.HtmlEncode(noiDung);
        phPopupSP.Visible = false;
        hlPopupThanhToan.Visible = GioHang.TongSoLuong() > 0;
        pnlGioPopup.Visible = true;
    }

    // Ẩn/hiện cột danh mục bên trái (trang Giỏ hàng, Thanh toán dùng toàn bộ chiều ngang)
    public bool HienCotTrai
    {
        get { return divCotTrai.Visible; }
        set { divCotTrai.Visible = value; }
    }
}
