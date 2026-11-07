# Website bán linh kiện điện tử – Linh Kiện TVU

Đồ án **Chuyên đề ASP.NET** – Trường Kỹ thuật và Công nghệ, Đại học Trà Vinh.

Website có hai phân hệ:
- **Khách hàng:** xem, tìm kiếm sản phẩm; giỏ hàng; đăng ký, đăng nhập; thanh toán COD hoặc chuyển khoản; theo dõi đơn hàng.
- **Quản trị:** quản lý loại, hãng, sản phẩm, đơn hàng, người dùng; thống kê; cấu hình website.

Công nghệ: ASP.NET Web Forms (C#, .NET Framework 4.8), ADO.NET, SQL Server. Website chạy **offline** trên máy cá nhân.

## Thông tin liên lạc

| | |
|---|---|
| Sinh viên thực hiện | **Bùi Thanh Duy** |
| MSSV / Lớp | ………… / ………… |
| Email | btduy10@gmail.com |
| Điện thoại | ………… |
| Giảng viên hướng dẫn | TS. Nguyễn Nhứt Lam |

## Cấu trúc repository

```
├── README.md            ← tập tin này
├── setup/               ← script tạo CSDL + dữ liệu thử, hướng dẫn cài đặt, sơ đồ triển khai
├── src/                 ← mã nguồn: WebLinhKien.sln + thư mục WebLinhKien (ASP.NET Web Site)
├── progress-report/     ← báo cáo tiến độ thực hiện đồ án
├── thesis/
│   ├── doc/             ← báo cáo, bìa, hướng dẫn (.docx) + ảnh chụp màn hình
│   ├── pdf/             ← báo cáo, bìa (.pdf)
│   ├── abs/             ← slide trình chiếu (.pptx)
│   └── refs/            ← danh mục tài liệu tham khảo
└── soft/                ← danh sách phần mềm sử dụng và nơi tải
```

Đồ án không dùng Docker, vì ASP.NET Web Forms trên .NET Framework chạy bằng IIS/IIS Express trên Windows.

## Chạy nhanh

1. Cài các phần mềm trong [`soft/`](soft/README.md).
2. Mở SSMS, chạy [`setup/QLLinhKien.sql`](setup/QLLinhKien.sql) để tạo CSDL kèm dữ liệu thử.
3. Mở `src/WebLinhKien.sln` bằng Visual Studio. Nếu máy dùng SQL Server Express, sửa `Data Source` trong `src/WebLinhKien/Web.config`.
4. Nhấn **Ctrl + F5**.

Tài khoản thử: quản trị **admin / admin123**; khách hàng **khachhang1 / 123456**.

Hướng dẫn chi tiết và cách xử lý lỗi xem tại [`setup/README.md`](setup/README.md).
