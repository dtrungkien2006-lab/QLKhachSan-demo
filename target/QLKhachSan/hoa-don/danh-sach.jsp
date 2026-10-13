<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hóa đơn | Horizon Hotel</title>

    <style>
        :root {
            --blue: #2563eb;
            --bg: #f3f6fb;
            --white: #fff;
            --text: #172b4d;
            --muted: #718096;
            --border: #e3eaf3;
            --green: #15803d;
            --amber: #b45309;
            --red: #b91c1c;
            --shadow: 0 4px 18px rgba(16,36,58,.045);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: var(--bg);
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            font-size: 14px;
        }

        a { text-decoration: none; color: inherit; }
        button, input, select { font: inherit; }

        .invoice-content {
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px 32px 44px;
        }

        .heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 24px;
        }

        .eyebrow {
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1.25px;
            color: var(--blue);
            margin-bottom: 8px;
        }

        .heading h1 {
            font-size: 27px;
            letter-spacing: -.5px;
            margin: 0;
        }

        .subtitle {
            margin-top: 8px;
            color: var(--muted);
            font-size: 13px;
        }

        .heading-actions {
            display: flex;
            gap: 9px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text);
            cursor: pointer;
            white-space: nowrap;
        }

        .btn:hover { background: #f8fafc; }

        .alert {
            padding: 12px 15px;
            border-radius: 9px;
            margin-bottom: 16px;
        }

        .success {
            background: #ecfdf3;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .error {
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 18px 19px;
            box-shadow: var(--shadow);
            min-width: 0;
        }

        .stat-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
            color: var(--muted);
            font-size: 12px;
        }

        .stat-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: grid;
            place-items: center;
            font-size: 17px;
            flex-shrink: 0;
        }

        .ib { background: #eaf2ff; color: #2563eb; }
        .ig { background: #eaf9ef; color: #15803d; }
        .ia { background: #fff5e7; color: #b45309; }
        .ir { background: #fff0f0; color: #b91c1c; }

        .stat-value {
            font-size: 25px;
            font-weight: 800;
            margin-top: 10px;
            letter-spacing: -.4px;
        }

        .stat-note {
            font-size: 11px;
            color: #8a97a8;
            margin-top: 5px;
        }

        .panel {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 19px 21px;
            border-bottom: 1px solid var(--border);
        }

        .panel-title {
            font-size: 15px;
            font-weight: 750;
        }

        .panel-sub {
            font-size: 12px;
            color: var(--muted);
            margin-top: 5px;
        }

        .count {
            background: #eff6ff;
            color: #1d4ed8;
            border-radius: 20px;
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .toolbar {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
            padding: 16px 21px;
            border-bottom: 1px solid var(--border);
        }

        .search {
            position: relative;
            flex: 1;
            min-width: 210px;
            max-width: 390px;
        }

        .search input {
            width: 100%;
            height: 39px;
            padding: 0 12px 0 36px;
            border: 1px solid #dbe4ef;
            border-radius: 8px;
            outline: none;
        }

        .search input:focus,
        .toolbar select:focus {
            border-color: #80aaf8;
            box-shadow: 0 0 0 3px #dbeafe;
        }

        .search-icon {
            position: absolute;
            left: 12px;
            top: 10px;
            color: #8493a7;
        }

        .toolbar select {
            height: 39px;
            padding: 0 32px 0 11px;
            border: 1px solid #dbe4ef;
            border-radius: 8px;
            background: #fff;
            color: #475569;
            outline: none;
        }

        .toolbar .spacer { flex: 1; }

        .toolbar-note {
            font-size: 11px;
            color: var(--muted);
        }

        .table-wrap { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
            white-space: nowrap;
        }

        thead { background: #f8fafc; }

        th {
            padding: 14px 16px;
            text-align: left;
            font-size: 10px;
            letter-spacing: .65px;
            text-transform: uppercase;
            color: #64748b;
            font-weight: 800;
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #edf1f6;
            font-size: 12px;
            vertical-align: middle;
        }

        tbody tr:hover { background: #f8fbff; }
        tbody tr:last-child td { border-bottom: 0; }

        .code {
            font-weight: 800;
            color: #1d4ed8;
        }

        .subline {
            font-size: 11px;
            color: #8794a7;
            margin-top: 4px;
        }

        .money {
            font-variant-numeric: tabular-nums;
            text-align: right;
        }

        th.money { text-align: right; }

        .total {
            font-weight: 800;
            color: #172b4d;
            font-size: 13px;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 20px;
            padding: 6px 9px;
            font-size: 10px;
            font-weight: 800;
        }

        .status:before {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
        }

        .s-draft { background: #fff7e6; color: #a16207; }
        .s-issued { background: #ecfdf3; color: #15803d; }
        .s-cancelled { background: #fff1f2; color: #be123c; }

        .actions {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #dfe7f0;
            border-radius: 6px;
            padding: 6px 8px;
            background: #fff;
            color: #475569;
            font-size: 11px;
            font-weight: 650;
            cursor: pointer;
            white-space: nowrap;
        }

        .action:hover { background: #f1f5f9; }
        .action-blue { color: #1d4ed8; background: #f5f8ff; border-color: #d5e3ff; }
        .action-green { color: #15803d; background: #f0fdf4; border-color: #c9efd5; }
        .action-red { color: #b91c1c; background: #fff7f7; border-color: #fecaca; }

        .empty {
            text-align: center;
            padding: 42px 20px !important;
            color: var(--muted);
            white-space: normal;
        }

        .panel-foot {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: center;
            padding: 14px 21px;
            border-top: 1px solid var(--border);
            font-size: 11px;
            color: var(--muted);
        }

        .hidden-row { display: none !important; }

        @media (max-width: 1150px) {
            .invoice-content { padding: 25px 20px; }
            .stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 760px) {
            .invoice-content { padding: 20px 13px; }
            .heading { align-items: flex-start; flex-direction: column; }
            .heading h1 { font-size: 23px; }
            .stats { gap: 10px; }
            .stat { padding: 14px; }
            .stat-value { font-size: 22px; }
            .panel-head { padding: 16px; }
            .toolbar { padding: 14px; }
            .panel-foot { align-items: flex-start; flex-direction: column; }
        }
    </style>
</head>

<body>
    <%-- Layout chung được dựng bởi shared-layout.js --%>

    <main class="invoice-content">

        <c:if test="${not empty param.success}">
            <div class="alert success" role="status">
                ✓ Thao tác hóa đơn đã được thực hiện thành công.
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert error" role="alert">
                ⚠ <c:out value="${error}"/>
            </div>
        </c:if>

        <%-- Đếm trạng thái trong chính danh sách backend gửi về --%>
        <c:set var="draftCount" value="0"/>
        <c:set var="issuedCount" value="0"/>
        <c:set var="cancelCount" value="0"/>

        <c:forEach var="x" items="${items}">
            <c:if test="${x.trangThai == 'NHAP'}">
                <c:set var="draftCount" value="${draftCount + 1}"/>
            </c:if>
            <c:if test="${x.trangThai == 'DA_PHAT_HANH'}">
                <c:set var="issuedCount" value="${issuedCount + 1}"/>
            </c:if>
            <c:if test="${x.trangThai == 'DA_HUY'}">
                <c:set var="cancelCount" value="${cancelCount + 1}"/>
            </c:if>
        </c:forEach>

        <section class="heading">
            <div>
                <div class="eyebrow">QLKHACHSAN / TÀI CHÍNH</div>
                <h1>Quản lý hóa đơn</h1>
                <div class="subtitle">
                    Theo dõi chi phí lưu trú, dịch vụ và tình trạng phát hành hóa đơn.
                </div>
            </div>

            <div class="heading-actions">
                <a class="btn"
                   href="${pageContext.request.contextPath}/dat-phong?action=list">
                    ← Danh sách đặt phòng
                </a>
            </div>
        </section>

        <section class="stats">
            <div class="stat">
                <div class="stat-head">
                    <span>Hóa đơn trong danh sách</span>
                    <span class="stat-icon ib">▤</span>
                </div>
                <div class="stat-value">
                    <c:out value="${empty items ? 0 : items.size()}"/>
                </div>
                <div class="stat-note">Dữ liệu được tải từ hệ thống</div>
            </div>

            <div class="stat">
                <div class="stat-head">
                    <span>Hóa đơn nháp</span>
                    <span class="stat-icon ia">◷</span>
                </div>
                <div class="stat-value"><c:out value="${draftCount}"/></div>
                <div class="stat-note">Chờ phát hành hoặc xử lý</div>
            </div>

            <div class="stat">
                <div class="stat-head">
                    <span>Đã phát hành</span>
                    <span class="stat-icon ig">✓</span>
                </div>
                <div class="stat-value"><c:out value="${issuedCount}"/></div>
                <div class="stat-note">Hóa đơn đã phát hành trong danh sách</div>
            </div>

            <div class="stat">
                <div class="stat-head">
                    <span>Đã hủy</span>
                    <span class="stat-icon ir">×</span>
                </div>
                <div class="stat-value"><c:out value="${cancelCount}"/></div>
                <div class="stat-note">Hóa đơn không còn hiệu lực</div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-head">
                <div>
                    <div class="panel-title">Danh sách hóa đơn</div>
                    <div class="panel-sub">
                        Tìm kiếm và lọc hóa đơn theo trạng thái.
                    </div>
                </div>
                <span class="count">
                    <c:out value="${empty items ? 0 : items.size()}"/> hóa đơn
                </span>
            </div>

            <div class="toolbar">
                <div class="search">
                    <span class="search-icon" aria-hidden="true">⌕</span>
                    <input id="invoiceSearch"
                           type="search"
                           placeholder="Tìm mã hóa đơn, mã đặt phòng..."
                           aria-label="Tìm hóa đơn">
                </div>

                <select id="statusFilter" aria-label="Lọc trạng thái">
                    <option value="">Tất cả trạng thái</option>
                    <option value="NHAP">Nháp</option>
                    <option value="DA_PHAT_HANH">Đã phát hành</option>
                    <option value="DA_HUY">Đã hủy</option>
                </select>

                <span class="spacer"></span>
                <span class="toolbar-note">Lọc trên danh sách hiện tại</span>
            </div>

            <div class="table-wrap">
                <table id="invoiceTable">
                    <thead>
                        <tr>
                            <th>Mã hóa đơn</th>
                            <th>Mã đặt phòng</th>
                            <th>Ngày lập</th>
                            <th class="money">Tiền phòng</th>
                            <th class="money">Tiền dịch vụ</th>
                            <th class="money">Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr
                                data-search="${item.maHoaDon} ${item.datPhong.maDatPhong}"
                                data-status="${item.trangThai}">

                                <td>
                                    <span class="code">
                                        <c:out value="${item.maHoaDon}"/>
                                    </span>
                                    <div class="subline">Mã chứng từ</div>
                                </td>

                                <td>
                                    <strong>
                                        <c:out value="${item.datPhong.maDatPhong}"/>
                                    </strong>
                                    <div class="subline">Đặt phòng</div>
                                </td>

                                <td><c:out value="${item.ngayLap}"/></td>

                                <td class="money">
                                    <fmt:formatNumber value="${item.tongTienPhong}"
                                                      pattern="#,##0"
                                                      groupingUsed="true"/> ₫
                                </td>

                                <td class="money">
                                    <fmt:formatNumber value="${item.tongTienDichVu}"
                                                      pattern="#,##0"
                                                      groupingUsed="true"/> ₫
                                </td>

                                <td class="money total">
                                    <fmt:formatNumber value="${item.tongTien}"
                                                      pattern="#,##0"
                                                      groupingUsed="true"/> ₫
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${item.trangThai == 'NHAP'}">
                                            <span class="status s-draft">Nháp</span>
                                        </c:when>
                                        <c:when test="${item.trangThai == 'DA_PHAT_HANH'}">
                                            <span class="status s-issued">Đã phát hành</span>
                                        </c:when>
                                        <c:when test="${item.trangThai == 'DA_HUY'}">
                                            <span class="status s-cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status s-draft">
                                                <c:out value="${item.trangThai}"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <div class="actions">
                                        <a class="action action-blue"
                                           href="${pageContext.request.contextPath}/hoa-don?action=detail&amp;id=${item.maHoaDon}">
                                            Chi tiết
                                        </a>

                                        <c:if test="${item.trangThai == 'NHAP'}">
                                            <a class="action action-green"
                                               href="${pageContext.request.contextPath}/hoa-don?action=issue&amp;id=${item.maHoaDon}"
                                               onclick="return confirm('Bạn có chắc muốn phát hành hóa đơn này?');">
                                                Phát hành
                                            </a>

                                            <a class="action action-red"
                                               href="${pageContext.request.contextPath}/hoa-don?action=delete&amp;id=${item.maHoaDon}"
                                               onclick="return confirm('Bạn có chắc muốn xóa hóa đơn nháp này?');">
                                                Xóa
                                            </a>
                                        </c:if>

                                        <c:if test="${item.trangThai != 'DA_HUY'}">
                                            <a class="action action-red"
                                               href="${pageContext.request.contextPath}/hoa-don?action=cancel&amp;id=${item.maHoaDon}"
                                               onclick="return confirm('Bạn có chắc muốn hủy hóa đơn này?');">
                                                Hủy
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty items}">
                            <tr>
                                <td colspan="8" class="empty">
                                    <div style="font-size:30px;margin-bottom:10px">▤</div>
                                    <strong>Không có hóa đơn cần hiển thị</strong>
                                    <div style="margin-top:6px">
                                        Danh sách hiện chưa có hóa đơn phù hợp.
                                    </div>
                                </td>
                            </tr>
                        </c:if>

                        <tr id="noMatch" class="hidden-row">
                            <td colspan="8" class="empty">
                                Không tìm thấy hóa đơn phù hợp với điều kiện lọc.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="panel-foot">
                <span>
                    Đang hiển thị
                    <strong id="visibleCount">
                        <c:out value="${empty items ? 0 : items.size()}"/>
                    </strong>
                    hóa đơn
                </span>
                <span>Horizon Hotel · Quản lý tài chính</span>
            </div>
        </section>
    </main>

    <script src="${pageContext.request.contextPath}/js/shared-layout.js"></script>

    <script>
        (function () {
            const search = document.getElementById('invoiceSearch');
            const status = document.getElementById('statusFilter');
            const table = document.getElementById('invoiceTable');

            if (!search || !status || !table) return;

            const rows = Array.from(
                table.querySelectorAll('tbody tr[data-search]')
            );

            const visibleCount = document.getElementById('visibleCount');
            const noMatch = document.getElementById('noMatch');

            function filterRows() {
                const q = search.value.trim().toLocaleLowerCase('vi');
                const st = status.value;
                let shown = 0;

                rows.forEach(function (row) {
                    const text = (row.dataset.search || '')
                        .toLocaleLowerCase('vi');

                    const matchText = text.includes(q);
                    const matchStatus = !st || row.dataset.status === st;
                    const visible = matchText && matchStatus;

                    row.classList.toggle('hidden-row', !visible);

                    if (visible) shown++;
                });

                if (visibleCount) {
                    visibleCount.textContent = shown;
                }

                if (noMatch) {
                    noMatch.classList.toggle(
                        'hidden-row',
                        shown !== 0 || rows.length === 0
                    );
                }
            }

            search.addEventListener('input', filterRows);
            status.addEventListener('change', filterRows);
        })();
    </script>
</body>
</html>
