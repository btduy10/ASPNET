<%@ Page Title="Quản lý hãng sản xuất" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLHangSX.aspx.cs" Inherits="Admin_QLHangSX" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">QUẢN LÝ HÃNG SẢN XUẤT</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <!-- Form thêm mới -->
    <asp:Panel ID="pnlThem" runat="server" CssClass="thanh-loc" DefaultButton="btnThem">
        Tên hãng:
        <asp:TextBox ID="txtTenHang" runat="server" MaxLength="100" Width="220px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvTenHang" runat="server" ControlToValidate="txtTenHang" ValidationGroup="Them"
            ErrorMessage="Chưa nhập tên hãng" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
        &nbsp;Quốc gia:
        <asp:TextBox ID="txtQuocGia" runat="server" MaxLength="50" Width="320px"></asp:TextBox>
        <asp:Button ID="btnThem" runat="server" Text="+ Thêm hãng" CssClass="nut" ValidationGroup="Them" OnClick="btnThem_Click" />
    </asp:Panel>

    <!-- GridView có chức năng Sửa / Xóa trực tiếp (Chương 6 - 2.3 Sự kiện trong GridView) -->
    <asp:GridView ID="gvHang" runat="server" AutoGenerateColumns="False" DataKeyNames="MaHang"
        AllowPaging="True" PageSize="10"
        OnRowEditing="gvHang_RowEditing" OnRowCancelingEdit="gvHang_RowCancelingEdit"
        OnRowUpdating="gvHang_RowUpdating" OnRowDeleting="gvHang_RowDeleting"
        OnPageIndexChanging="gvHang_PageIndexChanging" OnRowDataBound="gvHang_RowDataBound">
        <Columns>
            <asp:BoundField DataField="MaHang" HeaderText="Mã hãng" ReadOnly="True" ItemStyle-Width="80px" />
            <asp:TemplateField HeaderText="Tên hãng">
                <ItemTemplate><%# Eval("TenHang") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtSuaTen" runat="server" Text='<%# Bind("TenHang") %>' MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSuaTen" runat="server" ControlToValidate="txtSuaTen" ValidationGroup="Sua"
                        ErrorMessage="Không được để trống" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Quốc gia">
                <ItemTemplate><%# Eval("QuocGia") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtSuaQuocGia" runat="server" Text='<%# Bind("QuocGia") %>' MaxLength="50"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="SoSP" HeaderText="Số SP" ReadOnly="True" ItemStyle-CssClass="so" />
            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" EditText="Sửa" DeleteText="Xóa"
                UpdateText="Lưu" CancelText="Hủy" ValidationGroup="Sua" />
        </Columns>
    </asp:GridView>
</asp:Content>
