using System;
using System.Security.Cryptography;
using System.Text;

/// <summary>
/// Lớp BaoMat: băm mật khẩu bằng SHA-256 trước khi lưu vào CSDL.
/// Kết quả là chuỗi HEX in hoa 64 ký tự, trùng với hàm
/// CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', ...), 2) trong SQL Server.
/// </summary>
public class BaoMat
{
    public static string MaHoaSHA256(string chuoi)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] mang = sha.ComputeHash(Encoding.UTF8.GetBytes(chuoi));
            return BitConverter.ToString(mang).Replace("-", "");
        }
    }
}
