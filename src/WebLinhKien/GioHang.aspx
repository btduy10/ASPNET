<%@ Page Title="Giỏ hàng - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GioHang.aspx.cs" Inherits="GioHangPage" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h3 class="tieu-de">GIỎ HÀNG CỦA BẠN</h3>
    <asp:Label ID="lblThongBao" runat="server" Visible="false" CssClass="thong-bao"></asp:Label>

    <div class="gio-bo-cuc">
        <!-- ===== Cột trái: danh sách sản phẩm trong giỏ ===== -->
        <div class="gio-trai">
            <!-- EnableTheming="false": không dùng skin chung, giỏ hàng có giao diện riêng -->
            <asp:GridView ID="gvGioHang" runat="server" AutoGenerateColumns="False" DataKeyNames="MaSP"
                EnableTheming="false" CssClass="bang-gio" GridLines="None"
                OnRowCommand="gvGioHang_RowCommand" OnRowDeleting="gvGioHang_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="Thông tin sản phẩm">
                        <ItemTemplate>
                            <div class="gio-sp">
                                <img src='<%# TienIch.Hinh(Eval("HinhAnh")) %>' alt="" />
                                <div>
                                    <a class="ten" href='ChiTiet.aspx?masp=<%# Eval("MaSP") %>'><%# Eval("TenSP") %></a>
                                    <div class="ma">Mã SP: SP<%# Eval("MaSP", "{0:000}") %></div>
                                    <asp:LinkButton ID="lbtXoa" runat="server" CommandName="Delete" CausesValidation="false"
                                        CssClass="xoa">Xóa</asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" DataFormatString="{0:N0}đ"
                        HeaderStyle-CssClass="giua" ItemStyle-CssClass="tien" />
                    <asp:TemplateField HeaderText="Số lượng" HeaderStyle-CssClass="giua" ItemStyle-CssClass="giua">
                        <ItemTemplate>
                            <!-- Nút giảm / tăng số lượng: sự kiện RowCommand của GridView -->
                            <div class="chon-sl">
                                <asp:LinkButton ID="lbtGiam" runat="server" CommandName="Giam" CommandArgument='<%# Eval("MaSP") %>'
                                    CausesValidation="false" CssClass="nut-sl" ToolTip="Giảm">&minus;</asp:LinkButton>
                                <asp:TextBox ID="txtSoLuong" runat="server" Text='<%# Eval("SoLuong") %>' MaxLength="3"
                                    AutoPostBack="true" OnTextChanged="txtSoLuong_TextChanged"></asp:TextBox>
                                <asp:LinkButton ID="lbtTang" runat="server" CommandName="Tang" CommandArgument='<%# Eval("MaSP") %>'
                                    CausesValidation="false" CssClass="nut-sl" ToolTip="Tăng">+</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0}đ"
                        HeaderStyle-CssClass="giua" ItemStyle-CssClass="tien" />
                </Columns>
                <EmptyDataTemplate>
                    <div class="gio-trong">Giỏ hàng đang trống. <a href="SanPham.aspx">Tiếp tục mua sắm »</a></div>
                </EmptyDataTemplate>
            </asp:GridView>

            <asp:Panel ID="pnlTong" runat="server" CssClass="gio-tong">
                <div class="dong-tong">
                    <span>Tổng tiền (<asp:Label ID="lblTongSL" runat="server"></asp:Label> sản phẩm):</span>
                    <b><asp:Label ID="lblTongTien" runat="server"></asp:Label></b>
                </div>
                <asp:Button ID="btnThanhToan" runat="server" Text="Thanh toán" CssClass="nut-thanh-toan" OnClick="btnThanhToan_Click" />
                <div class="gio-phu">
                    <asp:HyperLink ID="hlMuaTiep" runat="server" NavigateUrl="~/SanPham.aspx">« Tiếp tục mua hàng</asp:HyperLink>
                    <asp:LinkButton ID="lbtXoaHet" runat="server" CausesValidation="false" OnClick="lbtXoaHet_Click"
                        OnClientClick="return confirm('Xóa toàn bộ giỏ hàng?');">Xóa hết giỏ hàng</asp:LinkButton>
                </div>
            </asp:Panel>
        </div>

        <!-- ===== Cột phải: lưu ý giao hàng, thanh toán ===== -->
        <div class="gio-phai">
            <h4>Thời gian gửi hàng đi</h4>
            <%= CauHinh.DoanVan("GH_ThoiGianGui") %>
            <h4>Hình thức thanh toán</h4>
            <ul>
                <li>Chuyển khoản ngân hàng</li>
                <li>Thanh toán khi nhận hàng (COD)</li>
            </ul>
            <h4>Giao hàng</h4>
            <%= CauHinh.DoanVan("GH_ChinhSach") %>
        </div>
    </div>
</asp:Content>
