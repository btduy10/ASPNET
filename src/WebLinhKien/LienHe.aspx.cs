using System;
using System.Web;
using System.Web.UI;

// Trang Thông tin liên hệ: địa chỉ, giờ làm việc, hotline, email, Zalo, Facebook và bản đồ
public partial class LienHe : Page
{
    // Từ khóa tìm vị trí trên bản đồ: ưu tiên mục "LH_BanDo", nếu trống thì dùng địa chỉ cửa hàng
    protected string TuKhoaBanDo
    {
        get
        {
            string q = CauHinh.Lay("LH_BanDo").Trim();
            if (q == "") q = CauHinh.Lay("DiaChi");
            return HttpUtility.HtmlAttributeEncode(q);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Master.HienCotTrai = false;   // dùng toàn bộ chiều ngang
    }
}
