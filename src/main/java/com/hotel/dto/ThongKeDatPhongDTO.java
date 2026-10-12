package com.hotel.dto;

import java.util.LinkedHashMap;
import java.util.Map;

/** Thống kê đặt phòng: số lượng, theo trạng thái, theo thời gian, số lượng hủy. */
public class ThongKeDatPhongDTO {
    private long tong;
    private long choXacNhan;
    private long daXacNhan;
    private long dangO;
    private long daTraPhong;
    private long daHuy;
    private double tyLeHuy;
    /** nhãn thời gian -> số đặt phòng (đã sắp xếp tăng dần). */
    private Map<String, Long> theoThoiGian = new LinkedHashMap<>();
    /** nhãn thời gian -> số đặt phòng bị hủy. */
    private Map<String, Long> huyTheoThoiGian = new LinkedHashMap<>();

    public long getTong() { return tong; }
    public void setTong(long v) { this.tong = v; }
    public long getChoXacNhan() { return choXacNhan; }
    public void setChoXacNhan(long v) { this.choXacNhan = v; }
    public long getDaXacNhan() { return daXacNhan; }
    public void setDaXacNhan(long v) { this.daXacNhan = v; }
    public long getDangO() { return dangO; }
    public void setDangO(long v) { this.dangO = v; }
    public long getDaTraPhong() { return daTraPhong; }
    public void setDaTraPhong(long v) { this.daTraPhong = v; }
    public long getDaHuy() { return daHuy; }
    public void setDaHuy(long v) { this.daHuy = v; }
    public double getTyLeHuy() { return tyLeHuy; }
    public void setTyLeHuy(double v) { this.tyLeHuy = v; }
    public Map<String, Long> getTheoThoiGian() { return theoThoiGian; }
    public void setTheoThoiGian(Map<String, Long> v) { this.theoThoiGian = v; }
    public Map<String, Long> getHuyTheoThoiGian() { return huyTheoThoiGian; }
    public void setHuyTheoThoiGian(Map<String, Long> v) { this.huyTheoThoiGian = v; }
}
