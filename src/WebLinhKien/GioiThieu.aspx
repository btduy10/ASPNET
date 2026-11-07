<%@ Page Title="Giới thiệu - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GioiThieu.aspx.cs" Inherits="GioiThieu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="banner">
        <h1>Giới thiệu <%= CauHinh.Html("TenCuaHang1") + " " %><%= CauHinh.Html("TenCuaHang2") %></h1>
        <p><%= CauHinh.Html("GT_MoTaBanner") %></p>
    </div>

    <!-- Số liệu thống kê lấy trực tiếp từ CSDL bằng ExecuteScalar -->
    <div class="so-gt">
        <div class="o-so"><asp:Label ID="lblSoSP" runat="server" CssClass="gia-tri"></asp:Label><div class="nhan">Sản phẩm</div></div>
        <div class="o-so"><asp:Label ID="lblSoLoai" runat="server" CssClass="gia-tri"></asp:Label><div class="nhan">Danh mục</div></div>
        <div class="o-so"><asp:Label ID="lblSoHang" runat="server" CssClass="gia-tri"></asp:Label><div class="nhan">Hãng đối tác</div></div>
        <div class="o-so"><asp:Label ID="lblSoDon" runat="server" CssClass="gia-tri"></asp:Label><div class="nhan">Đơn hàng hoàn thành</div></div>
    </div>

    <div class="hop">
        <div class="hop-tieude">Về chúng tôi</div>
        <div class="noi-dung-gt">
            <%= CauHinh.DoanVan("GT_VeChungToi") %>
        </div>
    </div>

    <div class="hai-cot">
        <div class="hop" style="flex:1">
            <div class="hop-tieude">Cam kết</div>
            <%= CauHinh.DanhSach("GT_CamKet") %>
        </div>
        <div class="hop" style="flex:1">
            <div class="hop-tieude">Thông tin liên hệ</div>
            <ul class="ds-gt">
                <li>Địa chỉ: <%= CauHinh.Cum("DiaChi") %></li>
                <li>Hotline: <%= CauHinh.Html("Hotline") %></li>
                <li>Email: <%= CauHinh.Html("Email") %></li>
                <li>Giờ làm việc: <%= CauHinh.Cum("GioLamViec") %></li>
            </ul>
        </div>
    </div>
</asp:Content>
