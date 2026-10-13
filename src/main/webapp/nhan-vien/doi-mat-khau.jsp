<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .password-page {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 32px 40px;
            color: #172b43;
        }

        .password-breadcrumb {
            margin-bottom: 24px;
            color: #64748b;
            font-size: 13px;
        }

        .password-breadcrumb strong {
            color: #0f766e;
        }

        .password-heading {
            margin-bottom: 24px;
        }

        .password-heading h1 {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 27px;
            font-weight: 750;
        }

        .password-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }

        .password-card {
            overflow: hidden;
            border: 1px solid #e5eaf1;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 5px 18px rgba(15, 23, 42, .045);
        }

        .password-card-header {
            padding: 24px 28px;
            color: #fff;
            background: linear-gradient(120deg, #10243b, #164e63);
        }

        .password-card-header h2 {
            margin: 0 0 7px;
            font-size: 18px;
            font-weight: 700;
        }

        .password-card-header p {
            margin: 0;
            color: #d5e7ef;
            font-size: 14px;
            line-height: 1.6;
        }

        .password-card-body {
            padding: 28px;
        }

        .password-employee {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 18px;
            margin-bottom: 28px;
            border: 1px solid #e5eaf1;
            border-radius: 12px;
            background: #f8fafc;
        }

        .password-avatar {
            display: flex;
            flex: 0 0 54px;
            width: 54px;
            height: 54px;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background: #dff5f1;
            color: #0f766e;
            font-size: 20px;
            font-weight: 750;
        }

        .password-employee h3 {
            margin: 0 0 6px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .password-employee p {
            margin: 0;
            color: #64748b;
            font-size: 13px;
        }

        .password-section-title {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .password-description {
            margin: 0 0 22px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .password-field {
            max-width: 560px;
            margin-bottom: 22px;
        }

        .password-label {
            display: block;
            margin-bottom: 9px;
            color: #334155;
            font-size: 13px;
            font-weight: 650;
        }

        .password-required {
            color: #dc2626;
        }

        .password-input-wrap {
            position: relative;
        }

        .password-input {
            box-sizing: border-box;
            width: 100%;
            min-height: 46px;
            padding: 11px 48px 11px 13px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            background: #fff;
            color: #172b43;
            font-family: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .password-input:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .password-input::placeholder {
            color: #94a3b8;
        }

        .password-toggle {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            padding: 5px 7px;
            border: 0;
            border-radius: 6px;
            background: transparent;
            color: #64748b;
            font-size: 12px;
            cursor: pointer;
        }

        .password-toggle:hover {
            background: #f1f5f9;
            color: #0f766e;
        }

        .password-help {
            margin-top: 8px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .password-alert {
            margin-bottom: 22px;
            padding: 13px 15px;
            border: 1px solid #fecaca;
            border-radius: 9px;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 14px;
        }

        .password-actions {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #edf1f5;
        }

        .password-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            padding: 10px 18px;
            border: 1px solid #dbe3ed;
            border-radius: 9px;
            background: #fff;
            color: #334155;
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
            cursor: pointer;
            transition: .2s ease;
        }

        .password-btn:hover {
            border-color: #0f766e;
            background: #f0fdfa;
            color: #0f766e;
        }

        .password-btn-primary {
            border-color: #0f766e;
            background: #0f766e;
            color: #fff;
        }

        .password-btn-primary:hover {
            border-color: #115e59;
            background: #115e59;
            color: #fff;
        }

        @media (max-width: 650px) {
            .password-page {
                padding: 20px 14px 30px;
            }

            .password-card-header,
            .password-card-body {
                padding: 21px 18px;
            }

            .password-actions {
                flex-direction: column-reverse;
                align-items: stretch;
            }

            .password-btn {
                width: 100%;
                box-sizing: border-box;
            }
        }
    </style>
</head>

<body>

<main class="password-page">

    <div class="password-breadcrumb">
        UTE Hotel / Nhân viên / <strong>Đổi mật khẩu</strong>
    </div>

    <div class="password-heading">
        <h1>Đổi mật khẩu</h1>
        <p>Cập nhật mật khẩu cho tài khoản nhân viên.</p>
    </div>

    <section class="password-card">

        <header class="password-card-header">
            <h2>Bảo mật tài khoản</h2>
            <p>Nhập mật khẩu mới và lưu để hoàn tất thay đổi.</p>
        </header>

        <div class="password-card-body">

            <div class="password-employee">
                <div class="password-avatar">NV</div>
                <div>
                    <h3><c:out value="${item.hoTen}"/></h3>
                    <p>
                        <c:out value="${item.maNV}"/>
                        — Nhân viên <c:out value="${item.hoTen}"/>
                    </p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="password-alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <h3 class="password-section-title">Mật khẩu mới</h3>
            <p class="password-description">
                Hãy sử dụng mật khẩu riêng và tránh chia sẻ mật khẩu với người khác.
            </p>

            <form method="post"
                  action="${pageContext.request.contextPath}/nhan-vien?action=password">

                <input type="hidden"
                       name="maNV"
                       value="<c:out value='${item.maNV}'/>">

                <div class="password-field">
                    <label class="password-label" for="matKhauMoi">
                        Mật khẩu mới <span class="password-required">*</span>
                    </label>

                    <div class="password-input-wrap">
                        <input class="password-input"
                               type="password"
                               id="matKhauMoi"
                               name="matKhauMoi"
                               placeholder="Nhập mật khẩu mới"
                               autocomplete="new-password"
                               required>

                        <button class="password-toggle"
                                type="button"
                                data-target="matKhauMoi"
                                aria-label="Hiện hoặc ẩn mật khẩu">
                            Hiện
                        </button>
                    </div>

                    <div class="password-help">
                        Nhập mật khẩu mới theo yêu cầu bảo mật của hệ thống.
                    </div>
                </div>

                <div class="password-actions">
                    <a class="password-btn"
                       href="${pageContext.request.contextPath}/nhan-vien?action=list">
                        &#8592; Quay lại
                    </a>

                    <button class="password-btn password-btn-primary"
                            type="submit">
                        &#10003; Lưu mật khẩu
                    </button>
                </div>

            </form>
        </div>
    </section>
</main>

<script>
    document.querySelectorAll('.password-toggle').forEach(function (button) {
        button.addEventListener('click', function () {
            const input = document.getElementById(button.dataset.target);
            const isHidden = input.type === 'password';

            input.type = isHidden ? 'text' : 'password';
            button.textContent = isHidden ? 'Ẩn' : 'Hiện';
        });
    });
</script>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>