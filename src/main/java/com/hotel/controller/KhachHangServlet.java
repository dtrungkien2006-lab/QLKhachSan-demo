package com.hotel.controller;

import com.hotel.entity.KhachHang;
import com.hotel.enums.GioiTinh;
import com.hotel.service.KhachHangService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@WebServlet("/khach-hang")
public class KhachHangServlet extends HttpServlet {

    private KhachHangService service;

    @Override
    public void init() {
        service = new KhachHangService();
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = val(req.getParameter("action"), "list");

        try {
            switch (action) {
                case "new":
                    form(req, resp, null);
                    break;

                case "edit": {
                    KhachHang x =
                            service.findById(required(req, "id"));

                    if (x == null) {
                        throw new IllegalArgumentException(
                                "Không tìm thấy khách hàng."
                        );
                    }

                    form(req, resp, x);
                    break;
                }

                case "delete":
                    delete(req, resp);
                    break;

                case "detail":
                    detail(req, resp);
                    break;

                default:
                    list(req, resp);
                    break;
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("error", e.getMessage());
            list(req, resp);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            try {
                service.xoa(required(req, "id"));

                resp.sendRedirect(
                        req.getContextPath()
                                + "/khach-hang?action=list&success=deleted"
                );
            } catch (RuntimeException e) {
                req.setAttribute("error", e.getMessage());
                list(req, resp);
            }
            return;
        }

        KhachHang x = new KhachHang();

        x.setHoTen(trim(req.getParameter("hoTen")));
        x.setCccd(trim(req.getParameter("cccd")));
        x.setNgaySinh(date(req.getParameter("ngaySinh")));
        x.setGioiTinh(
                enumVal(GioiTinh.class, req.getParameter("gioiTinh"))
        );
        x.setSoDienThoai(trim(req.getParameter("soDienThoai")));
        x.setEmail(trim(req.getParameter("email")));
        x.setDiaChi(trim(req.getParameter("diaChi")));

        try {
            if ("create".equals(action)) {
                // Thêm mới: tuyệt đối không nhận mã từ form.
                x.setMaKH(null);
                service.them(x);

            } else if ("update".equals(action)) {
                // Cập nhật: mã phải được gửi lên từ form sửa.
                x.setMaKH(required(req, "maKH"));
                service.capNhat(x);

            } else {
                throw new IllegalArgumentException(
                        "Thao tác không hợp lệ. "
                                + "Vui lòng tải lại trang và thử lại."
                );
            }

            resp.sendRedirect(
                    req.getContextPath()
                            + "/khach-hang?action=list&success=saved"
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("error", e.getMessage());

            // Nếu thêm mới thất bại, giữ form ở chế độ thêm mới.
            if ("create".equals(action)) {
                x.setMaKH(null);
                form(req, resp, x);
            } else if ("update".equals(action)) {
                form(req, resp, x);
            } else {
                list(req, resp);
            }
        }
    }

    private void list(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = trim(req.getParameter("keyword"));
        List<KhachHang> items = service.findAll();

        if (!blank(keyword)) {
            String key = keyword.toLowerCase(Locale.ROOT);

            items = items.stream()
                    .filter(kh ->
                            (kh.getMaKH() != null
                                    && kh.getMaKH()
                                    .toLowerCase(Locale.ROOT)
                                    .contains(key))
                                    || (kh.getHoTen() != null
                                    && kh.getHoTen()
                                    .toLowerCase(Locale.ROOT)
                                    .contains(key))
                                    || (kh.getSoDienThoai() != null
                                    && kh.getSoDienThoai()
                                    .contains(keyword))
                    )
                    .collect(Collectors.toList());
        }

        req.setAttribute("items", items);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher(
                "/khach-hang/danh-sach.jsp"
        ).forward(req, resp);
    }

    private void form(
            HttpServletRequest req,
            HttpServletResponse resp,
            KhachHang x)
            throws ServletException, IOException {

        req.setAttribute("item", x);
        req.setAttribute("gioiTinhs", GioiTinh.values());

        String gioiTinhDaChon = "";

        if (x != null && x.getGioiTinh() != null) {
            gioiTinhDaChon = x.getGioiTinh().name();
        }

        req.setAttribute("gioiTinhDaChon", gioiTinhDaChon);

        req.getRequestDispatcher(
                "/khach-hang/form.jsp"
        ).forward(req, resp);
    }

    private void detail(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        KhachHang x = service.findById(required(req, "id"));

        if (x == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy khách hàng."
            );
        }

        req.setAttribute("item", x);

        req.getRequestDispatcher(
                "/khach-hang/chi-tiet.jsp"
        ).forward(req, resp);
    }

    private void delete(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        service.xoa(required(req, "id"));

        resp.sendRedirect(
                req.getContextPath()
                        + "/khach-hang?action=list&success=deleted"
        );
    }

    private static String required(
            HttpServletRequest req,
            String name) {

        String value = req.getParameter(name);

        if (blank(value)) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập đầy đủ thông tin: " + name
            );
        }

        return value.trim();
    }

    private static String trim(String value) {
        return value == null ? null : value.trim();
    }

    private static boolean blank(String value) {
        return value == null || value.isBlank();
    }

    private static String val(String value, String fallback) {
        return blank(value) ? fallback : value;
    }

    private static LocalDate date(String value) {
        return blank(value) ? null : LocalDate.parse(value);
    }

    private static <E extends Enum<E>> E enumVal(
            Class<E> type,
            String value) {

        return blank(value) ? null : Enum.valueOf(type, value);
    }
}