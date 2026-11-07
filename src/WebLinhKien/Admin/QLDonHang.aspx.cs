using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_QLDonHang : Page
{
    // Mã đơn hàng đang xem, lưu trong ViewState
    private int MaDHDangXem
    {
        get { return ViewState["MaDH"] == null ? 0 : (int)ViewState["MaDH"]; }
        set { ViewState["MaDH"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDonHang();
            // Mở trực tiếp 1 đơn khi đi từ trang Tổng quan: QLDonHang.aspx?madh=...
            int maDH;
            if (int.TryParse(Request.QueryString["madh"], out maDH)) HienChiTiet(maDH);
        }
    }

    private void LoadDonHang()
    {
        string sql = "SELECT MaDH, Username, HoTenNhan, DienThoaiNhan, NgayDat, TongTien, HinhThucTT, TrangThai FROM tblDonHang WHERE 1 = 1";
        List<SqlParameter> thamSo = new List<SqlParameter>();
        if (ddlLocTrangThai.SelectedValue != "")
        {
            sql += " AND TrangThai = @TrangThai";
            thamSo.Add(new SqlParameter("@TrangThai", ddlLocTrangThai.SelectedValue));
        }
        if (txtTim.Text.Trim() != "")
        {
            sql += " AND (HoTenNhan LIKE @TuKhoa OR DienThoaiNhan LIKE @TuKhoa OR Username LIKE @TuKhoa)";
            thamSo.Add(new SqlParameter("@TuKhoa", "%" + txtTim.Text.Trim() + "%"));
        }
        sql += " ORDER BY NgayDat DESC";
        gvDonHang.DataSource = KetNoi.LayDuLieu(sql, thamSo.ToArray());
        gvDonHang.DataBind();
    }

    private void HienChiTiet(int maDH)
    {
        DataTable dt = KetNoi.LayDuLieu("SELECT * FROM tblDonHang WHERE MaDH = @MaDH", new SqlParameter("@MaDH", maDH));
        if (dt.Rows.Count == 0) { pnlChiTiet.Visible = false; return; }

        MaDHDangXem = maDH;
        dvDonHang.DataSource = dt;
        dvDonHang.DataBind();

        gvChiTiet.DataSource = KetNoi.LayDuLieu(
            @"SELECT ct.MaSP, s.TenSP, ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien
              FROM tblChiTietDH ct JOIN tblSanPham s ON s.MaSP = ct.MaSP WHERE ct.MaDH = @MaDH",
            new SqlParameter("@MaDH", maDH));
        gvChiTiet.DataBind();

        string trangThai = dt.Rows[0]["TrangThai"].ToString();
        ddlTrangThai.SelectedValue = trangThai;
        // Đơn đã Hoàn thành hoặc Đã hủy thì không được đổi trạng thái nữa
        bool choPhepSua = (trangThai != "Hoàn thành" && trangThai != "Đã hủy");
        ddlTrangThai.Enabled = btnCapNhatTT.Enabled = choPhepSua;
        pnlChiTiet.Visible = true;
    }

    protected void gvDonHang_SelectedIndexChanged(object sender, EventArgs e)
    {
        HienChiTiet((int)gvDonHang.SelectedDataKey.Value);
    }

    // Cập nhật trạng thái; nếu hủy đơn thì hoàn lại số lượng tồn kho
    protected void btnCapNhatTT_Click(object sender, EventArgs e)
    {
        int maDH = MaDHDangXem;
        string trangThaiMoi = ddlTrangThai.SelectedValue;
        using (SqlConnection conn = new SqlConnection(KetNoi.ChuoiKetNoi))
        {
            conn.Open();
            SqlTransaction tran = conn.BeginTransaction();
            try
            {
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE tblDonHang SET TrangThai = @TrangThai
                      WHERE MaDH = @MaDH AND TrangThai NOT IN (N'Hoàn thành', N'Đã hủy')", conn, tran);
                cmd.Parameters.AddWithValue("@TrangThai", trangThaiMoi);
                cmd.Parameters.AddWithValue("@MaDH", maDH);
                if (cmd.ExecuteNonQuery() == 0)
                    throw new Exception("Đơn hàng đã kết thúc, không thể cập nhật.");

                if (trangThaiMoi == "Đã hủy")
                {
                    SqlCommand cmdKho = new SqlCommand(
                        @"UPDATE s SET s.SoLuongTon = s.SoLuongTon + ct.SoLuong
                          FROM tblSanPham s JOIN tblChiTietDH ct ON ct.MaSP = s.MaSP
                          WHERE ct.MaDH = @MaDH", conn, tran);
                    cmdKho.Parameters.AddWithValue("@MaDH", maDH);
                    cmdKho.ExecuteNonQuery();
                }
                tran.Commit();
                HienThongBao("Đã cập nhật đơn DH" + maDH.ToString("0000") + " sang trạng thái \"" + trangThaiMoi + "\".", true);
            }
            catch (Exception ex)
            {
                tran.Rollback();
                HienThongBao("Lỗi: " + ex.Message, false);
            }
        }
        LoadDonHang();
        HienChiTiet(maDH);
    }

    protected void btnLoc_Click(object sender, EventArgs e)
    {
        gvDonHang.PageIndex = 0;
        gvDonHang.SelectedIndex = -1;
        pnlChiTiet.Visible = false;
        LoadDonHang();
    }

    protected void gvDonHang_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvDonHang.PageIndex = e.NewPageIndex;
        gvDonHang.SelectedIndex = -1;
        LoadDonHang();
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
