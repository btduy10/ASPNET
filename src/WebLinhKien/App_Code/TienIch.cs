using System;
using System.Configuration;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Các hàm tiện ích dùng trong biểu thức liên kết dữ liệu &lt;%# ... %&gt;
/// </summary>
public class TienIch
{
    // Định dạng tiền Việt Nam: 650000 -> "650.000 đ"
    public static string Tien(object giaTri)
    {
        decimal so = KetNoi.SoThuc(giaTri);
        return so.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + " đ";
    }

    // Trả về đường dẫn tuyệt đối tới hình sản phẩm
    public static string Hinh(object tenFile)
    {
        string thuMuc = ConfigurationManager.AppSettings["ThuMucHinh"];
        string ten = (tenFile == null || tenFile == DBNull.Value || tenFile.ToString() == "")
                     ? "no-image.png" : tenFile.ToString();
        return VirtualPathUtility.ToAbsolute(thuMuc + ten);
    }

    // Hiển thị tình trạng kho
    public static string TinhTrangKho(object soLuong)
    {
        int sl = KetNoi.SoNguyen(soLuong);
        if (sl <= 0) return "Hết hàng";
        if (sl < 10) return "Sắp hết (còn " + sl + ")";
        return "Còn hàng";
    }

    // Gắn hộp thoại xác nhận cho nút "Xóa" của CommandField trong GridView
    public static void GanXacNhanXoa(GridViewRow dong)
    {
        if (dong.RowType != DataControlRowType.DataRow) return;
        foreach (TableCell o in dong.Cells)
            foreach (Control c in o.Controls)
            {
                LinkButton nut = c as LinkButton;
                if (nut != null && nut.CommandName == "Delete")
                    nut.OnClientClick = "return confirm('Bạn chắc chắn muốn xóa?');";
            }
    }

    // Đổi mã hình thức thanh toán thành tên hiển thị
    public static string TenHinhThucTT(object ma)
    {
        string s = ma == null ? "" : ma.ToString();
        if (s == "Chuyển khoản") return "Chuyển khoản ngân hàng";
        if (s == "COD") return "Thanh toán khi nhận hàng (COD)";
        return s;
    }
}
