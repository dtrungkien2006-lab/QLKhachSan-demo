<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết nhân viên | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .nv-detail-page {
            max-width: 1120px;
            margin: 0 auto;
            padding: 30px 32px 40px;
            color: #172b43;
        }

        .nv-breadcrumb {
            margin-bottom: 24px;
            color: #64748b;
            font-size: 13px;
        }

        .nv-breadcrumb strong {
            color: #0f766e;
        }

        .nv-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .nv-heading h1 {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 27px;
            font-weight: 750;
        }

        .nv-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }

        .nv-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 16px;
            border: 1px solid #dbe3ed;
            border-radius: 9px;
            background: #fff;
            color: #334155;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: .2s ease;
        }

        .nv-btn:hover {
            border-color: #0f766e;
            background: #f0fdfa;
            color: #0f766e;
        }

        .nv-card {
            overflow: hidden;
            border: 1px solid #e5eaf1;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 5px 18px rgba(15, 23, 42, .045);
        }

        .nv-card-header {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 28px 32px;
            background: linear-gradient(120deg, #10243b, #164e63);
            color: #fff;
        }

        .nv-avatar {
            display: flex;
            flex: 0 0 76px;
            width: 76px;
            height: 76px;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255,255,255,.4);
            border-radius: 20px;
            background: rgba(255,255,255,.13);
            color: #fff;
            font-size: 27px;
            font-weight: 750;
        }

        .nv-card-header h2 {
            margin: 0 0 8px;
            font-size: 22px;
            font-weight: 700;
        }

        .nv-card-header p {
            margin: 0;
            color: #d5e7ef;
            font-size: 14px;
        }

        .nv-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 13px;
        }

        .nv-badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            border-radius: 20px;
            background: rgba(255,255,255,.14);
            color: #fff;
            font-size: 12px;
            font-weight: 600;
        }

        .nv-card-body {
            padding: 28px 32px 32px;
        }

        .nv-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .nv-section-title::before {
            content: "";
            width: 4px;
            height: 20px;
            border-radius: 4px;
            background: #0f766e;
        }

        .nv-info-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            column-gap: 28px;
        }

        .nv-info-item {
            min-width: 0;
            padding: 17px 0;
            border-bottom: 1px solid #edf1f5;
        }

        .nv-info-label {
            display: block;
            margin-bottom: 8px;
            color: #64748b;
            font-size: 13px;
        }

        .nv-info-value {
            overflow-wrap: anywhere;
            color: #172b43;
            font-size: 14px;
            font-weight: 600;
        }

        .nv-role {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 6px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: 700;
        }

        .nv-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 6px;
            background: #ecfdf5;
            color: #047857;
            font-size: 12px;
            font-weight: 700;
        }

        .nv-card-footer {
            display: flex;
            justify-content: flex-end;
            padding: 18px 32px;
            border-top: 1px solid #edf1f5;
            background: #fafbfd;
        }

        @media (max-width: 700px) {
            .nv-detail-page {
                padding: 20px 14px 30px;
            }

            .nv-card-header {
                align-items: flex-start;
                gap: 14px;
                padding: 22px 18px;
            }

            .nv-avatar {
                flex-basis: 58px;
                width: 58px;
                height: 58px;
                border-radius: 15px;
                font-size: 22px;
            }

            .nv-card-header h2 {
                font-size: 18px;
            }

            .nv-card-body {
                padding: 22px 18px;
            }

            .nv-info-grid {
                grid-template-columns: 1fr;
            }

            .nv-card-footer {
                padding: 16px 18px;
            }
        }
    </style>
</head>

<body>

<a href="${pageContext.request.contextPath}/logout"
   class="logout-trigger"
   style="display:none">Đăng xuất</a>

<main class="nv-detail-page">

    <div class="nv-breadcrumb">
        UTE Hotel / Nhân viên / <strong>Chi tiết nhân viên</strong>
    </div>

    <div class="nv-heading">
        <div>
            <h1>Chi tiết nhân viên</h1>
            <p>Xem thông tin cá nhân và thông tin công tác của nhân viên.</p>
        </div>

        <a class="nv-btn"
           href="${pageContext.request.contextPath}/nhan-vien?action=list">
            &#8592; Quay lại danh sách
        </a>
    </div>

    <section class="nv-card">

        <header class="nv-card-header">
            <div class="nv-avatar">
                <c:choose>
                    <c:when test="${not empty item.hoTen}">
                        <c:out value="${item.hoTen.substring(0, 1)}"/>
                    </c:when>
                    <c:otherwise>NV</c:otherwise>
                </c:choose>
            </div>

            <div>
                <h2><c:out value="${item.hoTen}"/></h2>
                <p>Mã nhân viên: <c:out value="${item.maNV}"/></p>

                <div class="nv-badges">
                    <span class="nv-badge">
                        Vai trò:
                        &nbsp;<c:out value="${taiKhoan.vaiTro}"/>
                    </span>
                    <span class="nv-badge">
                        Trạng thái:
                        &nbsp;<c:out value="${taiKhoan.trangThai}"/>
                    </span>
                </div>
            </div>
        </header>

        <div class="nv-card-body">
            <h3 class="nv-section-title">Thông tin cá nhân</h3>

            <div class="nv-info-grid">

                <div class="nv-info-item">
                    <span class="nv-info-label">Mã nhân viên</span>
                    <div class="nv-info-value">
                        <c:out value="${item.maNV}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Họ và tên</span>
                    <div class="nv-info-value">
                        <c:out value="${item.hoTen}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Ngày sinh</span>
                    <div class="nv-info-value">
                        <c:out value="${item.ngaySinh}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Giới tính</span>
                    <div class="nv-info-value">
                        <c:out value="${item.gioiTinh}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Số điện thoại</span>
                    <div class="nv-info-value">
                        <c:out value="${item.soDienThoai}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Email</span>
                    <div class="nv-info-value">
                        <c:out value="${item.email}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Địa chỉ</span>
                    <div class="nv-info-value">
                        <c:out value="${item.diaChi}"/>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Vai trò hệ thống</span>
                    <div class="nv-info-value">
                        <span class="nv-role">
                            <c:out value="${taiKhoan.vaiTro}"/>
                        </span>
                    </div>
                </div>

                <div class="nv-info-item">
                    <span class="nv-info-label">Trạng thái tài khoản</span>
                    <div class="nv-info-value">
                        <span class="nv-status">
                            <c:out value="${taiKhoan.trangThai}"/>
                        </span>
                    </div>
                </div>

            </div>
        </div>

        <footer class="nv-card-footer">
            <a class="nv-btn"
               href="${pageContext.request.contextPath}/nhan-vien?action=list">
                &#8592; Quay lại danh sách nhân viên
            </a>
        </footer>

    </section>
</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>