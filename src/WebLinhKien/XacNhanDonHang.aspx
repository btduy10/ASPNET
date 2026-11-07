<%@ Page Title="Xác nhận đơn hàng - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="XacNhanDonHang.aspx.cs" Inherits="XacNhanDonHang" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao tb-loi"></asp:Label>

    <asp:Panel ID="pnlXacNhan" runat="server">
        <div class="xn-dau">
            <span class="xn-tich">&#10003;</span>
            <div>
                <h2>Đặt hàng thành công!</h2>
                <p>Cảm ơn Quý khách đã mua hàng tại Linh Kiện TVU. Mã đơn hàng: <b><asp:Label ID="lblMaDH" runat="server"></asp:Label></b>
                   &nbsp;|&nbsp; Ngày đặt: <asp:Label ID="lblNgayDat" runat="server"></asp:Label>
                   &nbsp;|&nbsp; Trạng thái: <b><asp:Label ID="lblTrangThai" runat="server"></asp:Label></b></p>
            </div>
        </div>

        <div class="xn-hai-cot">
            <!-- Thông tin nhận hàng -->
            <div class="hop">
                <div class="hop-tieude">Thông tin nhận hàng</div>
                <table class="xn-bang">
                    <tr><td>Người nhận</td><td><asp:Label ID="lblHoTen" runat="server"></asp:Label></td></tr>
                    <tr><td>Điện thoại</td><td><asp:Label ID="lblDienThoai" runat="server"></asp:Label></td></tr>
                    <tr><td>Email</td><td><asp:Label ID="lblEmail" runat="server"></asp:Label></td></tr>
                    <tr><td>Địa chỉ giao</td><td><asp:Label ID="lblDiaChi" runat="server"></asp:Label></td></tr>
                    <tr><td>Ghi chú</td><td><asp:Label ID="lblGhiChu" runat="server"></asp:Label></td></tr>
                    <tr><td>Vận chuyển</td><td><%= CauHinh.Html("VC_TenGoi") %> – Miễn phí</td></tr>
                    <tr><td>Thanh toán</td><td><b><asp:Label ID="lblHinhThuc" runat="server"></asp:Label></b></td></tr>
                </table>
            </div>

            <!-- Thông tin chuyển khoản (chỉ hiện khi khách chọn Chuyển khoản) -->
            <asp:Panel ID="pnlChuyenKhoan" runat="server" CssClass="hop xn-ck">
                <div class="hop-tieude">Thông tin chuyển khoản</div>
                <table class="xn-bang">
                    <tr><td>Ngân hàng</td><td><b><asp:Label ID="lblNganHang" runat="server"></asp:Label></b></td></tr>
                    <tr><td>Số tài khoản</td><td><b class="xn-noi-bat" id="ckSoTK"><asp:Literal ID="litSoTK" runat="server"></asp:Literal></b>
                        <a href="#" class="xn-chep" onclick="return chepCK('ckSoTK', this);">Sao chép</a></td></tr>
                    <tr><td>Chủ tài khoản</td><td><b><asp:Label ID="lblChuTK" runat="server"></asp:Label></b></td></tr>
                    <tr><td>Số tiền</td><td><b class="xn-tien"><asp:Label ID="lblSoTien" runat="server"></asp:Label></b></td></tr>
                    <tr><td>Nội dung</td><td><b class="xn-noi-bat" id="ckNoiDung"><asp:Literal ID="litNoiDung" runat="server"></asp:Literal></b>
                        <a href="#" class="xn-chep" onclick="return chepCK('ckNoiDung', this);">Sao chép</a></td></tr>
                </table>
                <p class="xn-luu-y"><b>Quan trọng!!!:</b> <asp:Literal ID="litLuuYCK" runat="server"></asp:Literal><br />
                   Vui lòng ghi <b>đúng nội dung chuyển khoản</b>.</p>
            </asp:Panel>

            <!-- Thanh toán khi nhận hàng -->
            <asp:Panel ID="pnlCOD" runat="server" CssClass="hop">
                <div class="hop-tieude">Thanh toán khi nhận hàng</div>
                <p class="xn-luu-y"><asp:Literal ID="litMoTaCOD" runat="server"></asp:Literal><br />
                   Số tiền cần chuẩn bị: <b class="xn-tien"><asp:Label ID="lblSoTienCOD" runat="server"></asp:Label></b></p>
            </asp:Panel>
        </div>

        <h3 class="tieu-de" style="margin-top:6px">SẢN PHẨM ĐÃ ĐẶT</h3>
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
        <div class="tong-tien">Tổng cộng: <b><asp:Label ID="lblTongTien" runat="server"></asp:Label></b></div>
        <div style="text-align:right">
            <asp:HyperLink ID="hlMuaTiep" runat="server" NavigateUrl="~/Default.aspx" CssClass="nut nut-xam">« Tiếp tục mua hàng</asp:HyperLink>
            <asp:HyperLink ID="hlDonHang" runat="server" NavigateUrl="~/DonHangCuaToi.aspx" CssClass="nut">Xem đơn hàng của tôi</asp:HyperLink>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        // Sao chép số tài khoản / nội dung chuyển khoản vào bộ nhớ tạm
        function chepCK(id, nut) {
            var text = document.getElementById(id).innerText;
            if (navigator.clipboard) navigator.clipboard.writeText(text);
            nut.innerText = 'Đã chép';
            setTimeout(function () { nut.innerText = 'Sao chép'; }, 1500);
            return false;
        }
    </script>
</asp:Content>
