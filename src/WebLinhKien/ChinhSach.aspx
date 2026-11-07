<%@ Page Title="Chính sách & hướng dẫn - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ChinhSach.aspx.cs" Inherits="ChinhSach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">CHÍNH SÁCH &amp; HƯỚNG DẪN</h3>
    <div class="cs-muc-luc">
        <a href="#huong-dan">Hướng dẫn mua hàng</a>
        <a href="#giao-dich">Điều kiện giao dịch</a>
        <a href="#bao-mat">Bảo mật thông tin</a>
        <a href="#thanh-toan">Thanh toán</a>
        <a href="#doi-tra">Giao nhận, đổi trả</a>
    </div>

    <div id="huong-dan" class="hop cs-muc">
        <div class="hop-tieude">Hướng dẫn mua hàng</div>
        <%= CauHinh.DanhSach("CS_HuongDan") %>
    </div>

    <div id="giao-dich" class="hop cs-muc">
        <div class="hop-tieude">Điều kiện giao dịch chung</div>
        <%= CauHinh.DanhSach("CS_GiaoDich") %>
    </div>

    <div id="bao-mat" class="hop cs-muc">
        <div class="hop-tieude">Chính sách bảo mật thông tin</div>
        <%= CauHinh.DanhSach("CS_BaoMat") %>
    </div>

    <div id="thanh-toan" class="hop cs-muc">
        <div class="hop-tieude">Chính sách thanh toán</div>
        <%= CauHinh.DanhSach("CS_ThanhToan") %>
    </div>

    <div id="doi-tra" class="hop cs-muc">
        <div class="hop-tieude">Chính sách giao nhận, đổi trả và hoàn tiền</div>
        <%= CauHinh.DanhSach("CS_DoiTra") %>
    </div>
</asp:Content>
