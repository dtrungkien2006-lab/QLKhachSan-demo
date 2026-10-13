package com.hotel.controller;

import com.hotel.entity.LoaiPhong;
import com.hotel.entity.Phong;
import com.hotel.enums.TrangThaiPhong;
import com.hotel.service.LoaiPhongService;
import com.hotel.service.PhongService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = value(request.getParameter("action"), "list");

        try {
            switch (action) {
                case "new":
                    if (PhanQuyen.tuChoiNeuKhongCoQuyen(request, response)) {
                        return;
                    }
                    form(request, response, null, "them");
                    break;

                case "edit":
                    if (PhanQuyen.tuChoiNeuKhongCoQuyen(request, response)) {
                        return;
                    }
                    editForm(request, response);
                    break;

                case "detail":
                    detail(request, response);
                    break;

                case "delete":
                    if (PhanQuyen.tuChoiNeuKhongCoQuyen(request, response)) {
                        return;
                    }
                    delete(request, response);
                    break;

                case "status":
                    if (PhanQuyen.tuChoiNeuKhongCoQuyen(request, response)) {
                        return;
                    }
                    updateStatus(request, response);
                    break;

                default:
                    list(request, response);
                    break;
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            list(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (PhanQuyen.tuChoiNeuKhongCoQuyen(request, response)) {
            return;
        }

        String action = value(request.getParameter("action"), "them");

        try {
            if ("xoa".equals(action)) {
                service.xoa(required(request, "id"));
                response.sendRedirect(request.getContextPath()
                        + "/phong?success=deleted");
                return;
            }

            Phong phong = new Phong();

            String maPhong = trim(request.getParameter("maPhong"));
            String soPhong = trim(request.getParameter("soPhong"));
            String maLoaiPhong = trim(request.getParameter("maLoaiPhong"));

            if ("sua".equals(action)) {
                maPhong = required(request, "maPhongCu");
            } else if (!"them".equals(action)) {
                throw new IllegalArgumentException("Thao tác không hợp lệ.");
            }

            if ("sua".equals(action)) {
                phong.setMaPhong(maPhong);
            } else {
                phong.setMaPhong(maPhong);
            }

            phong.setSoPhong(soPhong);
            phong.setViTri(trim(request.getParameter("viTri")));

            String trangThai = trim(request.getParameter("trangThai"));
            if (trangThai == null || trangThai.isEmpty()) {
                phong.setTrangThai(TrangThaiPhong.TRONG);
            } else {
                phong.setTrangThai(TrangThaiPhong.valueOf(trangThai));
            }

            LoaiPhong loaiPhong = loaiPhongService.findById(maLoaiPhong);

            if (loaiPhong == null) {
                throw new IllegalArgumentException("Không tìm thấy loại phòng.");
            }

            phong.setLoaiPhong(loaiPhong);

            if ("them".equals(action)) {
                service.them(phong);
            } else {
                service.capNhat(phong);
            }

            response.sendRedirect(request.getContextPath()
                    + "/phong?success=saved");

        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());

            String formAction = "sua".equals(action) ? "sua" : "them";
            request.setAttribute("formAction", formAction);
            request.setAttribute("item", null);
            request.setAttribute("loaiPhongs", loaiPhongService.findAll());
            request.setAttribute("trangThais", TrangThaiPhong.values());

            request.getRequestDispatcher("/phong/form.jsp")
                    .forward(request, response);
        }
    }

    private void list(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("items", service.findAll());

        request.getRequestDispatcher("/phong/danh-sach.jsp")
                .forward(request, response);
    }

    private void form(HttpServletRequest request,
                      HttpServletResponse response,
                      Phong phong,
                      String formAction)
            throws ServletException, IOException {

        request.setAttribute("item", phong);
        request.setAttribute("formAction", formAction);
        request.setAttribute("loaiPhongs", loaiPhongService.findAll());
        request.setAttribute("trangThais", TrangThaiPhong.values());

        request.getRequestDispatcher("/phong/form.jsp")
                .forward(request, response);
    }

    private void editForm(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String id = required(request, "id");
        Phong phong = service.findByIdWithLoaiPhong(id);

        if (phong == null) {
            throw new IllegalArgumentException("Không tìm thấy phòng: " + id);
        }

        form(request, response, phong, "sua");
    }

    private void detail(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {

        String id = required(request, "id");
        Phong phong = service.findByIdWithLoaiPhong(id);

        if (phong == null) {
            throw new IllegalArgumentException("Không tìm thấy phòng: " + id);
        }

        request.setAttribute("item", phong);

        request.getRequestDispatcher("/phong/chi-tiet.jsp")
                .forward(request, response);
    }

    private void delete(HttpServletRequest request,
                        HttpServletResponse response)
            throws IOException {

        service.xoa(required(request, "id"));

        response.sendRedirect(request.getContextPath()
                + "/phong?success=deleted");
    }

    private void updateStatus(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String id = required(request, "id");
        String status = required(request, "trangThai");

        service.capNhatTrangThai(
                id,
                TrangThaiPhong.valueOf(status)
        );

        response.sendRedirect(request.getContextPath()
                + "/phong?success=status");
    }

    private static String required(HttpServletRequest request, String name) {
        String value = request.getParameter(name);

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Thiếu tham số: " + name);
        }

        return value.trim();
    }

    private static String trim(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private static String value(String value, String defaultValue) {
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }
}