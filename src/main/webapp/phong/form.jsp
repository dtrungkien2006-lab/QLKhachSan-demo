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

        .field {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .field > span {
            font-size: 14px;
            font-weight: 500;
        }

        .field input,
        .field select {
            box-sizing: border-box;
            width: 100%;
            padding: 11px;
            border: 1px solid #d8e0ea;
            border-radius: 8px;
            font: inherit;
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

    <div class="bar">
        <div>
            <div class="eyebrow">QLKhachSan / Quản lý</div>

            <h1 style="font-size: 25px; margin: 5px 0;">
                <c:choose>
                    <c:when test="${formAction eq 'sua'}">
                        Cập nhật phòng
                    </c:when>
                    <c:otherwise>
                        Thêm phòng mới
                    </c:otherwise>
                </c:choose>
            </h1>

            <p class="muted">
                Nhập thông tin phòng khách sạn.
            </p>
        </div>

        <div class="actions">
            <a class="btn"
               href="${pageContext.request.contextPath}/phong">
                ← Quay lại danh sách
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form class="form-grid"
          method="post"
          action="${pageContext.request.contextPath}/phong">

        <!-- Xác định rõ thao tác thêm hay sửa -->
        <input type="hidden"
               name="action"
               value="${formAction eq 'sua' ? 'sua' : 'them'}">

        <!-- Giữ mã phòng ban đầu khi sửa -->
        <c:if test="${formAction eq 'sua'}">
            <input type="hidden"
                   name="maPhongCu"
                   value="${item.maPhong}">
        </c:if>

        <label class="field">
            <span>Mã phòng</span>

            <input type="text"
                   name="maPhong"
                   value="<c:out value='${item.maPhong}'/>"
                   <c:if test="${formAction eq 'sua'}">readonly</c:if>>
        </label>

        <label class="field">
            <span>Số phòng</span>

            <input type="text"
                   name="soPhong"
                   value="<c:out value='${item.soPhong}'/>"
                   required>
        </label>

        <label class="field">
            <span>Vị trí</span>

            <input type="text"
                   name="viTri"
                   value="<c:out value='${item.viTri}'/>">
        </label>

        <label class="field">
            <span>Loại phòng</span>

            <select name="maLoaiPhong" required>
                <option value="">-- Chọn loại phòng --</option>

                <c:forEach var="lp" items="${loaiPhongs}">
                    <option value="${lp.maLoaiPhong}"
                        <c:if test="${item.loaiPhong.maLoaiPhong eq lp.maLoaiPhong}">
                            selected
                        </c:if>>
                        <c:out value="${lp.tenLoaiPhong}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <label class="field">
            <span>Trạng thái phòng</span>

            <select name="trangThai" required>
                <c:forEach var="s" items="${trangThais}">
                    <option value="${s}"
                        <c:if test="${item.trangThai eq s}">
                            selected
                        </c:if>>
                        <c:out value="${s}"/>
                    </option>
                </c:forEach>
            </select>
        </label>

        <div class="actions full-width">
            <button class="btn btn-primary" type="submit">
                <c:choose>
                    <c:when test="${formAction eq 'sua'}">
                        Lưu thay đổi
                    </c:when>
                    <c:otherwise>
                        Thêm phòng
                    </c:otherwise>
                </c:choose>
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