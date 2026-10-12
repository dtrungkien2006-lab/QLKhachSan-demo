
package com.hotel.dao;

import com.hotel.entity.ThanhToan;
import com.hotel.enums.TrangThaiThanhToan;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.util.List;

public class ThanhToanDAO extends BaseDAO<ThanhToan, String> {

    public ThanhToanDAO() {
        super(ThanhToan.class);
    }

    public List<ThanhToan> findByDatPhong(
            EntityManager em, String maDatPhong) {

        String jpql = """
                SELECT t
                FROM ThanhToan t
                WHERE t.datPhong.maDatPhong = :maDatPhong
                ORDER BY t.thoiGianTao DESC
                """;

        return em.createQuery(jpql, ThanhToan.class)
                .setParameter("maDatPhong", maDatPhong)
                .getResultList();
    }

    public BigDecimal sumSuccessfulByDatPhong(
            EntityManager em, String maDatPhong) {

        BigDecimal total = em.createQuery("""
                SELECT COALESCE(SUM(t.soTien), 0)
                FROM ThanhToan t
                WHERE t.datPhong.maDatPhong = :maDatPhong
                  AND t.trangThai = :status
                """, BigDecimal.class)
                .setParameter("maDatPhong", maDatPhong)
                .setParameter("status", TrangThaiThanhToan.DA_THANH_TOAN)
                .getSingleResult();

        return total == null ? BigDecimal.ZERO : total;
    }
}
