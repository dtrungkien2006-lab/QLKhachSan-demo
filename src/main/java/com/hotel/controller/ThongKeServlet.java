package com.hotel.controller;

import com.hotel.enums.KieuThoiGian;
import com.hotel.service.ThongKeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/thong-ke")
public class ThongKeServlet extends HttpServlet {

    private ThongKeService service;

    @Override
    public void init() {
        service = new ThongKeService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        LocalDate hienTai = LocalDate.now();
        LocalDate tu = parse(req.getParameter("tuNgay"), hienTai.withDayOfMonth(1));
        LocalDate den = parse(req.getParameter("denNgay"), hienTai);
        KieuThoiGian kieu = KieuThoiGian.parse(req.getParameter("kieu"));
        String loai = val(req.getParameter("loai"), "tong-quan");

        req.setAttribute("tuNgay", tu);
        req.setAttribute("denNgay", den);
        req.setAttribute("kieu", kieu);
        req.setAttribute("kieuThoiGians", KieuThoiGian.values());
        boolean gomNhap = "1".equals(req.getParameter("nhap"));
        req.setAttribute("loai", loai);
        req.setAttribute("nhap", gomNhap);

        try {
            switch (loai) {
                case "phong" -> req.setAttribute("phong", service.thongKePhong(tu, den));
                case "dat-phong" -> req.setAttribute("datPhong", service.thongKeDatPhong(tu, den, kieu));
                case "khach-hang" -> req.setAttribute("khachHangs", service.thongKeKhach(tu, den, gomNhap));
                case "doanh-thu" -> req.setAttribute("doanhThu", service.thongKeDoanhThu(tu, den, kieu, gomNhap));
                default -> { // tổng quan: gom đủ 4 nhóm
                    req.setAttribute("phong", service.thongKePhong(tu, den));
                    req.setAttribute("datPhong", service.thongKeDatPhong(tu, den, kieu));
                    req.setAttribute("doanhThu", service.thongKeDoanhThu(tu, den, kieu, gomNhap));
                    req.setAttribute("khachHangs", service.thongKeKhach(tu, den, gomNhap));
                }
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/thong-ke/thong-ke.jsp").forward(req, resp);
    }

    private static LocalDate parse(String v, LocalDate macDinh) {
        if (v == null || v.isBlank()) return macDinh;
        try {
            return LocalDate.parse(v.trim());
        } catch (DateTimeParseException e) {
            return macDinh;
        }
    }

    private static String val(String v, String f) {
        return v == null || v.isBlank() ? f : v.trim();
    }
}