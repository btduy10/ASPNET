<%@ Page Title="Đơn hàng của tôi - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DonHangCuaToi.aspx.cs" Inherits="DonHangCuaToi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">ĐƠN HÀNG CỦA TÔI</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" DataKeyNames="MaDH,TrangThai"
        OnSelectedIndexChanged="gvDonHang_SelectedIndexChanged">
        <Columns>
            <asp:BoundField DataField="MaDH" HeaderText="Mã đơn" DataFormatString="DH{0:0000}" />
            <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
            <asp:BoundField DataField="DiaChiGiao" HeaderText="Địa chỉ giao" />
            <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="so" />
            <asp:BoundField DataField="HinhThucTT" HeaderText="Thanh toán" />
            <asp:BoundField DataField="TrangThai" HeaderText="Trạng thái" />
            <asp:CommandField ShowSelectButton="True" SelectText="Xem chi tiết" />
            <asp:HyperLinkField Text="Thông tin TT" DataNavigateUrlFields="MaDH"
                DataNavigateUrlFormatString="XacNhanDonHang.aspx?madh={0}" />
        </Columns>
        <EmptyDataTemplate>Bạn chưa có đơn hàng nào.</EmptyDataTemplate>
    </asp:GridView>

    <asp:Panel ID="pnlChiTiet" runat="server" Visible="false" style="margin-top:18px">
        <h3 class="tieu-de">CHI TIẾT ĐƠN HÀNG <asp:Label ID="lblMaDH" runat="server"></asp:Label></h3>
        <asp:GridView ID="gvChiTiet" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:TemplateField HeaderText="Hình">
                    <ItemTemplate><img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt="" /></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
                <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" ItemStyle-CssClass="so" />
                <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" ItemStyle-CssClass="so" />
                <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="so" />
            </Columns>
        </asp:GridView>
        <div style="text-align:right; margin-top:12px">
            <asp:Button ID="btnHuyDon" runat="server" Text="Hủy đơn hàng" CssClass="nut nut-do"
                OnClick="btnHuyDon_Click" OnClientClick="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');" />
        </div>
    </asp:Panel>
</asp:Content>
