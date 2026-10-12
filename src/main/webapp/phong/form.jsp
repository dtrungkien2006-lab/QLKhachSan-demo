<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>${empty item ? 'Thêm Phòng' : 'Cập Nhật Phòng'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <h3>${empty item ? 'Thêm Phòng Mới' : 'Cập Nhật Phòng'}</h3>

    <form action="${pageContext.request.contextPath}/phong" method="post" class="mt-3 col-md-6">
        <input type="hidden" name="isEdit" value="${not empty item ? 'true' : 'false'}" />

        <div class="mb-3">
            <label class="form-label">Số Phòng (Ví dụ: 401, 402):</label>
            <input type="text" id="soPhong" name="soPhong" value="${item.soPhong}" class="form-control" required oninput="genMaPhong()" />
        </div>

        <div class="mb-3">
            <label class="form-label">Mã Phòng:</label>
            <input type="text" id="maPhong" name="maPhong" value="${item.maPhong}" class="form-control" ${not empty item ? 'readonly' : ''} placeholder="Tự động tạo theo số phòng (vd: P401)" />
        </div>

        <div class="mb-3">
            <label class="form-label">Vị Trí (Tầng/Khu):</label>
            <input type="text" name="viTri" value="${item.viTri}" class="form-control" placeholder="Tầng 4" />
        </div>

        <div class="mb-3">
            <label class="form-label">Loại Phòng:</label>
            <select name="maLoaiPhong" class="form-select" required>
                <option value="">-- Chọn Loại Phòng --</option>
                <c:forEach var="lp" items="${loaiPhongs}">
                    <option value="${lp.maLoaiPhong}" ${item.loaiPhong.maLoaiPhong == lp.maLoaiPhong ? 'selected' : ''}>
                        ${lp.tenLoaiPhong} (<fmt:formatNumber value="${lp.giaCoBan}" pattern="#,##0" /> VNĐ)
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Trạng Thái Phòng:</label>
            <select name="trangThai" class="form-select" required>
                <c:forEach var="tt" items="${trangThais}">
                    <option value="${tt}" ${item.trangThai == tt ? 'selected' : ''}>${tt.tenHienThi}</option>
                </c:forEach>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Lưu Phòng</button>
        <a href="${pageContext.request.contextPath}/phong" class="btn btn-secondary">Hủy</a>
    </form>

    <script>
        function genMaPhong() {
            const isEditMode = ${not empty item ? 'true' : 'false'};
            if (!isEditMode) {
                const soPhong = document.getElementById('soPhong').value.trim();
                document.getElementById('maPhong').value = soPhong ? 'P' + soPhong : '';
            }
        }
    </script>
</body>
</html>