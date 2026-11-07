<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucDanhMuc.ascx.cs" Inherits="UserControls_ucDanhMuc" %>
<%-- User Control danh mục (Chương 7 - Bài 2 - I. User controls)
     Dùng Repeater để liên kết dữ liệu có lặp (Chương 5 - Bài 4 - 2.2) --%>

<div class="hop">
    <div class="hop-tieude">DANH MỤC SẢN PHẨM</div>
    <ul>
        <asp:Repeater ID="rptLoai" runat="server">
            <ItemTemplate>
                <li>
                    <a href='<%# ResolveUrl("~/SanPham.aspx?maloai=" + Eval("MaLoai")) %>'>
                        <%# Eval("TenLoai") %> (<%# Eval("SoSP") %>)
                    </a>
                </li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</div>

<div class="hop">
    <div class="hop-tieude">THƯƠNG HIỆU</div>
    <ul>
        <asp:Repeater ID="rptHang" runat="server">
            <ItemTemplate>
                <li>
                    <a href='<%# ResolveUrl("~/SanPham.aspx?mahang=" + Eval("MaHang")) %>'>
                        <%# Eval("TenHang") %>
                    </a>
                </li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</div>
