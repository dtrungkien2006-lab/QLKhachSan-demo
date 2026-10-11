package com.hotel.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Doanh thu theo kỳ + cơ cấu nguồn thu. Chỉ tính hóa đơn DA_PHAT_HANH. */
public class ThongKeDoanhThuDTO {
    private List<DoanhThuDTO> theoThoiGian = new ArrayList<>();
    private BigDecimal tongTienPhong = BigDecimal.ZERO;
    private BigDecimal tongTienDichVu = BigDecimal.ZERO;
    private BigDecimal tongDoanhThu = BigDecimal.ZERO;
    private int tongSoHoaDon;
    /** Thực thu theo phương thức thanh toán (chỉ giao dịch DA_THANH_TOAN). */
    private Map<String, BigDecimal> thucThuTheoPhuongThuc = new LinkedHashMap<>();
    private BigDecimal tongThucThu = BigDecimal.ZERO;

    public List<DoanhThuDTO> getTheoThoiGian() { return theoThoiGian; }
    public void setTheoThoiGian(List<DoanhThuDTO> v) { this.theoThoiGian = v; }
    public BigDecimal getTongTienPhong() { return tongTienPhong; }
    public void setTongTienPhong(BigDecimal v) { this.tongTienPhong = v; }
    public BigDecimal getTongTienDichVu() { return tongTienDichVu; }
    public void setTongTienDichVu(BigDecimal v) { this.tongTienDichVu = v; }
    public BigDecimal getTongDoanhThu() { return tongDoanhThu; }
    public void setTongDoanhThu(BigDecimal v) { this.tongDoanhThu = v; }
    public int getTongSoHoaDon() { return tongSoHoaDon; }
    public void setTongSoHoaDon(int v) { this.tongSoHoaDon = v; }
    public Map<String, BigDecimal> getThucThuTheoPhuongThuc() { return thucThuTheoPhuongThuc; }
    public void setThucThuTheoPhuongThuc(Map<String, BigDecimal> v) { this.thucThuTheoPhuongThuc = v; }
    public BigDecimal getTongThucThu() { return tongThucThu; }
    public void setTongThucThu(BigDecimal v) { this.tongThucThu = v; }
}
