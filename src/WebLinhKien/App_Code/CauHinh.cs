using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

/// <summary>
/// Lớp CauHinh: đọc thông tin hiển thị của website từ bảng tblCauHinh.
/// Toàn bộ cấu hình được nạp 1 lần và lưu trong biến Application (dùng chung cho mọi người dùng),
/// khi Admin lưu thay đổi thì gọi LamMoi() để nạp lại.
/// </summary>
public static class CauHinh
{
    private const string KHOA_APP = "CauHinhWebsite";

    private static Dictionary<string, string> TatCa()
    {
        HttpApplicationState app = HttpContext.Current.Application;
        Dictionary<string, string> ds = app[KHOA_APP] as Dictionary<string, string>;
        if (ds == null)
        {
            ds = new Dictionary<string, string>();
            DataTable dt = KetNoi.LayDuLieu("SELECT MaCH, GiaTri FROM tblCauHinh");
            foreach (DataRow dong in dt.Rows)
                ds[dong["MaCH"].ToString()] = dong["GiaTri"] == DBNull.Value ? "" : dong["GiaTri"].ToString();
            app.Lock();
            app[KHOA_APP] = ds;
            app.UnLock();
        }
        return ds;
    }

    // Xóa bộ nhớ đệm để lần sau nạp lại từ CSDL (gọi sau khi Admin lưu)
    public static void LamMoi()
    {
        HttpApplicationState app = HttpContext.Current.Application;
        app.Lock();
        app.Remove(KHOA_APP);
        app.UnLock();
    }

    // Giá trị thô (dùng trong code-behind)
    public static string Lay(string ma)
    {
        string giaTri;
        return TatCa().TryGetValue(ma, out giaTri) ? giaTri : "";
    }

    // Giá trị đã mã hóa HTML; **chữ** được in đậm
    public static string Html(string ma)
    {
        return DinhDang(Lay(ma));
    }

    // Dùng cho thuộc tính href của liên kết
    public static string Url(string ma)
    {
        string v = Lay(ma).Trim();
        return HttpUtility.HtmlAttributeEncode(v == "" ? "#" : v);
    }

    // Thông tin ngắn (địa chỉ, giờ làm việc): chỉ cho xuống dòng tại dấu phẩy,
    // mỗi cụm giữa hai dấu phẩy luôn nằm trên một dòng -> không bị tách từ ghép như "Vĩnh / Long"
    public static string Cum(string ma)
    {
        string[] cacCum = Lay(ma).Split(',');
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cacCum.Length; i++)
        {
            string cum = cacCum[i].Trim();
            if (cum == "") continue;
            if (sb.Length > 0) sb.Append(", ");
            // Cụm quá dài (trên 32 ký tự) vẫn cho xuống dòng bình thường để không tràn khung
            sb.Append(cum.Length <= 32 ? "<span class=\"cum\">" + DinhDang(cum) + "</span>" : DinhDang(cum));
        }
        return sb.ToString();
    }

    // Đường dẫn ảnh (cho phép dạng ~/Images/...); trả về "" nếu chưa nhập
    public static string Anh(string ma)
    {
        string v = Lay(ma).Trim();
        if (v == "") return "";
        if (v.StartsWith("~")) v = VirtualPathUtility.ToAbsolute(v);
        return HttpUtility.HtmlAttributeEncode(v);
    }

    // Trạng thái mở cửa tính theo giờ hiện tại của máy chủ (GioMoCua, GioDongCua, NgayLamViec)
    public static string TrangThaiMoCua()
    {
        TimeSpan mo, dong;
        if (!TimeSpan.TryParse(Lay("GioMoCua"), out mo) || !TimeSpan.TryParse(Lay("GioDongCua"), out dong))
            return Cum("GioLamViec");

        DateTime bayGio = DateTime.Now;
        // Quy ước: Thứ 2 = 2 ... Thứ 7 = 7, Chủ Nhật = 8
        int thu = bayGio.DayOfWeek == DayOfWeek.Sunday ? 8 : (int)bayGio.DayOfWeek + 1;
        bool homNayLamViec = ("," + Lay("NgayLamViec").Replace(" ", "") + ",").Contains("," + thu + ",");
        string gioMo = mo.ToString(@"hh\:mm"), gioDong = dong.ToString(@"hh\:mm");

        if (homNayLamViec && bayGio.TimeOfDay >= mo && bayGio.TimeOfDay < dong)
            return "<span class=\"zl-mo\">Đang mở cửa</span> • Đóng cửa lúc " + gioDong;
        return "<span class=\"zl-dong\">Đã đóng cửa</span> • Mở cửa lúc " + gioMo;
    }

    // Mỗi dòng thành 1 đoạn văn <p>
    public static string DoanVan(string ma)
    {
        StringBuilder sb = new StringBuilder();
        foreach (string dong in TachDong(ma)) sb.Append("<p>").Append(DinhDang(dong)).Append("</p>");
        return sb.ToString();
    }

    // Mỗi dòng thành 1 gạch đầu dòng <li>
    public static string DanhSach(string ma)
    {
        StringBuilder sb = new StringBuilder("<ul class=\"ds-gt\">");
        foreach (string dong in TachDong(ma)) sb.Append("<li>").Append(DinhDang(dong)).Append("</li>");
        return sb.Append("</ul>").ToString();
    }

    private static List<string> TachDong(string ma)
    {
        List<string> kq = new List<string>();
        foreach (string dong in Lay(ma).Replace("\r", "").Split('\n'))
            if (dong.Trim() != "") kq.Add(dong.Trim());
        return kq;
    }

    // Mã hóa HTML (chống chèn mã) rồi đổi **chữ** thành <b>chữ</b>
    private static string DinhDang(string s)
    {
        string html = HttpUtility.HtmlEncode(s.Replace("\r", "")).Replace("\n", "<br />");
        return Regex.Replace(html, @"\*\*(.+?)\*\*", "<b>$1</b>");
    }
}
