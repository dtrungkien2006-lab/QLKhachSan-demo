
package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.CtHoaDonDAO;
import com.hotel.dao.HoaDonDAO;
import com.hotel.dao.SuDungDichVuDAO;
import com.hotel.dao.ThanhToanDAO;
import com.hotel.entity.CtDatPhong;
import com.hotel.entity.CtHoaDon;
import com.hotel.entity.DatPhong;
import com.hotel.entity.DichVu;
import com.hotel.entity.HoaDon;
import com.hotel.entity.SuDungDichVu;
import com.hotel.entity.ThanhToan;
import com.hotel.enums.TrangThaiHoaDon;
import com.hotel.enums.TrangThaiDatPhong;
import com.hotel.enums.TrangThaiThanhToan;
import com.hotel.util.MaCodeGenerator;
import jakarta.persistence.EntityManager;
import org.hibernate.Hibernate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class HoaDonService {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();
    private final CtHoaDonDAO ctHoaDonDAO = new CtHoaDonDAO();
    private final SuDungDichVuDAO suDungDichVuDAO =
            new SuDungDichVuDAO();
    private final ThanhToanDAO thanhToanDAO =
            new ThanhToanDAO();

    /**
     * Tạo hoặc cập nhật hóa đơn cho một đặt phòng.
     * Nếu hóa đơn đã tồn tại thì cập nhật chi tiết, không tạo trùng.
     */
    public HoaDon taoHoaDon(String maDatPhong) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            DatPhong datPhong = em.find(
                    DatPhong.class, maDatPhong);

            if (datPhong == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy đặt phòng: " + maDatPhong);
            }

            if (datPhong.getTrangThai()
                    == TrangThaiDatPhong.DA_HUY) {
                throw new IllegalStateException(
                        "Không thể lập hóa đơn cho đặt phòng đã hủy.");
            }

            if (datPhong.getChiTietDatPhong() == null
                    || datPhong.getChiTietDatPhong().isEmpty()) {
                throw new IllegalStateException(
                        "Đặt phòng không có chi tiết phòng.");
            }

            BigDecimal tongTienPhong = BigDecimal.ZERO;
            BigDecimal tongTienDichVu = BigDecimal.ZERO;
            List<CtHoaDon> chiTietMoi = new ArrayList<>();

            // Tính tiền phòng.
            for (CtDatPhong ct : datPhong.getChiTietDatPhong()) {
                BigDecimal tienPhong = tinhTienPhong(ct);
                tongTienPhong = tongTienPhong.add(tienPhong);

                CtHoaDon line = new CtHoaDon();
                line.setTenKhoanThu(
                        "Tiền phòng "
                        + (ct.getPhong() != null
                           ? ct.getPhong().getSoPhong()
                           : ""));
                line.setSoLuong(1);
                line.setDonGia(ct.getGiaPhong());
                line.setThanhTien(tienPhong);

                chiTietMoi.add(line);
            }

            // Tính tiền dịch vụ.
            List<SuDungDichVu> danhSachSuDung =
                    suDungDichVuDAO.findByDatPhong(
                            em, maDatPhong);

            for (SuDungDichVu sd : danhSachSuDung) {
                BigDecimal tienDichVu = tinhTienDichVu(sd);
                tongTienDichVu =
                        tongTienDichVu.add(tienDichVu);

                CtHoaDon line = taoChiTietDichVu(
                        sd, tienDichVu);
                chiTietMoi.add(line);
            }

            BigDecimal tongTien =
                    tongTienPhong.add(tongTienDichVu);

            // Tìm hóa đơn hiện có.
            List<HoaDon> hoaDons =
                    hoaDonDAO.findByDatPhong(em, maDatPhong);

            HoaDon hoaDon;

            if (hoaDons.isEmpty()) {
                hoaDon = new HoaDon();
                hoaDon.setMaHoaDon(
                        MaCodeGenerator.nextId(
                                hoaDonDAO.findAll(em),
                                "maHoaDon",
                                "HD"));

                hoaDon.setDatPhong(datPhong);
                hoaDon.setNgayLap(LocalDateTime.now());
                hoaDon.setTrangThai(TrangThaiHoaDon.NHAP);

                hoaDonDAO.save(em, hoaDon);
            } else {
                hoaDon = hoaDons.get(0);

                if (hoaDon.getTrangThai()
                        == TrangThaiHoaDon.DA_HUY) {
                    throw new IllegalStateException(
                            "Hóa đơn đã hủy, không thể cập nhật.");
                }

                if (hoaDon.getTrangThai()
                        == TrangThaiHoaDon.DA_PHAT_HANH) {
                    throw new IllegalStateException(
                            "Hóa đơn đã phát hành. "
                            + "Không thể tự động tính lại hóa đơn.");
                }

                for (CtHoaDon old : ctHoaDonDAO.findAll(em)) {
                    if (old.getHoaDon() != null
                            && hoaDon.getMaHoaDon().equals(
                                    old.getHoaDon().getMaHoaDon())) {
                        ctHoaDonDAO.delete(em, old);
                    }
                }
            }

            hoaDon.setTongTienPhong(tongTienPhong);
            hoaDon.setTongTienDichVu(tongTienDichVu);
            hoaDon.setTongTien(tongTien);

            hoaDonDAO.update(em, hoaDon);

            Set<String> maDaSinh = new HashSet<>();

            for (CtHoaDon line : chiTietMoi) {
                line.setMaCtHoaDon(
                        MaCodeGenerator.nextId(
                                ctHoaDonDAO.findAll(em),
                                "maCtHoaDon",
                                "CTHD",
                                maDaSinh));

                maDaSinh.add(line.getMaCtHoaDon());
                line.setHoaDon(hoaDon);
                ctHoaDonDAO.save(em, line);
            }

            tm.commit();
            return hoaDon;

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    private BigDecimal tinhTienPhong(CtDatPhong ct) {
        if (ct.getNgayNhan() == null
                || ct.getNgayTra() == null
                || ct.getGiaPhong() == null) {
            throw new IllegalArgumentException(
                    "Chi tiết đặt phòng thiếu ngày hoặc giá phòng.");
        }

        long soDem = ChronoUnit.DAYS.between(
                ct.getNgayNhan(), ct.getNgayTra());

        if (soDem <= 0) {
            throw new IllegalArgumentException(
                    "Số đêm lưu trú phải lớn hơn 0.");
        }

        return ct.getGiaPhong().multiply(
                BigDecimal.valueOf(soDem));
    }

    private BigDecimal tinhTienDichVu(SuDungDichVu sd) {
        if (sd.getSoLuong() == null
                || sd.getDonGia() == null
                || sd.getSoLuong() <= 0) {
            throw new IllegalArgumentException(
                    "Số lượng hoặc đơn giá dịch vụ không hợp lệ.");
        }

        return sd.getDonGia().multiply(
                BigDecimal.valueOf(sd.getSoLuong()));
    }

    private CtHoaDon taoChiTietDichVu(
            SuDungDichVu sd, BigDecimal thanhTien) {

        CtHoaDon line = new CtHoaDon();
        DichVu dichVu = sd.getDichVu();

        line.setTenKhoanThu(
                dichVu != null
                        ? dichVu.getTenDichVu()
                        : "Dịch vụ");

        line.setSoLuong(sd.getSoLuong());
        line.setDonGia(sd.getDonGia());
        line.setThanhTien(thanhTien);

        return line;
    }

    public void phatHanhHoaDon(String maHoaDon) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            HoaDon hd = hoaDonDAO.findById(em, maHoaDon);

            if (hd == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy hóa đơn: " + maHoaDon);
            }

            if (hd.getTrangThai() != TrangThaiHoaDon.NHAP) {
                throw new IllegalStateException(
                        "Chỉ hóa đơn NHAP mới được phát hành.");
            }

            hd.setTrangThai(TrangThaiHoaDon.DA_PHAT_HANH);
            hoaDonDAO.update(em, hd);

            tm.commit();
        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public void huyHoaDon(String maHoaDon) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            HoaDon hd = hoaDonDAO.findById(em, maHoaDon);

            if (hd == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy hóa đơn: " + maHoaDon);
            }

            if (hd.getTrangThai() == TrangThaiHoaDon.DA_HUY) {
                throw new IllegalStateException(
                        "Hóa đơn đã được hủy.");
            }

            hd.setTrangThai(TrangThaiHoaDon.DA_HUY);
            hoaDonDAO.update(em, hd);

            tm.commit();
        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    public HoaDon findById(String maHoaDon) {
        TransactionManager tm = new TransactionManager();

        try {
            HoaDon hd = hoaDonDAO.findById(
                    tm.getEntityManager(), maHoaDon);
            initialize(hd);
            return hd;
        } finally {
            tm.close();
        }
    }

    public List<HoaDon> findByDatPhong(String maDatPhong) {
        TransactionManager tm = new TransactionManager();

        try {
            List<HoaDon> items = hoaDonDAO.findByDatPhong(
                    tm.getEntityManager(), maDatPhong);
            items.forEach(this::initialize);
            return items;
        } finally {
            tm.close();
        }
    }

    /**
     * Danh sách hóa đơn còn số tiền phải thu.
     * Hóa đơn đã thanh toán đủ không xuất hiện trong danh sách này.
     * Không xóa hóa đơn hoặc lịch sử giao dịch khỏi database.
     */
    public List<HoaDon> findHoaDonConPhaiThu() {
        TransactionManager tm = new TransactionManager();

        try {
            EntityManager em = tm.getEntityManager();

            List<HoaDon> danhSach = hoaDonDAO.findAll(em);
            List<HoaDon> ketQua = new ArrayList<>();

            for (HoaDon hoaDon : danhSach) {
                if (hoaDon.getTrangThai()
                        == TrangThaiHoaDon.DA_HUY) {
                    continue;
                }

                if (hoaDon.getTongTien() == null
                        || hoaDon.getDatPhong() == null) {
                    continue;
                }

                String maDatPhong =
                        hoaDon.getDatPhong().getMaDatPhong();

                BigDecimal daThanhToan = BigDecimal.ZERO;

                List<ThanhToan> giaoDich =
                        thanhToanDAO.findByDatPhong(em, maDatPhong);

                for (ThanhToan tt : giaoDich) {
                    if (tt.getTrangThai()
                            == TrangThaiThanhToan.DA_THANH_TOAN
                            && tt.getSoTien() != null) {
                        daThanhToan =
                                daThanhToan.add(tt.getSoTien());
                    }
                }

                BigDecimal conPhaiThu =
                        hoaDon.getTongTien().subtract(daThanhToan);

                if (conPhaiThu.compareTo(BigDecimal.ZERO) > 0) {
                    initialize(hoaDon);
                    ketQua.add(hoaDon);
                }
            }

            return ketQua;

        } finally {
            tm.close();
        }
    }

    public List<HoaDon> findAll() {
        TransactionManager tm = new TransactionManager();

        try {
            List<HoaDon> items =
                    hoaDonDAO.findAll(tm.getEntityManager());
            items.forEach(this::initialize);
            return items;
        } finally {
            tm.close();
        }
    }

    public void xoa(String maHoaDon) {
        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            HoaDon hd = hoaDonDAO.findById(em, maHoaDon);

            if (hd == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy hóa đơn: " + maHoaDon);
            }

            if (hd.getTrangThai() != TrangThaiHoaDon.NHAP) {
                throw new IllegalStateException(
                        "Chỉ hóa đơn NHAP mới được xóa.");
            }

            hoaDonDAO.delete(em, hd);
            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }
    }

    private void initialize(HoaDon hd) {
        if (hd == null) {
            return;
        }

        Hibernate.initialize(hd.getDatPhong());

        if (hd.getDatPhong() != null) {
            Hibernate.initialize(
                    hd.getDatPhong().getKhachHang());
        }

        Hibernate.initialize(hd.getChiTietHoaDon());
    }
}
