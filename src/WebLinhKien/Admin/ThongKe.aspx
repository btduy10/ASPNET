<%@ Page Title="Thống kê - báo cáo" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ThongKe.aspx.cs" Inherits="Admin_ThongKe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">THỐNG KÊ - BÁO CÁO</h3>

    <!-- ===== 1. Doanh thu theo tháng (gọi Stored Procedure) ===== -->
    <div class="thanh-loc">
        <b>1. Doanh thu theo tháng</b> &nbsp; Năm:
        <asp:DropDownList ID="ddlNam" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlNam_SelectedIndexChanged"></asp:DropDownList>
        &nbsp; <asp:Label ID="lblTongNam" runat="server"></asp:Label>
    </div>
    <asp:GridView ID="gvDoanhThu" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="Thang" HeaderText="Tháng" ItemStyle-Width="70px" />
            <asp:BoundField DataField="SoDonHang" HeaderText="Số đơn" ItemStyle-CssClass="so" ItemStyle-Width="80px" />
            <asp:BoundField DataField="DoanhThu" HeaderText="Doanh thu (đ)" DataFormatString="{0:N0}" ItemStyle-CssClass="so" ItemStyle-Width="140px" />
            <asp:TemplateField HeaderText="Biểu đồ">
                <ItemTemplate>
                    <span class="cot-bieu-do" style='width:<%# Eval("PhanTram") %>%'></span>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <div class="hai-cot" style="margin-top:20px">
        <!-- ===== 2. Top sản phẩm bán chạy theo khoảng thời gian ===== -->
        <div>
            <asp:Panel ID="pnlTop" runat="server" CssClass="thanh-loc" DefaultButton="btnXemTop">
                <b>2. Sản phẩm bán chạy</b><br />
                Từ <asp:TextBox ID="txtTuNgay" runat="server" TextMode="Date"></asp:TextBox>
                đến <asp:TextBox ID="txtDenNgay" runat="server" TextMode="Date"></asp:TextBox>
                <asp:Button ID="btnXemTop" runat="server" Text="Xem" CssClass="nut" ValidationGroup="Top" OnClick="btnXemTop_Click" />
                <asp:RequiredFieldValidator ID="rfvTuNgay" runat="server" ControlToValidate="txtTuNgay" ValidationGroup="Top"
                    ErrorMessage="Chọn ngày bắt đầu" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ID="rfvDenNgay" runat="server" ControlToValidate="txtDenNgay" ValidationGroup="Top"
                    ErrorMessage="Chọn ngày kết thúc" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CustomValidator ID="cvKhoangNgay" runat="server" ValidationGroup="Top" OnServerValidate="cvKhoangNgay_ServerValidate"
                    ErrorMessage="Ngày kết thúc phải sau ngày bắt đầu" CssClass="loi" Display="Dynamic"></asp:CustomValidator>
            </asp:Panel>
            <asp:GridView ID="gvTop" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="MaSP" HeaderText="Mã" />
                    <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
                    <asp:BoundField DataField="TongSoLuong" HeaderText="Đã bán" ItemStyle-CssClass="so" />
                    <asp:BoundField DataField="TongTien" HeaderText="Doanh thu" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- ===== 3. Doanh thu theo loại sản phẩm ===== -->
        <div>
            <div class="thanh-loc"><b>3. Doanh thu theo loại sản phẩm</b> (đơn Hoàn thành)</div>
            <asp:GridView ID="gvTheoLoai" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="TenLoai" HeaderText="Loại" />
                    <asp:BoundField DataField="SoLuong" HeaderText="SL bán" ItemStyle-CssClass="so" />
                    <asp:BoundField DataField="DoanhThu" HeaderText="Doanh thu" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- ===== 4. Tồn kho ===== -->
    <asp:Panel ID="pnlTon" runat="server" CssClass="thanh-loc" DefaultButton="btnXemTon" style="margin-top:20px">
        <b>4. Báo cáo tồn kho</b> &nbsp; Tồn kho nhỏ hơn:
        <asp:TextBox ID="txtNguong" runat="server" Text="20" Width="70px"></asp:TextBox>
        <asp:RangeValidator ID="rvNguong" runat="server" ControlToValidate="txtNguong" ValidationGroup="Ton" Type="Integer"
            MinimumValue="1" MaximumValue="100000" ErrorMessage="Nhập số nguyên dương" CssClass="loi" Display="Dynamic"></asp:RangeValidator>
        <asp:Button ID="btnXemTon" runat="server" Text="Xem" CssClass="nut" ValidationGroup="Ton" OnClick="btnXemTon_Click" />
        &nbsp; <asp:Label ID="lblGiaTriKho" runat="server"></asp:Label>
    </asp:Panel>
    <asp:GridView ID="gvTonKho" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="MaSP" HeaderText="Mã" />
            <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
            <asp:BoundField DataField="TenLoai" HeaderText="Loại" />
            <asp:BoundField DataField="SoLuongTon" HeaderText="Tồn" ItemStyle-CssClass="so" />
            <asp:BoundField DataField="GiaTriTon" HeaderText="Giá trị tồn (đ)" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
        </Columns>
    </asp:GridView>
</asp:Content>
