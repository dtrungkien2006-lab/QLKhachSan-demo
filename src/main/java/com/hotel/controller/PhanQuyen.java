package com.hotel.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public final class PhanQuyen {

    private PhanQuyen() {}

    public static boolean laQuanLyTroLen(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {return false;}

        Object role = session.getAttribute("vaiTro");

        if (role == null) {return false;}

        String vaiTro = role.toString();

        return "ADMIN".equals(vaiTro) || "QUAN_LY".equals(vaiTro);
    }

    public static boolean tuChoiNeuKhongCoQuyen(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (laQuanLyTroLen(request)) {return false;}

        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện chức năng này.");
        return true;
    }

    public static boolean laAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {return false;}
        Object role = session.getAttribute("vaiTro");
        return role != null && "ADMIN".equals(role.toString());
    }
}