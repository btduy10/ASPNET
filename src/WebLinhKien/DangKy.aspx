<%@ Page Title="Đăng ký tài khoản - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DangKy.aspx.cs" Inherits="DangKy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">ĐĂNG KÝ TÀI KHOẢN KHÁCH HÀNG</h3>
    <asp:Panel ID="pnlDangKy" runat="server" CssClass="form" DefaultButton="btnDangKy">
        <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>
        <!-- Tổng hợp lỗi (Chương 3 - Bài 3 - Điều khiển kiểm tra nhập liệu) -->
        <asp:ValidationSummary ID="vsDangKy" runat="server" CssClass="tom-tat-loi"
            HeaderText="Vui lòng kiểm tra lại các thông tin sau:" DisplayMode="BulletList" />
        <table>
            <tr>
                <td class="nhan">Tên đăng nhập (*)</td>
                <td>
                    <asp:TextBox ID="txtUsername" runat="server" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Chưa nhập tên đăng nhập" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername"
                        ValidationExpression="^[a-zA-Z0-9_]{4,50}$" ErrorMessage="Tên đăng nhập từ 4 - 50 ký tự, chỉ gồm chữ không dấu, số, dấu _"
                        Text="Tên đăng nhập từ 4 - 50 ký tự, chỉ gồm chữ không dấu, số, dấu _" CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>
                    <asp:CustomValidator ID="cvUsername" runat="server" ControlToValidate="txtUsername"
                        OnServerValidate="cvUsername_ServerValidate" ErrorMessage="Tên đăng nhập đã tồn tại"
                        Text="Tên đăng nhập đã tồn tại" CssClass="loi" Display="Dynamic"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Mật khẩu (*)</td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Chưa nhập mật khẩu" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                        ValidationExpression="^.{6,}$" ErrorMessage="Mật khẩu phải có ít nhất 6 ký tự"
                        Text="Mật khẩu phải có ít nhất 6 ký tự" CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Nhập lại mật khẩu (*)</td>
                <td>
                    <asp:TextBox ID="txtNhapLai" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNhapLai" runat="server" ControlToValidate="txtNhapLai"
                        ErrorMessage="Chưa nhập lại mật khẩu" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvNhapLai" runat="server" ControlToValidate="txtNhapLai" ControlToCompare="txtPassword"
                        ErrorMessage="Mật khẩu nhập lại không khớp" Text="Mật khẩu nhập lại không khớp" CssClass="loi" Display="Dynamic"></asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Họ và tên (*)</td>
                <td>
                    <asp:TextBox ID="txtHoTen" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHoTen" runat="server" ControlToValidate="txtHoTen"
                        ErrorMessage="Chưa nhập họ tên" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Email (*)</td>
                <td>
                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Chưa nhập email" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[\w\.\-]+@[\w\-]+(\.[\w\-]+)+$" ErrorMessage="Email không đúng định dạng"
                        Text="Email không đúng định dạng" CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>
                    <asp:CustomValidator ID="cvEmail" runat="server" ControlToValidate="txtEmail"
                        OnServerValidate="cvEmail_ServerValidate" ErrorMessage="Email đã được sử dụng"
                        Text="Email đã được sử dụng" CssClass="loi" Display="Dynamic"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Điện thoại (*)</td>
                <td>
                    <asp:TextBox ID="txtDienThoai" runat="server" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDienThoai" runat="server" ControlToValidate="txtDienThoai"
                        ErrorMessage="Chưa nhập số điện thoại" Text="*" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revDienThoai" runat="server" ControlToValidate="txtDienThoai"
                        ValidationExpression="^0\d{9}$" ErrorMessage="Số điện thoại gồm 10 chữ số, bắt đầu bằng 0"
                        Text="Số điện thoại gồm 10 chữ số, bắt đầu bằng 0" CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Địa chỉ</td>
                <td><asp:TextBox ID="txtDiaChi" runat="server" MaxLength="200" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="btnDangKy" runat="server" Text="Đăng ký" CssClass="nut nut-cam" OnClick="btnDangKy_Click" />
                    <asp:Button ID="btnNhapLai" runat="server" Text="Nhập lại" CssClass="nut nut-xam" CausesValidation="false" OnClick="btnNhapLai_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
