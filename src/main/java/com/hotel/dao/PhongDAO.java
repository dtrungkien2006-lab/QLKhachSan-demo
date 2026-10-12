package com.hotel.dao;

import com.hotel.entity.Phong;
import com.hotel.enums.TrangThaiDatPhong;
import com.hotel.enums.TrangThaiPhong;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class PhongDAO extends BaseDAO<Phong, String> {

    public PhongDAO() {
        super(Phong.class);
    }


    @Override
    public List<Phong> findAll(EntityManager em) {
        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                ORDER BY p.soPhong
                """;
        return em.createQuery(jpql, Phong.class).getResultList();
    }

    public Phong findByIdWithLoaiPhong(EntityManager em, String maPhong) {
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

    public Phong findBySoPhong(EntityManager em, String soPhong) {
        String jpql = """
                SELECT p
                FROM Phong p
                WHERE p.soPhong = :soPhong
                """;

        List<Phong> result = em.createQuery(jpql, Phong.class)
                .setParameter("soPhong", soPhong)
                .getResultList();

        return result.isEmpty()
                ? null
                : result.get(0);
    }

    public List<Phong> findByLoaiPhong(EntityManager em, String maLoaiPhong) {
        String jpql = """
                SELECT p
                FROM Phong p
                JOIN FETCH p.loaiPhong
                WHERE p.loaiPhong.maLoaiPhong = :maLoaiPhong
                """;

        return em.createQuery(jpql, Phong.class)
                .setParameter("maLoaiPhong", maLoaiPhong)
                .getResultList();
    }

    public List<Phong> findPhongCoTheDat(EntityManager em, LocalDate ngayNhan, LocalDate ngayTra) {
        String jpql = """
            SELECT p
            FROM Phong p
            JOIN FETCH p.loaiPhong
            WHERE p.maPhong NOT IN (
                SELECT c.phong.maPhong
                FROM CtDatPhong c
                WHERE c.datPhong.trangThai NOT IN :trangThaiKhongGiuPhong
                  AND c.ngayNhan < :ngayTra
                  AND c.ngayTra > :ngayNhan
            )
            ORDER BY p.soPhong
            """;

        return em.createQuery(jpql, Phong.class)
                .setParameter("trangThaiKhongGiuPhong", CtDatPhongDAO.TRANG_THAI_KHONG_GIU_PHONG)
                .setParameter("ngayNhan", ngayNhan)
                .setParameter("ngayTra", ngayTra)
                .getResultList();
    }

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
                WHERE c.datPhong.trangThai NOT IN :trangThaiKhongGiuPhong
                  AND c.ngayNhan < :ngayTra
                  AND c.ngayTra > :ngayNhan
            )
            """);

        if (maLoaiPhong != null) jpql.append(" AND lp.maLoaiPhong = :maLoaiPhong");
        if (giaTu != null) jpql.append(" AND lp.giaCoBan >= :giaTu");
        if (giaDen != null) jpql.append(" AND lp.giaCoBan <= :giaDen");
        if (trangThai != null) jpql.append(" AND p.trangThai = :trangThai");

        jpql.append(" ORDER BY p.soPhong");

        TypedQuery<Phong> query = em.createQuery(jpql.toString(), Phong.class)
                .setParameter("trangThaiKhongGiuPhong", CtDatPhongDAO.TRANG_THAI_KHONG_GIU_PHONG)
                .setParameter("ngayNhan", ngayNhan)
                .setParameter("ngayTra", ngayTra);

        if (maLoaiPhong != null) query.setParameter("maLoaiPhong", maLoaiPhong);
        if (giaTu != null) query.setParameter("giaTu", giaTu);
        if (giaDen != null) query.setParameter("giaDen", giaDen);
        if (trangThai != null) query.setParameter("trangThai", trangThai);

        return query.getResultList();
    }
}