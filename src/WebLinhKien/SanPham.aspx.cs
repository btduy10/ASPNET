using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SanPham : Page
{
    private const int SO_SP_MOI_TRANG = 8;

    // Lưu trang hiện tại trong ViewState (Chương 7 - 1.1 View State)
    private int TrangHienTai
    {
        get { return ViewState["Trang"] == null ? 0 : (int)ViewState["Trang"]; }
        set { ViewState["Trang"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TrangHienTai = 0;
            LoadSanPham();
        }
    }

    private void LoadSanPham()
    {
        string sql = @"SELECT s.MaSP, s.TenSP, s.DonGia, s.SoLuongTon, s.HinhAnh, h.TenHang
                       FROM tblSanPham s JOIN tblHangSX h ON h.MaHang = s.MaHang
                       WHERE s.TrangThai = 1";
        List<SqlParameter> thamSo = new List<SqlParameter>();
        string tieuDe = "TẤT CẢ SẢN PHẨM";

        // Lọc theo loại hoặc hãng nếu có tham số trên QueryString
        int maLoai, maHang;
        if (int.TryParse(Request.QueryString["maloai"], out maLoai))
        {
            sql += " AND s.MaLoai = @MaLoai";
            thamSo.Add(new SqlParameter("@MaLoai", maLoai));
            object ten = KetNoi.LayGiaTri("SELECT TenLoai FROM tblLoaiSP WHERE MaLoai = @Ma", new SqlParameter("@Ma", maLoai));
            if (ten != null) tieuDe = "DANH MỤC: " + ten.ToString().ToUpper();
        }
        else if (int.TryParse(Request.QueryString["mahang"], out maHang))
        {
            sql += " AND s.MaHang = @MaHang";
            thamSo.Add(new SqlParameter("@MaHang", maHang));
            object ten = KetNoi.LayGiaTri("SELECT TenHang FROM tblHangSX WHERE MaHang = @Ma", new SqlParameter("@Ma", maHang));
            if (ten != null) tieuDe = "THƯƠNG HIỆU: " + ten.ToString().ToUpper();
        }

        switch (ddlSapXep.SelectedValue)
        {
            case "giatang": sql += " ORDER BY s.DonGia ASC"; break;
            case "giagiam": sql += " ORDER BY s.DonGia DESC"; break;
            case "ten": sql += " ORDER BY s.TenSP ASC"; break;
            default: sql += " ORDER BY s.NgayCapNhat DESC, s.MaSP DESC"; break;
        }

        DataTable dt = KetNoi.LayDuLieu(sql, thamSo.ToArray());

        lblTieuDe.Text = tieuDe;
        lblSoKetQua.Text = "Có " + dt.Rows.Count + " sản phẩm";

        // Phân trang với PagedDataSource
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = dt.DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = SO_SP_MOI_TRANG;
        if (TrangHienTai >= pds.PageCount) TrangHienTai = 0;
        pds.CurrentPageIndex = TrangHienTai;

        dlSanPham.DataSource = pds;
        dlSanPham.DataBind();

        lblTrang.Text = "Trang " + (TrangHienTai + 1) + " / " + Math.Max(pds.PageCount, 1);
        btnTruoc.Enabled = !pds.IsFirstPage;
        btnSau.Enabled = !pds.IsLastPage && pds.PageCount > 1;
    }

    protected void btnTruoc_Click(object sender, EventArgs e)
    {
        TrangHienTai--;
        LoadSanPham();
    }

    protected void btnSau_Click(object sender, EventArgs e)
    {
        TrangHienTai++;
        LoadSanPham();
    }

    protected void ddlSapXep_SelectedIndexChanged(object sender, EventArgs e)
    {
        TrangHienTai = 0;
        LoadSanPham();
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
