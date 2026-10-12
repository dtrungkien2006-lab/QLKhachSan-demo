<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tổng quan | QLKhachSan</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body>
<div class="app-shell">
  <aside class="sidebar">
    <a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">H</span><span><span class="brand-name">Horizon Hotel</span><br><span class="brand-sub">HOTEL MANAGEMENT</span></span></a>
    <div><div class="nav-label">Tổng quan</div><nav class="nav-list">
      <a class="nav-link active" href="${pageContext.request.contextPath}/"><span class="nav-icon">▦</span>Dashboard</a>
    </nav></div>
    <div><div class="nav-label">Nghiệp vụ khách sạn</div><nav class="nav-list">
      <a class="nav-link" href="${pageContext.request.contextPath}/phong"><span class="nav-icon">▤</span>Quản lý phòng</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/loai-phong"><span class="nav-icon">▣</span>Loại phòng</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/dat-phong?action=list"><span class="nav-icon">▦</span>Đặt phòng</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/khach-hang"><span class="nav-icon">♙</span>Khách hàng</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/dich-vu"><span class="nav-icon">✧</span>Dịch vụ</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/su-dung-dich-vu"><span class="nav-icon">＋</span>Sử dụng dịch vụ</a>
    </nav></div>
    <div><div class="nav-label">Kế toán & hệ thống</div><nav class="nav-list">
      <a class="nav-link" href="${pageContext.request.contextPath}/hoa-don"><span class="nav-icon">▧</span>Hóa đơn</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/thanh-toan"><span class="nav-icon">＄</span>Thanh toán</a>
      <c:if test="${sessionScope.vaiTro == 'ADMIN'}"><a class="nav-link" href="${pageContext.request.contextPath}/nhan-vien"><span class="nav-icon">♧</span>Nhân viên & tài khoản</a></c:if>
    </nav></div>
    <div class="sidebar-foot">QLKhachSan · Java MVC<br>Hệ thống quản lý vận hành khách sạn</div>
  </aside>
  <main class="main">
    <header class="topbar"><div class="crumb">Hệ thống / <strong>Tổng quan</strong></div><div class="user-chip"><span class="avatar"><c:out value="${empty sessionScope.hoTen ? 'NV' : sessionScope.hoTen.substring(0,1)}"/></span><span><span class="user-name"><c:out value="${sessionScope.hoTen}"/></span><br><span class="user-role"><c:out value="${sessionScope.vaiTro}"/></span></span><a class="btn" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></div></header>
    <div class="page">
      <div class="page-heading"><div><div class="eyebrow">Hotel operations</div><h1>Xin chào, <c:out value="${sessionScope.hoTen}"/> 👋</h1><p class="subtitle">Quản lý các hoạt động khách sạn từ một nơi duy nhất.</p></div><a class="btn btn-primary" href="${pageContext.request.contextPath}/dat-phong?action=new">＋ Tạo đặt phòng</a></div>
      <div class="stats">
        <div class="stat-card"><div><div class="stat-label">Quản lý phòng</div><div class="stat-value">Phòng</div><div class="stat-note">Trạng thái và loại phòng</div></div><div class="stat-icon">▤</div></div>
        <div class="stat-card"><div><div class="stat-label">Tiếp nhận khách</div><div class="stat-value">Đặt phòng</div><div class="stat-note">Đặt phòng · nhận/trả phòng</div></div><div class="stat-icon">♙</div></div>
        <div class="stat-card"><div><div class="stat-label">Dịch vụ khách sạn</div><div class="stat-value">Dịch vụ</div><div class="stat-note">Ghi nhận dịch vụ phát sinh</div></div><div class="stat-icon">✧</div></div>
        <div class="stat-card"><div><div class="stat-label">Tài chính</div><div class="stat-value">Hóa đơn</div><div class="stat-note">Hóa đơn và thanh toán</div></div><div class="stat-icon">▧</div></div>
      </div>
      <div class="section-head"><h2>Truy cập nghiệp vụ</h2><span>Chọn chức năng để bắt đầu</span></div>
      <div class="module-grid">
        <a class="module-card" href="${pageContext.request.contextPath}/dat-phong?action=list"><span class="module-icon">▦</span><span><h3>Đặt phòng</h3><p>Xem danh sách đặt phòng, tạo đặt phòng và xử lý trạng thái lưu trú.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/phong"><span class="module-icon">▤</span><span><h3>Quản lý phòng</h3><p>Theo dõi mã phòng, loại phòng, vị trí và trạng thái hiện tại.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/khach-hang"><span class="module-icon">♙</span><span><h3>Khách hàng</h3><p>Tra cứu và cập nhật thông tin khách hàng của khách sạn.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/loai-phong"><span class="module-icon">▣</span><span><h3>Loại phòng</h3><p>Quản lý giá cơ bản, sức chứa và mô tả từng loại phòng.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/dich-vu"><span class="module-icon">✧</span><span><h3>Dịch vụ</h3><p>Quản lý danh mục dịch vụ và đơn giá đang kinh doanh.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/su-dung-dich-vu"><span class="module-icon">＋</span><span><h3>Sử dụng dịch vụ</h3><p>Ghi nhận dịch vụ khách sử dụng trong thời gian lưu trú.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/hoa-don"><span class="module-icon">▧</span><span><h3>Hóa đơn</h3><p>Xem hóa đơn và các khoản thu từ phòng, dịch vụ.</p></span><span class="module-arrow">›</span></a>
        <a class="module-card" href="${pageContext.request.contextPath}/thanh-toan"><span class="module-icon">＄</span><span><h3>Thanh toán</h3><p>Theo dõi phương thức, trạng thái và mã giao dịch.</p></span><span class="module-arrow">›</span></a>
        <c:if test="${sessionScope.vaiTro == 'ADMIN'}"><a class="module-card" href="${pageContext.request.contextPath}/nhan-vien"><span class="module-icon">♧</span><span><h3>Nhân viên & tài khoản</h3><p>Quản lý nhân sự và phân quyền truy cập hệ thống.</p></span><span class="module-arrow">›</span></a></c:if>
      </div>
      <div class="notice">ℹ️ Dữ liệu thống kê sẽ được hiển thị khi các truy vấn tổng hợp được kết nối. Các thẻ hiện tại là lối tắt nghiệp vụ, không phải số liệu giả lập.</div>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script></body></html>
