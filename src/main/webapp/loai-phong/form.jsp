<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${empty item ? 'Thêm Loại Phòng' : 'Cập Nhật Loại Phòng'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <h3>${empty item ? 'Thêm Loại Phòng Mới' : 'Cập Nhật Loại Phòng'}</h3>
    <form action="${pageContext.request.contextPath}/loai-phong" method="post" class="mt-3 col-md-6">
        <input type="hidden" name="maLoaiPhong" value="${item.maLoaiPhong}" />

        <div class="mb-3">
            <label class="form-label">Tên Loại Phòng:</label>
            <input type="text" name="tenLoaiPhong" value="${item.tenLoaiPhong}" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Giá Cơ Bản (VNĐ):</label>
            <input type="number" step="0.01" name="giaCoBan" value="${item.giaCoBan}" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Số Người Tối Đa:</label>
            <input type="number" name="soNguoiToiDa" value="${item.soNguoiToiDa}" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Mô Tả:</label>
            <textarea name="moTa" class="form-control" rows="3">${item.moTa}</textarea>
        </div>
        <button type="submit" class="btn btn-success">Lưu Loại Phòng</button>
        <a href="${pageContext.request.contextPath}/loai-phong" class="btn btn-secondary">Hủy</a>
    </form>
</body>
</html>