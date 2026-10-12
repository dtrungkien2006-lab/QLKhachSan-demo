<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Loại Phòng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh sách Loại Phòng</h2>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary me-2">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/loai-phong?action=new" class="btn btn-primary">+ Thêm Loại Phòng</a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>Mã Loại</th>
                <th>Tên Loại Phòng</th>
                <th>Giá Cơ Bản</th>
                <th>Số Người Tối Đa</th>
                <th>Mô Tả</th>
                <th width="180">Hành Động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="lp" items="${items}">
                <tr>
                    <td>${lp.maLoaiPhong}</td>
                    <td><strong>${lp.tenLoaiPhong}</strong></td>
                    <td class="text-end fw-bold text-success">
                        <fmt:formatNumber value="${lp.giaCoBan}" pattern="#,##0" /> VNĐ
                    </td>
                    <td>${lp.soNguoiToiDa} người</td>
                    <td>${lp.moTa}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/loai-phong?action=detail&id=${lp.maLoaiPhong}" class="btn btn-sm btn-info">Xem</a>
                        <a href="${pageContext.request.contextPath}/loai-phong?action=edit&id=${lp.maLoaiPhong}" class="btn btn-sm btn-warning">Sửa</a>
                        <a href="${pageContext.request.contextPath}/loai-phong?action=delete&id=${lp.maLoaiPhong}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>