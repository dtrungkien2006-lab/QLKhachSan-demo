package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.DichVuDAO;
import com.hotel.entity.DichVu;
import com.hotel.util.MaCodeGenerator;

import jakarta.persistence.EntityManager;

import java.math.BigDecimal;
import java.util.List;

public class DichVuService {

    private final DichVuDAO dao = new DichVuDAO();

    /**
     * Thêm dịch vụ mới.
     */
    public void them(DichVu x) {
        validate(x);

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();

            EntityManager em = tm.getEntityManager();

            // Tự sinh mã dịch vụ nếu chưa được cung cấp.
            if (x.getMaDichVu() == null
                    || x.getMaDichVu().isBlank()) {

                x.setMaDichVu(
                        MaCodeGenerator.nextId(
                                dao.findAll(em),
                                "maDichVu",
                                "DV"
                        )
                );
            }

            // Kiểm tra mã dịch vụ đã tồn tại hay chưa.
            if (dao.findById(em, x.getMaDichVu()) != null) {
                throw new IllegalArgumentException(
                        "Mã dịch vụ đã tồn tại: "
                                + x.getMaDichVu()
                );
            }

            // Mặc định dịch vụ đang kinh doanh.
            if (x.getDangKinhDoanh() == null) {
                x.setDangKinhDoanh(true);
            }

            dao.save(em, x);

            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;

        } finally {
            tm.close();
        }
    }

    /**
     * Tìm dịch vụ theo mã.
     */
    public DichVu findById(String id) {
        TransactionManager tm = new TransactionManager();

        try {
            return dao.findById(
                    tm.getEntityManager(),
                    id
            );

        } finally {
            tm.close();
        }
    }

    /**
     * Lấy danh sách tất cả dịch vụ.
     */
    public List<DichVu> findAll() {
        TransactionManager tm = new TransactionManager();

        try {
            return dao.findAll(
                    tm.getEntityManager()
            );

        } finally {
            tm.close();
        }
    }

    /**
     * Lấy danh sách dịch vụ đang kinh doanh.
     */
    public List<DichVu> findDangKinhDoanh() {
        return findAll()
                .stream()
                .filter(x ->
                        Boolean.TRUE.equals(
                                x.getDangKinhDoanh()
                        )
                )
                .toList();
    }

    /**
     * Cập nhật thông tin dịch vụ.
     */
    public void capNhat(DichVu x) {
        validate(x);

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();

            EntityManager em = tm.getEntityManager();

            // Kiểm tra dịch vụ có tồn tại hay không.
            if (dao.findById(em, x.getMaDichVu()) == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy dịch vụ: "
                                + x.getMaDichVu()
                );
            }

            dao.update(em, x);

            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;

        } finally {
            tm.close();
        }
    }

    /**
     * Ngừng kinh doanh dịch vụ.
     */
    public void ngungKinhDoanh(String id) {
        capNhatTrangThai(id, false);
    }

    /**
     * Mở lại kinh doanh dịch vụ.
     */
    public void moKinhDoanh(String id) {
        capNhatTrangThai(id, true);
    }

    /**
     * Cập nhật trạng thái kinh doanh.
     */
    private void capNhatTrangThai(
            String id,
            boolean value
    ) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();

            EntityManager em = tm.getEntityManager();

            DichVu x = dao.findById(em, id);

            if (x == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy dịch vụ: " + id
                );
            }

            x.setDangKinhDoanh(value);

            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;

        } finally {
            tm.close();
        }
    }

    /**
     * Xóa dịch vụ.
     */
    public void xoa(String id) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();

            EntityManager em = tm.getEntityManager();

            DichVu x = dao.findById(em, id);

            if (x == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy dịch vụ: " + id
                );
            }

            dao.delete(em, x);

            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;

        } finally {
            tm.close();
        }
    }

    /**
     * Kiểm tra dữ liệu dịch vụ.
     */
    private void validate(DichVu x) {
        if (x == null
                || blank(x.getTenDichVu())
                || x.getDonGia() == null
                || x.getDonGia().compareTo(BigDecimal.ZERO) < 0) {

            throw new IllegalArgumentException(
                    "Thông tin dịch vụ không hợp lệ."
            );
        }
    }

    /**
     * Kiểm tra chuỗi null hoặc rỗng.
     */
    private boolean blank(String s) {
        return s == null || s.isBlank();
    }
}
