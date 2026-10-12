package com.hotel.controller;

import com.hotel.dto.DatPhongListDTO;
import com.hotel.dto.DatPhongMapper;
import com.hotel.dto.DatPhongRequestDTO;
import com.hotel.dto.PhongOptionDTO;

import com.hotel.entity.DatPhong;
import com.hotel.entity.KhachHang;
import com.hotel.entity.Phong;

import com.hotel.enums.TrangThaiDatPhong;

import com.hotel.service.DatPhongService;
import com.hotel.service.CheckoutService;
import com.hotel.service.KhachHangService;
import com.hotel.service.LoaiPhongService;
import com.hotel.service.PhongService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/dat-phong")
public class DatPhongServlet extends HttpServlet {
    private DatPhongService datPhongService;
    private KhachHangService khachHangService;
    private PhongService phongService;
    private CheckoutService checkoutService;
    private LoaiPhongService loaiPhongService;

    @Override
    public void init() {
        datPhongService = new DatPhongService();
        khachHangService = new KhachHangService();
        phongService = new PhongService();
        checkoutService = new CheckoutService();
        loaiPhongService = new LoaiPhongService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = value(request.getParameter("action"), "list");

        try {
            switch (action) {
                case "new" -> showCreateForm(request, response);
                case "available" -> showCreateForm(request, response);
                case "detail" -> detail(request, response);
                case "confirm" -> confirm(request, response);
                case "cancel" -> cancel(request, response);
                case "checkin" -> checkIn(request, response);
                case "checkout" -> checkOut(request, response);
                default -> list(request, response);
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            list(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            DatPhongRequestDTO dto = parseRequest(request);

            KhachHang khachHang = new KhachHang();
            khachHang.setMaKH(dto.getMaKH());

            List<Phong> rooms = new ArrayList<>();
            for (DatPhongRequestDTO.ChiTiet item : dto.getChiTiet()) {
                Phong room = phongService.findByIdWithLoaiPhong(item.getMaPhong());
                if (room == null) {
                    throw new IllegalArgumentException("Không tìm thấy phòng: " + item.getMaPhong());
                }
                rooms.add(room);
            }

            DatPhong datPhong = DatPhongMapper.toEntity(dto, khachHang, rooms);

            datPhongService.datPhong(datPhong, datPhong.getChiTietDatPhong(), currentMaNV(request), dto.getSoLuongKhach());

            response.sendRedirect(request.getContextPath()
                    + "/dat-phong?action=list&success=created&ma=" + datPhong.getMaDatPhong());
        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maDatPhong = trimToNull(request.getParameter("maDatPhong"));
        String khachHang = trimToNull(request.getParameter("khachHang"));
        String trangThaiParam = trimToNull(request.getParameter("trangThai"));
        String tuNgayParam = trimToNull(request.getParameter("tuNgay"));
        String denNgayParam = trimToNull(request.getParameter("denNgay"));

        List<DatPhong> datPhongs;
        if (maDatPhong == null && khachHang == null && trangThaiParam == null
                && tuNgayParam == null && denNgayParam == null) {
            datPhongs = datPhongService.findAllWithKhachHang();
        } else {
            try {
                TrangThaiDatPhong trangThai = trangThaiParam == null
                        ? null : TrangThaiDatPhong.valueOf(trangThaiParam);
                LocalDate tuNgay = tuNgayParam == null ? null : LocalDate.parse(tuNgayParam);
                LocalDate denNgay = denNgayParam == null ? null : LocalDate.parse(denNgayParam);
                datPhongs = datPhongService.traCuu(maDatPhong, khachHang, trangThai, tuNgay, denNgay);
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Ngày tra cứu không hợp lệ.");
                datPhongs = List.of();
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Trạng thái tra cứu không hợp lệ.");
                datPhongs = List.of();
            }
        }

        List<DatPhongListDTO> items = datPhongs.stream().map(this::toListDTO).toList();
        request.setAttribute("items", items);
        request.setAttribute("trangThais", TrangThaiDatPhong.values());
        request.setAttribute("success", request.getParameter("success"));
        request.getRequestDispatcher("/dat-phong/danh-sach.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("khachHangs", khachHangService.findAll());
        request.setAttribute("loaiPhongs", loaiPhongService.findAll());

        String ngayNhanParam = request.getParameter("ngayNhan");
        String ngayTraParam = request.getParameter("ngayTra");

        if (notBlank(ngayNhanParam) && notBlank(ngayTraParam)) {
            request.setAttribute("ngayNhan", ngayNhanParam);
            request.setAttribute("ngayTra", ngayTraParam);
            try {
                LocalDate ngayNhan = LocalDate.parse(ngayNhanParam);
                LocalDate ngayTra = LocalDate.parse(ngayTraParam);

                String maLoaiPhong = trimToNull(request.getParameter("maLoaiPhong"));

                request.setAttribute("phongOptions", phongService.findPhongCoTheDat(
                                ngayNhan, ngayTra, maLoaiPhong, null, null, null)
                        .stream()
                        .map(p -> {
                            PhongOptionDTO option = new PhongOptionDTO(
                                    p.getMaPhong(), p.getSoPhong(),
                                    p.getLoaiPhong().getMaLoaiPhong(),
                                    p.getLoaiPhong().getTenLoaiPhong(),
                                    p.getLoaiPhong().getGiaCoBan());
                            option.setSoNguoiToiDa(p.getLoaiPhong().getSoNguoiToiDa()); // Đính kèm sức chứa
                            return option;
                        })
                        .toList());
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Ngày nhận/trả không hợp lệ.");
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
            }
        }
        request.getRequestDispatcher("/dat-phong/dat-phong.jsp").forward(request, response);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ma = required(request, "ma");
        DatPhong datPhong = datPhongService.findByIdWithChiTiet(ma);
        if (datPhong == null) {
            throw new IllegalArgumentException("Không tìm thấy đặt phòng: " + ma);
        }
        request.setAttribute("item", datPhong);
        request.getRequestDispatcher("/dat-phong/chi-tiet.jsp").forward(request, response);
    }

    private void confirm(HttpServletRequest request, HttpServletResponse response) throws IOException {
        datPhongService.xacNhanDatPhong(required(request, "ma"), currentMaNV(request));
        response.sendRedirect(request.getContextPath() + "/dat-phong?action=list&success=confirmed");
    }

    private void cancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        datPhongService.huyDatPhong(required(request, "ma"));
        response.sendRedirect(request.getContextPath() + "/dat-phong?action=list&success=cancelled");
    }


    private void checkIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String maDatPhong = required(request, "ma");
        datPhongService.checkIn(maDatPhong, currentMaNV(request));
        new com.hotel.service.HoaDonService().taoHoaDon(maDatPhong);
        response.sendRedirect(request.getContextPath() + "/dat-phong?action=list&success=checkin");
    }


    private void checkOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String maDatPhong = required(request, "ma");
        checkoutService.checkout(maDatPhong, currentMaNV(request));
        response.sendRedirect(request.getContextPath() + "/dat-phong?action=list&success=checkout");
    }

    private DatPhongRequestDTO parseRequest(HttpServletRequest request) {
        String maKH = required(request, "maKH");
        String[] maPhongs = request.getParameterValues("maPhong");
        String ngayNhanParam = required(request, "ngayNhan");
        String ngayTraParam = required(request, "ngayTra");

        if (maPhongs == null || maPhongs.length == 0) {
            throw new IllegalArgumentException("Phải chọn ít nhất một phòng.");
        }

        final LocalDate ngayNhan;
        final LocalDate ngayTra;
        try {
            ngayNhan = LocalDate.parse(ngayNhanParam);
            ngayTra = LocalDate.parse(ngayTraParam);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Ngày nhận/trả không hợp lệ.");
        }

        String soLuongKhachParam = required(request, "soLuongKhach");
        final Integer soLuongKhach;
        try {
            soLuongKhach = Integer.valueOf(soLuongKhachParam);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số lượng khách phải là số nguyên.");
        }

        DatPhongRequestDTO dto = new DatPhongRequestDTO();
        dto.setMaKH(maKH);
        dto.setGhiChu(request.getParameter("ghiChu"));
        dto.setSoLuongKhach(soLuongKhach);
        for (String maPhong : maPhongs) {
            if (notBlank(maPhong)) {
                dto.addChiTiet(maPhong.trim(), ngayNhan, ngayTra);
            }
        }
        if (dto.getChiTiet().isEmpty()) {
            throw new IllegalArgumentException("Phải chọn ít nhất một phòng.");
        }
        return dto;
    }

    private DatPhongListDTO toListDTO(DatPhong d) {
        DatPhongListDTO dto = new DatPhongListDTO();
        dto.setMaDatPhong(d.getMaDatPhong());
        dto.setNgayDat(d.getNgayDat());
        dto.setMaKH(d.getKhachHang().getMaKH());
        dto.setTenKhachHang(d.getKhachHang().getHoTen());
        dto.setTrangThai(d.getTrangThai());
        dto.setGhiChu(d.getGhiChu());
        dto.setMaNVXuLy(d.getNhanVienXuLy() == null ? null : d.getNhanVienXuLy().getMaNV());
        dto.setMaNVCheckIn(d.getNhanVienCheckIn() == null ? null : d.getNhanVienCheckIn().getMaNV());
        dto.setMaNVCheckOut(d.getNhanVienCheckOut() == null ? null : d.getNhanVienCheckOut().getMaNV());
        return dto;
    }

    private String currentMaNV(HttpServletRequest request) {
        Object value = request.getSession(false) == null ? null : request.getSession(false).getAttribute("maNV");
        if (value == null || value.toString().isBlank()) throw new IllegalStateException("Phiên đăng nhập nhân viên đã hết hạn.");
        return value.toString();
    }

    private String required(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (!notBlank(value)) throw new IllegalArgumentException("Thiếu tham số: " + name);
        return value.trim();
    }

    private String value(String value, String fallback) {
        return notBlank(value) ? value : fallback;
    }
    private boolean notBlank(String value) {
        return value != null && !value.isBlank();
    }
    private String trimToNull(String value) {
        return notBlank(value) ? value.trim() : null;
    }

}