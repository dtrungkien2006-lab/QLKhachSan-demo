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
import java.time.ZoneId;
import java.util.List;

public class PhongService {

    private final PhongDAO dao = new PhongDAO();
    private final LoaiPhongDAO loaiPhongDAO = new LoaiPhongDAO();

    // =====================================================================
    // 1. TÌM PHÒNG TRỐNG THEO KHOẢNG NGÀY (TV2)
    // =====================================================================

    /**
     * Tìm phòng có thể đặt theo khoảng ngày.
     */
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

    /**
     * Tìm phòng có thể đặt kết hợp bộ lọc.
     */
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

    /**
     * Ngày hôm nay theo giờ Việt Nam (server như Railway chạy múi giờ UTC nên
     * không dùng LocalDate.now() mặc định).
     */
    public static LocalDate homNay() {
        return LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));
    }

    /**
     * Kiểm tra khoảng ngày.
     */
    private void validateKhoangNgay(
            LocalDate ngayNhan,
            LocalDate ngayTra) {

        if (ngayNhan == null || ngayTra == null
                || !ngayTra.isAfter(ngayNhan)) {
            throw new IllegalArgumentException(
                    "Khoảng ngày không hợp lệ."
            );
        }

        if (ngayNhan.isBefore(homNay())) {
            throw new IllegalArgumentException(
                    "Ngày nhận không được trước ngày hôm nay."
            );
        }
    }

    // =====================================================================
    // 2. TRA CỨU PHÒNG
    // =====================================================================

    /**
     * Tìm phòng theo mã phòng.
     */
    public Phong findById(String id) {
        TransactionManager tm = new TransactionManager();
        try {
            return dao.findById(tm.getEntityManager(), id);
        } finally {
            tm.close();
        }
    }

    /**
     * Tìm phòng theo mã và tải kèm loại phòng.
     */
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

    /**
     * Tìm phòng theo số phòng.
     */
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

    /**
     * Lấy toàn bộ danh sách phòng cùng loại phòng.
     * Sửa lỗi LazyInitializationException khi JSP đọc tenLoaiPhong.
     */
    public List<Phong> findAll() {
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            return dao.findAllWithLoaiPhong(em);
        } finally {
            tm.close();
        }
    }

    /**
     * Lấy danh sách phòng theo loại phòng.
     */
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

    // =====================================================================
    // 3. QUẢN LÝ PHÒNG (thêm, sửa, đổi trạng thái, xóa)
    // =====================================================================

    /**
     * THÊM PHÒNG MỚI
     */
    public void them(Phong x) {
        validate(x);

        TransactionManager tm = new TransactionManager();
        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            if (x.getMaPhong() == null || x.getMaPhong().isBlank()) {
                x.setMaPhong(
                        MaCodeGenerator.nextId(
                                dao.findAll(em),
                                "maPhong",
                                "P"
                        )
                );
            }

            if (dao.findById(em, x.getMaPhong()) != null) {
                throw new IllegalArgumentException(
                        "Mã phòng đã tồn tại: " + x.getMaPhong()
                );
            }

            if (dao.findBySoPhong(em, x.getSoPhong()) != null) {
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

    /**
     * Cập nhật thông tin phòng.
     */
    public void capNhat(Phong x) {
        validate(x);

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

    /**
     * Cập nhật trạng thái phòng.
     */
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

    /**
     * Xóa phòng.
     */
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

    // =====================================================================
    // 4. HÀM HỖ TRỢ KIỂM TRA DỮ LIỆU
    // =====================================================================

    /**
     * Kiểm tra dữ liệu phòng.
     */
    private void validate(Phong x) {
        if (x == null
                || blank(x.getMaPhong()) && x.getMaPhong() != null
                || blank(x.getSoPhong())
                || x.getLoaiPhong() == null
                || blank(x.getLoaiPhong().getMaLoaiPhong())) {
            throw new IllegalArgumentException(
                    "Thông tin phòng không hợp lệ."
            );
        }
    }

    /**
     * Kiểm tra chuỗi rỗng hoặc chỉ chứa khoảng trắng.
     */
    private boolean blank(String s) {
        return s == null || s.isBlank();
    }
}