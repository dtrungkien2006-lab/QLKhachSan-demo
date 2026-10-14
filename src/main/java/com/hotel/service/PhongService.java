package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.LoaiPhongDAO;
import com.hotel.dao.PhongDAO;
import com.hotel.entity.LoaiPhong;
import com.hotel.entity.Phong;
import com.hotel.enums.TrangThaiPhong;
import com.hotel.util.MaCodeGenerator;
import jakarta.persistence.EntityManager;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class PhongService {

    private final PhongDAO dao = new PhongDAO();
    private final LoaiPhongDAO loaiPhongDAO = new LoaiPhongDAO();

    public void them(Phong x) {
        TransactionManager tm = new TransactionManager();
        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            // Tự động sinh mã phòng nếu để trống hoặc null
            if (x.getMaPhong() == null || x.getMaPhong().isBlank()) {
                x.setMaPhong(
                        MaCodeGenerator.nextId(
                                dao.findAll(em),
                                "maPhong",
                                "P"
                        )
                );
            } else {
                // Nếu người dùng tự nhập mã, kiểm tra xem đã tồn tại chưa
                if (dao.findById(em, x.getMaPhong().trim()) != null) {
                    throw new IllegalArgumentException(
                            "Mã phòng đã tồn tại: " + x.getMaPhong()
                    );
                }
                x.setMaPhong(x.getMaPhong().trim());
            }

            if (x.getSoPhong() == null || x.getSoPhong().isBlank()) {
                throw new IllegalArgumentException("Số phòng không được để trống.");
            }

            if (dao.findBySoPhong(em, x.getSoPhong().trim()) != null) {
                throw new IllegalArgumentException(
                        "Số phòng đã tồn tại: " + x.getSoPhong()
                );
            }

            if (x.getLoaiPhong() == null || x.getLoaiPhong().getMaLoaiPhong() == null) {
                throw new IllegalArgumentException("Vui lòng chọn loại phòng.");
            }

            LoaiPhong lp = loaiPhongDAO.findById(
                    em,
                    x.getLoaiPhong().getMaLoaiPhong()
            );

            if (lp == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy loại phòng."
                );
            }

            x.setLoaiPhong(lp);
            x.setSoPhong(x.getSoPhong().trim());
            if (x.getViTri() != null) {
                x.setViTri(x.getViTri().trim());
            }

            if (x.getTrangThai() == null) {
                x.setTrangThai(TrangThaiPhong.TRONG);
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

    public Phong findById(String id) {
        TransactionManager tm = new TransactionManager();
        try {
            return dao.findById(tm.getEntityManager(), id);
        } finally {
            tm.close();
        }
    }

    public Phong findByIdWithLoaiPhong(String id) {
        TransactionManager tm = new TransactionManager();
        try {
            return dao.findByIdWithLoaiPhong(
                    tm.getEntityManager(),
                    id
            );
        } finally {
            tm.close();
        }
    }

    public Phong findBySoPhong(String soPhong) {
        TransactionManager tm = new TransactionManager();
        try {
            return dao.findBySoPhong(
                    tm.getEntityManager(),
                    soPhong
            );
        } finally {
            tm.close();
        }
    }

    public List<Phong> findAll() {
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            return dao.findAllWithLoaiPhong(em);
        } finally {
            tm.close();
        }
    }

    public List<Phong> findByLoaiPhong(String maLoaiPhong) {
        TransactionManager tm = new TransactionManager();
        try {
            return dao.findByLoaiPhong(
                    tm.getEntityManager(),
                    maLoaiPhong
            );
        } finally {
            tm.close();
        }
    }

    public List<Phong> findPhongCoTheDat(
            LocalDate ngayNhan,
            LocalDate ngayTra) {

        validateKhoangNgay(ngayNhan, ngayTra);

        TransactionManager tm = new TransactionManager();
        try {
            return dao.findPhongCoTheDat(
                    tm.getEntityManager(),
                    ngayNhan,
                    ngayTra
            );
        } finally {
            tm.close();
        }
    }

    public List<Phong> findPhongCoTheDat(
            LocalDate ngayNhan,
            LocalDate ngayTra,
            String maLoaiPhong,
            BigDecimal giaTu,
            BigDecimal giaDen,
            TrangThaiPhong trangThai) {

        validateKhoangNgay(ngayNhan, ngayTra);

        if (giaTu != null && giaTu.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    "Giá từ không được âm."
            );
        }

        if (giaDen != null && giaDen.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    "Giá đến không được âm."
            );
        }

        if (giaTu != null && giaDen != null
                && giaTu.compareTo(giaDen) > 0) {
            throw new IllegalArgumentException(
                    "Giá từ không được lớn hơn giá đến."
            );
        }

        TransactionManager tm = new TransactionManager();
        try {
            return dao.findPhongCoTheDat(
                    tm.getEntityManager(),
                    ngayNhan,
                    ngayTra,
                    maLoaiPhong,
                    giaTu,
                    giaDen,
                    trangThai
            );
        } finally {
            tm.close();
        }
    }

    public void capNhat(Phong x) {
        TransactionManager tm = new TransactionManager();
        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            Phong current = dao.findById(em, x.getMaPhong());

            if (current == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy phòng: " + x.getMaPhong()
                );
            }

            Phong same = dao.findBySoPhong(em, x.getSoPhong());

            if (same != null
                    && !same.getMaPhong().equals(x.getMaPhong())) {
                throw new IllegalArgumentException(
                        "Số phòng đã tồn tại: " + x.getSoPhong()
                );
            }

            LoaiPhong lp = loaiPhongDAO.findById(
                    em,
                    x.getLoaiPhong().getMaLoaiPhong()
            );

            if (lp == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy loại phòng."
                );
            }

            x.setLoaiPhong(lp);

            dao.update(em, x);
            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public void capNhatTrangThai(
            String maPhong,
            TrangThaiPhong trangThai) {

        if (trangThai == null) {
            throw new IllegalArgumentException(
                    "Trạng thái phòng không được null."
            );
        }

        TransactionManager tm = new TransactionManager();
        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            Phong x = dao.findById(em, maPhong);

            if (x == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy phòng: " + maPhong
                );
            }

            x.setTrangThai(trangThai);
            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public void xoa(String id) {
        TransactionManager tm = new TransactionManager();
        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            Phong x = dao.findById(em, id);

            if (x == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy phòng: " + id
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

    private void validateKhoangNgay(
            LocalDate ngayNhan,
            LocalDate ngayTra) {

        if (ngayNhan == null || ngayTra == null
                || !ngayTra.isAfter(ngayNhan)) {
            throw new IllegalArgumentException(
                    "Khoảng ngày không hợp lệ."
            );
        }
    }
}