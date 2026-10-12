package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.ThongKeDAO;
import com.hotel.dto.DoanhThuDTO;
import com.hotel.dto.ThongKeDatPhongDTO;
import com.hotel.dto.ThongKeDoanhThuDTO;
import com.hotel.dto.ThongKeKhachDTO;
import com.hotel.dto.ThongKePhongDTO;
import com.hotel.entity.CtDatPhong;
import com.hotel.entity.DatPhong;
import com.hotel.entity.HoaDon;
import com.hotel.entity.KhachHang;
import com.hotel.entity.ThanhToan;
import com.hotel.enums.KieuThoiGian;
import com.hotel.enums.TrangThaiPhong;
import jakarta.persistence.EntityManager;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * TV5 - Nghiệp vụ Thống kê.
 * Mọi khoảng thời gian nhận vào là [tuNgay, denNgay] tính cả hai đầu (theo ngày).
 */
public class ThongKeService {

    private final ThongKeDAO dao = new ThongKeDAO();

    // ------------------------------------------------------------------
    // 1. Thống kê phòng
    // ------------------------------------------------------------------
    public ThongKePhongDTO thongKePhong(LocalDate tuNgay, LocalDate denNgay) {
        kiemTraKhoang(tuNgay, denNgay);
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            Map<TrangThaiPhong, Long> dem = dao.demPhongTheoTrangThai(em);

            ThongKePhongDTO dto = new ThongKePhongDTO();
            long trong = dem.getOrDefault(TrangThaiPhong.TRONG, 0L);
            long daDat = dem.getOrDefault(TrangThaiPhong.DA_DAT, 0L);
            long dangO = dem.getOrDefault(TrangThaiPhong.DANG_SU_DUNG, 0L);
            long tong = trong + daDat + dangO;
            dto.setPhongTrong(trong);
            dto.setPhongDaDat(daDat);
            dto.setPhongDangO(dangO);
            dto.setTongPhong(tong);
            dto.setTyLeDangO(phanTram(dangO, tong));

            // Công suất trong kỳ: số đêm phòng đã bán / (tổng phòng x số ngày)
            LocalDate den = denNgay.plusDays(1); // loại trừ đầu phải
            long soNgay = ChronoUnit.DAYS.between(tuNgay, den);
            long soDemBan = 0;
            for (CtDatPhong ct : dao.findCtDatPhongGiaoKhoang(em, tuNgay, den)) {
                soDemBan += soDemTrongKhoang(ct, tuNgay, den);
            }
            dto.setSoNgayTrongKy(soNgay);
            dto.setSoDemPhongDaBan(soDemBan);
            dto.setTyLeSuDungTrongKy(phanTram(soDemBan, tong * soNgay));
            return dto;
        } finally {
            tm.close();
        }
    }

    // ------------------------------------------------------------------
    // 2. Thống kê đặt phòng
    // ------------------------------------------------------------------
    public ThongKeDatPhongDTO thongKeDatPhong(LocalDate tuNgay, LocalDate denNgay, KieuThoiGian kieu) {
        kiemTraKhoang(tuNgay, denNgay);
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            List<DatPhong> ds = dao.findDatPhongTrongKhoang(em, batDau(tuNgay), ketThuc(denNgay));

            ThongKeDatPhongDTO dto = new ThongKeDatPhongDTO();
            Map<String, Long> theoTg = new TreeMap<>();
            Map<String, Long> huyTg = new TreeMap<>();
            for (DatPhong d : ds) {
                String nhan = kieu.nhom(d.getNgayDat());
                theoTg.merge(nhan, 1L, Long::sum);
                switch (d.getTrangThai()) {
                    case CHO_XAC_NHAN -> dto.setChoXacNhan(dto.getChoXacNhan() + 1);
                    case DA_XAC_NHAN -> dto.setDaXacNhan(dto.getDaXacNhan() + 1);
                    case DANG_O -> dto.setDangO(dto.getDangO() + 1);
                    case DA_TRA_PHONG -> dto.setDaTraPhong(dto.getDaTraPhong() + 1);
                    case DA_HUY -> {
                        dto.setDaHuy(dto.getDaHuy() + 1);
                        huyTg.merge(nhan, 1L, Long::sum);
                    }
                }
            }
            dto.setTong(ds.size());
            dto.setTyLeHuy(phanTram(dto.getDaHuy(), ds.size()));
            dto.setTheoThoiGian(new LinkedHashMap<>(theoTg));
            dto.setHuyTheoThoiGian(new LinkedHashMap<>(huyTg));
            return dto;
        } finally {
            tm.close();
        }
    }

    // ------------------------------------------------------------------
    // 3. Thống kê khách hàng và lịch sử lưu trú
    // ------------------------------------------------------------------
    public List<ThongKeKhachDTO> thongKeKhach(LocalDate tuNgay, LocalDate denNgay) {
        return thongKeKhach(tuNgay, denNgay, false);
    }

    public List<ThongKeKhachDTO> thongKeKhach(LocalDate tuNgay, LocalDate denNgay, boolean gomNhap) {
        kiemTraKhoang(tuNgay, denNgay);
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            LocalDate den = denNgay.plusDays(1);

            Map<String, ThongKeKhachDTO> theoKhach = new LinkedHashMap<>();
            Map<String, java.util.Set<String>> datPhongCuaKhach = new LinkedHashMap<>();

            for (CtDatPhong ct : dao.findCtDatPhongGiaoKhoang(em, tuNgay, den)) {
                DatPhong dp = ct.getDatPhong();
                KhachHang kh = dp.getKhachHang();
                ThongKeKhachDTO row = theoKhach.computeIfAbsent(kh.getMaKH(), k -> {
                    ThongKeKhachDTO x = new ThongKeKhachDTO();
                    x.setMaKH(kh.getMaKH());
                    x.setHoTen(kh.getHoTen());
                    x.setSoDienThoai(kh.getSoDienThoai());
                    return x;
                });
                datPhongCuaKhach.computeIfAbsent(kh.getMaKH(), k -> new java.util.HashSet<>())
                        .add(dp.getMaDatPhong());
                row.setSoDemLuuTru(row.getSoDemLuuTru() + soDemTrongKhoang(ct, tuNgay, den));
                if (row.getLanLuuTruGanNhat() == null || ct.getNgayNhan().isAfter(row.getLanLuuTruGanNhat())) {
                    row.setLanLuuTruGanNhat(ct.getNgayNhan());
                }
            }
            datPhongCuaKhach.forEach((ma, set) -> theoKhach.get(ma).setSoLanDatPhong(set.size()));

            // Tổng chi tiêu = hóa đơn đã phát hành trong kỳ của khách
            for (HoaDon h : dao.findHoaDonTinhDoanhThu(em, batDau(tuNgay), ketThuc(denNgay), gomNhap)) {
                ThongKeKhachDTO row = theoKhach.get(h.getDatPhong().getKhachHang().getMaKH());
                if (row != null) row.setTongChiTieu(row.getTongChiTieu().add(h.getTongTien()));
            }

            List<ThongKeKhachDTO> kq = new ArrayList<>(theoKhach.values());
            kq.sort(Comparator.comparing(ThongKeKhachDTO::getSoDemLuuTru).reversed());
            return kq;
        } finally {
            tm.close();
        }
    }

    // ------------------------------------------------------------------
    // 4. Thống kê doanh thu (theo ngày/tháng/năm và theo nguồn thu)
    // ------------------------------------------------------------------
    public ThongKeDoanhThuDTO thongKeDoanhThu(LocalDate tuNgay, LocalDate denNgay, KieuThoiGian kieu) {
        return thongKeDoanhThu(tuNgay, denNgay, kieu, false);
    }

    /** gomNhap=true: tính cả hóa đơn NHAP (doanh thu dự kiến, chưa phát hành). */
    public ThongKeDoanhThuDTO thongKeDoanhThu(LocalDate tuNgay, LocalDate denNgay, KieuThoiGian kieu, boolean gomNhap) {
        kiemTraKhoang(tuNgay, denNgay);
        TransactionManager tm = new TransactionManager();
        try {
            EntityManager em = tm.getEntityManager();
            LocalDateTime tu = batDau(tuNgay);
            LocalDateTime den = ketThuc(denNgay);

            ThongKeDoanhThuDTO dto = new ThongKeDoanhThuDTO();
            Map<String, DoanhThuDTO> theoTg = new TreeMap<>();
            BigDecimal phong = BigDecimal.ZERO;
            BigDecimal dichVu = BigDecimal.ZERO;
            int soHd = 0;

            for (HoaDon h : dao.findHoaDonTinhDoanhThu(em, tu, den, gomNhap)) {
                String nhan = kieu.nhom(h.getNgayLap());
                theoTg.computeIfAbsent(nhan, DoanhThuDTO::new)
                        .cong(h.getTongTienPhong(), h.getTongTienDichVu(), h.getTongTien());
                phong = phong.add(h.getTongTienPhong());
                dichVu = dichVu.add(h.getTongTienDichVu());
                soHd++;
            }
            dto.setTheoThoiGian(new ArrayList<>(theoTg.values()));
            dto.setTongTienPhong(phong);
            dto.setTongTienDichVu(dichVu);
            dto.setTongDoanhThu(phong.add(dichVu));
            dto.setTongSoHoaDon(soHd);

            // Thực thu theo phương thức (tiền mặt / chuyển khoản ...)
            Map<String, BigDecimal> theoPt = new LinkedHashMap<>();
            BigDecimal thucThu = BigDecimal.ZERO;
            for (ThanhToan t : dao.findThanhToanThanhCong(em, tu, den)) {
                theoPt.merge(t.getPhuongThuc().name(), t.getSoTien(), BigDecimal::add);
                thucThu = thucThu.add(t.getSoTien());
            }
            dto.setThucThuTheoPhuongThuc(theoPt);
            dto.setTongThucThu(thucThu);
            return dto;
        } finally {
            tm.close();
        }
    }

    // ------------------------------------------------------------------
    // Tiện ích
    // ------------------------------------------------------------------
    public static void kiemTraKhoang(LocalDate tu, LocalDate den) {
        if (tu == null || den == null) {
            throw new IllegalArgumentException("Vui lòng chọn khoảng thời gian.");
        }
        if (den.isBefore(tu)) {
            throw new IllegalArgumentException("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
        }
    }

    private static LocalDateTime batDau(LocalDate d) { return d.atStartOfDay(); }

    private static LocalDateTime ketThuc(LocalDate d) { return d.plusDays(1).atStartOfDay(); }

    /** Số đêm của chi tiết đặt phòng nằm trong [tu, den). */
    private static long soDemTrongKhoang(CtDatPhong ct, LocalDate tu, LocalDate den) {
        LocalDate bd = ct.getNgayNhan().isAfter(tu) ? ct.getNgayNhan() : tu;
        LocalDate kt = ct.getNgayTra().isBefore(den) ? ct.getNgayTra() : den;
        return Math.max(0, ChronoUnit.DAYS.between(bd, kt));
    }

    private static double phanTram(long tu, long mau) {
        if (mau <= 0) return 0;
        return Math.round(tu * 10000.0 / mau) / 100.0;
    }
}
