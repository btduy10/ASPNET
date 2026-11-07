<%@ Page Title="Quản lý sản phẩm" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLSanPham.aspx.cs" Inherits="Admin_QLSanPham" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">QUẢN LÝ SẢN PHẨM</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <!-- ===== Form thêm / sửa sản phẩm ===== -->
    <asp:Panel ID="pnlForm" runat="server" CssClass="form" style="margin-bottom:16px">
        <b><asp:Label ID="lblTieuDeForm" runat="server" Text="THÊM SẢN PHẨM MỚI"></asp:Label></b>
        <asp:HiddenField ID="hfMaSP" runat="server" />
        <asp:HiddenField ID="hfHinhCu" runat="server" />
        <div class="hai-cot">
            <div>
                <table>
                    <tr>
                        <td class="nhan">Tên sản phẩm (*)</td>
                        <td><asp:TextBox ID="txtTenSP" runat="server" MaxLength="200"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTenSP" runat="server" ControlToValidate="txtTenSP" ValidationGroup="SP"
                                ErrorMessage="Chưa nhập tên sản phẩm" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td class="nhan">Loại sản phẩm</td>
                        <td><asp:DropDownList ID="ddlLoai" runat="server"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="nhan">Hãng sản xuất</td>
                        <td><asp:DropDownList ID="ddlHang" runat="server"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="nhan">Đơn giá (đ) (*)</td>
                        <td><asp:TextBox ID="txtDonGia" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDonGia" runat="server" ControlToValidate="txtDonGia" ValidationGroup="SP"
                                ErrorMessage="Chưa nhập đơn giá" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvDonGia" runat="server" ControlToValidate="txtDonGia" ValidationGroup="SP"
                                Type="Double" MinimumValue="0" MaximumValue="999999999"
                                ErrorMessage="Đơn giá phải là số từ 0 trở lên" CssClass="loi" Display="Dynamic"></asp:RangeValidator></td>
                    </tr>
                    <tr>
                        <td class="nhan">Số lượng tồn (*)</td>
                        <td><asp:TextBox ID="txtSoLuong" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvSoLuong" runat="server" ControlToValidate="txtSoLuong" ValidationGroup="SP"
                                ErrorMessage="Chưa nhập số lượng" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvSoLuong" runat="server" ControlToValidate="txtSoLuong" ValidationGroup="SP"
                                Type="Integer" MinimumValue="0" MaximumValue="100000"
                                ErrorMessage="Số lượng là số nguyên từ 0 đến 100.000" CssClass="loi" Display="Dynamic"></asp:RangeValidator></td>
                    </tr>
                    <tr>
                        <td class="nhan">Trạng thái</td>
                        <td><asp:CheckBox ID="chkTrangThai" runat="server" Text=" Đang kinh doanh" Checked="true" /></td>
                    </tr>
                </table>
            </div>
            <div>
                <table>
                    <tr>
                        <td class="nhan">Hình ảnh</td>
                        <td><asp:FileUpload ID="fuHinh" runat="server" />
                            <asp:RegularExpressionValidator ID="revHinh" runat="server" ControlToValidate="fuHinh" ValidationGroup="SP"
                                ValidationExpression="^.*\.(jpg|JPG|jpeg|JPEG|png|PNG|gif|GIF|webp|WEBP)$"
                                ErrorMessage="Chỉ chấp nhận file .jpg, .png, .gif, .webp" CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>
                            <br /><asp:Image ID="imgHinh" runat="server" Height="90px" Visible="false" /></td>
                    </tr>
                    <tr>
                        <td class="nhan">Thông số</td>
                        <td><asp:TextBox ID="txtThongSo" runat="server" MaxLength="500" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="nhan">Mô tả</td>
                        <td><asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox></td>
                    </tr>
                </table>
            </div>
        </div>
        <div style="text-align:right">
            <asp:Button ID="btnThem" runat="server" Text="+ Thêm mới" CssClass="nut" ValidationGroup="SP" OnClick="btnThem_Click" />
            <asp:Button ID="btnCapNhat" runat="server" Text="Lưu cập nhật" CssClass="nut nut-cam" ValidationGroup="SP" Visible="false" OnClick="btnCapNhat_Click" />
            <asp:Button ID="btnLamMoi" runat="server" Text="Làm mới" CssClass="nut nut-xam" CausesValidation="false" OnClick="btnLamMoi_Click" />
        </div>
    </asp:Panel>

    <!-- ===== Thanh tìm kiếm / lọc ===== -->
    <asp:Panel ID="pnlLoc" runat="server" CssClass="thanh-loc" DefaultButton="btnLoc">
        Từ khóa: <asp:TextBox ID="txtTim" runat="server" Width="220px" placeholder="Tên sản phẩm..."></asp:TextBox>
        &nbsp;Loại: <asp:DropDownList ID="ddlLocLoai" runat="server"></asp:DropDownList>
        <asp:Button ID="btnLoc" runat="server" Text="Lọc" CssClass="nut" CausesValidation="false" OnClick="btnLoc_Click" />
        &nbsp;<asp:Label ID="lblSoSP" runat="server"></asp:Label>
    </asp:Panel>

    <!-- ===== Danh sách sản phẩm ===== -->
    <asp:GridView ID="gvSanPham" runat="server" AutoGenerateColumns="False" DataKeyNames="MaSP"
        AllowPaging="True" PageSize="8"
        OnSelectedIndexChanged="gvSanPham_SelectedIndexChanged" OnRowDeleting="gvSanPham_RowDeleting"
        OnPageIndexChanging="gvSanPham_PageIndexChanging" OnRowDataBound="gvSanPham_RowDataBound">
        <Columns>
            <asp:BoundField DataField="MaSP" HeaderText="Mã" />
            <asp:TemplateField HeaderText="Hình">
                <ItemTemplate><img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt="" /></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="TenSP" HeaderText="Tên sản phẩm" />
            <asp:BoundField DataField="TenLoai" HeaderText="Loại" />
            <asp:BoundField DataField="TenHang" HeaderText="Hãng" />
            <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
            <asp:BoundField DataField="SoLuongTon" HeaderText="Tồn" ItemStyle-CssClass="so" />
            <asp:CheckBoxField DataField="TrangThai" HeaderText="Bán" />
            <asp:CommandField ShowSelectButton="True" ShowDeleteButton="True" SelectText="Sửa" DeleteText="Xóa" />
        </Columns>
    </asp:GridView>
</asp:Content>
