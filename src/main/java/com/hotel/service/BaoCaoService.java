package com.hotel.service;

import com.hotel.dto.BaoCaoDTO;
import com.hotel.dto.DoanhThuDTO;
import com.hotel.dto.ThongKeDatPhongDTO;
import com.hotel.dto.ThongKeDoanhThuDTO;
import com.hotel.dto.ThongKeKhachDTO;
import com.hotel.dto.ThongKePhongDTO;
import com.hotel.enums.KieuThoiGian;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * TV5 - Nghiệp vụ Báo cáo.
 * Báo cáo dựng trên số liệu của ThongKeService và trả về BaoCaoDTO dạng bảng,
 * dùng chung cho màn hình xem và xuất CSV.
 */
public class BaoCaoService {

    public static final String DOANH_THU = "doanh-thu";
    public static final String SU_DUNG_PHONG = "su-dung-phong";
    public static final String DAT_PHONG = "dat-phong";
    public static final String LUU_TRU = "luu-tru";

    private static final DateTimeFormatter NGAY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final NumberFormat TIEN = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));

    private final ThongKeService thongKeService = new ThongKeService();

    public BaoCaoDTO taoBaoCao(String loai, LocalDate tu, LocalDate den, KieuThoiGian kieu) {
        return taoBaoCao(loai, tu, den, kieu, false);
    }

    /** gomNhap: chỉ ảnh hưởng báo cáo doanh thu và lưu trú (tính cả hóa đơn nháp = doanh thu dự kiến). */
    public BaoCaoDTO taoBaoCao(String loai, LocalDate tu, LocalDate den, KieuThoiGian kieu, boolean gomNhap) {
        ThongKeService.kiemTraKhoang(tu, den);
        String l = loai == null ? DOANH_THU : loai;
        return switch (l) {
            case DOANH_THU -> baoCaoDoanhThu(tu, den, kieu, gomNhap);
            case SU_DUNG_PHONG -> baoCaoSuDungPhong(tu, den);
            case DAT_PHONG -> baoCaoDatPhong(tu, den, kieu);
            case LUU_TRU -> baoCaoLuuTru(tu, den, gomNhap);
            default -> throw new IllegalArgumentException("Loại báo cáo không hợp lệ: " + loai);
        };
    }

    // ---------------- Báo cáo doanh thu ----------------
    public BaoCaoDTO baoCaoDoanhThu(LocalDate tu, LocalDate den, KieuThoiGian kieu) {
        return baoCaoDoanhThu(tu, den, kieu, false);
    }

    public BaoCaoDTO baoCaoDoanhThu(LocalDate tu, LocalDate den, KieuThoiGian kieu, boolean gomNhap) {
        ThongKeDoanhThuDTO tk = thongKeService.thongKeDoanhThu(tu, den, kieu, gomNhap);
        BaoCaoDTO bc = khoiTao(gomNhap ? "BÁO CÁO DOANH THU (GỒM HÓA ĐƠN NHÁP - DỰ KIẾN)" : "BÁO CÁO DOANH THU", tu, den);
        bc.setCot(List.of("Thời gian", "Số hóa đơn", "Tiền phòng", "Tiền dịch vụ", "Tổng doanh thu"));
        for (DoanhThuDTO r : tk.getTheoThoiGian()) {
            bc.getDong().add(List.of(r.getThoiGian(), String.valueOf(r.getSoHoaDon()),
                    tien(r.getTienPhong()), tien(r.getTienDichVu()), tien(r.getTongTien())));
        }
        List<Number> bdPhong = new ArrayList<>();
        List<Number> bdDichVu = new ArrayList<>();
        for (DoanhThuDTO r : tk.getTheoThoiGian()) {
            bc.getNhanBieuDo().add(r.getThoiGian());
            bdPhong.add(r.getTienPhong());
            bdDichVu.add(r.getTienDichVu());
        }
        bc.setLoaiBieuDo("bar");
        bc.setXepChong(true);
        bc.setTieuDeBieuDo("Doanh thu " + kieu.getNhan().toLowerCase() + " (đồng)");
        bc.getChuoiBieuDo().put("Tiền phòng", bdPhong);
        bc.getChuoiBieuDo().put("Tiền dịch vụ", bdDichVu);
        bc.getTongKet().put("Kiểu thống kê", kieu.getNhan());
        bc.getTongKet().put(gomNhap ? "Tổng số hóa đơn (phát hành + nháp)" : "Tổng số hóa đơn đã phát hành", String.valueOf(tk.getTongSoHoaDon()));
        bc.getTongKet().put("Doanh thu tiền phòng", tien(tk.getTongTienPhong()));
        bc.getTongKet().put("Doanh thu dịch vụ", tien(tk.getTongTienDichVu()));
        bc.getTongKet().put("Tổng doanh thu", tien(tk.getTongDoanhThu()));
        for (Map.Entry<String, BigDecimal> e : tk.getThucThuTheoPhuongThuc().entrySet()) {
            bc.getTongKet().put("Thực thu - " + e.getKey(), tien(e.getValue()));
        }
        bc.getTongKet().put("Tổng thực thu", tien(tk.getTongThucThu()));
        return bc;
    }

    // ---------------- Báo cáo tình hình sử dụng phòng ----------------
    public BaoCaoDTO baoCaoSuDungPhong(LocalDate tu, LocalDate den) {
        ThongKePhongDTO tk = thongKeService.thongKePhong(tu, den);
        BaoCaoDTO bc = khoiTao("BÁO CÁO TÌNH HÌNH SỬ DỤNG PHÒNG", tu, den);
        bc.setCot(List.of("Chỉ tiêu", "Giá trị"));
        bc.getDong().add(List.of("Tổng số phòng", String.valueOf(tk.getTongPhong())));
        bc.getDong().add(List.of("Phòng trống (hiện tại)", String.valueOf(tk.getPhongTrong())));
        bc.getDong().add(List.of("Phòng đã đặt (hiện tại)", String.valueOf(tk.getPhongDaDat())));
        bc.getDong().add(List.of("Phòng đang ở (hiện tại)", String.valueOf(tk.getPhongDangO())));
        bc.getDong().add(List.of("Tỷ lệ phòng đang ở (hiện tại)", tk.getTyLeDangO() + "%"));
        bc.getDong().add(List.of("Số ngày trong kỳ", String.valueOf(tk.getSoNgayTrongKy())));
        bc.getDong().add(List.of("Số đêm phòng đã bán trong kỳ", String.valueOf(tk.getSoDemPhongDaBan())));
        bc.setLoaiBieuDo("doughnut");
        bc.setTieuDeBieuDo("Tình trạng phòng hiện tại");
        bc.setNhanBieuDo(new ArrayList<>(List.of("Trống", "Đã đặt", "Đang ở")));
        bc.getChuoiBieuDo().put("Số phòng", List.of(tk.getPhongTrong(), tk.getPhongDaDat(), tk.getPhongDangO()));
        bc.getTongKet().put("Công suất sử dụng phòng trong kỳ", tk.getTyLeSuDungTrongKy() + "%");
        return bc;
    }

    // ---------------- Báo cáo đặt phòng ----------------
    public BaoCaoDTO baoCaoDatPhong(LocalDate tu, LocalDate den, KieuThoiGian kieu) {
        ThongKeDatPhongDTO tk = thongKeService.thongKeDatPhong(tu, den, kieu);
        BaoCaoDTO bc = khoiTao("BÁO CÁO ĐẶT PHÒNG", tu, den);
        bc.setCot(List.of("Thời gian", "Số đặt phòng", "Số hủy"));
        for (Map.Entry<String, Long> e : tk.getTheoThoiGian().entrySet()) {
            bc.getDong().add(List.of(e.getKey(), String.valueOf(e.getValue()),
                    String.valueOf(tk.getHuyTheoThoiGian().getOrDefault(e.getKey(), 0L))));
        }
        List<Number> bdTong = new ArrayList<>();
        List<Number> bdHuy = new ArrayList<>();
        for (Map.Entry<String, Long> e : tk.getTheoThoiGian().entrySet()) {
            bc.getNhanBieuDo().add(e.getKey());
            bdTong.add(e.getValue());
            bdHuy.add(tk.getHuyTheoThoiGian().getOrDefault(e.getKey(), 0L));
        }
        bc.setLoaiBieuDo("bar");
        bc.setTieuDeBieuDo("Số đặt phòng " + kieu.getNhan().toLowerCase());
        bc.getChuoiBieuDo().put("Số đặt phòng", bdTong);
        bc.getChuoiBieuDo().put("Số hủy", bdHuy);
        bc.getTongKet().put("Kiểu thống kê", kieu.getNhan());
        bc.getTongKet().put("Tổng số đặt phòng", String.valueOf(tk.getTong()));
        bc.getTongKet().put("Chờ xác nhận", String.valueOf(tk.getChoXacNhan()));
        bc.getTongKet().put("Đã xác nhận", String.valueOf(tk.getDaXacNhan()));
        bc.getTongKet().put("Đang ở", String.valueOf(tk.getDangO()));
        bc.getTongKet().put("Đã trả phòng", String.valueOf(tk.getDaTraPhong()));
        bc.getTongKet().put("Đã hủy", String.valueOf(tk.getDaHuy()));
        bc.getTongKet().put("Tỷ lệ hủy", tk.getTyLeHuy() + "%");
        return bc;
    }

    // ---------------- Báo cáo lưu trú ----------------
    public BaoCaoDTO baoCaoLuuTru(LocalDate tu, LocalDate den) {
        return baoCaoLuuTru(tu, den, false);
    }

    public BaoCaoDTO baoCaoLuuTru(LocalDate tu, LocalDate den, boolean gomNhap) {
        List<ThongKeKhachDTO> ds = thongKeService.thongKeKhach(tu, den, gomNhap);
        BaoCaoDTO bc = khoiTao("BÁO CÁO LƯU TRÚ", tu, den);
        bc.setCot(List.of("Mã KH", "Họ tên", "Số điện thoại", "Số lần đặt", "Số đêm lưu trú",
                "Lần ở gần nhất", "Tổng chi tiêu"));
        long tongDem = 0;
        BigDecimal tongChi = BigDecimal.ZERO;
        List<Number> soDemBieuDo = new ArrayList<>();
        for (ThongKeKhachDTO k : ds) {
            List<String> row = new ArrayList<>();
            row.add(k.getMaKH());
            row.add(k.getHoTen());
            row.add(k.getSoDienThoai());
            row.add(String.valueOf(k.getSoLanDatPhong()));
            row.add(String.valueOf(k.getSoDemLuuTru()));
            row.add(k.getLanLuuTruGanNhat() == null ? "" : k.getLanLuuTruGanNhat().format(NGAY));
            row.add(tien(k.getTongChiTieu()));
            bc.getDong().add(row);
            bc.getNhanBieuDo().add(k.getHoTen());
            soDemBieuDo.add(k.getSoDemLuuTru());
            tongDem += k.getSoDemLuuTru();
            tongChi = tongChi.add(k.getTongChiTieu());
        }
        bc.setLoaiBieuDo("bar");
        bc.setTieuDeBieuDo("Số đêm lưu trú theo khách");
        bc.getChuoiBieuDo().put("Số đêm lưu trú", soDemBieuDo);
        bc.getTongKet().put("Số khách lưu trú", String.valueOf(ds.size()));
        bc.getTongKet().put("Tổng số đêm lưu trú", String.valueOf(tongDem));
        bc.getTongKet().put("Tổng chi tiêu", tien(tongChi));
        return bc;
    }

    // ---------------- Xuất CSV (mở được bằng Excel) ----------------
    public byte[] xuatCsv(BaoCaoDTO bc) {
        StringBuilder sb = new StringBuilder("\uFEFF"); // BOM để Excel đọc đúng tiếng Việt
        sb.append(csv(bc.getTieuDe())).append("\r\n");
        sb.append(csv(bc.getKyBaoCao())).append("\r\n\r\n");
        sb.append(String.join(",", bc.getCot().stream().map(BaoCaoService::csv).toList())).append("\r\n");
        for (List<String> row : bc.getDong()) {
            sb.append(String.join(",", row.stream().map(BaoCaoService::csv).toList())).append("\r\n");
        }
        sb.append("\r\n");
        bc.getTongKet().forEach((k, v) -> sb.append(csv(k)).append(',').append(csv(v)).append("\r\n"));
        return sb.toString().getBytes(StandardCharsets.UTF_8);
    }

    // ---------------- helpers ----------------
    private static BaoCaoDTO khoiTao(String tieuDe, LocalDate tu, LocalDate den) {
        BaoCaoDTO bc = new BaoCaoDTO();
        bc.setTieuDe(tieuDe);
        bc.setKyBaoCao("Từ ngày " + tu.format(NGAY) + " đến ngày " + den.format(NGAY));
        return bc;
    }

    private static String tien(BigDecimal v) {
        return TIEN.format(v == null ? BigDecimal.ZERO : v) + " đ";
    }

    private static String csv(String v) {
        if (v == null) return "";
        String s = v.replace("\"", "\"\"");
        return (s.contains(",") || s.contains("\"") || s.contains("\n")) ? "\"" + s + "\"" : s;
    }
}
