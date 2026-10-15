<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý thanh toán | UTE Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .payment-page {
            max-width: 1500px;
            margin: 0 auto;
            padding: 8px 2px 32px;
            color: #172b4d;
        }

        .payment-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 26px;
        }

        .payment-eyebrow {
            margin: 0 0 8px;
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: .12em;
            text-transform: uppercase;
        }

        .payment-title {
            margin: 0;
            color: #12243a;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .payment-subtitle {
            margin: 8px 0 0;
            color: #64748b;
            font-size: 14px;
        }

        .payment-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 17px;
            border-radius: 10px;
            background: #2563eb;
            color: white !important;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 5px 14px #2563eb25;
            transition: .18s;
        }

        .payment-primary:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .payment-alert {
            margin-bottom: 18px;
            padding: 13px 16px;
            border-radius: 10px;
            font-size: 14px;
        }

        .payment-alert.ok {
            background: #ecfdf3;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .payment-alert.err {
            background: #fff1f2;
            color: #9f1239;
            border: 1px solid #fecdd3;
        }

        .payment-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .payment-stat {
            min-width: 0;
            padding: 21px;
            border: 1px solid #e5eaf2;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 16px #0f172a06;
        }

        .payment-stat-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            color: #64748b;
            font-size: 13px;
            font-weight: 600;
        }

        .payment-stat-icon {
            display: grid;
            width: 40px;
            height: 40px;
            place-items: center;
            border-radius: 11px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 19px;
        }

        .payment-stat strong {
            display: block;
            margin-top: 14px;
            color: #172b4d;
            font-size: 27px;
            line-height: 1.35;
            overflow-wrap: anywhere;
        }

        .payment-stat small {
            display: block;
            margin-top: 5px;
            color: #94a3b8;
            font-size: 12px;
        }

        .payment-panel {
            overflow: hidden;
            border: 1px solid #e5eaf2;
            border-radius: 15px;
            background: white;
            box-shadow: 0 4px 16px #0f172a06;
        }

        .payment-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            padding: 21px 22px;
            border-bottom: 1px solid #edf0f5;
        }

        .payment-panel-head h2 {
            margin: 0;
            color: #172b4d;
            font-size: 17px;
        }

        .payment-panel-head p {
            margin: 5px 0 0;
            color: #94a3b8;
            font-size: 13px;
        }

        .payment-search {
            position: relative;
            width: 100%;
            max-width: 350px;
        }

        .payment-search input {
            box-sizing: border-box;
            width: 100%;
            padding: 11px 13px 11px 38px;
            border: 1px solid #dbe2ec;
            border-radius: 9px;
            outline: none;
            background: #fbfcfe;
            font: inherit;
            font-size: 13px;
        }

        .payment-search input:focus {
            border-color: #60a5fa;
            box-shadow: 0 0 0 3px #dbeafe;
        }

        .payment-search span {
            position: absolute;
            top: 9px;
            left: 13px;
            color: #94a3b8;
        }

        .payment-table-wrap {
            overflow-x: auto;
        }

        .payment-table {
            width: 100%;
            min-width: 1100px;
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .payment-table th {
            padding: 14px 16px;
            border-bottom: 1px solid #e8edf4;
            background: #f8fafc;
            color: #64748b;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: .045em;
            font-size: 11px;
            font-weight: 800;
            white-space: nowrap;
        }

        .payment-table td {
            padding: 15px 16px;
            border-bottom: 1px solid #eef2f7;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
            white-space: nowrap;
        }

        .payment-table tbody tr:hover {
            background: #f8fbff;
        }

        .payment-table tbody tr:last-child td {
            border-bottom: 0;
        }

        .payment-id {
            color: #1d4ed8;
            font-weight: 800;
        }

        .payment-booking {
            color: #172b4d;
            font-weight: 700;
        }

        .payment-money {
            color: #172b4d;
            font-weight: 800;
            font-variant-numeric: tabular-nums;
        }

        .payment-method {
            display: inline-flex;
            padding: 6px 9px;
            border-radius: 7px;
            background: #f1f5f9;
            color: #475569;
            font-size: 11px;
            font-weight: 800;
        }

        .payment-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
        }

        .payment-status::before {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
            content: "";
        }

        .status-paid {
            background: #dcfce7;
            color: #15803d;
        }

        .status-wait {
            background: #fef3c7;
            color: #a16207;
        }

        .status-failed {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-refund {
            background: #ede9fe;
            color: #6d28d9;
        }

        .status-other {
            background: #e2e8f0;
            color: #475569;
        }

        .payment-actions {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .payment-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 10px;
            border: 1px solid #dbe4f0;
            border-radius: 7px;
            background: #fff;
            color: #475569 !important;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            transition: .15s;
        }

        .payment-action:hover {
            border-color: #bfdbfe;
            background: #eff6ff;
            color: #1d4ed8 !important;
        }

        .payment-action.primary {
            border-color: #bfdbfe;
            background: #eff6ff;
            color: #1d4ed8 !important;
        }

        .payment-action.danger {
            color: #b91c1c !important;
        }

        .payment-empty {
            padding: 45px 16px !important;
            color: #94a3b8 !important;
            text-align: center !important;
        }

        .payment-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding: 15px 22px;
            border-top: 1px solid #edf0f5;
            color: #94a3b8;
            font-size: 12px;
        }

        .payment-footer a {
            color: #2563eb;
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 900px) {
            .payment-stats {
                grid-template-columns: 1fr;
            }

            .payment-title {
                font-size: 24px;
            }

            .payment-panel-head {
                align-items: stretch;
            }

            .payment-search {
                max-width: none;
            }
        }
    </style>
