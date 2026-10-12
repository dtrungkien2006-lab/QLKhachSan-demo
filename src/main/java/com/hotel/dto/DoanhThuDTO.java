package com.hotel.dto;

import java.math.BigDecimal;

/** Doanh thu của một mốc thời gian (ngày/tháng/năm). */
public class DoanhThuDTO {
    private String thoiGian;
    private int soHoaDon;
    private BigDecimal tienPhong = BigDecimal.ZERO;
    private BigDecimal tienDichVu = BigDecimal.ZERO;
    private BigDecimal tongTien = BigDecimal.ZERO;

    public DoanhThuDTO() { }
    public DoanhThuDTO(String thoiGian) { this.thoiGian = thoiGian; }

    public void cong(BigDecimal phong, BigDecimal dichVu, BigDecimal tong) {
        this.soHoaDon++;
        this.tienPhong = this.tienPhong.add(phong);
        this.tienDichVu = this.tienDichVu.add(dichVu);
        this.tongTien = this.tongTien.add(tong);
    }

    public String getThoiGian() { return thoiGian; }
    public void setThoiGian(String v) { this.thoiGian = v; }
    public int getSoHoaDon() { return soHoaDon; }
    public BigDecimal getTienPhong() { return tienPhong; }
    public BigDecimal getTienDichVu() { return tienDichVu; }
    public BigDecimal getTongTien() { return tongTien; }
}
