<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Báo cáo</title>
    <style>
        :root { --xanh:#2563eb; --nen:#f8fafc; --vien:#e2e8f0; --chu:#0f172a; --mo:#64748b; }
        body { font-family: Arial, sans-serif; max-width: 1200px; margin: 30px auto; padding: 0 16px; color: var(--chu); }
        table { width:100%; border-collapse:collapse; margin:10px 0 24px; }
        th,td { border:1px solid var(--vien); padding:8px; }
        th { background:var(--nen); text-align:left; }
        .error { padding:10px; background:#ffe5e5; margin:10px 0; border-radius:6px; }
        .filter { background:var(--nen); padding:12px; border:1px solid var(--vien); border-radius:8px; margin:15px 0; }
        .filter label { margin-right:14px; display:inline-block; margin-bottom:6px; }
        .tongket { width:auto; min-width:420px; }
        .tongket td:first-child { font-weight:bold; background:var(--nen); }
        .chart-box { max-width:760px; border:1px solid var(--vien); border-radius:8px; padding:12px; margin:12px 0 20px; }
        .chart-box h4 { margin:0 0 8px; font-size:14px; color:var(--mo); }
        .ghichu { color:var(--mo); font-size:13px; }
        a { margin-right:8px; }
        @media print { .filter, .nav { display:none; } }
    </style>
</head>
<body>
<a href="${pageContext.request.contextPath}/logout" class="nav">Đăng xuất</a>
<h1>Báo cáo</h1>
<div class="nav">
    <a href="${pageContext.request.contextPath}/">Trang chủ</a>
    <a href="${pageContext.request.contextPath}/thong-ke">Thống kê</a>
    <a href="${pageContext.request.contextPath}/hoa-don?action=list">Hóa đơn</a>
</div>

<form class="filter" method="get" action="${pageContext.request.contextPath}/bao-cao">
    <label>Loại báo cáo:
        <select name="loai">
            <option value="doanh-thu" ${loai == 'doanh-thu' ? 'selected' : ''}>Doanh thu</option>
            <option value="su-dung-phong" ${loai == 'su-dung-phong' ? 'selected' : ''}>Tình hình sử dụng phòng</option>
            <option value="dat-phong" ${loai == 'dat-phong' ? 'selected' : ''}>Đặt phòng</option>
            <option value="luu-tru" ${loai == 'luu-tru' ? 'selected' : ''}>Lưu trú</option>
        </select>
    </label>
    <label>Từ ngày: <input type="date" name="tuNgay" value="${tuNgay}" required></label>
    <label>Đến ngày: <input type="date" name="denNgay" value="${denNgay}" required></label>
    <label>Gom theo:
        <select name="kieu">
            <c:forEach var="k" items="${kieuThoiGians}">
                <option value="${k}" ${k == kieu ? 'selected' : ''}>${k.nhan}</option>
            </c:forEach>
        </select>
    </label>
    <label><input type="checkbox" name="nhap" value="1" ${nhap ? 'checked' : ''}> Tính cả hóa đơn nháp (dự kiến)</label>
    <button type="submit">Xem báo cáo</button>
    <c:if test="${not empty baoCao}">
        <a href="${pageContext.request.contextPath}/bao-cao?loai=${loai}&tuNgay=${tuNgay}&denNgay=${denNgay}&kieu=${kieu}${nhap ? '&nhap=1' : ''}&format=csv">Xuất CSV</a>
        <a href="#" onclick="window.print(); return false;">In</a>
    </c:if>
</form>

<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>

<c:if test="${not empty baoCao}">
    <h2>${baoCao.tieuDe}</h2>
    <p><em>${baoCao.kyBaoCao}</em></p>

    <c:if test="${baoCao.coBieuDo}">
        <div class="chart-box">
            <h4><c:out value="${baoCao.tieuDeBieuDo}"/></h4>
            <canvas id="bieuDo"></canvas>
        </div>
    </c:if>

    <table>
        <thead>
        <tr><c:forEach var="c" items="${baoCao.cot}"><th>${c}</th></c:forEach></tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${baoCao.dong}">
            <tr><c:forEach var="cell" items="${row}"><td><c:out value="${cell}"/></td></c:forEach></tr>
        </c:forEach>
        <c:if test="${empty baoCao.dong}">
            <tr><td colspan="${baoCao.cot.size()}">Không có dữ liệu trong kỳ báo cáo.</td></tr>
        </c:if>
        </tbody>
    </table>

    <h3>Tổng kết</h3>
    <table class="tongket">
        <c:forEach var="e" items="${baoCao.tongKet}">
            <tr><td>${e.key}</td><td><c:out value="${e.value}"/></td></tr>
        </c:forEach>
    </table>

    <c:if test="${baoCao.coBieuDo}">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
        <script>
        (function () {
            var hop = document.querySelector('.chart-box');
            if (typeof Chart === 'undefined') {
                hop.insertAdjacentHTML('beforeend', '<p class="ghichu">Không tải được thư viện biểu đồ (cần kết nối Internet).</p>');
                return;
            }
            var MAU = ['#2563eb', '#0d9488', '#d97706', '#e11d48', '#7c3aed', '#64748b'];
            var fmt = function (n) { return Number(n).toLocaleString('vi-VN'); };
            var nhan = ${baoCao.nhanJson};
            var chuoi = ${baoCao.chuoiJson};
            var loai = '${baoCao.loaiBieuDo}';
            var chong = ${baoCao.xepChong};
            var ngang = ${loai == 'luu-tru'};
            var cauHinh;
            if (loai === 'doughnut') {
                cauHinh = { type: 'doughnut',
                    data: { labels: nhan, datasets: [{ data: chuoi[0].gia, backgroundColor: MAU, borderWidth: 2 }] },
                    options: { plugins: { legend: { position: 'bottom' } } } };
            } else {
                cauHinh = { type: 'bar',
                    data: { labels: nhan, datasets: chuoi.map(function (c, i) {
                        return { label: c.ten, data: c.gia, backgroundColor: MAU[i % MAU.length], borderRadius: 4 };
                    }) },
                    options: { indexAxis: ngang ? 'y' : 'x',
                        scales: { x: { stacked: chong }, y: { stacked: chong, beginAtZero: true } },
                        plugins: { legend: { display: chuoi.length > 1, position: 'bottom' },
                            tooltip: { callbacks: { label: function (c) { return ' ' + c.dataset.label + ': ' + fmt(c.parsed[ngang ? 'x' : 'y']); } } } } } };
            }
            new Chart(document.getElementById('bieuDo'), cauHinh);
        })();
        </script>
    </c:if>
</c:if>
</body>
</html>
