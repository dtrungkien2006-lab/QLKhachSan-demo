package com.hotel.controller;

import com.hotel.entity.LoaiPhong;
import com.hotel.entity.Phong;
import com.hotel.enums.TrangThaiPhong;
import com.hotel.service.LoaiPhongService;
import com.hotel.service.PhongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/phong")
public class PhongServlet extends HttpServlet {
    private PhongService service;
    private LoaiPhongService loaiPhongService;

    @Override
    public void init() {
        service = new PhongService();
        loaiPhongService = new LoaiPhongService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = v(req.getParameter("action"), "list");
        try {
            switch (action) {
                case "new" -> form(req, resp, null);
                case "edit" -> form(req, resp, service.findById(getReqParam(req, "id")));
                case "delete" -> del(req, resp);
                case "status" -> updateStatus(req, resp);
                case "detail" -> detail(req, resp);
                case "search" -> search(req, resp);
                default -> list(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            list(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String maPhong = trim(req.getParameter("maPhong"));
            String soPhong = getReqParam(req, "soPhong");
            boolean isEdit = "true".equals(req.getParameter("isEdit"));

            if (isBlank(maPhong)) {
                maPhong = "P" + soPhong;
            }

            Phong x = new Phong();
            x.setMaPhong(maPhong);
            x.setSoPhong(soPhong);
            x.setViTri(req.getParameter("viTri"));
            x.setTrangThai(enumVal(TrangThaiPhong.class, req.getParameter("trangThai")));

            LoaiPhong lp = loaiPhongService.findById(getReqParam(req, "maLoaiPhong"));
            if (lp == null) throw new IllegalArgumentException("Không tìm thấy loại phòng.");
            x.setLoaiPhong(lp);

            if (isEdit) {
                service.capNhat(x);
            } else {
                if (service.findById(maPhong) != null) {
                    throw new IllegalArgumentException("Phòng có mã " + maPhong + " đã tồn tại!");
                }
                service.them(x);
            }

            resp.sendRedirect(req.getContextPath() + "/phong?action=list&success=saved");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            list(req, resp);
        }
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String maPhong = getReqParam(req, "id");
        TrangThaiPhong tt = enumVal(TrangThaiPhong.class, getReqParam(req, "trangThai"));
        service.capNhatTrangThai(maPhong, tt);
        resp.sendRedirect(req.getContextPath() + "/phong?action=list&success=status");
    }

    private void search(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String maLoaiPhong = req.getParameter("maLoaiPhong");
        TrangThaiPhong trangThai = enumVal(TrangThaiPhong.class, req.getParameter("trangThai"));

        List<Phong> result = service.findAll().stream().filter(p -> {
            boolean matchKw = isBlank(keyword) || p.getSoPhong().contains(keyword) || (p.getViTri() != null && p.getViTri().contains(keyword));
            boolean matchLP = isBlank(maLoaiPhong) || p.getLoaiPhong().getMaLoaiPhong().equals(maLoaiPhong);
            boolean matchTT = trangThai == null || p.getTrangThai() == trangThai;
            return matchKw && matchLP && matchTT;
        }).toList();

        req.setAttribute("items", result);
        req.setAttribute("loaiPhongs", loaiPhongService.findAll());
        req.setAttribute("trangThais", TrangThaiPhong.values());
        req.getRequestDispatcher("/phong/danh-sach.jsp").forward(req, resp);
    }

    private void list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("items", service.findAll());
        req.setAttribute("loaiPhongs", loaiPhongService.findAll());
        req.setAttribute("trangThais", TrangThaiPhong.values());
        req.getRequestDispatcher("/phong/danh-sach.jsp").forward(req, resp);
    }

    private void form(HttpServletRequest req, HttpServletResponse resp, Phong item) throws ServletException, IOException {
        req.setAttribute("item", item);
        req.setAttribute("loaiPhongs", loaiPhongService.findAll());
        req.setAttribute("trangThais", TrangThaiPhong.values());
        req.getRequestDispatcher("/phong/form.jsp").forward(req, resp);
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Phong x = service.findByIdWithLoaiPhong(getReqParam(req, "id"));
        if (x == null) throw new IllegalArgumentException("Không tìm thấy phòng.");
        req.setAttribute("item", x);
        req.getRequestDispatcher("/phong/chi-tiet.jsp").forward(req, resp);
    }

    private void del(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        service.xoa(getReqParam(req, "id"));
        resp.sendRedirect(req.getContextPath() + "/phong?action=list&success=deleted");
    }

    private static String getReqParam(HttpServletRequest r, String n) {
        String x = r.getParameter(n);
        if (isBlank(x)) throw new IllegalArgumentException("Thiếu tham số: " + n);
        return x.trim();
    }
    private static String trim(String x) { return x == null ? null : x.trim(); }
    private static boolean isBlank(String x) { return x == null || x.isBlank(); }
    private static String v(String x, String f) { return isBlank(x) ? f : x; }
    private static <E extends Enum<E>> E enumVal(Class<E> c, String x) { return isBlank(x) ? null : Enum.valueOf(c, x); }
}