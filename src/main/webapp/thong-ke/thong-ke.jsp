<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thống kê | Horizon Hotel</title>
    <style>
        :root { --xanh:#2563eb; --nen:#f8fafc; --vien:#e2e8f0; --chu:#0f172a; --mo:#64748b; }
        .page-title { margin-bottom: 20px; }
        h2 { margin-top: 28px; border-left: 4px solid var(--xanh); padding-left: 10px; font-size: 1.25rem; }
        table { width:100%; border-collapse:collapse; margin:10px 0 24px; background: #fff; }
        th,td { border:1px solid var(--vien); padding:10px 12px; }
        th { background:var(--nen); text-align:left; font-weight: 600; }
        td.num { text-align:right; }
        .error { padding:12px; background:#ffe5e5; color: #c53030; margin:10px 0; border-radius:6px; }
        .filter { background:#fff; padding:16px; border:1px solid var(--vien); border-radius:8px; margin:15px 0; display:flex; flex-wrap:wrap; gap:12px; align-items:center; }
        .filter label { display:inline-flex; align-items:center; gap:6px; font-size:14px; }
        .cards { display:flex; gap:12px; flex-wrap:wrap; margin:12px 0 20px; }
        .card { flex:1; min-width:160px; border:1px solid var(--vien); padding:14px; border-radius:8px; background:#fff; }
        .card .v { font-size:22px; font-weight:bold; margin-top:4px; color:var(--xanh); }
        .card small { color:var(--mo); }
        .charts { display:flex; gap:20px; flex-wrap:wrap; margin-bottom:10px; }
        .chart-box { flex:1; min-width:300px; border:1px solid var(--vien); border-radius:8px; padding:16px; background:#fff; }
        .chart-box h4 { margin:0 0 12px; font-size:14px; color:var(--mo); }
        .chart-box canvas { max-height:280px; }
        .ghichu { color:var(--mo); font-size:13px; }
    </style>
</head>
<body>

<div class="page-heading">
    <div>
        <div class="eyebrow">Hệ thống báo cáo</div>
        <h1>Thống kê tổng quan 👋</h1>
        <p class="subtitle">Theo dõi các chỉ số hoạt động, doanh thu và công suất phòng.</p>
    </div>
</div>

<form class="filter" method="get" action="${pageContext.request.contextPath}/thong-ke">
    <label>Nhóm:
        <select name="loai">
            <option value="tong-quan" ${loai == 'tong-quan' ? 'selected' : ''}>Tổng quan</option>
            <option value="phong" ${loai == 'phong' ? 'selected' : ''}>Phòng</option>
            <option value="dat-phong" ${loai == 'dat-phong' ? 'selected' : ''}>Đặt phòng</option>
            <option value="khach-hang" ${loai == 'khach-hang' ? 'selected' : ''}>Khách hàng</option>
            <option value="doanh-thu" ${loai == 'doanh-thu' ? 'selected' : ''}>Doanh thu</option>
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
    <button type="submit" class="btn btn-primary">Xem thống kê</button>
</form>

<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>

<%-- ===================== PHÒNG ===================== --%>
<c:if test="${not empty phong}">
    <h2>Thống kê phòng</h2>
    <div class="cards">
        <div class="card">Tổng số phòng<div class="v">${phong.tongPhong}</div></div>
        <div class="card cp" data-label="Trống" data-v="${phong.phongTrong}">Trống<div class="v">${phong.phongTrong}</div></div>
        <div class="card cp" data-label="Đã đặt" data-v="${phong.phongDaDat}">Đã đặt<div class="v">${phong.phongDaDat}</div></div>
        <div class="card cp" data-label="Đang ở" data-v="${phong.phongDangO}">Đang ở<div class="v">${phong.phongDangO}</div></div>
        <div class="card">Tỷ lệ đang ở<div class="v">${phong.tyLeDangO}%</div></div>
        <div class="card">Công suất trong kỳ<div class="v">${phong.tyLeSuDungTrongKy}%</div>
            <small>${phong.soDemPhongDaBan} đêm phòng / ${phong.soNgayTrongKy} ngày</small></div>
    </div>
    <div class="charts">
        <div class="chart-box"><h4>Tình trạng phòng hiện tại</h4><canvas id="bdPhong"></canvas></div>
        <div class="chart-box"><h4>Công suất sử dụng trong kỳ (%)</h4><canvas id="bdCongSuat"></canvas></div>
    </div>
</c:if>

<%-- ===================== ĐẶT PHÒNG ===================== --%>
<c:if test="${not empty datPhong}">
    <h2>Thống kê đặt phòng</h2>
    <div class="cards">
        <div class="card">Tổng đặt phòng<div class="v">${datPhong.tong}</div></div>
        <div class="card ctt" data-label="Chờ xác nhận" data-v="${datPhong.choXacNhan}">Chờ xác nhận<div class="v">${datPhong.choXacNhan}</div></div>
        <div class="card ctt" data-label="Đã xác nhận" data-v="${datPhong.daXacNhan}">Đã xác nhận<div class="v">${datPhong.daXacNhan}</div></div>
        <div class="card ctt" data-label="Đang ở" data-v="${datPhong.dangO}">Đang ở<div class="v">${datPhong.dangO}</div></div>
        <div class="card ctt" data-label="Đã trả phòng" data-v="${datPhong.daTraPhong}">Đã trả phòng<div class="v">${datPhong.daTraPhong}</div></div>
        <div class="card ctt" data-label="Đã hủy" data-v="${datPhong.daHuy}">Đã hủy<div class="v">${datPhong.daHuy}</div><small>Tỷ lệ hủy ${datPhong.tyLeHuy}%</small></div>
    </div>
    <div class="charts">
        <div class="chart-box"><h4>Đặt phòng theo thời gian</h4><canvas id="bdDatPhongTg"></canvas></div>
        <div class="chart-box"><h4>Cơ cấu theo trạng thái</h4><canvas id="bdDatPhongTt"></canvas></div>
    </div>
    <table>
        <thead><tr><th>Thời gian</th><th>Số đặt phòng</th><th>Số hủy</th></tr></thead>
        <tbody>
        <c:forEach var="e" items="${datPhong.theoThoiGian}">
            <c:set var="soHuy" value="${empty datPhong.huyTheoThoiGian[e.key] ? 0 : datPhong.huyTheoThoiGian[e.key]}"/>
            <tr class="dp" data-label="${e.key}" data-tong="${e.value}" data-huy="${soHuy}">
                <td>${e.key}</td>
                <td class="num">${e.value}</td>
                <td class="num">${soHuy}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty datPhong.theoThoiGian}"><tr><td colspan="3">Không có dữ liệu trong kỳ.</td></tr></c:if>
        </tbody>
    </table>
</c:if>

<%-- ===================== DOANH THU ===================== --%>
<c:if test="${not empty doanhThu}">
    <h2>Thống kê doanh thu <small class="ghichu">(${nhap ? 'bao gồm nháp' : 'đã phát hành'})</small></h2>
    <div class="cards">
        <div class="card">Tổng doanh thu<div class="v"><fmt:formatNumber value="${doanhThu.tongDoanhThu}" pattern="#,##0"/> đ</div></div>
        <div class="card">Tiền phòng<div class="v"><fmt:formatNumber value="${doanhThu.tongTienPhong}" pattern="#,##0"/> đ</div></div>
        <div class="card">Tiền dịch vụ<div class="v"><fmt:formatNumber value="${doanhThu.tongTienDichVu}" pattern="#,##0"/> đ</div></div>
        <div class="card">Số hóa đơn<div class="v">${doanhThu.tongSoHoaDon}</div></div>
        <div class="card">Thực thu<div class="v"><fmt:formatNumber value="${doanhThu.tongThucThu}" pattern="#,##0"/> đ</div></div>
    </div>
    <div class="charts">
        <div class="chart-box"><h4>Doanh thu theo thời gian (đồng)</h4><canvas id="bdDoanhThu"></canvas></div>
        <div class="chart-box"><h4>Nguồn thu: phòng và dịch vụ</h4><canvas id="bdNguonThu"></canvas></div>
        <div class="chart-box">
            <h4>Thực thu theo phương thức</h4>
            <canvas id="bdPhuongThuc"></canvas>
            <p id="bdPhuongThucEmpty" class="ghichu" hidden>Không có giao dịch thanh toán thành công trong kỳ đã chọn.</p>
        </div>
    </div>
    <%-- Chuyển dữ liệu thực thu theo phương thức từ DTO sang DOM để Chart.js đọc. --%>
    <div class="du-lieu-phuong-thuc" hidden aria-hidden="true">
        <c:forEach var="pt" items="${doanhThu.thucThuTheoPhuongThuc}">
            <c:choose>
                <c:when test="${pt.key == 'TIEN_MAT'}"><span class="pt" data-label="Tiền mặt" data-v="${pt.value}"></span></c:when>
                <c:when test="${pt.key == 'VNPAY'}"><span class="pt" data-label="VNPay" data-v="${pt.value}"></span></c:when>
                <c:when test="${pt.key == 'MOMO'}"><span class="pt" data-label="MoMo" data-v="${pt.value}"></span></c:when>
                <c:otherwise><span class="pt" data-label="${pt.key}" data-v="${pt.value}"></span></c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
    <table>
        <thead>
        <tr><th>Thời gian</th><th>Số hóa đơn</th><th>Tiền phòng</th><th>Tiền dịch vụ</th><th>Tổng</th></tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${doanhThu.theoThoiGian}">
            <tr class="dt" data-label="${r.thoiGian}" data-phong="${r.tienPhong}" data-dv="${r.tienDichVu}">
                <td>${r.thoiGian}</td>
                <td class="num">${r.soHoaDon}</td>
                <td class="num"><fmt:formatNumber value="${r.tienPhong}" pattern="#,##0"/></td>
                <td class="num"><fmt:formatNumber value="${r.tienDichVu}" pattern="#,##0"/></td>
                <td class="num"><strong><fmt:formatNumber value="${r.tongTien}" pattern="#,##0"/></strong></td>
            </tr>
        </c:forEach>
        <c:if test="${empty doanhThu.theoThoiGian}"><tr><td colspan="5">Không có hóa đơn trong kỳ.</td></tr></c:if>
        </tbody>
    </table>
</c:if>

<%-- ===================== KHÁCH HÀNG ===================== --%>
<c:if test="${loai == 'khach-hang' or loai == 'tong-quan'}">
    <h2>Thống kê khách hàng và lịch sử lưu trú</h2>
    <p class="ghichu">Số khách có lưu trú trong kỳ: <strong>${khachHangs.size()}</strong></p>
    <div class="charts">
        <div class="chart-box"><h4>Số đêm lưu trú theo khách</h4><canvas id="bdKhach"></canvas></div>
        <div class="chart-box"><h4>Tổng chi tiêu theo khách (đồng)</h4><canvas id="bdChiTieu"></canvas></div>
    </div>
    <table>
        <thead>
        <tr><th>Mã KH</th><th>Họ tên</th><th>SĐT</th><th>Số lần đặt</th><th>Số đêm</th><th>Lần ở gần nhất</th><th>Tổng chi tiêu</th></tr>
        </thead>
        <tbody>
        <c:forEach var="k" items="${khachHangs}">
            <tr class="kh" data-ten="<c:out value='${k.hoTen}'/>" data-dem="${k.soDemLuuTru}" data-chi="${k.tongChiTieu}">
                <td>${k.maKH}</td>
                <td><c:out value="${k.hoTen}"/></td>
                <td>${k.soDienThoai}</td>
                <td class="num">${k.soLanDatPhong}</td>
                <td class="num">${k.soDemLuuTru}</td>
                <td>${k.lanLuuTruGanNhat}</td>
                <td class="num"><fmt:formatNumber value="${k.tongChiTieu}" pattern="#,##0"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty khachHangs}"><tr><td colspan="7">Không có khách lưu trú trong kỳ.</td></tr></c:if>
        </tbody>
    </table>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
(function () {
    if (typeof Chart === 'undefined') return;
    var MAU = ['#2563eb', '#0d9488', '#d97706', '#e11d48', '#7c3aed', '#64748b'];
    var fmt = function (n) { return Number(n).toLocaleString('vi-VN'); };

    function doc(sel, fn) { return Array.prototype.map.call(document.querySelectorAll(sel), fn); }
    function co(id) { return document.getElementById(id); }

    function banh(id, nhan, giaTri) {
        if (!co(id) || giaTri.every(function (v) { return v === 0; })) return;
        new Chart(co(id), { type: 'doughnut',
            data: { labels: nhan, datasets: [{ data: giaTri, backgroundColor: MAU, borderWidth: 2 }] },
            options: { plugins: { legend: { position: 'bottom' } } } });
    }
    function cot(id, nhan, chuoi, opt) {
        opt = opt || {};
        if (!co(id) || nhan.length === 0) return;
        new Chart(co(id), { type: 'bar',
            data: { labels: nhan, datasets: chuoi.map(function (c, i) {
                return { label: c.ten, data: c.gia, backgroundColor: MAU[i % MAU.length], borderRadius: 4 };
            }) },
            options: { indexAxis: opt.ngang ? 'y' : 'x',
                scales: { x: { stacked: !!opt.chong }, y: { stacked: !!opt.chong, beginAtZero: true,
                    ticks: { callback: function (v) { return opt.ngang ? v : fmt(v); } } } },
                plugins: { legend: { display: chuoi.length > 1, position: 'bottom' },
                    tooltip: { callbacks: { label: function (c) { return ' ' + c.dataset.label + ': ' + fmt(c.parsed[opt.ngang ? 'x' : 'y']); } } } } } });
    }

    banh('bdPhong', doc('.cp', function (e) { return e.dataset.label; }), doc('.cp', function (e) { return +e.dataset.v; }));
    var cs = ${empty phong ? 0 : phong.tyLeSuDungTrongKy};
    if (co('bdCongSuat')) banh('bdCongSuat', ['Đã sử dụng', 'Còn trống'], [cs, Math.max(0, 100 - cs)]);

    cot('bdDatPhongTg', doc('.dp', function (e) { return e.dataset.label; }), [
        { ten: 'Số đặt phòng', gia: doc('.dp', function (e) { return +e.dataset.tong; }) },
        { ten: 'Số hủy', gia: doc('.dp', function (e) { return +e.dataset.huy; }) }]);
    banh('bdDatPhongTt', doc('.ctt', function (e) { return e.dataset.label; }), doc('.ctt', function (e) { return +e.dataset.v; }));

    cot('bdDoanhThu', doc('.dt', function (e) { return e.dataset.label; }), [
        { ten: 'Tiền phòng', gia: doc('.dt', function (e) { return +e.dataset.phong; }) },
        { ten: 'Tiền dịch vụ', gia: doc('.dt', function (e) { return +e.dataset.dv; }) }], { chong: true });
    var tp = ${empty doanhThu ? 0 : doanhThu.tongTienPhong}, tdv = ${empty doanhThu ? 0 : doanhThu.tongTienDichVu};
    if (co('bdNguonThu')) banh('bdNguonThu', ['Tiền phòng', 'Tiền dịch vụ'], [tp, tdv]);

    // Lấy dữ liệu .pt do JSP tạo từ doanhThu.thucThuTheoPhuongThuc.
    // Nếu kỳ đã chọn chưa có giao dịch thành công thì hiển thị thông báo rõ ràng.
    var ptNhan = doc('.pt', function (e) { return e.dataset.label; });
    var ptGiaTri = doc('.pt', function (e) { return Number(e.dataset.v) || 0; });
    var ptCanvas = co('bdPhuongThuc');
    var ptEmpty = co('bdPhuongThucEmpty');
    if (ptCanvas) {
        if (ptNhan.length === 0 || ptGiaTri.every(function (v) { return v <= 0; })) {
            ptCanvas.style.display = 'none';
            if (ptEmpty) ptEmpty.hidden = false;
        } else {
            ptCanvas.style.display = '';
            if (ptEmpty) ptEmpty.hidden = true;
            banh('bdPhuongThuc', ptNhan, ptGiaTri);
        }
    }

    cot('bdKhach', doc('.kh', function (e) { return e.dataset.ten; }),
        [{ ten: 'Số đêm lưu trú', gia: doc('.kh', function (e) { return +e.dataset.dem; }) }], { ngang: true });
    cot('bdChiTieu', doc('.kh', function (e) { return e.dataset.ten; }),
        [{ ten: 'Tổng chi tiêu', gia: doc('.kh', function (e) { return +e.dataset.chi; }) }], { ngang: true });
})();
</script>

<!-- Thêm script chung để tự động bao bọc giao diện Layout -->
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>
</body>
</html>