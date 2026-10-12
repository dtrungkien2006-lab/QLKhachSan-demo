<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không có quyền truy cập | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #172b4d;
        }

        .error-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .error-card {
            width: 100%;
            max-width: 650px;
            padding: 45px 40px;
            border: 1px solid #e3e9f2;
            border-radius: 20px;
            background: #fff;
            box-shadow: 0 15px 50px rgba(23, 43, 77, .08);
            text-align: center;
        }

        .hotel-brand {
            display: inline-flex;
            align-items: center;
            gap: 11px;
            margin-bottom: 32px;
            text-align: left;
        }

        .hotel-logo {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 13px;
            background: #172b4d;
            color: #fff;
            font-size: 24px;
            font-weight: 800;
        }

        .hotel-name {
            font-size: 17px;
            font-weight: 800;
            color: #172b4d;
        }

        .hotel-subtitle {
            margin-top: 5px;
            color: #8390a5;
            font-size: 10px;
            letter-spacing: 1.2px;
        }

        .error-icon {
            width: 100px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 23px;
            border: 9px solid #fff0f0;
            border-radius: 50%;
            background: #ffe3e3;
            color: #c53030;
            font-size: 45px;
            font-weight: 800;
        }

        .error-code {
            margin-bottom: 10px;
            color: #c53030;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: 2px;
        }

        h1 {
            margin: 0 0 15px;
            color: #172b4d;
            font-size: 28px;
            line-height: 1.35;
        }

        .error-description {
            max-width: 460px;
            margin: 0 auto;
            color: #738198;
            font-size: 14px;
            line-height: 1.8;
        }

        .permission-note {
            margin-top: 25px;
            padding: 16px;
            border: 1px solid #f5d9a8;
            border-radius: 11px;
            background: #fff9ed;
            color: #875d18;
            font-size: 13px;
            line-height: 1.7;
            text-align: left;
        }

        .permission-note strong {
            display: block;
            margin-bottom: 5px;
        }

        .error-actions {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 28px;
        }

        .error-btn {
            min-height: 45px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 0 19px;
            border: 1px solid #dce4ef;
            border-radius: 9px;
            background: #fff;
            color: #52617a;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: .2s;
        }

        .error-btn:hover {
            background: #f5f8fc;
        }

        .error-btn-primary {
            border-color: #2458a6;
            background: #2458a6;
            color: #fff;
        }

        .error-btn-primary:hover {
            background: #194887;
            color: #fff;
        }

        .error-footer {
            margin-top: 35px;
            padding-top: 20px;
            border-top: 1px solid #edf0f5;
            color: #9aa5b5;
            font-size: 11px;
        }

        @media (max-width: 520px) {
            .error-card {
                padding: 30px 20px;
            }

            h1 {
                font-size: 23px;
            }

            .error-actions {
                flex-direction: column;
            }

            .error-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<main class="error-page">
    <section class="error-card">

        <div class="hotel-brand">
            <div class="hotel-logo">UTE</div>
            <div>
                <div class="hotel-name">UTE Hotel</div>
                <div class="hotel-subtitle">HOTEL MANAGEMENT</div>
            </div>
        </div>

        <div class="error-icon" aria-hidden="true">!</div>

        <div class="error-code">ERROR 403</div>

        <h1>Bạn không có quyền truy cập</h1>

        <p class="error-description">
            Tài khoản hiện tại chưa được cấp quyền sử dụng chức năng này.
            Vui lòng quay lại trang chủ hoặc liên hệ quản trị viên để được hỗ trợ.
        </p>

        <div class="permission-note">
            <strong>&#9888; Vì sao bạn thấy thông báo này?</strong>
            Chức năng quản lý nhân viên và tài khoản có thể chỉ dành cho
            tài khoản ADMIN. Nếu bạn là quản trị viên, hãy kiểm tra lại
            vai trò tài khoản và quy tắc phân quyền của hệ thống.
        </div>

        <div class="error-actions">
            <a class="error-btn error-btn-primary"
               href="${pageContext.request.contextPath}/">
                &#8962; Về trang chủ
            </a>

            <a class="error-btn"
               href="${pageContext.request.contextPath}/logout">
                &#8594; Đăng xuất
            </a>
        </div>

        <div class="error-footer">
             UTE Hotel &bull; Hotel Management System
        </div>

    </section>
</main>
</body>
</html>