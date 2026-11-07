<%@ Page Title="Thanh toán - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DatHang.aspx.cs" Inherits="DatHang" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <asp:Panel ID="pnlDatHang" runat="server" DefaultButton="btnThanhToan" CssClass="tt-bo-cuc">
        <!-- ===== Bên trái: thông tin nhận hàng + vận chuyển + hình thức thanh toán ===== -->
        <div class="tt-trai">
            <div class="tt-hai-cot">
                <div>
                    <h3 class="tt-tieude">Thông tin nhận hàng</h3>
                    <!-- Email lấy sẵn từ tài khoản, khách có thể sửa để nhận thông tin đơn hàng ở email khác -->
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="tt-o" MaxLength="100" placeholder="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Vui lòng nhập email" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[\w\.\-]+@[\w\-]+(\.[\w\-]+)+$" ErrorMessage="Email không hợp lệ"
                        CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>

                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="tt-o" MaxLength="100" placeholder="Họ và tên"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHoTen" runat="server" ControlToValidate="txtHoTen"
                        ErrorMessage="Vui lòng nhập họ tên người nhận" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:TextBox ID="txtDienThoai" runat="server" CssClass="tt-o" MaxLength="10" placeholder="Số điện thoại"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDienThoai" runat="server" ControlToValidate="txtDienThoai"
                        ErrorMessage="Vui lòng nhập số điện thoại" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revDienThoai" runat="server" ControlToValidate="txtDienThoai"
                        ValidationExpression="^0\d{9}$" ErrorMessage="Số điện thoại gồm 10 chữ số, bắt đầu bằng 0"
                        CssClass="loi" Display="Dynamic"></asp:RegularExpressionValidator>

                    <asp:TextBox ID="txtDiaChi" runat="server" CssClass="tt-o" MaxLength="200" TextMode="MultiLine" Rows="2"
                        placeholder="Địa chỉ (số nhà, đường, phường/xã, tỉnh/thành phố)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDiaChi" runat="server" ControlToValidate="txtDiaChi"
                        ErrorMessage="Vui lòng nhập địa chỉ giao hàng" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:TextBox ID="txtGhiChu" runat="server" CssClass="tt-o" MaxLength="255" TextMode="MultiLine" Rows="3"
                        placeholder="Ghi chú (tùy chọn)"></asp:TextBox>
                </div>
                <div>
                    <h3 class="tt-tieude">Vận chuyển</h3>
                    <div class="tt-hop">
                        <span><%= CauHinh.Html("VC_TenGoi") %></span>
                        <b>Miễn phí</b>
                    </div>

                    <h3 class="tt-tieude" style="margin-top:22px">Thanh toán</h3>
                    <!-- RadioButtonList: chọn hình thức thanh toán.
                         AutoPostBack="true": chọn xong trang gửi về server để hiện thông tin tương ứng -->
                    <div class="tt-khung-tt">
                        <asp:RadioButtonList ID="rblHinhThuc" runat="server" RepeatLayout="Flow" CssClass="tt-chon-tt"
                            AutoPostBack="true" OnSelectedIndexChanged="rblHinhThuc_SelectedIndexChanged">
                            <asp:ListItem Value="Chuyển khoản" Selected="True">Chuyển khoản ngân hàng</asp:ListItem>
                            <asp:ListItem Value="COD">Thanh toán khi nhận hàng (COD)</asp:ListItem>
                        </asp:RadioButtonList>
                        <!-- Thông tin tài khoản: đọc từ bảng tblCauHinh (Admin > Cấu hình website) -->
                        <asp:Panel ID="pnlThongTinCK" runat="server" CssClass="tt-thong-tin">
                            <p><b>Quan trọng!!!:</b> <%= CauHinh.Html("CK_LuuY") %></p>
                            <p><b>Thông tin tài khoản:</b></p>
                            <p><b>Tên:</b> <%= CauHinh.Html("CK_ChuTaiKhoan") %></p>
                            <p><b>STK:</b> <%= CauHinh.Html("CK_SoTaiKhoan") %></p>
                            <p><b>NH:</b> <%= CauHinh.Html("CK_NganHang") %></p>
                        </asp:Panel>
                        <asp:Panel ID="pnlThongTinCOD" runat="server" CssClass="tt-thong-tin" Visible="false">
                            <p><%= CauHinh.Html("COD_MoTa") %></p>
                        </asp:Panel>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvHinhThuc" runat="server" ControlToValidate="rblHinhThuc"
                        ErrorMessage="Vui lòng chọn hình thức thanh toán" CssClass="loi" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
            </div>
            <p class="tt-dieu-khoan">***Bằng việc nhấn nút Thanh toán, Quý khách đã đọc và đồng ý với
                <a href="GioiThieu.aspx">Điều khoản dịch vụ</a> và <a href="GioiThieu.aspx">Chính sách bảo mật thông tin</a>.</p>
        </div>

        <!-- ===== Bên phải: tóm tắt đơn hàng ===== -->
        <div class="tt-phai">
            <h3 class="tt-tieude">Đơn hàng (<asp:Label ID="lblSoSP" runat="server"></asp:Label> sản phẩm)</h3>
            <asp:Repeater ID="rptDonHang" runat="server">
                <ItemTemplate>
                    <div class="tt-sp">
                        <div class="tt-hinh">
                            <img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt="" />
                            <span><%# Eval("SoLuong") %></span>
                        </div>
                        <div class="tt-ten"><%# Eval("TenSP") %></div>
                        <div class="tt-tien"><%# TienIch.Tien(Eval("ThanhTien")) %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <div class="tt-dong"><span>Tạm tính</span><asp:Label ID="lblTamTinh" runat="server"></asp:Label></div>
            <div class="tt-dong"><span>Phí vận chuyển</span><span>Miễn phí</span></div>
            <div class="tt-dong tt-tong"><span>Tổng cộng</span><asp:Label ID="lblTongTien" runat="server"></asp:Label></div>
            <div class="tt-hanh-dong">
                <asp:HyperLink ID="hlQuayLai" runat="server" NavigateUrl="~/GioHang.aspx">‹ Quay về giỏ hàng</asp:HyperLink>
                <asp:Button ID="btnThanhToan" runat="server" Text="THANH TOÁN" CssClass="nut-thanh-toan" OnClick="btnThanhToan_Click" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
