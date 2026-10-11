package com.hotel.controller;

import com.hotel.dto.BaoCaoDTO;
import com.hotel.enums.KieuThoiGian;
import com.hotel.service.BaoCaoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * TV5 - Báo cáo: doanh thu, sử dụng phòng, đặt phòng, lưu trú.
 * URL: /bao-cao?loai=...&tuNgay=...&denNgay=...&kieu=...[&format=csv]
 */
@WebServlet("/bao-cao")
public class BaoCaoServlet extends HttpServlet {

    private BaoCaoService service;

    @Override
    public void init() {
        service = new BaoCaoService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        LocalDate hienTai = LocalDate.now();
        LocalDate tu = parse(req.getParameter("tuNgay"), hienTai.minusDays(60));
        LocalDate den = parse(req.getParameter("denNgay"), hienTai);
        KieuThoiGian kieu = KieuThoiGian.parse(req.getParameter("kieu"));
        String loai = val(req.getParameter("loai"), BaoCaoService.DOANH_THU);

        req.setAttribute("tuNgay", tu);
        req.setAttribute("denNgay", den);
        req.setAttribute("kieu", kieu);
        req.setAttribute("kieuThoiGians", KieuThoiGian.values());
        boolean gomNhap = "1".equals(req.getParameter("nhap"));
        req.setAttribute("loai", loai);
        req.setAttribute("nhap", gomNhap);

        try {
            BaoCaoDTO bc = service.taoBaoCao(loai, tu, den, kieu, gomNhap);
            if ("csv".equalsIgnoreCase(req.getParameter("format"))) {
                xuatCsv(resp, bc, loai, tu, den);
                return;
            }
            req.setAttribute("baoCao", bc);
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/bao-cao/bao-cao.jsp").forward(req, resp);
    }

    private void xuatCsv(HttpServletResponse resp, BaoCaoDTO bc, String loai, LocalDate tu, LocalDate den)
            throws IOException {
        byte[] data = service.xuatCsv(bc);
        String ten = "bao-cao-" + loai + "_" + tu + "_" + den + ".csv";
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + ten + "\"");
        resp.setContentLength(data.length);
        resp.getOutputStream().write(data);
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
