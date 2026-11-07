<%@ Page Title="Đăng nhập - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DangNhap.aspx.cs" Inherits="DangNhap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">ĐĂNG NHẬP</h3>
    <asp:Panel ID="pnlDangNhap" runat="server" CssClass="form" DefaultButton="btnDangNhap" style="max-width:640px">
        <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao tb-loi"></asp:Label>
        <table>
            <tr>
                <td class="nhan">Tên đăng nhập</td>
                <td>
                    <asp:TextBox ID="txtUsername" runat="server" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Vui lòng nhập tên đăng nhập" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="nhan">Mật khẩu</td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Vui lòng nhập mật khẩu" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><asp:CheckBox ID="chkGhiNho" runat="server" Text=" Ghi nhớ tên đăng nhập" /></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="btnDangNhap" runat="server" Text="Đăng nhập" CssClass="nut nut-cam" OnClick="btnDangNhap_Click" />
                    &nbsp; Chưa có tài khoản? <asp:HyperLink ID="hlDangKy" runat="server" NavigateUrl="~/DangKy.aspx">Đăng ký ngay</asp:HyperLink>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
