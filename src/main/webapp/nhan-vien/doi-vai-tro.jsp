<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi vai trò | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .role-page {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 32px 40px;
            color: #172b43;
        }

        .role-breadcrumb {
            margin-bottom: 24px;
            color: #64748b;
            font-size: 13px;
        }

        .role-breadcrumb strong {
            color: #0f766e;
        }

        .role-heading {
            margin-bottom: 24px;
        }

        .role-heading h1 {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 27px;
            font-weight: 750;
        }

        .role-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }

        .role-card {
            overflow: hidden;
            border: 1px solid #e5eaf1;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 5px 18px rgba(15, 23, 42, .045);
        }

        .role-card-header {
            padding: 24px 28px;
            background: linear-gradient(120deg, #10243b, #164e63);
            color: #fff;
        }

        .role-card-header h2 {
            margin: 0 0 7px;
            font-size: 18px;
            font-weight: 700;
        }

        .role-card-header p {
            margin: 0;
            color: #d5e7ef;
            font-size: 14px;
        }

        .role-card-body {
            padding: 28px;
        }

        .role-employee {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px;
            margin-bottom: 28px;
            border: 1px solid #e5eaf1;
            border-radius: 12px;
            background: #f8fafc;
        }

        .role-avatar {
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

        .role-employee h3 {
            margin: 0 0 6px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .role-employee p {
            margin: 0;
            color: #64748b;
            font-size: 13px;
        }

        .role-form-title {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .role-description {
            margin: 0 0 18px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .role-label {
            display: block;
            margin-bottom: 9px;
            color: #334155;
            font-size: 14px;
            font-weight: 650;
        }

        .role-select {
            display: block;
            width: 100%;
            max-width: 480px;
            min-height: 46px;
            padding: 0 14px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            background: #fff;
            color: #172b43;
            font: inherit;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .role-select:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .role-help {
            margin-top: 9px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .role-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #edf1f5;
        }

        .role-btn {
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

        .role-btn:hover {
            border-color: #0f766e;
            background: #f0fdfa;
            color: #0f766e;
        }

        .role-btn-primary {
            border-color: #0f766e;
            background: #0f766e;
            color: #fff;
        }

        .role-btn-primary:hover {
            border-color: #115e59;
            background: #115e59;
            color: #fff;
        }

        @media (max-width: 650px) {
            .role-page {
                padding: 20px 14px 30px;
            }

            .role-card-header,
            .role-card-body {
                padding: 20px 18px;
            }

            .role-actions {
                flex-direction: column-reverse;
                align-items: stretch;
            }

            .role-btn {
                width: 100%;
                box-sizing: border-box;
            }
        }
    </style>
</head>

<body>

<main class="role-page">

    <div class="role-breadcrumb">
        UTE Hotel / Nhân viên / <strong>Đổi vai trò</strong>
    </div>

    <div class="role-heading">
        <h1>Đổi vai trò nhân viên</h1>
        <p>Cập nhật vai trò tài khoản theo nhiệm vụ của nhân viên.</p>
    </div>

    <section class="role-card">

        <header class="role-card-header">
            <h2>Thông tin và phân quyền</h2>
            <p>Kiểm tra nhân viên trước khi lưu thay đổi.</p>
        </header>

        <div class="role-card-body">

            <div class="role-employee">
                <div class="role-avatar">
                    <c:choose>
                        <c:when test="${not empty item.hoTen}">
                            <c:out value="${item.hoTen.substring(0, 1)}"/>
                        </c:when>
                        <c:otherwise>NV</c:otherwise>
                    </c:choose>
                </div>

                <div>
                    <h3>
                        <c:out value="${item.hoTen}"/>
                    </h3>
                    <p>
                        Mã nhân viên:
                        <strong><c:out value="${item.maNV}"/></strong>
                    </p>
                </div>
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/nhan-vien?action=role">

                <input type="hidden"
                       name="maNV"
                       value="<c:out value='${item.maNV}'/>">

                <h3 class="role-form-title">Vai trò hệ thống</h3>
                <p class="role-description">
                    Chọn vai trò mới phù hợp với nhiệm vụ được giao.
                    Quyền truy cập của tài khoản có thể thay đổi theo vai trò.
                </p>

                <label class="role-label" for="vaiTro">
                    Chọn vai trò <span style="color:#dc2626">*</span>
                </label>

                <select class="role-select" id="vaiTro" name="vaiTro" required>
                    <option value="LE_TAN"
                        ${taiKhoan.vaiTro == 'LE_TAN' ? 'selected' : ''}>
                        Lễ tân
                    </option>
                    <option value="QUAN_LY"
                        ${taiKhoan.vaiTro == 'QUAN_LY' ? 'selected' : ''}>
                        Quản lý
                    </option>
                    <option value="KE_TOAN"
                        ${taiKhoan.vaiTro == 'KE_TOAN' ? 'selected' : ''}>
                        Kế toán
                    </option>
                </select>

                <p class="role-help">
                    Vai trò được lưu theo mã hệ thống, ví dụ:
                    <strong>LE_TAN</strong>, <strong>QUAN_LY</strong>,
                    <strong>KE_TOAN</strong>.
                </p>

                <div class="role-actions">
                    <a class="role-btn"
                       href="${pageContext.request.contextPath}/nhan-vien?action=list">
                        &#8592; Quay lại
                    </a>

                    <button class="role-btn role-btn-primary" type="submit">
                        &#10003; Lưu thay đổi
                    </button>
                </div>

            </form>
        </div>
    </section>

</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>