<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý & Tra Cứu Phòng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh Sách Phòng</h2>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary me-2">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/phong?action=new" class="btn btn-primary">+ Thêm Phòng Mới</a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Khung Tra cứu & Lọc Phòng -->
    <div class="card mb-4">
        <div class="card-header bg-light"><strong>Tra Cứu / Lọc Phòng</strong></div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/phong" method="get" class="row g-3">
                <input type="hidden" name="action" value="search" />
                <div class="col-md-4">
                    <input type="text" name="keyword" class="form-control" placeholder="Nhập Số phòng / Vị trí..." value="${param.keyword}">
                </div>
                <div class="col-md-3">
                    <select name="maLoaiPhong" class="form-select">
                        <option value="">-- Tất cả Loại phòng --</option>
                        <c:forEach var="lp" items="${loaiPhongs}">
                            <option value="${lp.maLoaiPhong}" ${param.maLoaiPhong == lp.maLoaiPhong ? 'selected' : ''}>${lp.tenLoaiPhong}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="trangThai" class="form-select">
                        <option value="">-- Tất cả Trạng thái --</option>
                        <c:forEach var="tt" items="${trangThais}">
                            <option value="${tt}" ${param.trangThai == tt ? 'selected' : ''}>${tt.tenHienThi}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-secondary w-100">Tìm kiếm</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bảng Danh Sách Phòng & Đổi Trạng Thái -->
    <table class="table table-bordered align-middle">
        <thead class="table-dark">
            <tr>
                <th>Mã Phòng</th>
                <th>Số Phòng</th>
                <th>Vị Trí</th>
                <th>Loại Phòng</th>
                <th>Trạng Thái Hiện Tại</th>
                <th>Đổi Trạng Thái Nhanh</th>
                <th width="180">Hành Động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${items}">
                <tr>
                    <td>${p.maPhong}</td>
                    <td><strong class="fs-5">${p.soPhong}</strong></td>
                    <td>${p.viTri}</td>
                    <td>${p.loaiPhong.tenLoaiPhong}</td>
                    <td>
                        <c:choose>
                            <c:when test="${p.trangThai == 'TRONG'}"><span class="badge bg-success">Trống</span></c:when>
                            <c:when test="${p.trangThai == 'DA_DAT'}"><span class="badge bg-warning text-dark">Đã đặt</span></c:when>
                            <c:when test="${p.trangThai == 'DANG_SU_DUNG'}"><span class="badge bg-primary">Đang sử dụng</span></c:when>
                        </c:choose>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/phong" method="get" class="d-flex gap-1">
                            <input type="hidden" name="action" value="status" />
                            <input type="hidden" name="id" value="${p.maPhong}" />
                            <select name="trangThai" class="form-select form-select-sm" onchange="this.form.submit()">
                                <c:forEach var="tt" items="${trangThais}">
                                    <option value="${tt}" ${p.trangThai == tt ? 'selected' : ''}>${tt.tenHienThi}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/phong?action=detail&id=${p.maPhong}" class="btn btn-sm btn-info">Xem</a>
                        <a href="${pageContext.request.contextPath}/phong?action=edit&id=${p.maPhong}" class="btn btn-sm btn-warning">Sửa</a>
                        <a href="${pageContext.request.contextPath}/phong?action=delete&id=${p.maPhong}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa phòng này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>