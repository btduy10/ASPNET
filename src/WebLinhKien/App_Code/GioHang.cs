using System;
using System.Data;
using System.Web;

/// <summary>
/// Lớp GioHang: quản lý giỏ hàng lưu trong Session (Chương 7 - Quản lý trạng thái).
/// Giỏ hàng là một DataTable gồm các cột: MaSP, TenSP, HinhAnh, DonGia, SoLuong, ThanhTien.
/// </summary>
public class GioHang
{
    private const string KHOA_SESSION = "GioHang";

    // Lấy giỏ hàng hiện tại, nếu chưa có thì tạo mới
    public static DataTable LayGioHang()
    {
        DataTable gio = HttpContext.Current.Session[KHOA_SESSION] as DataTable;
        if (gio == null)
        {
            gio = new DataTable();
            gio.Columns.Add("MaSP", typeof(int));
            gio.Columns.Add("TenSP", typeof(string));
            gio.Columns.Add("HinhAnh", typeof(string));
            gio.Columns.Add("DonGia", typeof(decimal));
            gio.Columns.Add("SoLuong", typeof(int));
            // Cột biểu thức: tự tính thành tiền
            gio.Columns.Add("ThanhTien", typeof(decimal), "DonGia * SoLuong");
            gio.PrimaryKey = new DataColumn[] { gio.Columns["MaSP"] };
            HttpContext.Current.Session[KHOA_SESSION] = gio;
        }
        return gio;
    }

    // Thêm sản phẩm vào giỏ; nếu đã có thì cộng dồn số lượng
    public static void Them(int maSP, string tenSP, string hinhAnh, decimal donGia, int soLuong)
    {
        DataTable gio = LayGioHang();
        DataRow dong = gio.Rows.Find(maSP);
        if (dong != null)
        {
            dong["SoLuong"] = (int)dong["SoLuong"] + soLuong;
        }
        else
        {
            dong = gio.NewRow();
            dong["MaSP"] = maSP;
            dong["TenSP"] = tenSP;
            dong["HinhAnh"] = hinhAnh;
            dong["DonGia"] = donGia;
            dong["SoLuong"] = soLuong;
            gio.Rows.Add(dong);
        }
    }

    // Cập nhật số lượng; số lượng <= 0 thì xóa khỏi giỏ
    public static void CapNhat(int maSP, int soLuong)
    {
        DataRow dong = LayGioHang().Rows.Find(maSP);
        if (dong == null) return;
        if (soLuong <= 0) dong.Delete();
        else dong["SoLuong"] = soLuong;
        LayGioHang().AcceptChanges();
    }

    // Xóa một sản phẩm khỏi giỏ
    public static void Xoa(int maSP)
    {
        DataRow dong = LayGioHang().Rows.Find(maSP);
        if (dong != null)
        {
            dong.Delete();
            LayGioHang().AcceptChanges();
        }
    }

    // Lấy số lượng của 1 sản phẩm đang có trong giỏ
    public static int SoLuongCuaSP(int maSP)
    {
        DataRow dong = LayGioHang().Rows.Find(maSP);
        return dong == null ? 0 : (int)dong["SoLuong"];
    }

    // Xóa toàn bộ giỏ hàng (sau khi đặt hàng thành công)
    public static void XoaHet()
    {
        HttpContext.Current.Session.Remove(KHOA_SESSION);
    }

    public static int TongSoLuong()
    {
        object tong = LayGioHang().Compute("SUM(SoLuong)", "");
        return tong == DBNull.Value ? 0 : Convert.ToInt32(tong);
    }

    public static decimal TongTien()
    {
        object tong = LayGioHang().Compute("SUM(ThanhTien)", "");
        return tong == DBNull.Value ? 0 : Convert.ToDecimal(tong);
    }
}
