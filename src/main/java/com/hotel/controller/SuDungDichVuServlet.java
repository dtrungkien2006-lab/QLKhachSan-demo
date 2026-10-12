package com.hotel.controller;

import com.hotel.entity.DatPhong;
import com.hotel.entity.DichVu;
import com.hotel.entity.SuDungDichVu;
import com.hotel.service.DatPhongService;
import com.hotel.service.DichVuService;
import com.hotel.service.SuDungDichVuService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/su-dung-dich-vu")
public class SuDungDichVuServlet extends HttpServlet {

    private SuDungDichVuService service;
    private DatPhongService datPhongService;
    private DichVuService dichVuService;

    @Override
    public void init() {
        service = new SuDungDichVuService();
        datPhongService = new DatPhongService();
        dichVuService = new DichVuService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = value(request.getParameter("action"), "list");

        try {
            switch (action) {
                case "new" ->
                    form(request, response, null);

                case "edit" -> {
                    SuDungDichVu item =
                            service.findById(required(request, "id"));

                    if (item == null) {
                        throw new IllegalArgumentException(
                                "Không tìm thấy thông tin sử dụng dịch vụ.");
                    }

                    form(request, response, item);
                }

                case "delete" ->
                    delete(request, response);

                case "by-dat-phong" ->
                    byDatPhong(request, response);

                case "detail" ->
                    detail(request, response);

                default ->
                    list(request, response);
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            list(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String maDatPhong = required(request, "maDatPhong");
            String maDichVu = required(request, "maDichVu");
            int soLuong;

            try {
                soLuong = Integer.parseInt(required(request, "soLuong"));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException(
                        "Số lượng phải là số nguyên hợp lệ.");
            }

            if (soLuong <= 0) {
                throw new IllegalArgumentException(
                        "Số lượng dịch vụ phải lớn hơn 0.");
            }

            DatPhong datPhong = datPhongService.findById(maDatPhong);
            DichVu dichVu = dichVuService.findById(maDichVu);

            if (datPhong == null || dichVu == null) {
                throw new IllegalArgumentException(
                        "Đặt phòng hoặc dịch vụ không tồn tại.");
            }

            SuDungDichVu item = new SuDungDichVu();
            item.setMaSuDungDichVu(
                    trim(request.getParameter("maSuDungDichVu")));
            item.setDatPhong(datPhong);
            item.setDichVu(dichVu);
            item.setSoLuong(soLuong);
            item.setDonGia(dichVu.getDonGia());

            if (blank(item.getMaSuDungDichVu())) {
                service.them(item);
            } else {
                service.capNhatSoLuong(
                        item.getMaSuDungDichVu(), soLuong);
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/su-dung-dich-vu?action=list&success=saved");

        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            form(request, response, null);
        }
    }

    private void list(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("items", service.findAll());

        request.getRequestDispatcher(
                "/dich-vu/su-dung-danh-sach.jsp")
                .forward(request, response);
    }

    private void byDatPhong(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String maDatPhong = required(request, "maDatPhong");

        request.setAttribute(
                "items", service.findByDatPhong(maDatPhong));
        request.setAttribute("maDatPhong", maDatPhong);

        request.getRequestDispatcher(
                "/dich-vu/su-dung-danh-sach.jsp")
                .forward(request, response);
    }

    private void form(
            HttpServletRequest request,
            HttpServletResponse response,
            SuDungDichVu item)
            throws ServletException, IOException {

        request.setAttribute("item", item);
        request.setAttribute(
                "datPhongs", datPhongService.findAllWithKhachHang());
        request.setAttribute(
                "dichVus", dichVuService.findDangKinhDoanh());

        request.getRequestDispatcher(
                "/dich-vu/su-dung-form.jsp")
                .forward(request, response);
    }

    private void detail(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        SuDungDichVu item =
                service.findById(required(request, "id"));

        if (item == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy sử dụng dịch vụ.");
        }

        request.setAttribute("item", item);

        request.getRequestDispatcher(
                "/dich-vu/su-dung-chi-tiet.jsp")
                .forward(request, response);
    }

    private void delete(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        service.xoa(required(request, "id"));

        response.sendRedirect(
                request.getContextPath()
                + "/su-dung-dich-vu?action=list&success=deleted");
    }

    private static String required(
            HttpServletRequest request, String name) {

        String value = request.getParameter(name);

        if (blank(value)) {
            throw new IllegalArgumentException(
                    "Thiếu tham số: " + name);
        }

        return value.trim();
    }

    private static String trim(String value) {
        return value == null ? null : value.trim();
    }

    private static boolean blank(String value) {
        return value == null || value.isBlank();
    }

    private static String value(String value, String fallback) {
        return blank(value) ? fallback : value;
    }
}