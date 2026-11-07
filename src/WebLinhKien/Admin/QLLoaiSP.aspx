<%@ Page Title="Quản lý loại sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLLoaiSP.aspx.cs" Inherits="Admin_QLLoaiSP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">QUẢN LÝ LOẠI SẢN PHẨM</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <!-- Form thêm mới -->
    <asp:Panel ID="pnlThem" runat="server" CssClass="thanh-loc" DefaultButton="btnThem">
        Tên loại:
        <asp:TextBox ID="txtTenLoai" runat="server" MaxLength="100" Width="220px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvTenLoai" runat="server" ControlToValidate="txtTenLoai" ValidationGroup="Them"
            ErrorMessage="Chưa nhập tên loại" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
        &nbsp;Mô tả:
        <asp:TextBox ID="txtMoTa" runat="server" MaxLength="255" Width="320px"></asp:TextBox>
        <asp:Button ID="btnThem" runat="server" Text="+ Thêm loại" CssClass="nut" ValidationGroup="Them" OnClick="btnThem_Click" />
    </asp:Panel>

    <!-- GridView có chức năng Sửa / Xóa trực tiếp (Chương 6 - 2.3 Sự kiện trong GridView) -->
    <asp:GridView ID="gvLoai" runat="server" AutoGenerateColumns="False" DataKeyNames="MaLoai"
        AllowPaging="True" PageSize="10"
        OnRowEditing="gvLoai_RowEditing" OnRowCancelingEdit="gvLoai_RowCancelingEdit"
        OnRowUpdating="gvLoai_RowUpdating" OnRowDeleting="gvLoai_RowDeleting"
        OnPageIndexChanging="gvLoai_PageIndexChanging" OnRowDataBound="gvLoai_RowDataBound">
        <Columns>
            <asp:BoundField DataField="MaLoai" HeaderText="Mã loại" ReadOnly="True" ItemStyle-Width="80px" />
            <asp:TemplateField HeaderText="Tên loại">
                <ItemTemplate><%# Eval("TenLoai") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtSuaTen" runat="server" Text='<%# Bind("TenLoai") %>' MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSuaTen" runat="server" ControlToValidate="txtSuaTen" ValidationGroup="Sua"
                        ErrorMessage="Không được để trống" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Mô tả">
                <ItemTemplate><%# Eval("MoTa") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtSuaMoTa" runat="server" Text='<%# Bind("MoTa") %>' MaxLength="255"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="SoSP" HeaderText="Số SP" ReadOnly="True" ItemStyle-CssClass="so" />
            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" EditText="Sửa" DeleteText="Xóa"
                UpdateText="Lưu" CancelText="Hủy" ValidationGroup="Sua" />
        </Columns>
    </asp:GridView>
</asp:Content>
