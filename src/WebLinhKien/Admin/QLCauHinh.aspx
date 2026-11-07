<%@ Page Title="Cấu hình website" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLCauHinh.aspx.cs" Inherits="Admin_QLCauHinh" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">CẤU HÌNH WEBSITE</h3>
    <p class="ch-huong-dan">Chỉnh sửa các thông tin hiển thị trên website (dữ liệu lưu trong bảng <b>tblCauHinh</b>).
        Ô nhiều dòng: <b>mỗi dòng</b> là một đoạn văn hoặc một gạch đầu dòng. Viết <b>**chữ**</b> để in đậm.</p>

    <div class="ch-nhom">
        <!-- Repeater hiển thị các nhóm cấu hình dạng tab -->
        <asp:Repeater ID="rptNhom" runat="server" OnItemCommand="rptNhom_ItemCommand">
            <ItemTemplate>
                <asp:LinkButton runat="server" CommandName="ChonNhom" CommandArgument='<%# Eval("Nhom") %>'
                    CssClass='<%# Eval("Nhom").ToString() == NhomDangChon ? "chon" : "" %>'><%# Eval("Nhom") %></asp:LinkButton>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <div class="form ch-form">
        <asp:Repeater ID="rptCauHinh" runat="server">
            <ItemTemplate>
                <div class="ch-dong">
                    <label><%# Eval("TenCH") %></label>
                    <asp:HiddenField ID="hfMaCH" runat="server" Value='<%# Eval("MaCH") %>' />
                    <asp:TextBox ID="txtGiaTri" runat="server" Text='<%# Eval("GiaTri") %>'
                        TextMode='<%# Eval("KieuNhap").ToString() == "multi" ? TextBoxMode.MultiLine : TextBoxMode.SingleLine %>'
                        Rows="5" CssClass="o-nhap ch-o"></asp:TextBox>
                    <small><%# Eval("GhiChu") %></small>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Button ID="btnLuu" runat="server" Text="Lưu thay đổi" CssClass="nut nut-cam" OnClick="btnLuu_Click" />
    </div>
</asp:Content>
