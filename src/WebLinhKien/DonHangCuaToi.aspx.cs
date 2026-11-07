using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class DonHangCuaToi : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Username"] == null)
        {
            Response.Redirect("DangNhap.aspx?ReturnUrl=DonHangCuaToi.aspx");
            return;
        }
        if (!IsPostBack) LoadDonHang();
    }

    private void LoadDonHang()
    {
        gvDonHang.DataSource = KetNoi.LayDuLieu(
            @"SELECT MaDH, NgayDat, DiaChiGiao, TongTien, HinhThucTT, TrangThai FROM tblDonHang
              WHERE Username = @Username ORDER BY NgayDat DESC",
            new SqlParameter("@Username", Session["Username"].ToString()));
        gvDonHang.DataBind();
    }

    protected void gvDonHang_SelectedIndexChanged(object sender, EventArgs e)
    {
        HienChiTiet();
    }

    private void HienChiTiet()
    {
        int maDH = (int)gvDonHang.SelectedDataKey["MaDH"];
        string trangThai = gvDonHang.SelectedDataKey["TrangThai"].ToString();

        gvChiTiet.DataSource = KetNoi.LayDuLieu(
            @"SELECT s.TenSP, s.HinhAnh, ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien
              FROM tblChiTietDH ct JOIN tblSanPham s ON s.MaSP = ct.MaSP
              WHERE ct.MaDH = @MaDH",
            new SqlParameter("@MaDH", maDH));
        gvChiTiet.DataBind();

        lblMaDH.Text = "DH" + maDH.ToString("0000") + " - " + trangThai;
        pnlChiTiet.Visible = true;
        // Chỉ được hủy khi đơn còn ở trạng thái "Chờ xử lý"
        btnHuyDon.Visible = (trangThai == "Chờ xử lý");
    }

    // Khách hủy đơn: đổi trạng thái và hoàn lại tồn kho trong cùng 1 transaction
    protected void btnHuyDon_Click(object sender, EventArgs e)
    {
        int maDH = (int)gvDonHang.SelectedDataKey["MaDH"];
        using (SqlConnection conn = new SqlConnection(KetNoi.ChuoiKetNoi))
        {
            conn.Open();
            SqlTransaction tran = conn.BeginTransaction();
            try
            {
                SqlCommand cmd = new SqlCommand(
                    @"UPDATE tblDonHang SET TrangThai = N'Đã hủy'
                      WHERE MaDH = @MaDH AND Username = @Username AND TrangThai = N'Chờ xử lý'", conn, tran);
                cmd.Parameters.AddWithValue("@MaDH", maDH);
                cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
                if (cmd.ExecuteNonQuery() == 0)
                    throw new Exception("Đơn hàng không còn ở trạng thái Chờ xử lý.");

                SqlCommand cmdKho = new SqlCommand(
                    @"UPDATE s SET s.SoLuongTon = s.SoLuongTon + ct.SoLuong
                      FROM tblSanPham s JOIN tblChiTietDH ct ON ct.MaSP = s.MaSP
                      WHERE ct.MaDH = @MaDH", conn, tran);
                cmdKho.Parameters.AddWithValue("@MaDH", maDH);
                cmdKho.ExecuteNonQuery();

                tran.Commit();
                lblThongBao.Text = "Đã hủy đơn hàng DH" + maDH.ToString("0000") + ".";
                lblThongBao.CssClass = "thong-bao tb-ok";
            }
            catch (Exception ex)
            {
                tran.Rollback();
                lblThongBao.Text = "Không hủy được đơn hàng: " + ex.Message;
                lblThongBao.CssClass = "thong-bao tb-loi";
            }
        }
        lblThongBao.Visible = true;
        pnlChiTiet.Visible = false;
        gvDonHang.SelectedIndex = -1;
        LoadDonHang();
    }
}
