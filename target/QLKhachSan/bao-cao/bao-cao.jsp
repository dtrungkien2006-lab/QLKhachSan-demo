<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Báo cáo | Horizon Hotel</title>
    <style>
        :root { --xanh:#2563eb; --nen:#f8fafc; --vien:#e2e8f0; --chu:#0f172a; --mo:#64748b; }
        table { width:100%; border-collapse:collapse; margin:10px 0 24px; background: #fff; }
        th,td { border:1px solid var(--vien); padding:10px 12px; }
        th { background:var(--nen); text-align:left; font-weight:600; }
        .error { padding:12px; background:#ffe5e5; color:#c53030; margin:10px 0; border-radius:6px; }
        .filter { background:#fff; padding:16px; border:1px solid var(--vien); border-radius:8px; margin:15px 0; display:flex; flex-wrap:wrap; gap:12px; align-items:center; }
        .filter label { display:inline-flex; align-items:center; gap:6px; font-size:14px; }
        .tongket { width:auto; min-width:380px; }
        .tongket td:first-child { font-weight:bold; background:var(--nen); }
        .chart-box { max-width:100%; border:1px solid var(--vien); border-radius:8px; padding:16px; margin:12px 0 20px; background:#fff; }
        .chart-box h4 { margin:0 0 12px; font-size:14px; color:var(--mo); }
        .ghichu { color:var(--mo); font-size:13px; }
        @media print { .filter, .sidebar, .topbar { display:none !important; } }
    </style>
</head>
<body>

<div class="page-heading">
    <div>
        <div class="eyebrow">Hệ thống báo cáo</div>
        <h1>Xuất báo cáo chi tiết 📋</h1>
        <p class="subtitle">Tổng hợp dữ liệu kinh doanh, tình hình sử dụng phòng và lượt lưu trú.</p>
    </div>
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
    <label><input type="checkbox" name="nhap" value="1" ${nhap ? 'checked' : ''}> Tính cả hóa đơn nháp</label>
    <button type="submit" class="btn btn-primary">Xem báo cáo</button>
    <c:if test="${not empty baoCao}">
        <a href="${pageContext.request.contextPath}/bao-cao?loai=${loai}&tuNgay=${tuNgay}&denNgay=${denNgay}&kieu=${kieu}${nhap ? '&nhap=1' : ''}&format=csv" class="btn">Xuất CSV</a>
        <button type="button" class="btn" onclick="window.print();">In báo cáo</button>
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
            <tr>
                <c:forEach var="cell" items="${row}">
                    <td>
                        <c:choose>
                            <c:when test="${cell ne null and (cell.getClass().name.contains('Double') or cell.getClass().name.contains('Long') or cell.getClass().name.contains('Integer') or cell.getClass().name.contains('BigDecimal'))}">
                                <fmt:formatNumber value="${cell}" type="number" pattern="#,##0" />
                            </c:when>
                            <c:otherwise>
                                <c:out value="${cell}"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </c:forEach>
            </tr>
        </c:forEach>
        <c:if test="${empty baoCao.dong}">
            <tr><td colspan="${baoCao.cot.size()}">Không có dữ liệu trong kỳ báo cáo.</td></tr>
        </c:if>
        </tbody>
    </table>

    <h3>Tổng kết</h3>
    <table class="tongket">
        <c:forEach var="e" items="${baoCao.tongKet}">
            <tr>
                <td>${e.key}</td>
                <td>
                    <c:choose>
                        <c:when test="${e.value ne null and (e.value.getClass().name.contains('Double') or e.value.getClass().name.contains('Long') or e.value.getClass().name.contains('Integer') or e.value.getClass().name.contains('BigDecimal'))}">
                            <fmt:formatNumber value="${e.value}" type="number" pattern="#,##0" /> đ
                        </c:when>
                        <c:otherwise>
                            <c:out value="${e.value}"/>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </table>

    <c:if test="${baoCao.coBieuDo}">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
        <script>
        (function () {
            var hop = document.querySelector('.chart-box');
            if (typeof Chart === 'undefined') return;
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

<!-- Thêm script chung để tự động bao bọc giao diện Layout -->
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>
</body>
</html>