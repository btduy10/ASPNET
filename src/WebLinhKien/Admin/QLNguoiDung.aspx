<%@ Page Title="Quản lý người dùng" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLNguoiDung.aspx.cs" Inherits="Admin_QLNguoiDung" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">QUẢN LÝ NGƯỜI DÙNG</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <asp:Panel ID="pnlLoc" runat="server" CssClass="thanh-loc" DefaultButton="btnLoc">
        Từ khóa: <asp:TextBox ID="txtTim" runat="server" Width="240px" placeholder="Tên đăng nhập, họ tên, email..."></asp:TextBox>
        &nbsp;Vai trò:
        <asp:DropDownList ID="ddlRole" runat="server">
            <asp:ListItem Value="">-- Tất cả --</asp:ListItem>
            <asp:ListItem Value="Admin">Admin</asp:ListItem>
            <asp:ListItem Value="KhachHang">Khách hàng</asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnLoc" runat="server" Text="Lọc" CssClass="nut" OnClick="btnLoc_Click" />
    </asp:Panel>

    <asp:GridView ID="gvUser" runat="server" AutoGenerateColumns="False" DataKeyNames="Username"
        AllowPaging="True" PageSize="10" OnRowCommand="gvUser_RowCommand" OnRowDeleting="gvUser_RowDeleting"
        OnPageIndexChanging="gvUser_PageIndexChanging" OnRowDataBound="gvUser_RowDataBound">
        <Columns>
            <asp:BoundField DataField="Username" HeaderText="Tên đăng nhập" />
            <asp:BoundField DataField="HoTen" HeaderText="Họ tên" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="DienThoai" HeaderText="Điện thoại" />
            <asp:BoundField DataField="Role" HeaderText="Vai trò" />
            <asp:BoundField DataField="SoDon" HeaderText="Số đơn" ItemStyle-CssClass="so" />
            <asp:TemplateField HeaderText="Trạng thái">
                <ItemTemplate><%# (bool)Eval("TrangThai") ? "Hoạt động" : "<span style='color:#c0392b'>Đã khóa</span>" %></ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Thao tác">
                <ItemTemplate>
                    <asp:LinkButton ID="lbtKhoa" runat="server" CommandName="KhoaMo" CommandArgument='<%# Eval("Username") %>'
                        Text='<%# (bool)Eval("TrangThai") ? "Khóa" : "Mở khóa" %>'></asp:LinkButton> |
                    <asp:LinkButton ID="lbtQuyen" runat="server" CommandName="DoiQuyen" CommandArgument='<%# Eval("Username") %>'
                        Text="Đổi quyền"></asp:LinkButton> |
                    <asp:LinkButton ID="lbtReset" runat="server" CommandName="DatLaiMK" CommandArgument='<%# Eval("Username") %>'
                        Text="Đặt lại MK" OnClientClick="return confirm('Đặt lại mật khẩu về 123456?');"></asp:LinkButton> |
                    <asp:LinkButton ID="lbtXoa" runat="server" CommandName="Delete" Text="Xóa"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
