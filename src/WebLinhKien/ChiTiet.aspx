<%@ Page Title="Chi tiết sản phẩm - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ChiTiet.aspx.cs" Inherits="ChiTiet" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <!-- FormView hiển thị chi tiết 1 sản phẩm (Chương 6 - IV. FormView) -->
    <asp:FormView ID="fvSanPham" runat="server" RenderOuterTable="false">
        <ItemTemplate>
            <div class="chitiet">
                <div class="anh">
                    <img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt='<%# Eval("TenSP") %>' />
                </div>
                <div style="flex:1">
                    <h2><%# Eval("TenSP") %></h2>
                    <div>Mã SP: <b>SP<%# Eval("MaSP", "{0:000}") %></b> &nbsp;|&nbsp;
                         Loại: <a href='SanPham.aspx?maloai=<%# Eval("MaLoai") %>'><%# Eval("TenLoai") %></a> &nbsp;|&nbsp;
                         Hãng: <a href='SanPham.aspx?mahang=<%# Eval("MaHang") %>'><%# Eval("TenHang") %></a></div>
                    <div class="gia-lon"><%# TienIch.Tien(Eval("DonGia")) %></div>
                    <div>Tình trạng: <b><%# TienIch.TinhTrangKho(Eval("SoLuongTon")) %></b></div>
                    <div class="thong-so"><b>Thông số kỹ thuật:</b><br /><%# Eval("ThongSo") %></div>
                    <div><%# Eval("MoTa") %></div>
                </div>
            </div>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="thong-bao tb-loi">Không tìm thấy sản phẩm hoặc sản phẩm đã ngừng kinh doanh.</div>
        </EmptyDataTemplate>
    </asp:FormView>

    <!-- Khu vực chọn số lượng và thêm vào giỏ -->
    <asp:Panel ID="pnlMuaHang" runat="server" CssClass="form mua-hang" DefaultButton="btnThemGio">
        Số lượng:
        <asp:TextBox ID="txtSoLuong" runat="server" Text="1" CssClass="so-luong"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvSoLuong" runat="server" ControlToValidate="txtSoLuong"
            ErrorMessage="Vui lòng nhập số lượng" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
        <asp:RangeValidator ID="rvSoLuong" runat="server" ControlToValidate="txtSoLuong" Type="Integer"
            MinimumValue="1" MaximumValue="1" CssClass="loi" Display="Dynamic"></asp:RangeValidator>
        &nbsp;
        <asp:Button ID="btnThemGio" runat="server" Text="Thêm vào giỏ hàng" CssClass="nut nut-cam" OnClick="btnThemGio_Click" />
        <asp:Button ID="btnMuaNgay" runat="server" Text="Mua ngay" CssClass="nut" OnClick="btnMuaNgay_Click" />
    </asp:Panel>

    <h3 class="tieu-de" style="margin-top:22px">SẢN PHẨM CÙNG LOẠI</h3>
    <asp:DataList ID="dlCungLoai" runat="server" OnItemCommand="dsSanPham_ItemCommand" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ds-sanpham">
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
            </div>
        </ItemTemplate>
    </asp:DataList>
</asp:Content>
