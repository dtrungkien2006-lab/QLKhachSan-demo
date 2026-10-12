package com.hotel.enums;

public enum TrangThaiPhong {
    TRONG("Trống"),
    DANG_SU_DUNG("Đang sử dụng"),
    DA_DAT("Đã đặt");

    private final String tenHienThi;

    TrangThaiPhong(String tenHienThi) {
        this.tenHienThi = tenHienThi;
    }

    public String getTenHienThi() {
        return tenHienThi;
    }
}