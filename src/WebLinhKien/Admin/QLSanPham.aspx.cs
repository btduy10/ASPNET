using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_QLSanPham : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropDownList();
            LoadSanPham();
        }
    }

    // Đổ dữ liệu cho các DropDownList Loại, Hãng
    private void LoadDropDownList()
    {
        DataTable dtLoai = KetNoi.LayDuLieu("SELECT MaLoai, TenLoai FROM tblLoaiSP ORDER BY TenLoai");
        ddlLoai.DataSource = dtLoai;
        ddlLoai.DataTextField = "TenLoai";
        ddlLoai.DataValueField = "MaLoai";
        ddlLoai.DataBind();

        ddlLocLoai.DataSource = dtLoai;
        ddlLocLoai.DataTextField = "TenLoai";
        ddlLocLoai.DataValueField = "MaLoai";
        ddlLocLoai.DataBind();
        ddlLocLoai.Items.Insert(0, new ListItem("-- Tất cả --", "0"));

        ddlHang.DataSource = KetNoi.LayDuLieu("SELECT MaHang, TenHang FROM tblHangSX ORDER BY TenHang");
        ddlHang.DataTextField = "TenHang";
        ddlHang.DataValueField = "MaHang";
        ddlHang.DataBind();
    }

    // Hiển thị danh sách sản phẩm có lọc theo từ khóa (tìm tương đối) và loại
    private void LoadSanPham()
    {
        string sql = @"SELECT s.MaSP, s.TenSP, s.DonGia, s.SoLuongTon, s.HinhAnh, s.TrangThai, l.TenLoai, h.TenHang
                       FROM tblSanPham s
                       JOIN tblLoaiSP l ON l.MaLoai = s.MaLoai
                       JOIN tblHangSX h ON h.MaHang = s.MaHang
                       WHERE 1 = 1";
        List<SqlParameter> thamSo = new List<SqlParameter>();
        if (txtTim.Text.Trim() != "")
        {
            sql += " AND s.TenSP LIKE @TuKhoa";
            thamSo.Add(new SqlParameter("@TuKhoa", "%" + txtTim.Text.Trim() + "%"));
        }
        if (ddlLocLoai.SelectedValue != "0")
        {
            sql += " AND s.MaLoai = @MaLoai";
            thamSo.Add(new SqlParameter("@MaLoai", int.Parse(ddlLocLoai.SelectedValue)));
        }
        sql += " ORDER BY s.MaSP ASC";   // sắp xếp theo mã sản phẩm từ nhỏ đến lớn

        DataTable dt = KetNoi.LayDuLieu(sql, thamSo.ToArray());
        gvSanPham.DataSource = dt;
        gvSanPham.DataBind();
        lblSoSP.Text = "Tổng: " + dt.Rows.Count + " sản phẩm";
    }

    // Lưu file hình được upload, trả về tên file (hoặc hình cũ nếu không upload)
    private string LuuHinh()
    {
        if (!fuHinh.HasFile) return hfHinhCu.Value;

        string duoi = Path.GetExtension(fuHinh.FileName).ToLower();
        string tenFile = "sp_" + DateTime.Now.ToString("yyyyMMddHHmmss") + duoi;
        string thuMuc = Server.MapPath(ConfigurationManager.AppSettings["ThuMucHinh"]);
        fuHinh.SaveAs(Path.Combine(thuMuc, tenFile));
        return tenFile;
    }

    // Tạo danh sách tham số dùng chung cho INSERT và UPDATE
    private SqlParameter[] ThamSoSanPham(string hinh)
    {
        return new SqlParameter[]
        {
            new SqlParameter("@TenSP", txtTenSP.Text.Trim()),
            new SqlParameter("@MaLoai", int.Parse(ddlLoai.SelectedValue)),
            new SqlParameter("@MaHang", int.Parse(ddlHang.SelectedValue)),
            new SqlParameter("@DonGia", decimal.Parse(txtDonGia.Text)),
            new SqlParameter("@SoLuongTon", int.Parse(txtSoLuong.Text)),
            new SqlParameter("@HinhAnh", hinh),
            new SqlParameter("@ThongSo", txtThongSo.Text.Trim()),
            new SqlParameter("@MoTa", txtMoTa.Text.Trim()),
            new SqlParameter("@TrangThai", chkTrangThai.Checked)
        };
    }

    // ===== THÊM =====
    protected void btnThem_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        try
        {
            string sql = @"INSERT INTO tblSanPham (TenSP, MaLoai, MaHang, DonGia, SoLuongTon, HinhAnh, ThongSo, MoTa, TrangThai)
                           VALUES (@TenSP, @MaLoai, @MaHang, @DonGia, @SoLuongTon, @HinhAnh, @ThongSo, @MoTa, @TrangThai)";
            KetNoi.ThucThi(sql, ThamSoSanPham(LuuHinh()));
            HienThongBao("Đã thêm sản phẩm \"" + txtTenSP.Text.Trim() + "\".", true);
            LamMoiForm();
            LoadSanPham();
        }
        catch (Exception ex)
        {
            HienThongBao("Lỗi khi thêm: " + ex.Message, false);
        }
    }

    // ===== CHỌN DÒNG ĐỂ SỬA: đưa dữ liệu lên form =====
    protected void gvSanPham_SelectedIndexChanged(object sender, EventArgs e)
    {
        int maSP = (int)gvSanPham.SelectedDataKey.Value;
        DataTable dt = KetNoi.LayDuLieu("SELECT * FROM tblSanPham WHERE MaSP = @MaSP", new SqlParameter("@MaSP", maSP));
        if (dt.Rows.Count == 0) return;
        DataRow sp = dt.Rows[0];

        hfMaSP.Value = maSP.ToString();
        txtTenSP.Text = sp["TenSP"].ToString();
        ddlLoai.SelectedValue = sp["MaLoai"].ToString();
        ddlHang.SelectedValue = sp["MaHang"].ToString();
        txtDonGia.Text = Convert.ToDecimal(sp["DonGia"]).ToString("0");
        txtSoLuong.Text = sp["SoLuongTon"].ToString();
        txtThongSo.Text = sp["ThongSo"].ToString();
        txtMoTa.Text = sp["MoTa"].ToString();
        chkTrangThai.Checked = (bool)sp["TrangThai"];
        hfHinhCu.Value = sp["HinhAnh"].ToString();
        imgHinh.ImageUrl = TienIch.Hinh(sp["HinhAnh"]);
        imgHinh.Visible = true;

        lblTieuDeForm.Text = "CẬP NHẬT SẢN PHẨM MÃ " + maSP;
        btnThem.Visible = false;
        btnCapNhat.Visible = true;
    }

    // ===== CẬP NHẬT =====
    protected void btnCapNhat_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid || hfMaSP.Value == "") return;
        try
        {
            string sql = @"UPDATE tblSanPham SET TenSP = @TenSP, MaLoai = @MaLoai, MaHang = @MaHang, DonGia = @DonGia,
                                  SoLuongTon = @SoLuongTon, HinhAnh = @HinhAnh, ThongSo = @ThongSo, MoTa = @MoTa,
                                  TrangThai = @TrangThai, NgayCapNhat = GETDATE()
                           WHERE MaSP = @MaSP";
            List<SqlParameter> thamSo = new List<SqlParameter>(ThamSoSanPham(LuuHinh()));
            thamSo.Add(new SqlParameter("@MaSP", int.Parse(hfMaSP.Value)));
            KetNoi.ThucThi(sql, thamSo.ToArray());
            HienThongBao("Đã cập nhật sản phẩm mã " + hfMaSP.Value + ".", true);
            LamMoiForm();
            LoadSanPham();
        }
        catch (Exception ex)
        {
            HienThongBao("Lỗi khi cập nhật: " + ex.Message, false);
        }
    }

    // ===== XÓA =====
    protected void gvSanPham_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int maSP = (int)gvSanPham.DataKeys[e.RowIndex].Value;
        try
        {
            KetNoi.ThucThi("DELETE FROM tblSanPham WHERE MaSP = @MaSP", new SqlParameter("@MaSP", maSP));
            HienThongBao("Đã xóa sản phẩm mã " + maSP + ".", true);
        }
        catch (SqlException ex)
        {
            // 547: vi phạm khóa ngoại - sản phẩm đã có trong đơn hàng
            if (ex.Number == 547)
                HienThongBao("Không thể xóa: sản phẩm đã phát sinh đơn hàng. Hãy bỏ chọn \"Đang kinh doanh\" để ngừng bán.", false);
            else
                HienThongBao("Lỗi khi xóa: " + ex.Message, false);
        }
        LamMoiForm();
        LoadSanPham();
    }

    protected void gvSanPham_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvSanPham.PageIndex = e.NewPageIndex;
        gvSanPham.SelectedIndex = -1;
        LoadSanPham();
    }

    protected void gvSanPham_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        TienIch.GanXacNhanXoa(e.Row);
    }

    protected void btnLoc_Click(object sender, EventArgs e)
    {
        gvSanPham.PageIndex = 0;
        LoadSanPham();
    }

    protected void btnLamMoi_Click(object sender, EventArgs e)
    {
        LamMoiForm();
    }

    private void LamMoiForm()
    {
        hfMaSP.Value = hfHinhCu.Value = "";
        txtTenSP.Text = txtDonGia.Text = txtSoLuong.Text = txtThongSo.Text = txtMoTa.Text = "";
        chkTrangThai.Checked = true;
        imgHinh.Visible = false;
        lblTieuDeForm.Text = "THÊM SẢN PHẨM MỚI";
        btnThem.Visible = true;
        btnCapNhat.Visible = false;
        gvSanPham.SelectedIndex = -1;
    }

    private void HienThongBao(string noiDung, bool thanhCong)
    {
        lblThongBao.Visible = true;
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = "thong-bao " + (thanhCong ? "tb-ok" : "tb-loi");
    }
}
