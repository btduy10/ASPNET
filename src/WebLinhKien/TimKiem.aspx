<%@ Page Title="Tìm kiếm - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TimKiem.aspx.cs" Inherits="TimKiem" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">TÌM KIẾM SẢN PHẨM</h3>

    <asp:Panel ID="pnlTim" runat="server" CssClass="thanh-loc" DefaultButton="btnTimKiem">
        Từ khóa:
        <asp:TextBox ID="txtTuKhoa" runat="server" Width="200px" placeholder="VD: cảm biến, esp..."></asp:TextBox>
        &nbsp;Loại:
        <asp:DropDownList ID="ddlLoai" runat="server"></asp:DropDownList>
        &nbsp;Giá từ:
        <asp:TextBox ID="txtGiaTu" runat="server" Width="90px"></asp:TextBox>
        đến
        <asp:TextBox ID="txtGiaDen" runat="server" Width="90px"></asp:TextBox>
        <asp:CompareValidator ID="cvGia" runat="server" ControlToValidate="txtGiaDen" ControlToCompare="txtGiaTu"
            Operator="GreaterThanEqual" Type="Double" ErrorMessage="Giá đến phải lớn hơn hoặc bằng giá từ"
            CssClass="loi" Display="Dynamic" ValidationGroup="Tim"></asp:CompareValidator>
        &nbsp;<asp:Button ID="btnTimKiem" runat="server" Text="Tìm" CssClass="nut nut-cam" ValidationGroup="Tim" OnClick="btnTimKiem_Click" />
    </asp:Panel>

    <p><asp:Label ID="lblKetQua" runat="server"></asp:Label></p>

    <asp:DataList ID="dlKetQua" runat="server" OnItemCommand="dsSanPham_ItemCommand" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ds-sanpham">
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
                <div class="ton"><%# Eval("TenLoai") %></div>
            </div>
        </ItemTemplate>
    </asp:DataList>
</asp:Content>
