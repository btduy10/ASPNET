<%@ Page Title="Thông tin liên hệ - Linh Kiện TVU" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="LienHe.aspx.cs" Inherits="LienHe" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="lh-bo-cuc">
        <!-- Khung thông tin liên hệ: nội dung lấy từ bảng tblCauHinh (Admin > Cấu hình website) -->
        <div class="lh-the">
            <h2>Cửa hàng <%= CauHinh.Html("TenCuaHang1") + " " %><%= CauHinh.Html("TenCuaHang2") %></h2>
            <div class="lh-luoi">
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-7-6.2-7-11.5A7 7 0 0 1 19 9.5C19 14.8 12 21 12 21z"/><circle cx="12" cy="9.5" r="2.5"/></svg></span>
                    <div><b>Địa chỉ</b><span><%= CauHinh.Cum("DiaChi") %></span></div>
                </div>
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span>
                    <div><b>Thời gian làm việc</b><span><%= CauHinh.Cum("GioLamViec") %></span></div>
                </div>
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/></svg></span>
                    <div><b>Hotline</b><span><a href="tel:<%= CauHinh.Url("Hotline") %>"><%= CauHinh.Html("Hotline") %></a></span></div>
                </div>
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg></span>
                    <div><b>Email</b><span><a href="mailto:<%= CauHinh.Url("Email") %>"><%= CauHinh.Html("Email") %></a></span></div>
                </div>
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a8 8 0 0 1-11.6 7.1L4 20l1-4.6A8 8 0 1 1 21 12z"/></svg></span>
                    <div><b>Zalo</b><span><a href="#" onclick="return moZalo();"><%= CauHinh.Html("Zalo_HienThi") %></a></span></div>
                </div>
                <div class="lh-muc">
                    <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/></svg></span>
                    <div><b>Facebook</b><span><a href="<%= CauHinh.Url("Facebook") %>" target="_blank"><%= CauHinh.Html("Facebook_HienThi") %></a></span></div>
                </div>
            </div>
            <div class="lh-luu-y"><%= CauHinh.Html("LH_LuuY") %></div>
        </div>

        <!-- Bản đồ: cần Internet. Khi không có mạng hiển thị khung địa chỉ thay thế -->
        <div class="lh-ban-do" id="banDo" data-q="<%= TuKhoaBanDo %>">
            <div class="lh-ban-do-thay">
                <span class="lh-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-7-6.2-7-11.5A7 7 0 0 1 19 9.5C19 14.8 12 21 12 21z"/><circle cx="12" cy="9.5" r="2.5"/></svg></span>
                <b><%= CauHinh.Html("TenCuaHang1") + " " %><%= CauHinh.Html("TenCuaHang2") %></b>
                <span><%= CauHinh.Cum("DiaChi") %></span>
                <small>Bản đồ hiển thị khi máy tính có kết nối Internet.</small>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Chỉ nạp Google Maps khi trình duyệt đang có mạng
        (function () {
            var khung = document.getElementById('banDo');
            if (!navigator.onLine || !khung) return;
            var f = document.createElement('iframe');
            f.src = 'https://maps.google.com/maps?q=' + encodeURIComponent(khung.getAttribute('data-q')) + '&z=16&output=embed';
            f.loading = 'lazy';
            f.title = 'Bản đồ';
            khung.appendChild(f);
        })();
    </script>
</asp:Content>
