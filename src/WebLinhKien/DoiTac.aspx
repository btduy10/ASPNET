<%@ Page Title="Đối tác - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DoiTac.aspx.cs" Inherits="DoiTac" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="banner">
        <h1>Đối tác &amp; thương hiệu</h1>
        <p><%= CauHinh.Html("DT_MoTaBanner") %></p>
    </div>

    <h3 class="tieu-de">CÁC HÃNG SẢN XUẤT ĐỐI TÁC (<asp:Label ID="lblSoHang" runat="server"></asp:Label>)</h3>
    <!-- Danh sách hãng đọc từ bảng tblHangSX, hiển thị bằng DataList 3 cột -->
    <asp:DataList ID="dlDoiTac" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" CssClass="ds-sanpham">
        <ItemTemplate>
            <div class="the-doitac">
                <div class="chu-cai"><%# Eval("TenHang").ToString().Substring(0, 1) %></div>
                <div class="ten-hang"><%# Eval("TenHang") %></div>
                <div class="quoc-gia">Quốc gia: <%# Eval("QuocGia") %></div>
                <div class="so-sp"><%# Eval("SoSP") %> sản phẩm đang kinh doanh</div>
                <asp:HyperLink runat="server" CssClass="nut-xem"
                    NavigateUrl='<%# "~/SanPham.aspx?mahang=" + Eval("MaHang") %>'>Xem sản phẩm »</asp:HyperLink>
            </div>
        </ItemTemplate>
    </asp:DataList>

    <div class="hop" style="margin-top:20px">
        <div class="hop-tieude">Trở thành đối tác của <%= CauHinh.Html("TenCuaHang1") + " " %><%= CauHinh.Html("TenCuaHang2") %></div>
        <div class="noi-dung-gt">
            <%= CauHinh.DoanVan("DT_MoiHopTac") %>
        </div>
    </div>
</asp:Content>
