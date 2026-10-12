package com.hotel.dao;

import com.hotel.entity.CtDatPhong;
import com.hotel.entity.DatPhong;
import com.hotel.entity.HoaDon;
import com.hotel.entity.ThanhToan;
import com.hotel.enums.TrangThaiDatPhong;
import com.hotel.enums.TrangThaiHoaDon;
import com.hotel.enums.TrangThaiPhong;
import com.hotel.enums.TrangThaiThanhToan;
import jakarta.persistence.EntityManager;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

/**
 * Truy vấn dữ liệu phục vụ thống kê và báo cáo (chỉ đọc).
 * Không extends BaseDAO vì không gắn với một entity duy nhất.
 */
public class ThongKeDAO {

    /** Số phòng theo từng trạng thái. */
    public Map<TrangThaiPhong, Long> demPhongTheoTrangThai(EntityManager em) {
        List<Object[]> rows = em.createQuery(
                "SELECT p.trangThai, COUNT(p) FROM Phong p GROUP BY p.trangThai",
                Object[].class).getResultList();
        Map<TrangThaiPhong, Long> map = new EnumMap<>(TrangThaiPhong.class);
        for (Object[] r : rows) {
            map.put((TrangThaiPhong) r[0], (Long) r[1]);
        }
        return map;
    }

    /** Các đặt phòng được tạo trong khoảng [tu, den). */
    public List<DatPhong> findDatPhongTrongKhoang(EntityManager em, LocalDateTime tu, LocalDateTime den) {
        return em.createQuery("""
                SELECT d FROM DatPhong d
                JOIN FETCH d.khachHang
                WHERE d.ngayDat >= :tu AND d.ngayDat < :den
                ORDER BY d.ngayDat
                """, DatPhong.class)
                .setParameter("tu", tu)
                .setParameter("den", den)
                .getResultList();
    }

    /**
     * Hóa đơn lập trong khoảng [tu, den) - cơ sở tính doanh thu.
     * Luôn lấy DA_PHAT_HANH; gomNhap=true thì lấy thêm NHAP (doanh thu dự kiến). DA_HUY không bao giờ tính.
     */
    public List<HoaDon> findHoaDonTinhDoanhThu(EntityManager em, LocalDateTime tu, LocalDateTime den, boolean gomNhap) {
        return em.createQuery("""
                SELECT h FROM HoaDon h
                JOIN FETCH h.datPhong d
                JOIN FETCH d.khachHang
                WHERE h.trangThai IN :tts AND h.ngayLap >= :tu AND h.ngayLap < :den
                ORDER BY h.ngayLap
                """, HoaDon.class)
                .setParameter("tts", gomNhap
                        ? List.of(TrangThaiHoaDon.DA_PHAT_HANH, TrangThaiHoaDon.NHAP)
                        : List.of(TrangThaiHoaDon.DA_PHAT_HANH))
                .setParameter("tu", tu)
                .setParameter("den", den)
                .getResultList();
    }

    /** Giao dịch thanh toán thành công trong khoảng [tu, den). */
    public List<ThanhToan> findThanhToanThanhCong(EntityManager em, LocalDateTime tu, LocalDateTime den) {
        return em.createQuery("""
                SELECT t FROM ThanhToan t
                WHERE t.trangThai = :tt
                  AND t.thoiGianThanhToan >= :tu AND t.thoiGianThanhToan < :den
                ORDER BY t.thoiGianThanhToan
                """, ThanhToan.class)
                .setParameter("tt", TrangThaiThanhToan.DA_THANH_TOAN)
                .setParameter("tu", tu)
                .setParameter("den", den)
                .getResultList();
    }

    /**
     * Chi tiết đặt phòng (đã bán, không hủy) có kỳ lưu trú giao với [tu, den).
     * Dùng cho công suất phòng và lịch sử lưu trú.
     */
    public List<CtDatPhong> findCtDatPhongGiaoKhoang(EntityManager em, LocalDate tu, LocalDate den) {
        return em.createQuery("""
                SELECT c FROM CtDatPhong c
                JOIN FETCH c.phong
                JOIN FETCH c.datPhong d
                JOIN FETCH d.khachHang
                WHERE d.trangThai IN (:dangO, :daTra)
                  AND c.ngayNhan < :den AND c.ngayTra > :tu
                ORDER BY c.ngayNhan
                """, CtDatPhong.class)
                .setParameter("dangO", TrangThaiDatPhong.DANG_O)
                .setParameter("daTra", TrangThaiDatPhong.DA_TRA_PHONG)
                .setParameter("tu", tu)
                .setParameter("den", den)
                .getResultList();
    }
}
