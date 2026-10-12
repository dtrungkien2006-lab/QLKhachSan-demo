package com.hotel.enums;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Cách gom nhóm số liệu theo thời gian trong thống kê/báo cáo. */
public enum KieuThoiGian {
    NGAY("Theo ngày", "yyyy-MM-dd"),
    THANG("Theo tháng", "yyyy-MM"),
    NAM("Theo năm", "yyyy");

    private final String nhan;
    private final DateTimeFormatter formatter;

    KieuThoiGian(String nhan, String pattern) {
        this.nhan = nhan;
        this.formatter = DateTimeFormatter.ofPattern(pattern);
    }

    public String getNhan() { return nhan; }

    public String nhom(LocalDateTime t) { return t.format(formatter); }

    public String nhom(LocalDate d) { return d.format(formatter); }

    public static KieuThoiGian parse(String v) {
        if (v == null || v.isBlank()) return NGAY;
        try {
            return valueOf(v.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return NGAY;
        }
    }
}
