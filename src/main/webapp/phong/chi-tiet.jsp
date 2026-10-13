<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Chi tiết phòng | QLKhachSan</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .wrap {
            max-width: 1250px;
            margin: 0 auto;
            padding: 28px;
        }

        .bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .muted {
            color: #718096;
        }

        @media (max-width: 650px) {
            .wrap {
                padding: 15px;
            }
        }
    </style>
</head>

<body>
<main class="wrap">

    <!-- Tiêu đề và điều hướng -->
    <div class="bar">
        <div>
            <div class="eyebrow">QLKhachSan / Quản lý</div>

            <h1 style="font-size: 25px; margin: 5px 0;">
                Chi tiết phòng
            </h1>

            <p class="muted">
                Quản lý dữ liệu kết nối với cơ sở dữ liệu khách sạn.
            </p>
        </div>

        <div class="actions">
            <a class="btn"
               href="${pageContext.request.contextPath}/">
                ← Dashboard
            </a>

            <a class="btn btn-primary"
               href="${pageContext.request.contextPath}/phong?action=new">
                ＋ Thêm mới
            </a>
        </div>
    </div>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <!-- Thông tin chi tiết phòng -->
    <div class="panel">

        <p>
            <b>Mã phòng:</b>
            <c:out value="${item.maPhong}"/>
        </p>

        <p>
            <b>Số phòng:</b>
            <c:out value="${item.soPhong}"/>
        </p>

        <p>
            <b>Vị trí:</b>
            <c:out value="${item.viTri}"/>
        </p>

        <p>
            <b>Loại phòng:</b>
            <c:out value="${item.loaiPhong.tenLoaiPhong}"/>
        </p>

        <p>
            <b>Trạng thái:</b>
            <c:out value="${item.trangThai}"/>
        </p>

        <a class="btn"
           href="${pageContext.request.contextPath}/phong">
            Quay lại
        </a>

    </div>

</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>
