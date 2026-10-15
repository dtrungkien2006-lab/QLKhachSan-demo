
package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.DatPhongDAO;
import com.hotel.dao.KhachHangDAO;
import com.hotel.entity.DatPhong;
import com.hotel.entity.KhachHang;
import com.hotel.util.MaCodeGenerator;
import jakarta.persistence.EntityManager;

import java.util.List;
import java.util.Locale;

public class KhachHangService {

    private final KhachHangDAO dao = new KhachHangDAO();
    private final DatPhongDAO datPhongDAO = new DatPhongDAO();

    public void them(KhachHang khachHang) {
        validate(khachHang);
        normalize(khachHang);

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            if (blank(khachHang.getMaKH())) {
                khachHang.setMaKH(
                        MaCodeGenerator.nextId(
                                dao.findAll(em),
                                "maKH",
                                "KH"
                        )
                );
            }

            if (dao.findById(em, khachHang.getMaKH()) != null) {
                throw new IllegalArgumentException(
                        "Mã khách hàng đã tồn tại: "
                                + khachHang.getMaKH()
                );
            }

            ensureUnique(em, khachHang, null);

            dao.save(em, khachHang);
            tm.commit();

        } catch (RuntimeException e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public KhachHang findById(String maKH) {
        TransactionManager tm = new TransactionManager();

        try {
            return dao.findById(tm.getEntityManager(), maKH);
        } finally {
            tm.close();
        }
    }

    public List<KhachHang> findAll() {
        TransactionManager tm = new TransactionManager();

        try {
            return dao.findAll(tm.getEntityManager());
        } finally {
            tm.close();
        }
    }

    public void capNhat(KhachHang khachHang) {
        validate(khachHang);

        if (blank(khachHang.getMaKH())) {
            throw new IllegalArgumentException(
                    "Mã khách hàng không được để trống."
            );
        }

        normalize(khachHang);

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            KhachHang khachHangCu =
                    dao.findById(em, khachHang.getMaKH());

            if (khachHangCu == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy khách hàng: "
                                + khachHang.getMaKH()
                );
            }

            ensureUnique(em, khachHang, khachHang.getMaKH());

            dao.update(em, khachHang);
            tm.commit();

        } catch (RuntimeException e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public void xoa(String maKH) {
        if (blank(maKH)) {
            throw new IllegalArgumentException(
                    "Mã khách hàng không được để trống."
            );
        }

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            KhachHang khachHang = dao.findById(em, maKH);

            if (khachHang == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy khách hàng: " + maKH
                );
            }

            // Không xóa khách hàng đã có lịch sử đặt phòng.
            List<DatPhong> danhSachDatPhong =
                    datPhongDAO.findByKhachHang(em, maKH);

            if (danhSachDatPhong != null
                    && !danhSachDatPhong.isEmpty()) {
                throw new IllegalStateException(
                        "Không thể xóa khách hàng "
                                + maKH
                                + " vì khách hàng đã có lịch sử đặt phòng. "
                                + "Hãy giữ lại hồ sơ để bảo toàn lịch sử "
                                + "đặt phòng, hóa đơn và thanh toán."
                );
            }

            dao.delete(em, khachHang);
            tm.commit();

        } catch (RuntimeException e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    private void validate(KhachHang x) {
        if (x == null) {
            throw new IllegalArgumentException(
                    "Thông tin khách hàng không hợp lệ."
            );
        }

        if (blank(x.getHoTen())) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập họ tên khách hàng."
            );
        }

        if (blank(x.getSoDienThoai())) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập số điện thoại."
            );
        }

        if (!blank(x.getCccd())) {
            String cccd = x.getCccd().trim();

            if (!cccd.matches("[0-9]{12}")) {
                throw new IllegalArgumentException(
                        "CCCD phải gồm đúng 12 chữ số."
                );
            }
        }
    }

    /**
     * Chuẩn hóa dữ liệu trước khi lưu hoặc cập nhật.
     */
    private void normalize(KhachHang x) {
        x.setHoTen(normalizeSpaces(x.getHoTen()));

        if (x.getCccd() != null) {
            x.setCccd(x.getCccd().trim());
        }

        if (x.getSoDienThoai() != null) {
            x.setSoDienThoai(
                    normalizePhone(x.getSoDienThoai())
            );
        }

        if (x.getEmail() != null) {
            String email = x.getEmail().trim();

            x.setEmail(
                    email.isEmpty()
                            ? null
                            : email.toLowerCase(Locale.ROOT)
            );
        }

        if (x.getDiaChi() != null) {
            String diaChi = normalizeSpaces(x.getDiaChi());

            x.setDiaChi(diaChi.isEmpty() ? null : diaChi);
        }
    }

    /**
     * Kiểm tra CCCD, số điện thoại và email trùng.
     * Bỏ qua chính khách hàng đang được cập nhật.
     */
    private void ensureUnique(
            EntityManager em,
            KhachHang x,
            String currentId) {

        String cccdMoi = normalizeCccd(x.getCccd());
        String dienThoaiMoi = normalizePhone(x.getSoDienThoai());
        String emailMoi = normalizeEmail(x.getEmail());

        for (KhachHang item : dao.findAll(em)) {

            if (currentId != null
                    && currentId.equals(item.getMaKH())) {
                continue;
            }

            if (cccdMoi != null
                    && cccdMoi.equals(normalizeCccd(item.getCccd()))) {
                throw new IllegalArgumentException(
                        "CCCD đã được sử dụng."
                );
            }

            if (dienThoaiMoi.equals(
                    normalizePhone(item.getSoDienThoai()))) {
                throw new IllegalArgumentException(
                        "Số điện thoại đã được sử dụng."
                );
            }

            if (emailMoi != null
                    && emailMoi.equals(normalizeEmail(item.getEmail()))) {
                throw new IllegalArgumentException(
                        "Email đã được sử dụng."
                );
            }
        }
    }

    /**
     * Xóa khoảng trắng đầu/cuối và gộp nhiều khoảng trắng liên tiếp.
     */
    private String normalizeSpaces(String value) {
        if (value == null) {
            return "";
        }

        return value.trim().replaceAll("\\s+", " ");
    }

    /**
     * Chuẩn hóa số điện thoại bằng cách bỏ dấu cách,
     * dấu chấm, dấu gạch ngang và dấu ngoặc.
     * Giữ nguyên dấu + nếu có.
     */
    private String normalizePhone(String value) {
        if (value == null) {
            return "";
        }

        return value.trim().replaceAll("[\\s().-]", "");
    }

    private String normalizeCccd(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return value.trim();
    }

    private String normalizeEmail(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return value.trim().toLowerCase(Locale.ROOT);
    }

    private boolean blank(String value) {
        return value == null || value.isBlank();
    }
}
