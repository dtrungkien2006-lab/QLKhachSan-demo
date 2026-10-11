package com.hotel.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Một dòng thống kê khách hàng + lịch sử lưu trú trong kỳ. */
public class ThongKeKhachDTO {
    private String maKH;
    private String hoTen;
    private String soDienThoai;
    private int soLanDatPhong;
    private long soDemLuuTru;
    private LocalDate lanLuuTruGanNhat;
    private BigDecimal tongChiTieu = BigDecimal.ZERO;

    public String getMaKH() { return maKH; }
    public void setMaKH(String v) { this.maKH = v; }
    public String getHoTen() { return hoTen; }
    public void setHoTen(String v) { this.hoTen = v; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String v) { this.soDienThoai = v; }
    public int getSoLanDatPhong() { return soLanDatPhong; }
    public void setSoLanDatPhong(int v) { this.soLanDatPhong = v; }
    public long getSoDemLuuTru() { return soDemLuuTru; }
    public void setSoDemLuuTru(long v) { this.soDemLuuTru = v; }
    public LocalDate getLanLuuTruGanNhat() { return lanLuuTruGanNhat; }
    public void setLanLuuTruGanNhat(LocalDate v) { this.lanLuuTruGanNhat = v; }
    public BigDecimal getTongChiTieu() { return tongChiTieu; }
    public void setTongChiTieu(BigDecimal v) { this.tongChiTieu = v; }
}
