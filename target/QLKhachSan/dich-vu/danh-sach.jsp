<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý dịch vụ | Horizon Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
    <style>
        .service-page{max-width:1500px;margin:0 auto;padding:30px 34px 42px}
        .service-heading{display:flex;align-items:flex-start;justify-content:space-between;gap:20px;margin-bottom:25px}
        .service-kicker{display:inline-flex;align-items:center;gap:8px;color:#2563eb;font-size:11px;font-weight:800;letter-spacing:1.3px;text-transform:uppercase}
        .service-kicker:before{content:"";width:22px;height:2px;background:#2563eb;border-radius:2px}
        .service-heading h1{font-size:28px;letter-spacing:-.7px;margin:8px 0 7px}
        .service-heading p{margin:0;color:#718096;font-size:13px}
        .service-heading-actions{display:flex;gap:10px;flex-wrap:wrap}
        .service-btn{min-height:42px}
        .service-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:23px}
        .service-stat{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:19px 20px;background:#fff;border:1px solid #e5eaf1;border-radius:14px;box-shadow:0 5px 18px rgba(18,36,58,.035)}
        .service-stat-label{font-size:12px;color:#718096;font-weight:600}
        .service-stat-value{font-size:27px;font-weight:800;line-height:1.2;letter-spacing:-.6px;margin-top:8px;color:#172033}
        .service-stat-note{font-size:11px;color:#94a3b8;margin-top:5px}
        .service-stat-icon{width:45px;height:45px;border-radius:13px;display:grid;place-items:center;font-size:21px;flex-shrink:0;background:#eaf0ff;color:#315dd7}
        .service-stat:nth-child(2) .service-stat-icon{background:#e5f8ef;color:#0f9f6e}
        .service-stat:nth-child(3) .service-stat-icon{background:#fff2df;color:#d97706}
        .service-stat:nth-child(4) .service-stat-icon{background:#f2eaff;color:#805ad5}
        .service-panel{background:#fff;border:1px solid #e5eaf1;border-radius:15px;box-shadow:0 8px 24px rgba(18,36,58,.04);overflow:hidden}
        .service-panel-head{display:flex;justify-content:space-between;align-items:center;gap:15px;padding:20px 22px;border-bottom:1px solid #edf0f5}
        .service-panel-title{font-size:16px;font-weight:800;color:#172033}
        .service-panel-subtitle{font-size:12px;color:#8a97a8;margin-top:4px}
        .service-count{font-size:12px;font-weight:750;color:#315dd7;background:#edf2ff;border-radius:20px;padding:7px 11px;white-space:nowrap}
        .service-toolbar{display:flex;align-items:center;justify-content:space-between;gap:14px;padding:17px 22px;border-bottom:1px solid #edf0f5;background:#fcfdff}
        .service-search{position:relative;flex:1;max-width:470px}
        .service-search span{position:absolute;left:13px;top:10px;font-size:17px;color:#94a3b8}
        .service-search input{width:100%;height:41px;border:1px solid #dce4ee;border-radius:9px;padding:0 13px 0 39px;outline:none;background:#fff;color:#172033}
        .service-search input:focus{border-color:#7da2ff;box-shadow:0 0 0 3px #2563eb14}
        .service-filters{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
        .service-filter{height:38px;border:1px solid #dce4ee;background:#fff;border-radius:8px;padding:0 11px;color:#475569;font-size:12px;outline:none}
        .service-table-wrap{overflow-x:auto}
        .service-table{width:100%;border-collapse:collapse;min-width:850px}
        .service-table thead th{background:#f8fafc;color:#718096;font-size:10px;letter-spacing:.65px;font-weight:800;text-transform:uppercase;text-align:left;padding:14px 18px;border-bottom:1px solid #e9eef5;white-space:nowrap}
        .service-table tbody td{padding:15px 18px;border-bottom:1px solid #edf1f6;font-size:13px;color:#475569;vertical-align:middle}
        .service-table tbody tr:last-child td{border-bottom:0}
        .service-table tbody tr:hover{background:#f9fbff}
        .service-code{font-size:12px;font-weight:800;color:#315dd7;background:#edf2ff;padding:6px 9px;border-radius:7px;display:inline-block}
        .service-name{font-weight:750;color:#1e293b;font-size:13px}
        .service-description{font-size:11px;color:#94a3b8;margin-top:4px;max-width:260px;white-space:normal;line-height:1.45}
        .service-type{display:inline-block;background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;border-radius:6px;padding:5px 8px;font-size:11px;font-weight:650}
        .service-price{font-weight:800;color:#172033;white-space:nowrap}
        .service-status{display:inline-flex;align-items:center;gap:7px;border-radius:20px;padding:6px 10px;font-size:11px;font-weight:750;white-space:nowrap}
        .service-status:before{content:"";width:6px;height:6px;border-radius:50%;background:currentColor}
        .service-status.is-active{color:#07845b;background:#e8f8f0}
        .service-status.is-inactive{color:#b45309;background:#fff4df}
        .service-actions{display:flex;align-items:center;gap:6px;white-space:nowrap}
        .service-action{display:inline-flex;align-items:center;justify-content:center;min-height:31px;padding:6px 9px;border:1px solid #e1e7ef;border-radius:7px;background:#fff;color:#475569;font-size:11px;font-weight:700;transition:.15s}
        .service-action:hover{background:#f3f7fc;border-color:#c7d5e7}
        .service-action.edit{color:#2457c5;background:#f4f7ff;border-color:#dbe5ff}
        .service-action.toggle-stop{color:#b45309;background:#fffaf0;border-color:#f7e5bf}
        .service-action.toggle-start{color:#07845b;background:#f0fdf7;border-color:#ccefe0}
        .service-empty{padding:50px 20px!important;text-align:center;color:#718096!important}
        .service-empty-icon{font-size:30px;margin-bottom:9px;color:#94a3b8}
        .service-footer{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 22px;border-top:1px solid #edf0f5;color:#8a97a8;font-size:11px}
        .service-alert{padding:13px 16px;border-radius:10px;margin-bottom:17px;font-size:13px}
        .service-alert.success{background:#ecfdf3;border:1px solid #bbf7d0;color:#166534}
        .service-alert.error{background:#fff1f2;border:1px solid #fecdd3;color:#be123c}
        .service-hidden{display:none!important}
        @media(max-width:1050px){.service-page{padding:24px}.service-stats{grid-template-columns:repeat(2,minmax(0,1fr))}.service-toolbar{align-items:stretch;flex-direction:column}.service-search{max-width:none}}
        @media(max-width:650px){.service-page{padding:20px 14px}.service-heading{display:block}.service-heading-actions{margin-top:16px}.service-heading h1{font-size:24px}.service-stats{gap:10px}.service-stat{padding:14px}.service-stat-value{font-size:23px}.service-stat-icon{width:38px;height:38px}.service-panel-head,.service-toolbar{padding:15px}.service-footer{align-items:flex-start;flex-direction:column;padding:14px 15px}}
    </style>
</head>
<body>
<main class="service-page">
    <c:if test="${param.success == 'saved'}"><div class="service-alert success">✓ Đã lưu thông tin dịch vụ thành công.</div></c:if>
    <c:if test="${param.success == 'status'}"><div class="service-alert success">✓ Đã cập nhật trạng thái kinh doanh của dịch vụ.</div></c:if>
    <c:if test="${param.success == 'deleted'}"><div class="service-alert success">✓ Đã xóa dịch vụ thành công.</div></c:if>
    <c:if test="${not empty error}"><div class="service-alert error">⚠ <c:out value="${error}"/></div></c:if>

    <section class="service-heading">
        <div>
            <div class="service-kicker">Vận hành khách sạn / Dịch vụ</div>
            <h1>Quản lý dịch vụ</h1>
            <p>Quản lý danh mục dịch vụ, giá bán và trạng thái kinh doanh của khách sạn.</p>
        </div>
        <div class="service-heading-actions">
            <a class="btn service-btn" href="${pageContext.request.contextPath}/">← Dashboard</a>
            <a class="btn btn-primary service-btn" href="${pageContext.request.contextPath}/dich-vu?action=new">＋ Thêm dịch vụ</a>
        </div>
    </section>

    <section class="service-stats" aria-label="Tổng quan dịch vụ">
        <div class="service-stat"><div><div class="service-stat-label">Tổng dịch vụ</div><div class="service-stat-value" id="totalServices">0</div><div class="service-stat-note">Danh mục hiện có</div></div><div class="service-stat-icon">▤</div></div>
        <div class="service-stat"><div><div class="service-stat-label">Đang kinh doanh</div><div class="service-stat-value" id="activeServices">0</div><div class="service-stat-note">Sẵn sàng phục vụ khách</div></div><div class="service-stat-icon">✓</div></div>
        <div class="service-stat"><div><div class="service-stat-label">Ngừng kinh doanh</div><div class="service-stat-value" id="inactiveServices">0</div><div class="service-stat-note">Tạm ngưng cung cấp</div></div><div class="service-stat-icon">Ⅱ</div></div>
        <div class="service-stat"><div><div class="service-stat-label">Nhóm dịch vụ</div><div class="service-stat-value" id="categoryServices">0</div><div class="service-stat-note">Phân loại theo danh mục</div></div><div class="service-stat-icon">◇</div></div>
    </section>

    <section class="service-panel">
        <div class="service-panel-head">
            <div><div class="service-panel-title">Danh mục dịch vụ</div><div class="service-panel-subtitle">Tra cứu và thao tác trên từng dịch vụ</div></div>
            <span class="service-count"><span id="visibleServices">0</span> dịch vụ</span>
        </div>
        <div class="service-toolbar">
            <label class="service-search"><span>⌕</span><input id="serviceSearch" type="search" placeholder="Tìm theo mã, tên hoặc mô tả dịch vụ..." autocomplete="off"></label>
            <div class="service-filters">
                <select id="statusFilter" class="service-filter" aria-label="Lọc trạng thái">
                    <option value="all">Tất cả trạng thái</option><option value="active">Đang kinh doanh</option><option value="inactive">Ngừng kinh doanh</option>
                </select>
                <select id="typeFilter" class="service-filter" aria-label="Lọc loại dịch vụ"><option value="all">Tất cả loại dịch vụ</option></select>
            </div>
        </div>

        <div class="service-table-wrap">
            <table class="service-table">
                <thead><tr><th>Mã dịch vụ</th><th>Thông tin dịch vụ</th><th>Phân loại</th><th>Đơn giá</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                <tbody id="serviceTableBody">
                <c:forEach var="x" items="${items}">
                    <tr class="service-row" data-code="${x.maDichVu}" data-name="${x.tenDichVu}" data-description="${x.moTa}" data-type="${x.loaiDichVu}" data-status="${x.dangKinhDoanh ? 'active' : 'inactive'}">
                        <td><span class="service-code"><c:out value="${x.maDichVu}"/></span></td>
                        <td><div class="service-name"><c:out value="${x.tenDichVu}"/></div><c:if test="${not empty x.moTa}"><div class="service-description"><c:out value="${x.moTa}"/></div></c:if></td>
                        <td><span class="service-type"><c:choose><c:when test="${not empty x.loaiDichVu}"><c:out value="${x.loaiDichVu}"/></c:when><c:otherwise>Chưa phân loại</c:otherwise></c:choose></span></td>
                        <td><span class="service-price" data-price="${x.donGia}"><c:out value="${x.donGia}"/> ₫</span></td>
                        <td><c:choose><c:when test="${x.dangKinhDoanh}"><span class="service-status is-active">Đang kinh doanh</span></c:when><c:otherwise><span class="service-status is-inactive">Ngừng kinh doanh</span></c:otherwise></c:choose></td>
                        <td><div class="service-actions">
                            <a class="service-action edit" href="${pageContext.request.contextPath}/dich-vu?action=edit&amp;id=${x.maDichVu}">Sửa</a>
                            <a class="service-action" href="${pageContext.request.contextPath}/dich-vu?action=detail&amp;id=${x.maDichVu}">Chi tiết</a>
                            <c:choose><c:when test="${x.dangKinhDoanh}"><a class="service-action toggle-stop" href="${pageContext.request.contextPath}/dich-vu?action=stop&amp;id=${x.maDichVu}" onclick="return confirm('Bạn có chắc muốn ngừng kinh doanh dịch vụ này?')">Ngừng bán</a></c:when><c:otherwise><a class="service-action toggle-start" href="${pageContext.request.contextPath}/dich-vu?action=start&amp;id=${x.maDichVu}">Mở bán</a></c:otherwise></c:choose>
                        </div></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty items}"><tr id="noDataRow"><td colspan="6" class="service-empty"><div class="service-empty-icon">▤</div><strong>Chưa có dịch vụ nào</strong><div style="margin-top:5px">Hãy thêm dịch vụ đầu tiên để quản lý danh mục của khách sạn.</div></td></tr></c:if>
                <tr id="noSearchRow" class="service-hidden"><td colspan="6" class="service-empty"><div class="service-empty-icon">⌕</div><strong>Không tìm thấy dịch vụ phù hợp</strong><div style="margin-top:5px">Thử thay đổi từ khóa hoặc điều kiện lọc.</div></td></tr>
                </tbody>
            </table>
        </div>
        <div class="service-footer"><span>Hiển thị <strong id="footerVisible">0</strong> trên <strong id="footerTotal">0</strong> dịch vụ</span><span>Dữ liệu được tải từ hệ thống quản lý khách sạn</span></div>
    </section>
</main>
<script>
(function(){
    const rows = Array.from(document.querySelectorAll('.service-row'));
    const search = document.getElementById('serviceSearch');
    const status = document.getElementById('statusFilter');
    const type = document.getElementById('typeFilter');
    const noSearch = document.getElementById('noSearchRow');
    const types = [...new Set(rows.map(r => (r.dataset.type || '').trim()).filter(Boolean))].sort((a,b)=>a.localeCompare(b,'vi'));
    types.forEach(t => { const o=document.createElement('option');o.value=t;o.textContent=t;type.appendChild(o); });
    const active = rows.filter(r=>r.dataset.status==='active').length;
    const inactive = rows.length-active;
    document.getElementById('totalServices').textContent=rows.length;
    document.getElementById('activeServices').textContent=active;
    document.getElementById('inactiveServices').textContent=inactive;
    document.getElementById('categoryServices').textContent=types.length;
    document.getElementById('footerTotal').textContent=rows.length;
    function filterRows(){
        const q=search.value.trim().toLocaleLowerCase('vi');
        const s=status.value, t=type.value;
        let visible=0;
        rows.forEach(r=>{
            const text=[r.dataset.code,r.dataset.name,r.dataset.description,r.dataset.type].join(' ').toLocaleLowerCase('vi');
            const show=text.includes(q)&&(s==='all'||r.dataset.status===s)&&(t==='all'||r.dataset.type===t);
            r.classList.toggle('service-hidden',!show);if(show)visible++;
        });
        noSearch.classList.toggle('service-hidden',visible!==0||rows.length===0);
        document.getElementById('visibleServices').textContent=visible;
        document.getElementById('footerVisible').textContent=visible;
    }
    [search,status,type].forEach(el=>el.addEventListener(el===search?'input':'change',filterRows));
    filterRows();
    document.querySelectorAll('.service-price').forEach(el=>{const n=Number(el.dataset.price);if(Number.isFinite(n))el.textContent=new Intl.NumberFormat('vi-VN',{style:'currency',currency:'VND',maximumFractionDigits:0}).format(n);});
})();
</script>
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>
</body>
</html>
