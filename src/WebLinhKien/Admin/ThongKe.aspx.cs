using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ThongKe : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Danh sách các năm có đơn hàng
            DataTable dtNam = KetNoi.LayDuLieu(
                "SELECT DISTINCT YEAR(NgayDat) AS Nam FROM tblDonHang UNION SELECT YEAR(GETDATE()) ORDER BY Nam DESC");
            ddlNam.DataSource = dtNam;
            ddlNam.DataTextField = "Nam";
            ddlNam.DataValueField = "Nam";
            ddlNam.DataBind();

            // Mặc định thống kê bán chạy từ đầu năm đến hôm nay
            txtTuNgay.Text = new DateTime(DateTime.Today.Year, 1, 1).ToString("yyyy-MM-dd");
            txtDenNgay.Text = DateTime.Today.ToString("yyyy-MM-dd");

            ThongKeDoanhThu();
            ThongKeTop();
            ThongKeTheoLoai();
            ThongKeTonKho();
        }
    }

    // 1. Gọi thủ tục sp_ThongKeDoanhThuTheoThang, bổ sung đủ 12 tháng
    private void ThongKeDoanhThu()
    {
        DataTable dtSP = KetNoi.LayDuLieuSP("sp_ThongKeDoanhThuTheoThang",
            new SqlParameter("@Nam", int.Parse(ddlNam.SelectedValue)));

        DataTable dt = new DataTable();
        dt.Columns.Add("Thang", typeof(int));
        dt.Columns.Add("SoDonHang", typeof(int));
        dt.Columns.Add("DoanhThu", typeof(decimal));
        dt.Columns.Add("PhanTram", typeof(int));

        decimal max = 0, tong = 0;
        for (int thang = 1; thang <= 12; thang++)
        {
            DataRow[] tim = dtSP.Select("Thang = " + thang);
            int soDon = tim.Length > 0 ? KetNoi.SoNguyen(tim[0]["SoDonHang"]) : 0;
            decimal doanhThu = tim.Length > 0 ? KetNoi.SoThuc(tim[0]["DoanhThu"]) : 0;
            dt.Rows.Add(thang, soDon, doanhThu, 0);
            if (doanhThu > max) max = doanhThu;
            tong += doanhThu;
        }
        // Tính độ dài cột biểu đồ theo % so với tháng cao nhất
        foreach (DataRow dong in dt.Rows)
            dong["PhanTram"] = max == 0 ? 0 : (int)((decimal)dong["DoanhThu"] * 100 / max);

        gvDoanhThu.DataSource = dt;
        gvDoanhThu.DataBind();
        lblTongNam.Text = "Tổng doanh thu năm " + ddlNam.SelectedValue + ": <b>" + TienIch.Tien(tong) + "</b>";
    }

    // 2. Gọi thủ tục sp_TopSanPhamBanChay
    private void ThongKeTop()
    {
        gvTop.DataSource = KetNoi.LayDuLieuSP("sp_TopSanPhamBanChay",
            new SqlParameter("@TuNgay", DateTime.Parse(txtTuNgay.Text)),
            new SqlParameter("@DenNgay", DateTime.Parse(txtDenNgay.Text)),
            new SqlParameter("@SoLuong", 5));
        gvTop.DataBind();
    }

    // 3. Doanh thu theo loại sản phẩm
    private void ThongKeTheoLoai()
    {
        gvTheoLoai.DataSource = KetNoi.LayDuLieu(
            @"SELECT l.TenLoai, SUM(ct.SoLuong) AS SoLuong, SUM(ct.SoLuong * ct.DonGia) AS DoanhThu
              FROM tblChiTietDH ct
              JOIN tblDonHang dh ON dh.MaDH = ct.MaDH AND dh.TrangThai = N'Hoàn thành'
              JOIN tblSanPham s ON s.MaSP = ct.MaSP
              JOIN tblLoaiSP l ON l.MaLoai = s.MaLoai
              GROUP BY l.TenLoai ORDER BY DoanhThu DESC");
        gvTheoLoai.DataBind();
    }

    // 4. Danh sách sản phẩm có tồn kho dưới ngưỡng + tổng giá trị kho
    private void ThongKeTonKho()
    {
        gvTonKho.DataSource = KetNoi.LayDuLieu(
            @"SELECT s.MaSP, s.TenSP, l.TenLoai, s.SoLuongTon, s.SoLuongTon * s.DonGia AS GiaTriTon
              FROM tblSanPham s JOIN tblLoaiSP l ON l.MaLoai = s.MaLoai
              WHERE s.SoLuongTon < @Nguong AND s.TrangThai = 1
              ORDER BY s.SoLuongTon",
            new SqlParameter("@Nguong", int.Parse(txtNguong.Text)));
        gvTonKho.DataBind();

        lblGiaTriKho.Text = "Tổng giá trị hàng tồn kho: <b>" +
            TienIch.Tien(KetNoi.LayGiaTri("SELECT SUM(SoLuongTon * DonGia) FROM tblSanPham WHERE TrangThai = 1")) + "</b>";
    }

    protected void ddlNam_SelectedIndexChanged(object sender, EventArgs e)
    {
        ThongKeDoanhThu();
    }

    protected void cvKhoangNgay_ServerValidate(object source, ServerValidateEventArgs args)
    {
        DateTime tu, den;
        args.IsValid = DateTime.TryParse(txtTuNgay.Text, out tu) && DateTime.TryParse(txtDenNgay.Text, out den) && den >= tu;
    }

    protected void btnXemTop_Click(object sender, EventArgs e)
    {
        if (Page.IsValid) ThongKeTop();
    }

    protected void btnXemTon_Click(object sender, EventArgs e)
    {
        if (Page.IsValid) ThongKeTonKho();
    }
}
