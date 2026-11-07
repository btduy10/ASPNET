using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Lớp KetNoi: gom các thao tác ADO.NET dùng chung (Chương 5 - ADO.NET).
///  - LayDuLieu  : SqlDataAdapter.Fill  -> DataTable   (SELECT)
///  - ThucThi    : SqlCommand.ExecuteNonQuery           (INSERT, UPDATE, DELETE)
///  - LayGiaTri  : SqlCommand.ExecuteScalar             (COUNT, SUM, ...)
///  - LayDuLieuSP: gọi thủ tục lưu trữ (Stored Procedure)
/// Tất cả câu lệnh đều dùng tham số (SqlParameter) để tránh lỗi SQL Injection.
/// </summary>
public class KetNoi
{
    // Lấy chuỗi kết nối trong web.config (giống Bước 3 của bài tập chương 5)
    public static string ChuoiKetNoi
    {
        get { return ConfigurationManager.AppSettings["ConnectionString"].ToString(); }
    }

    // Thực hiện câu lệnh SELECT, trả về DataTable
    public static DataTable LayDuLieu(string sql, params SqlParameter[] thamSo)
    {
        DataTable dt = new DataTable();
        using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            if (thamSo != null) cmd.Parameters.AddRange(thamSo);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);   // DataAdapter tự mở và đóng kết nối
        }
        return dt;
    }

    // Thực hiện INSERT / UPDATE / DELETE, trả về số dòng bị ảnh hưởng
    public static int ThucThi(string sql, params SqlParameter[] thamSo)
    {
        using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            if (thamSo != null) cmd.Parameters.AddRange(thamSo);
            conn.Open();
            return cmd.ExecuteNonQuery();
        }
    }

    // Thực hiện câu lệnh trả về 1 giá trị (ô đầu tiên của dòng đầu tiên)
    public static object LayGiaTri(string sql, params SqlParameter[] thamSo)
    {
        using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            if (thamSo != null) cmd.Parameters.AddRange(thamSo);
            conn.Open();
            return cmd.ExecuteScalar();
        }
    }

    // Gọi thủ tục lưu trữ (Chương 5 - Bài 2 - 4.3 Làm việc với Stored Procedure)
    public static DataTable LayDuLieuSP(string tenThuTuc, params SqlParameter[] thamSo)
    {
        DataTable dt = new DataTable();
        using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
        {
            SqlCommand cmd = new SqlCommand(tenThuTuc, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            if (thamSo != null) cmd.Parameters.AddRange(thamSo);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
        }
        return dt;
    }

    // Tiện ích: chuyển giá trị object sang số nguyên an toàn
    public static int SoNguyen(object giaTri)
    {
        if (giaTri == null || giaTri == DBNull.Value) return 0;
        return Convert.ToInt32(giaTri);
    }

    // Tiện ích: chuyển giá trị object sang decimal an toàn
    public static decimal SoThuc(object giaTri)
    {
        if (giaTri == null || giaTri == DBNull.Value) return 0;
        return Convert.ToDecimal(giaTri);
    }
}
