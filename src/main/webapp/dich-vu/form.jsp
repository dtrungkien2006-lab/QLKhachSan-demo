<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Thông tin dịch vụ | QLKhachSan</title>

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

        .form-grid textarea {
            resize: vertical;
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

        .full-width {
            grid-column: 1 / -1;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
        }

        .muted {
            color: #718096;
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
                Thông tin dịch vụ
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
               href="${pageContext.request.contextPath}/dich-vu?action=new">
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

    <!-- Form thêm mới hoặc cập nhật dịch vụ -->
    <form class="form-grid"
          method="post"
          action="${pageContext.request.contextPath}/dich-vu">

        <!-- Mã dịch vụ -->
        <label class="field">
            <span>Mã dịch vụ (để trống khi thêm)</span>

            <input type="text"
                   name="maDichVu"
                   value="${item.maDichVu}">
        </label>

        <!-- Tên dịch vụ -->
        <label class="field">
            <span>Tên dịch vụ</span>

            <input type="text"
                   name="tenDichVu"
                   value="${item.tenDichVu}"
                   required>
        </label>

        <!-- Đơn giá -->
        <label class="field">
            <span>Đơn giá (VNĐ)</span>

            <input type="number"
                   name="donGia"
                   min="0"
                   step="1000"
                   value="${item.donGia}"
                   required>
        </label>

        <!-- Loại dịch vụ -->
        <label class="field">
            <span>Loại dịch vụ</span>

            <input type="text"
                   name="loaiDichVu"
                   value="${item.loaiDichVu}"
                   placeholder="DoUong, DoAn...">
        </label>

        <!-- Mô tả -->
        <label class="field full-width">
            <span>Mô tả</span>

            <textarea name="moTa"
                      rows="3"><c:out value="${item.moTa}"/></textarea>
        </label>

        <!-- Trạng thái kinh doanh -->
        <label class="field">
            <span>Trạng thái kinh doanh</span>

            <select name="dangKinhDoanh">
                <option value="true"
                    ${item.dangKinhDoanh == null || item.dangKinhDoanh
                        ? 'selected' : ''}>
                    Đang kinh doanh
                </option>

                <option value="false"
                    ${item.dangKinhDoanh != null && !item.dangKinhDoanh
                        ? 'selected' : ''}>
                    Ngừng kinh doanh
                </option>
            </select>
        </label>

        <!-- Nút thao tác -->
        <div class="actions full-width">
            <button type="submit" class="btn btn-primary">
                Lưu dịch vụ
            </button>

            <a class="btn"
               href="${pageContext.request.contextPath}/dich-vu">
                Hủy
            </a>
        </div>

    </form>
</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>
