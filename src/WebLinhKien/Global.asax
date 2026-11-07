<%@ Application Language="C#" %>

<script runat="server">
    // Chương 7 - II. Application State & III. Tập tin global.asax

    void Application_Start(object sender, EventArgs e)
    {
        Application["SoLuotTruyCap"] = 0;   // tổng lượt truy cập từ khi khởi động
        Application["DangOnline"] = 0;      // số người đang online
    }

    void Session_Start(object sender, EventArgs e)
    {
        Application.Lock();
        Application["SoLuotTruyCap"] = (int)Application["SoLuotTruyCap"] + 1;
        Application["DangOnline"] = (int)Application["DangOnline"] + 1;
        Application.UnLock();
    }

    void Session_End(object sender, EventArgs e)
    {
        Application.Lock();
        int dangOnline = (int)Application["DangOnline"] - 1;
        Application["DangOnline"] = dangOnline < 0 ? 0 : dangOnline;
        Application.UnLock();
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Có thể ghi log lỗi tại đây
    }
</script>
