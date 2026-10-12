<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Loại phòng | QLKhachSan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
    <style>
        .wrap{max-width:1250px;margin:0 auto;padding:28px}
        .bar{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:20px}
        .table-wrap{overflow:auto;background:#fff;border:1px solid #e5eaf1;border-radius:12px}
        table{width:100%;border-collapse:collapse;min-width:650px}
        th,td{padding:13px 15px;text-align:left;border-bottom:1px solid #edf0f5}
        th{font-size:12px;text-transform:uppercase;letter-spacing:.4px;color:#718096;background:#f8fafc}
        td{font-size:13px}
        .form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:0 18px;max-width:780px;background:white;padding:24px;border:1px solid #e5eaf1;border-radius:14px}
        .form-grid input,.form-grid select,.form-grid textarea{width:100%;padding:11px;border:1px solid #d8e0ea;border-radius:8px}
        .actions{display:flex;gap:8px;flex-wrap:wrap}
        .muted{color:#718096}
        @media(max-width:650px){.wrap{padding:15px}.form-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<main class="wrap">
    <div class="bar">
        <div>
            <div class="eyebrow">QLKhachSan / Quản lý</div>
            <h1 style="font-size:25px;margin:5px 0">Quản lý loại phòng</h1>
            <p class="muted">Quản lý dữ liệu kết nối với cơ sở dữ liệu khách sạn.</p>
        </div>
        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/">← Dashboard</a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/loai-phong?action=new">＋ Thêm mới</a>
        </div>
    </div>
    <c:if test="${not empty error}">
        <div class="error"><c:out value="${error}"/></div>
    </c:if>
    <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>Mã loại</th>
                <th>Tên loại phòng</th>
                <th>Sức chứa</th>
                <th>Giá cơ bản</th>
                <th>Mô tả</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="x" items="${items}">
                <tr>
                    <td><c:out value="${x.maLoaiPhong}"/></td>
                    <td><b><c:out value="${x.tenLoaiPhong}"/></b></td>
                    <td><c:out value="${x.soNguoiToiDa}"/> người</td>
                    <td><fmt:formatNumber value="${x.giaCoBan}" type="number" pattern="#,##0" /> đ</td>
                    <td><c:out value="${x.moTa}"/></td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/loai-phong?action=edit&id=${x.maLoaiPhong}">Sửa</a>
                        <a href="${pageContext.request.contextPath}/loai-phong?action=detail&id=${x.maLoaiPhong}">Chi tiết</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty items}">
                <tr><td colspan="6">Chưa có dữ liệu.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>
</body>
</html>