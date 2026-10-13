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
            max-width: 1000px;
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

        .panel {
            max-width: 780px;
            padding: 24px;
            background: #fff;
            border: 1px solid #e5eaf1;
            border-radius: 14px;
        }

        .detail-row {
            display: grid;
            grid-template-columns: 160px minmax(0, 1fr);
            gap: 12px;
            padding: 14px 0;
            border-bottom: 1px solid #edf0f5;
        }

        .detail-label {
            color: #718096;
            font-weight: 500;
        }

        .detail-value {
            overflow-wrap: anywhere;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        .muted {
            color: #718096;
        }

        @media (max-width: 650px) {
            .wrap {
                padding: 15px;
            }

            .panel {
                padding: 18px;
            }

            .detail-row {
                grid-template-columns: 1fr;
                gap: 5px;
            }
        }
    </style>
</head>

<body>
<main class="wrap">

    <div class="bar">
        <div>
            <div class="eyebrow">QLKhachSan / Quản lý</div>

            <h1 style="font-size:25px; margin:5px 0;">
                Chi tiết phòng
            </h1>

            <p class="muted">
                Thông tin chi tiết phòng khách sạn.
            </p>
        </div>

        <a class="btn"
           href="${pageContext.request.contextPath}/phong">
            ← Danh sách phòng
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty item}">
            <div class="panel">

                <div class="detail-row">
                    <div class="detail-label">Mã phòng</div>
                    <div class="detail-value">
                        <c:out value="${item.maPhong}"/>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Số phòng</div>
                    <div class="detail-value">
                        <strong>
                            <c:out value="${item.soPhong}"/>
                        </strong>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Vị trí</div>
                    <div class="detail-value">
                        <c:out value="${item.viTri}"/>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Loại phòng</div>
                    <div class="detail-value">
                        <c:out value="${item.loaiPhong.tenLoaiPhong}"/>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Trạng thái</div>
                    <div class="detail-value">
                        <c:out value="${item.trangThai}"/>
                    </div>
                </div>

                <div class="actions">
                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/phong?action=edit&amp;id=${item.maPhong}">
                        Sửa phòng
                    </a>

                    <a class="btn"
                       href="${pageContext.request.contextPath}/phong">
                        Quay lại
                    </a>
                </div>

            </div>
        </c:when>

        <c:otherwise>
            <div class="panel">
                <p>Không có dữ liệu phòng để hiển thị.</p>

                <a class="btn"
                   href="${pageContext.request.contextPath}/phong">
                    Quay lại danh sách phòng
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>