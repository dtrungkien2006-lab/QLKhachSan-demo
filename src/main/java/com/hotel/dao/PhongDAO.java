
package com.hotel.dao;

import com.hotel.entity.Phong;
import com.hotel.enums.TrangThaiPhong;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * PhongDAO kế thừa BaseDAO:
 * - Kế thừa CRUD cơ bản.
 * - Entity: Phong.
 * - Khóa chính: maPhong.
 */
public class PhongDAO extends BaseDAO<Phong, String> {

    public PhongDAO() {
        super(Phong.class);
    }

    /**
     * Lấy toàn bộ danh sách phòng và tải kèm loại phòng.
     * Dùng cho trang danh sách phòng để tránh LazyInitializationException.
     */
    public List<Phong> findAllWithLoaiPhong(EntityManager em) {
        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                ORDER BY p.soPhong
                """;

        return em.createQuery(jpql, Phong.class)
                .getResultList();
    }

    /**
     * Tìm phòng theo mã phòng và tải kèm loại phòng.
     */
    public Phong findByIdWithLoaiPhong(
            EntityManager em,
            String maPhong) {

        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                WHERE p.maPhong = :maPhong
                """;

        List<Phong> result = em.createQuery(jpql, Phong.class)
                .setParameter("maPhong", maPhong)
                .getResultList();

        return result.isEmpty() ? null : result.get(0);
    }

    /**
     * Tra cứu phòng theo số phòng.
     */
    public Phong findBySoPhong(
            EntityManager em,
            String soPhong) {

        String jpql = """
                SELECT p
                FROM Phong p
                WHERE p.soPhong = :soPhong
                """;

        List<Phong> result = em.createQuery(jpql, Phong.class)
                .setParameter("soPhong", soPhong)
                .getResultList();

        return result.isEmpty() ? null : result.get(0);
    }

    /**
     * Lấy danh sách phòng theo mã loại phòng.
     */
    public List<Phong> findByLoaiPhong(
            EntityManager em,
            String maLoaiPhong) {

        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                WHERE p.loaiPhong.maLoaiPhong = :maLoaiPhong
                ORDER BY p.soPhong
                """;

        return em.createQuery(jpql, Phong.class)
                .setParameter("maLoaiPhong", maLoaiPhong)
                .getResultList();
    }

    /**
     * Tìm phòng có thể đặt theo khoảng ngày.
     */
    public List<Phong> findPhongCoTheDat(
            EntityManager em,
            LocalDate ngayNhan,
            LocalDate ngayTra) {

        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                WHERE p.maPhong NOT IN (
                    SELECT c.phong.maPhong
                    FROM CtDatPhong c
                    WHERE c.datPhong.trangThai
                        NOT IN :trangThaiKhongGiuPhong
                      AND c.ngayNhan < :ngayTra
                      AND c.ngayTra > :ngayNhan
                )
                ORDER BY p.soPhong
                """;

        return em.createQuery(jpql, Phong.class)
                .setParameter(
                        "trangThaiKhongGiuPhong",
                        CtDatPhongDAO.TRANG_THAI_KHONG_GIU_PHONG
                )
                .setParameter("ngayNhan", ngayNhan)
                .setParameter("ngayTra", ngayTra)
                .getResultList();
    }

    /**
     * Tìm phòng có thể đặt kết hợp bộ lọc:
     * loại phòng, giá từ, giá đến và trạng thái phòng.
     */
    public List<Phong> findPhongCoTheDat(
            EntityManager em,
            LocalDate ngayNhan,
            LocalDate ngayTra,
            String maLoaiPhong,
            BigDecimal giaTu,
            BigDecimal giaDen,
            TrangThaiPhong trangThai) {

        StringBuilder jpql = new StringBuilder("""
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong lp
                WHERE p.maPhong NOT IN (
                    SELECT c.phong.maPhong
                    FROM CtDatPhong c
                    WHERE c.datPhong.trangThai
                        NOT IN :trangThaiKhongGiuPhong
                      AND c.ngayNhan < :ngayTra
                      AND c.ngayTra > :ngayNhan
                )
                """);

        if (maLoaiPhong != null && !maLoaiPhong.isBlank()) {
            jpql.append(" AND lp.maLoaiPhong = :maLoaiPhong");
        }

        if (giaTu != null) {
            jpql.append(" AND lp.giaCoBan >= :giaTu");
        }

        if (giaDen != null) {
            jpql.append(" AND lp.giaCoBan <= :giaDen");
        }

        if (trangThai != null) {
            jpql.append(" AND p.trangThai = :trangThai");
        }

        jpql.append(" ORDER BY p.soPhong");

        TypedQuery<Phong> query = em.createQuery(
                jpql.toString(),
                Phong.class
        );

        query.setParameter(
                "trangThaiKhongGiuPhong",
                CtDatPhongDAO.TRANG_THAI_KHONG_GIU_PHONG
        );
        query.setParameter("ngayNhan", ngayNhan);
        query.setParameter("ngayTra", ngayTra);

        if (maLoaiPhong != null && !maLoaiPhong.isBlank()) {
            query.setParameter("maLoaiPhong", maLoaiPhong);
        }

        if (giaTu != null) {
            query.setParameter("giaTu", giaTu);
        }

        if (giaDen != null) {
            query.setParameter("giaDen", giaDen);
        }

        if (trangThai != null) {
            query.setParameter("trangThai", trangThai);
        }

        return query.getResultList();
    }
}
