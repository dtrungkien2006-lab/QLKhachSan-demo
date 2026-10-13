package com.hotel.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Locale;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of("/login", "/logout", "/favicon.ico");
    private static final Set<String> ADMIN_ONLY = Set.of("/nhan-vien");
    private static final Set<String> ADMIN_QUAN_LY = Set.of("/bao-cao", "/thong-ke");
    private static final Set<String> READ_ONLY_FOR_LE_TAN = Set.of("/phong", "/loai-phong", "/dich-vu");
    private static final Set<String> VALID_ROLES = Set.of("ADMIN", "QUAN_LY", "LE_TAN");
    private static final Set<String> READ_ACTIONS = Set.of("list", "detail", "view", "search");

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        resp.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        String uri = req.getRequestURI()
                .substring(req.getContextPath().length());

        // Cho phép tài nguyên tĩnh.
        boolean staticResource =
                uri.startsWith("/css/")
                        || uri.startsWith("/js/")
                        || uri.startsWith("/images/")
                        || uri.startsWith("/fonts/")
                        || uri.equals("/favicon.ico");

        if (staticResource || PUBLIC_PATHS.contains(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // Không tạo session mới khi chỉ kiểm tra đăng nhập.
        HttpSession session = req.getSession(false);

        if (session == null
                || session.getAttribute("maNV") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object roleObject = session.getAttribute("vaiTro");

        // Session thiếu vai trò hoặc có vai trò không hợp lệ.
        if (roleObject == null
                || !VALID_ROLES.contains(roleObject.toString())) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = roleObject.toString();
        String method = req.getMethod().toUpperCase(Locale.ROOT);

        // Chỉ ADMIN được quản lý nhân viên và tài khoản.
        if (ADMIN_ONLY.contains(uri) && !"ADMIN".equals(role)) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền quản lý nhân viên và tài khoản."
            );
            return;
        }

        // Báo cáo và thống kê chỉ dành cho ADMIN, QUAN_LY.
        if (ADMIN_QUAN_LY.contains(uri)
                && !Set.of("ADMIN", "QUAN_LY").contains(role)) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền xem báo cáo và thống kê."
            );
            return;
        }

        // LE_TAN chỉ được xem phòng, loại phòng và dịch vụ.
        if ("LE_TAN".equals(role)
                && READ_ONLY_FOR_LE_TAN.contains(uri)) {

            String action = req.getParameter("action");

            if (action != null) {
                action = action.trim().toLowerCase(Locale.ROOT);
            }

            boolean isReadRequest = "GET".equals(method);

            boolean isReadAction = action == null
                    || action.isBlank()
                    || READ_ACTIONS.contains(action);

            if (!isReadRequest || !isReadAction) {
                resp.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Lễ tân chỉ được xem thông tin trong nghiệp vụ này."
                );
                return;
            }
        }

        chain.doFilter(request, response);
    }
}