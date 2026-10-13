<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Thông tin phòng | QLKhachSan</title>

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

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
            max-width: 780px;
            padding: 24px;
            background: #fff;
            border: 1px solid #e5eaf1;
            border-radius: 14px;
        }

        .form-grid input,
        .form-grid select,
        .form-grid textarea {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            border: 1px solid #d8e0ea;
            border-radius: 8px;
            font: inherit;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .field > span {
            font-size: 14px;
            font-weight: 500;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        @media (max-width: 650px) {
            .wrap {
                padding: 15px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                padding: 18px;
            }

            .full-width {
                grid-column: auto;
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
                Thông tin phòng
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

    <!-- Form thêm mới hoặc cập nhật phòng -->
    <form class="form-grid"
          method="post"
          action="${pageContext.request.contextPath}/phong">

        <!-- Mã phòng -->
        <label class="field">
            <span>Mã phòng (để trống khi thêm mới)</span>

            <input type="text"
                   name="maPhong"
                   value="${item.maPhong}"
                   placeholder="P101">
        </label>

        <!-- Số phòng -->
        <label class="field">
            <span>Số phòng</span>

            <input type="text"
                   name="soPhong"
                   value="${item.soPhong}"
                   required>
        </label>

        <!-- Vị trí -->
        <label class="field">
            <span>Vị trí</span>

            <input type="text"
                   name="viTri"
                   value="${item.viTri}"
                   placeholder="Tầng 1">
        </label>

        <!-- Loại phòng -->
        <label class="field">
            <span>Loại phòng</span>

            <select name="maLoaiPhong" required>
                <option value="">-- Chọn loại phòng --</option>

                <c:forEach var="lp" items="${loaiPhongs}">
                    <option value="${lp.maLoaiPhong}"
                        ${item.loaiPhong.maLoaiPhong == lp.maLoaiPhong
                            ? 'selected' : ''}>
                        <c:out value="${lp.tenLoaiPhong}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <!-- Trạng thái phòng -->
        <label class="field">
            <span>Trạng thái</span>

            <select name="trangThai">
                <c:forEach var="s" items="${trangThais}">
                    <option value="${s}"
                        ${item.trangThai == s ? 'selected' : ''}>
                        <c:out value="${s}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <!-- Nút thao tác -->
        <div class="actions full-width">
            <button class="btn btn-primary" type="submit">
                Lưu phòng
            </button>

            <a class="btn"
               href="${pageContext.request.contextPath}/phong">
                Hủy
            </a>
        </div>

    </form>
</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>
