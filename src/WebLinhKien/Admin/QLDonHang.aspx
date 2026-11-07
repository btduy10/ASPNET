<%@ Page Title="Quản lý đơn hàng" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="QLDonHang.aspx.cs" Inherits="Admin_QLDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">QUẢN LÝ ĐƠN HÀNG</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <asp:Panel ID="pnlLoc" runat="server" CssClass="thanh-loc" DefaultButton="btnLoc">
        Trạng thái:
        <asp:DropDownList ID="ddlLocTrangThai" runat="server">
            <asp:ListItem Value="">-- Tất cả --</asp:ListItem>
            <asp:ListItem>Chờ xử lý</asp:ListItem>
            <asp:ListItem>Đang giao</asp:ListItem>
            <asp:ListItem>Hoàn thành</asp:ListItem>
            <asp:ListItem>Đã hủy</asp:ListItem>
        </asp:DropDownList>
        &nbsp;Từ khóa: <asp:TextBox ID="txtTim" runat="server" Width="220px" placeholder="Tên người nhận, SĐT, tài khoản..."></asp:TextBox>
        <asp:Button ID="btnLoc" runat="server" Text="Lọc" CssClass="nut" OnClick="btnLoc_Click" />
    </asp:Panel>

    <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" DataKeyNames="MaDH"
        AllowPaging="True" PageSize="8"
        OnSelectedIndexChanged="gvDonHang_SelectedIndexChanged" OnPageIndexChanging="gvDonHang_PageIndexChanging">
        <Columns>
            <asp:BoundField DataField="MaDH" HeaderText="Mã đơn" DataFormatString="DH{0:0000}" />
            <asp:BoundField DataField="Username" HeaderText="Tài khoản" />
            <asp:BoundField DataField="HoTenNhan" HeaderText="Người nhận" />
            <asp:BoundField DataField="DienThoaiNhan" HeaderText="Điện thoại" />
            <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
            <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
            <asp:BoundField DataField="HinhThucTT" HeaderText="Thanh toán" />
            <asp:BoundField DataField="TrangThai" HeaderText="Trạng thái" />
            <asp:CommandField ShowSelectButton="True" SelectText="Xử lý" />
        </Columns>
    </asp:GridView>

    <asp:Panel ID="pnlChiTiet" runat="server" Visible="false" style="margin-top:18px">
        <div class="hai-cot">
            <div>
                <h3 class="tieu-de">THÔNG TIN ĐƠN HÀNG</h3>
                <!-- DetailsView hiển thị 1 bản ghi theo dạng dọc (Chương 6 - III. DetailView) -->
                <asp:DetailsView ID="dvDonHang" runat="server" AutoGenerateRows="False">
                    <Fields>
                        <asp:BoundField DataField="MaDH" HeaderText="Mã đơn" DataFormatString="DH{0:0000}" />
                        <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        <asp:BoundField DataField="Username" HeaderText="Tài khoản" />
                        <asp:BoundField DataField="HoTenNhan" HeaderText="Người nhận" />
                        <asp:BoundField DataField="DienThoaiNhan" HeaderText="Điện thoại" />
                        <asp:BoundField DataField="EmailNhan" HeaderText="Email" />
                        <asp:BoundField DataField="DiaChiGiao" HeaderText="Địa chỉ giao" />
                        <asp:BoundField DataField="GhiChu" HeaderText="Ghi chú" />
                        <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" />
                        <asp:BoundField DataField="HinhThucTT" HeaderText="Hình thức thanh toán" />
                        <asp:BoundField DataField="TrangThai" HeaderText="Trạng thái" />
                    </Fields>
                </asp:DetailsView>
                <div class="thanh-loc" style="margin-top:12px">
                    Cập nhật trạng thái:
                    <asp:DropDownList ID="ddlTrangThai" runat="server">
                        <asp:ListItem>Chờ xử lý</asp:ListItem>
                        <asp:ListItem>Đang giao</asp:ListItem>
                        <asp:ListItem>Hoàn thành</asp:ListItem>
                        <asp:ListItem>Đã hủy</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnCapNhatTT" runat="server" Text="Cập nhật" CssClass="nut nut-cam" OnClick="btnCapNhatTT_Click" />
                </div>
            </div>
            <div>
                <h3 class="tieu-de">SẢN PHẨM TRONG ĐƠN</h3>
                <asp:GridView ID="gvChiTiet" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="MaSP" HeaderText="Mã SP" />
                        <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
                        <asp:BoundField DataField="SoLuong" HeaderText="SL" ItemStyle-CssClass="so" />
                        <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
                        <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0}" ItemStyle-CssClass="so" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
