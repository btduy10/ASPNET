<%@ Page Title="Trang chủ - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="banner">
        <h1><%= CauHinh.Html("BannerTieuDe") %></h1>
        <p><%= CauHinh.Html("BannerMoTa") %></p>
    </div>

    <h3 class="tieu-de">SẢN PHẨM MỚI</h3>
    <asp:DataList ID="dlSanPhamMoi" runat="server" OnItemCommand="dsSanPham_ItemCommand" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ds-sanpham">
        <ItemTemplate>
            <div class="the-sp">
                <!-- Nút giỏ hàng: chỉ hiện khi rà chuột vào thẻ sản phẩm -->
                <asp:LinkButton runat="server" CssClass="nut-them-gio" CommandName="ThemGio" CommandArgument='<%# Eval("MaSP") %>'
                    CausesValidation="false" ToolTip="Thêm vào giỏ hàng"><span>Thêm vào giỏ</span></asp:LinkButton>
                <a href='ChiTiet.aspx?masp=<%# Eval("MaSP") %>'>
                    <img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt='<%# Eval("TenSP") %>' />
                    <span class="ten"><%# Eval("TenSP") %></span>
                </a>
                <div class="gia"><%# TienIch.Tien(Eval("DonGia")) %></div>
                <div class="ton"><%# TienIch.TinhTrangKho(Eval("SoLuongTon")) %></div>
            </div>
        </ItemTemplate>
    </asp:DataList>

    <h3 class="tieu-de" style="margin-top:20px">SẢN PHẨM BÁN CHẠY</h3>
    <asp:DataList ID="dlBanChay" runat="server" OnItemCommand="dsSanPham_ItemCommand" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ds-sanpham">
        <ItemTemplate>
            <div class="the-sp">
                <!-- Nút giỏ hàng: chỉ hiện khi rà chuột vào thẻ sản phẩm -->
                <asp:LinkButton runat="server" CssClass="nut-them-gio" CommandName="ThemGio" CommandArgument='<%# Eval("MaSP") %>'
                    CausesValidation="false" ToolTip="Thêm vào giỏ hàng"><span>Thêm vào giỏ</span></asp:LinkButton>
                <a href='ChiTiet.aspx?masp=<%# Eval("MaSP") %>'>
                    <img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt='<%# Eval("TenSP") %>' />
                    <span class="ten"><%# Eval("TenSP") %></span>
                </a>
                <div class="gia"><%# TienIch.Tien(Eval("DonGia")) %></div>
                <div class="ton">Đã bán: <%# Eval("DaBan") %></div>
            </div>
        </ItemTemplate>
    </asp:DataList>
</asp:Content>
