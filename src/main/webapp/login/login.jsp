<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Đăng nhập | Horizon Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">
</head>

<body>
<div class="login-page">

    <!-- Khu vực giới thiệu thương hiệu -->
    <section class="login-side">

        <div class="brand">
            <span class="brand-mark">H</span>

            <span>
                <span class="brand-name">Horizon Hotel</span>
                <br>
                <span class="brand-sub">HOTEL MANAGEMENT</span>
            </span>
        </div>

        <div>
            <div class="login-art">⌂</div>

            <h1>Vận hành khách sạn, đơn giản hơn.</h1>

            <p>
                Không gian quản lý tập trung cho đặt phòng,
                khách hàng, dịch vụ và thanh toán.
            </p>
        </div>

        <div style="font-size: 12px; color: #a9bfd5;">
            QLKhachSan · Hệ thống nội bộ
        </div>

    </section>

    <!-- Khu vực đăng nhập -->
    <section class="login-main">
        <div class="login-box">

            <div class="eyebrow">Chào mừng trở lại</div>

            <h2>Đăng nhập hệ thống</h2>

            <p class="muted">
                Sử dụng tài khoản nhân viên để tiếp tục.
            </p>

            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="error">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <!-- Form đăng nhập -->
            <form method="post"
                  action="${pageContext.request.contextPath}/login">

                <label class="field">
                    <span>Mã nhân viên</span>

                    <input type="text"
                           name="maNV"
                           value="<c:out value='${maNV}'/>"
                           placeholder="Ví dụ: 24110261"
                           autocomplete="username"
                           required
                           autofocus>
                </label>

                <label class="field">
                    <span>Mật khẩu</span>

                    <input type="password"
                           name="matKhau"
                           placeholder="Nhập mật khẩu"
                           autocomplete="current-password"
                           required>
                </label>

                <button class="btn btn-primary" type="submit">
                    Đăng nhập <span>→</span>
                </button>

            </form>

            <!-- Thông tin bảo mật -->
            <div class="login-foot">
                Bảo mật tài khoản · Chỉ dành cho nhân viên được cấp quyền
            </div>

        </div>
    </section>

</div>
</body>
</html>