</head>

<body>
<div class="payment-page">

    <header class="payment-head">
        <div>
            <p class="payment-eyebrow">UTE Hotel / Tài chính</p>
            <h1 class="payment-title">Quản lý thanh toán</h1>
            <p class="payment-subtitle">
                Theo dõi giao dịch, trạng thái thu tiền và lịch sử thanh toán của khách.
            </p>
        </div>

        <a class="payment-primary"
           href="${pageContext.request.contextPath}/thanh-toan?action=new">
            <span>＋</span> Tạo thanh toán
        </a>
    </header>

    <c:if test="${not empty param.success}">
        <div class="payment-alert ok">
            ✓ Thao tác đã được ghi nhận.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="payment-alert err">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <section class="payment-stats">

        <div class="payment-stat">
            <div class="payment-stat-top">
                <span>Giao dịch hiển thị</span>
                <span class="payment-stat-icon">▤</span>
            </div>
            <strong>
                <c:out value="${empty items ? 0 : items.size()}"/>
            </strong>
            <small>Tổng số bản ghi trong danh sách</small>
        </div>

        <div class="payment-stat">
            <div class="payment-stat-top">
                <span>Chờ thanh toán</span>
                <span class="payment-stat-icon">◷</span>
            </div>
            <strong>
                <c:set var="waitingCount" value="0"/>
                <c:forEach var="x" items="${items}">
                    <c:if test="${x.trangThai == 'CHO_THANH_TOAN'}">
                        <c:set var="waitingCount"
                               value="${waitingCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:out value="${waitingCount}"/>
            </strong>
            <small>Các giao dịch đang chờ xử lý</small>
        </div>

        <div class="payment-stat">
            <div class="payment-stat-top">
                <span>Đã thanh toán</span>
                <span class="payment-stat-icon">✓</span>
            </div>
            <strong>
                <c:set var="paidCount" value="0"/>
                <c:forEach var="x" items="${items}">
                    <c:if test="${x.trangThai == 'DA_THANH_TOAN'}">
                        <c:set var="paidCount"
                               value="${paidCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:out value="${paidCount}"/>
            </strong>
            <small>Giao dịch được ghi nhận thành công</small>
        </div>

    </section>

    <section class="payment-panel">

        <div class="payment-panel-head">
            <div>
                <h2>Lịch sử giao dịch</h2>
                <p>Tra cứu và thao tác trên từng giao dịch thanh toán</p>
            </div>

            <label class="payment-search">
                <span>⌕</span>
                <input id="paymentSearch"
                       type="search"
                       placeholder="Tìm mã thanh toán, đặt phòng, phương thức..."
                       aria-label="Tìm kiếm thanh toán">
            </label>
        </div>

        <div class="payment-table-wrap">
            <table class="payment-table" id="paymentTable">
                <thead>
                <tr>
                    <th>Mã thanh toán</th>
                    <th>Mã đặt phòng</th>
                    <th>Số tiền</th>
                    <th>Phương thức</th>
                    <th>Trạng thái</th>
                    <th>Mã giao dịch</th>
                    <th>Thời gian tạo</th>
                    <th>Thời gian thanh toán</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:choose>
                    <c:when test="${empty items}">
                        <tr>
                            <td colspan="9" class="payment-empty">
                                Chưa có giao dịch thanh toán nào.
                            </td>
                        </tr>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>
                                    <span class="payment-id">
                                        <c:out value="${item.maThanhToan}"/>
                                    </span>
                                </td>

                                <td>
                                    <span class="payment-booking">
                                        <c:out value="${item.datPhong.maDatPhong}"/>
                                    </span>
                                </td>

                                <td>
                                    <span class="payment-money">
                                        <fmt:formatNumber value="${item.soTien}" type="number" pattern="#,##0" /> ₫
                                    </span>
                                </td>

                                <td>
                                    <span class="payment-method">
                                        <c:out value="${item.phuongThuc}"/>
                                    </span>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${item.trangThai == 'DA_THANH_TOAN'}">
                                            <span class="payment-status status-paid">
                                                Đã thanh toán
                                            </span>
                                        </c:when>
                                        <c:when test="${item.trangThai == 'CHO_THANH_TOAN'}">
                                            <span class="payment-status status-wait">
                                                Chờ thanh toán
                                            </span>
                                        </c:when>
                                        <c:when test="${item.trangThai == 'THAT_BAI'}">
                                            <span class="payment-status status-failed">
                                                Thất bại
                                            </span>
                                        </c:when>
                                        <c:when test="${item.trangThai == 'DA_HOAN_TIEN'}">
                                            <span class="payment-status status-refund">
                                                Đã hoàn tiền
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="payment-status status-other">
                                                <c:out value="${item.trangThai}"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.maGiaoDich}">
                                            <c:out value="${item.maGiaoDich}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#94a3b8">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:out value="${item.thoiGianTao}"/>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.thoiGianThanhToan}">
                                            <c:out value="${item.thoiGianThanhToan}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#94a3b8">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <div class="payment-actions">
                                        <a class="payment-action"
                                           href="${pageContext.request.contextPath}/thanh-toan?action=detail&id=${item.maThanhToan}">
                                            Chi tiết
                                        </a>

                                        <c:if test="${item.trangThai == 'CHO_THANH_TOAN'}">
                                            <a class="payment-action primary"
                                               href="${pageContext.request.contextPath}/thanh-toan?action=success&id=${item.maThanhToan}">
                                                Xác nhận
                                            </a>

                                            <a class="payment-action danger"
                                               href="${pageContext.request.contextPath}/thanh-toan?action=fail&id=${item.maThanhToan}">
                                                Thất bại
                                            </a>
                                        </c:if>

                                        <c:if test="${item.trangThai == 'DA_THANH_TOAN'}">
                                            <a class="payment-action"
                                               href="${pageContext.request.contextPath}/thanh-toan?action=refund&id=${item.maThanhToan}">
                                                Hoàn tiền
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <footer class="payment-footer">
            <span>Danh sách giao dịch thanh toán</span>
            <a href="${pageContext.request.contextPath}/hoa-don?action=list">
                ← Quay lại hóa đơn
            </a>
        </footer>

    </section>
</div>

<script>
(() => {
    const input = document.getElementById('paymentSearch');
    const rows = document.querySelectorAll('#paymentTable tbody tr');

    input.addEventListener('input', () => {
        const query = input.value.trim().toLocaleLowerCase('vi');

        rows.forEach(row => {
            row.style.display =
                row.innerText.toLocaleLowerCase('vi').includes(query)
                    ? ''
                    : 'none';
        });
    });
})();
</script>

<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>
</body>
</html>