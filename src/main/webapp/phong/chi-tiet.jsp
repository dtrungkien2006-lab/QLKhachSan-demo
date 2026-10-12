<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Phòng ${item.soPhong}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <div class="card col-md-8 mx-auto">
        <div class="card-header bg-primary text-white fs-5">
            Thông Tin Chi Tiết Phòng ${item.soPhong}
        </div>
        <div class="card-body">
            <table class="table table-borderless fs-5">
                <tr><th width="35%">Mã Phòng:</th><td>${item.maPhong}</td></tr>
                <tr><th>Số Phòng:</th><td><strong class="fs-4">${item.soPhong}</strong></td></tr>
                <tr><th>Vị Trí:</th><td>${item.viTri}</td></tr>
                <tr><th>Tên Loại Phòng:</th><td>${item.loaiPhong.tenLoaiPhong}</td></tr>
                <tr><th>Giá Cơ Bản:</th><td class="text-success fw-bold"><fmt:formatNumber value="${item.loaiPhong.giaCoBan}" pattern="#,##0" /> VNĐ / đêm</td></tr>
                <tr><th>Số Người Tối Đa:</th><td>${item.loaiPhong.soNguoiToiDa} người</td></tr>
                <tr><th>Trạng Thái:</th><td><strong>${item.trangThai.tenHienThi}</strong></td></tr>
            </table>
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/phong?action=edit&id=${item.maPhong}" class="btn btn-warning">Sửa Phòng</a>
                <a href="${pageContext.request.contextPath}/phong" class="btn btn-secondary">Quay Lại</a>
            </div>
        </div>
    </div>
</body>
</html>