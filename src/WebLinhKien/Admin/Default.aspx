<%@ Page Title="Tổng quan - Quản trị" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">
    <h3 class="tieu-de">TỔNG QUAN HỆ THỐNG</h3>
    <div class="the-so">
        <div><span>Sản phẩm đang bán</span><b><asp:Label ID="lblSoSP" runat="server"></asp:Label></b></div>
        <div><span>Đơn chờ xử lý</span><b><asp:Label ID="lblDonCho" runat="server"></asp:Label></b></div>
        <div><span>Khách hàng</span><b><asp:Label ID="lblSoKH" runat="server"></asp:Label></b></div>
        <div><span>Doanh thu tháng này</span><b><asp:Label ID="lblDoanhThu" runat="server"></asp:Label></b></div>
    </div>

    <div class="hai-cot">
        <div>
            <h3 class="tieu-de">ĐƠN HÀNG MỚI NHẤT</h3>
            <asp:GridView ID="gvDonMoi" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:HyperLinkField DataTextField="MaDH" DataTextFormatString="DH{0:0000}" HeaderText="Mã đơn"
                        DataNavigateUrlFields="MaDH" DataNavigateUrlFormatString="QLDonHang.aspx?madh={0}" />
                    <asp:BoundField DataField="HoTenNhan" HeaderText="Khách hàng" />
                    <asp:BoundField DataField="NgayDat" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" DataFormatString="{0:N0} đ" ItemStyle-CssClass="so" />
                    <asp:BoundField DataField="TrangThai" HeaderText="Trạng thái" />
                </Columns>
            </asp:GridView>
        </div>
        <div>
            <h3 class="tieu-de">SẢN PHẨM SẮP HẾT HÀNG (&lt; 10)</h3>
            <asp:GridView ID="gvSapHet" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="MaSP" HeaderText="Mã" />
                    <asp:BoundField DataField="TenSP" HeaderText="Sản phẩm" />
                    <asp:BoundField DataField="SoLuongTon" HeaderText="Tồn" ItemStyle-CssClass="so" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
