package com.hotel.dao;

import com.hotel.entity.SuDungDichVu;
import jakarta.persistence.EntityManager;
import java.util.List;

public class SuDungDichVuDAO
        extends BaseDAO<SuDungDichVu, String> {

    public SuDungDichVuDAO() {
        super(SuDungDichVu.class);
    }

    /**
     * Lấy toàn bộ danh sách sử dụng dịch vụ,
     * tải sẵn Đặt phòng và Dịch vụ để JSP không
     * phải truy cập proxy sau khi Session đóng.
     */
    public List<SuDungDichVu> findAllWithDichVu(EntityManager em) {
        String jpql = """
            SELECT s
            FROM SuDungDichVu s
            JOIN FETCH s.dichVu
            JOIN FETCH s.datPhong
            ORDER BY s.thoiGianSuDung DESC
            """;

        return em.createQuery(jpql, SuDungDichVu.class)
                .getResultList();
    }

    /**
     * Lấy danh sách sử dụng dịch vụ theo đặt phòng.
     */
    public List<SuDungDichVu> findByDatPhong(
            EntityManager em,
            String maDatPhong) {

        String jpql = """
            SELECT s
            FROM SuDungDichVu s
            JOIN FETCH s.dichVu
            JOIN FETCH s.datPhong
            WHERE s.datPhong.maDatPhong = :maDatPhong
            ORDER BY s.thoiGianSuDung DESC
            """;

        return em.createQuery(jpql, SuDungDichVu.class)
                .setParameter("maDatPhong", maDatPhong)
                .getResultList();
    }
}
