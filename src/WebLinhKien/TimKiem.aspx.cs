using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TimKiem : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Đổ danh sách loại vào DropDownList (giống hàm FillSearchOption - Bài tập chương 5)
            ddlLoai.DataSource = KetNoi.LayDuLieu("SELECT MaLoai, TenLoai FROM tblLoaiSP ORDER BY TenLoai");
            ddlLoai.DataTextField = "TenLoai";
            ddlLoai.DataValueField = "MaLoai";
            ddlLoai.DataBind();
            ddlLoai.Items.Insert(0, new ListItem("-- Tất cả --", "0"));

            // Nhận từ khóa từ ô tìm kiếm trên Master Page
            if (Request.QueryString["tukhoa"] != null)
                txtTuKhoa.Text = Request.QueryString["tukhoa"];

            TimSanPham();
        }
    }

    // Tìm kiếm tương đối: LIKE N'%từ khóa%' trên tên, thông số, mô tả, hãng
    private void TimSanPham()
    {
        string sql = @"SELECT s.MaSP, s.TenSP, s.DonGia, s.HinhAnh, l.TenLoai
                       FROM tblSanPham s
                       JOIN tblLoaiSP l ON l.MaLoai = s.MaLoai
                       JOIN tblHangSX h ON h.MaHang = s.MaHang
                       WHERE s.TrangThai = 1";
        List<SqlParameter> thamSo = new List<SqlParameter>();

        string tuKhoa = txtTuKhoa.Text.Trim();
        if (tuKhoa != "")
        {
            sql += @" AND (s.TenSP LIKE @TuKhoa OR s.ThongSo LIKE @TuKhoa
                          OR s.MoTa LIKE @TuKhoa OR h.TenHang LIKE @TuKhoa)";
            thamSo.Add(new SqlParameter("@TuKhoa", "%" + tuKhoa + "%"));
        }
        if (ddlLoai.SelectedValue != "0")
        {
            sql += " AND s.MaLoai = @MaLoai";
            thamSo.Add(new SqlParameter("@MaLoai", int.Parse(ddlLoai.SelectedValue)));
        }
        decimal gia;
        if (decimal.TryParse(txtGiaTu.Text, out gia))
        {
            sql += " AND s.DonGia >= @GiaTu";
            thamSo.Add(new SqlParameter("@GiaTu", gia));
        }
        if (decimal.TryParse(txtGiaDen.Text, out gia))
        {
            sql += " AND s.DonGia <= @GiaDen";
            thamSo.Add(new SqlParameter("@GiaDen", gia));
        }
        sql += " ORDER BY s.TenSP";

        DataTable dt = KetNoi.LayDuLieu(sql, thamSo.ToArray());
        dlKetQua.DataSource = dt;
        dlKetQua.DataBind();

        if (tuKhoa != "")
            lblKetQua.Text = "Tìm thấy <b>" + dt.Rows.Count + "</b> sản phẩm với từ khóa \"<b>" + Server.HtmlEncode(tuKhoa) + "</b>\"";
        else
            lblKetQua.Text = "Tìm thấy <b>" + dt.Rows.Count + "</b> sản phẩm";
    }

    protected void btnTimKiem_Click(object sender, EventArgs e)
    {
        if (Page.IsValid) TimSanPham();
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
