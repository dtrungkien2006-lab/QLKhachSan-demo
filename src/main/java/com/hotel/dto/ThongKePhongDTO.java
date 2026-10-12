package com.hotel.dto;

/** Thống kê phòng: tổng số, theo trạng thái, tỷ lệ sử dụng. */
public class ThongKePhongDTO {
    private long tongPhong;
    private long phongTrong;
    private long phongDaDat;
    private long phongDangO;
    /** Tỷ lệ phòng đang ở / tổng phòng tại thời điểm hiện tại (%). */
    private double tyLeDangO;
    /** Tỷ lệ công suất: số đêm phòng đã bán / (tổng phòng × số ngày) trong kỳ (%). */
    private double tyLeSuDungTrongKy;
    private long soDemPhongDaBan;
    private long soNgayTrongKy;

    public long getTongPhong() { return tongPhong; }
    public void setTongPhong(long v) { this.tongPhong = v; }
    public long getPhongTrong() { return phongTrong; }
    public void setPhongTrong(long v) { this.phongTrong = v; }
    public long getPhongDaDat() { return phongDaDat; }
    public void setPhongDaDat(long v) { this.phongDaDat = v; }
    public long getPhongDangO() { return phongDangO; }
    public void setPhongDangO(long v) { this.phongDangO = v; }
    public double getTyLeDangO() { return tyLeDangO; }
    public void setTyLeDangO(double v) { this.tyLeDangO = v; }
    public double getTyLeSuDungTrongKy() { return tyLeSuDungTrongKy; }
    public void setTyLeSuDungTrongKy(double v) { this.tyLeSuDungTrongKy = v; }
    public long getSoDemPhongDaBan() { return soDemPhongDaBan; }
    public void setSoDemPhongDaBan(long v) { this.soDemPhongDaBan = v; }
    public long getSoNgayTrongKy() { return soNgayTrongKy; }
    public void setSoNgayTrongKy(long v) { this.soNgayTrongKy = v; }
}
