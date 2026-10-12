<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Loại Phòng ${item.tenLoaiPhong}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <div class="card col-md-8 mx-auto">
        <div class="card-header bg-primary text-white fs-5">
            Thông Tin Chi Tiết Loại Phòng
        </div>
        <div class="card-body">
            <table class="table table-borderless fs-5">
                <tr><th width="35%">Mã Loại Phòng:</th><td>${item.maLoaiPhong}</td></tr>
                <tr><th>Tên Loại Phòng:</th><td><strong>${item.tenLoaiPhong}</strong></td></tr>
                <tr><th>Giá Cơ Bản:</th><td class="text-success fw-bold"><fmt:formatNumber value="${item.giaCoBan}" pattern="#,##0" /> VNĐ / đêm</td></tr>
                <tr><th>Số Người Tối Đa:</th><td>${item.soNguoiToiDa} người</td></tr>
                <tr><th>Mô Tả:</th><td>${item.moTa}</td></tr>
            </table>
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/loai-phong?action=edit&id=${item.maLoaiPhong}" class="btn btn-warning">Sửa</a>
                <a href="${pageContext.request.contextPath}/loai-phong" class="btn btn-secondary">Quay Lại</a>
            </div>
        </div>
    </div>
</body>
</html>