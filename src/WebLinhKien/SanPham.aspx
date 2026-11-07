<%@ Page Title="Sản phẩm - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="SanPham.aspx.cs" Inherits="SanPham" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de"><asp:Label ID="lblTieuDe" runat="server" Text="TẤT CẢ SẢN PHẨM"></asp:Label></h3>

    <div class="thanh-loc">
        Sắp xếp theo:
        <asp:DropDownList ID="ddlSapXep" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSapXep_SelectedIndexChanged">
            <asp:ListItem Value="moi">Mới nhất</asp:ListItem>
            <asp:ListItem Value="giatang">Giá tăng dần</asp:ListItem>
            <asp:ListItem Value="giagiam">Giá giảm dần</asp:ListItem>
            <asp:ListItem Value="ten">Tên A - Z</asp:ListItem>
        </asp:DropDownList>
        &nbsp; <asp:Label ID="lblSoKetQua" runat="server"></asp:Label>
    </div>

    <asp:DataList ID="dlSanPham" runat="server" OnItemCommand="dsSanPham_ItemCommand" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ds-sanpham">
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
                <div class="ton"><%# Eval("TenHang") %> - <%# TienIch.TinhTrangKho(Eval("SoLuongTon")) %></div>
            </div>
        </ItemTemplate>
    </asp:DataList>

    <!-- Phân trang bằng PagedDataSource -->
    <div class="phan-trang">
        <asp:Button ID="btnTruoc" runat="server" Text="« Trang trước" CssClass="nut nut-xam" OnClick="btnTruoc_Click" />
        <asp:Label ID="lblTrang" runat="server"></asp:Label>
        <asp:Button ID="btnSau" runat="server" Text="Trang sau »" CssClass="nut nut-xam" OnClick="btnSau_Click" />
    </div>
</asp:Content>
