<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Phòng | QLKhachSan</title>

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

        .table-wrap {
            overflow: auto;
            background: #fff;
            border: 1px solid #e5eaf1;
            border-radius: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        th, td {
            padding: 13px 15px;
            text-align: left;
            border-bottom: 1px solid #edf0f5;
        }

        th {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .4px;
            color: #718096;
            background: #f8fafc;
        }

        td {
            font-size: 13px;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .actions a,
        .actions button {
            font: inherit;
            cursor: pointer;
        }

        .delete-button {
            border: 0;
            background: none;
            color: #dc2626;
            padding: 0;
        }

        .delete-button:hover {
            text-decoration: underline;
        }

        .muted {
            color: #718096;
        }

        .success {
            margin-bottom: 16px;
            padding: 12px 16px;
            color: #166534;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 8px;
        }

        .error {
            margin-bottom: 16px;
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

    <div class="bar">
        <div>
            <div class="eyebrow">QLKhachSan / Quản lý</div>

            <h1 style="font-size:25px; margin:5px 0;">
                Quản lý phòng
            </h1>

            <p class="muted">
                Quản lý dữ liệu phòng khách sạn.
            </p>
        </div>

        <div class="actions">
            <a class="btn btn-primary"
               href="${pageContext.request.contextPath}/phong?action=new">
                ＋ Thêm mới
            </a>
        </div>
    </div>

    <c:if test="${param.success eq 'saved'}">
        <div class="success">Lưu thông tin phòng thành công.</div>
    </c:if>

    <c:if test="${param.success eq 'deleted'}">
        <div class="success">Xóa phòng thành công.</div>
    </c:if>

    <c:if test="${param.success eq 'status'}">
        <div class="success">Cập nhật trạng thái phòng thành công.</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>Mã phòng</th>
                <th>Số phòng</th>
                <th>Vị trí</th>
                <th>Loại phòng</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="x" items="${items}">
                <tr>
                    <td>
                        <c:out value="${x.maPhong}"/>
                    </td>

                    <td>
                        <strong>
                            <c:out value="${x.soPhong}"/>
                        </strong>
                    </td>

                    <td>
                        <c:out value="${x.viTri}"/>
                    </td>

                    <td>
                        <c:out value="${x.loaiPhong.tenLoaiPhong}"/>
                    </td>

                    <td>
                        <c:out value="${x.trangThai}"/>
                    </td>

                    <td>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/phong?action=edit&amp;id=${x.maPhong}">
                                Sửa
                            </a>

                            <a href="${pageContext.request.contextPath}/phong?action=detail&amp;id=${x.maPhong}">
                                Chi tiết
                            </a>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/phong"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa phòng này không?');"
                                  style="display:inline; margin:0;">

                                <input type="hidden"
                                       name="action"
                                       value="xoa">

                                <input type="hidden"
                                       name="id"
                                       value="<c:out value='${x.maPhong}'/>">

                                <button type="submit" class="delete-button">
                                    Xóa
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty items}">
                <tr>
                    <td colspan="6" class="muted">
                        Chưa có dữ liệu phòng.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>