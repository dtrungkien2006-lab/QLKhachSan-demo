<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đặt phòng | Horizon Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        :root {
            --booking-primary: #173b65;
            --booking-primary-light: #eaf2fb;
            --booking-bg: #f4f7fb;
            --booking-text: #1e293b;
            --booking-muted: #64748b;
            --booking-border: #e2e8f0;
            --booking-green: #15803d;
            --booking-orange: #b45309;
            --booking-red: #b91c1c;
            --booking-shadow: 0 4px 16px rgba(15, 35, 60, .05);
        }

        .booking-content,
        .booking-content * {
            box-sizing: border-box;
        }

        .booking-content {
            width: 100%;
            max-width: 1800px;
            margin: 0 auto;
            color: var(--booking-text);
            font-family: "Segoe UI", Arial, sans-serif;
            font-size: 14px;
        }

        .booking-content a {
            text-decoration: none;
        }

        .booking-content button,
        .booking-content input,
        .booking-content select {
            font: inherit;
        }

        /* Tiêu đề trang */
        .booking-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 25px;
        }

        .booking-eyebrow {
            color: #52769e;
            font-weight: 750;
            font-size: 11px;
            letter-spacing: 1.2px;
            margin-bottom: 8px;
        }

        .booking-heading h1 {
            margin: 0;
            font-size: 27px;
            font-weight: 750;
            letter-spacing: -.5px;
        }

        .booking-subtitle {
            color: var(--booking-muted);
            margin-top: 8px;
            line-height: 1.6;
        }

        .booking-btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            border: 1px solid var(--booking-border);
            border-radius: 8px;
            padding: 11px 15px;
            cursor: pointer;
            font-weight: 650;
            white-space: nowrap;
            background: #fff;
            color: var(--booking-text);
            transition: .2s;
        }

        .booking-btn:hover {
            transform: translateY(-1px);
        }

        .booking-btn-primary {
            color: #fff;
            background: var(--booking-primary);
            border-color: var(--booking-primary);
            box-shadow: 0 3px 8px rgba(23, 59, 101, .16);
        }

        .booking-btn-primary:hover {
            background: #245080;
        }

        .booking-btn-light:hover {
            background: #f8fafc;
        }

        /* Thông báo */
        .booking-alert {
            padding: 13px 16px;
            border-radius: 9px;
            margin-bottom: 18px;
            line-height: 1.5;
        }

        .booking-success {
            background: #ecfdf3;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .booking-error {
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
        }

        /* Thẻ thống kê */
        .booking-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .booking-stat {
            background: #fff;
            border: 1px solid var(--booking-border);
            border-radius: 12px;
            padding: 21px;
            box-shadow: var(--booking-shadow);
            min-width: 0;
        }

        .booking-stat-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }

        .booking-stat-title {
            color: var(--booking-muted);
            font-size: 13px;
            font-weight: 550;
        }

        .booking-stat-icon {
            width: 42px;
            height: 42px;
            flex-shrink: 0;
            border-radius: 11px;
            display: grid;
            place-items: center;
            font-size: 20px;
        }

        .booking-icon-blue {
            background: #eaf2ff;
            color: #2563eb;
        }

        .booking-icon-orange {
            background: #fff3e7;
            color: #c2410c;
        }

        .booking-icon-green {
            background: #eaf9ef;
            color: #15803d;
        }

        .booking-icon-purple {
            background: #f2eafe;
            color: #7c3aed;
        }

        .booking-stat-value {
            font-size: 27px;
            font-weight: 750;
            margin-top: 12px;
        }

        .booking-stat-note {
            margin-top: 8px;
            font-size: 12px;
            color: var(--booking-muted);
        }

        /* Khung nội dung */
        .booking-panel {
            background: #fff;
            border: 1px solid var(--booking-border);
            border-radius: 12px;
            box-shadow: var(--booking-shadow);
            margin-bottom: 22px;
            overflow: hidden;
        }

        .booking-panel-heading {
            padding: 20px 22px;
            border-bottom: 1px solid var(--booking-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .booking-panel-title {
            font-size: 16px;
            font-weight: 750;
        }

        .booking-panel-description {
            font-size: 12px;
            color: var(--booking-muted);
            margin-top: 5px;
            line-height: 1.5;
        }

        .booking-count {
            background: var(--booking-primary-light);
            color: var(--booking-primary);
            border-radius: 8px;
            padding: 9px 12px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        /* Bộ lọc */
        .booking-filter {
            padding: 22px;
        }

        .booking-filter-grid {
            display: grid;
            grid-template-columns: 1fr 1.35fr 1fr 1fr 1fr;
            gap: 15px;
            align-items: end;
        }

        .booking-field {
            min-width: 0;
        }

        .booking-field label {
            display: block;
            font-size: 12px;
            font-weight: 650;
            color: #475569;
            margin-bottom: 8px;
        }

        .booking-field input,
        .booking-field select {
            width: 100%;
            min-width: 0;
            height: 42px;
            border: 1px solid #d7e0eb;
            border-radius: 7px;
            padding: 0 11px;
            background: #fff;
            color: var(--booking-text);
            outline: none;
        }

        .booking-field input:focus,
        .booking-field select:focus {
            border-color: #4f83bd;
            box-shadow: 0 0 0 3px rgba(79, 131, 189, .12);
        }

        .booking-filter-actions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
            align-items: center;
            flex-wrap: wrap;
        }

        /* Bảng dữ liệu */
        .booking-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .booking-table {
            width: 100%;
            border-collapse: collapse;
            white-space: nowrap;
        }

        .booking-table thead {
            background: #f8fafc;
        }

        .booking-table th {
            padding: 15px 17px;
            text-align: left;
            color: #475569;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: .45px;
            font-weight: 750;
            border-bottom: 1px solid var(--booking-border);
        }

        .booking-table td {
            padding: 15px 17px;
            border-bottom: 1px solid #edf1f6;
            vertical-align: middle;
        }

        .booking-table tbody tr {
            transition: background .15s;
        }

        .booking-table tbody tr:hover {
            background: #f8fbff;
        }

        .booking-table tbody tr:last-child td {
            border-bottom: 0;
        }

        .booking-code {
            font-weight: 750;
            color: var(--booking-primary);
        }

        .booking-customer {
            font-weight: 650;
            color: #26374b;
        }

        .booking-secondary {
            color: var(--booking-muted);
            font-size: 12px;
            margin-top: 5px;
        }

        .booking-date {
            color: #475569;
            font-size: 13px;
        }

        .booking-note {
            max-width: 220px;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--booking-muted);
        }

        /* Trạng thái */
        .booking-status {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 750;
        }

        .booking-status::before {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
        }

        .booking-status-pending {
            color: #b45309;
            background: #fff7e6;
        }

        .booking-status-confirmed {
            color: #1d4ed8;
            background: #eff6ff;
        }

        .booking-status-staying {
            color: #047857;
            background: #ecfdf5;
        }

        .booking-status-done {
            color: #475569;
            background: #f1f5f9;
        }

        .booking-status-cancelled {
            color: #b91c1c;
            background: #fef2f2;
        }

        /* Thao tác */
        .booking-actions {
            display: flex;
            align-items: center;
            gap: 7px;
            flex-wrap: wrap;
        }

        .booking-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 9px;
            border: 1px solid var(--booking-border);
            border-radius: 6px;
            background: #fff;
            color: #334155;
            font-size: 12px;
            font-weight: 650;
            transition: .15s;
        }

        .booking-action:hover {
            background: #f1f5f9;
            border-color: #b8c8dc;
        }

        .booking-action-primary {
            color: #1d4ed8;
            border-color: #cfe0ff;
            background: #f5f8ff;
        }

        .booking-action-success {
            color: #15803d;
            border-color: #c4eed2;
            background: #f0fdf4;
        }

        .booking-action-danger {
            color: #b91c1c;
            border-color: #fecaca;
            background: #fff7f7;
        }

        .booking-empty {
            text-align: center;
            color: var(--booking-muted);
            padding: 45px 20px !important;
            white-space: normal;
        }

        .booking-empty-icon {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .booking-table-footer {
            padding: 15px 22px;
            border-top: 1px solid var(--booking-border);
            color: var(--booking-muted);
            font-size: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }

        /* Responsive: chỉ điều chỉnh nội dung, không sửa sidebar chung */
        @media (max-width: 1250px) {
            .booking-content {
                max-width: 100%;
            }

            .booking-filter-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .booking-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .booking-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .booking-heading h1 {
                font-size: 23px;
            }

            .booking-stats {
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            .booking-stat {
                padding: 15px;
            }

            .booking-stat-value {
                font-size: 23px;
            }

            .booking-filter-grid {
                grid-template-columns: 1fr;
            }

            .booking-filter {
                padding: 16px;
            }

            .booking-panel-heading {
                padding: 16px;
            }

            .booking-table-footer {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<div class="booking-content">

    <!-- Thông báo kết quả thao tác -->
    <c:if test="${not empty success}">
        <div class="booking-alert booking-success">
            ✓ Thao tác thành công.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="booking-alert booking-error">
            ⚠ <c:out value="${error}"/>
        </div>
    </c:if>

    <!-- Tiêu đề -->
    <section class="booking-heading">
        <div>
            <div class="booking-eyebrow">RESERVATION MANAGEMENT</div>
            <h1>Quản lý đặt phòng</h1>
            <div class="booking-subtitle">
                Theo dõi, tra cứu và xử lý các đặt phòng của khách sạn.
            </div>
        </div>

        <a class="booking-btn booking-btn-primary"
           href="${pageContext.request.contextPath}/dat-phong?action=new">
            <span>＋</span> Tạo đặt phòng
        </a>
    </section>

    <!-- Thống kê -->
    <section class="booking-stats">

        <div class="booking-stat">
            <div class="booking-stat-top">
                <div class="booking-stat-title">Tổng bản ghi đang hiển thị</div>
                <div class="booking-stat-icon booking-icon-blue">▣</div>
            </div>
            <div class="booking-stat-value">
                <c:out value="${items.size()}"/>
            </div>
            <div class="booking-stat-note">
                Theo điều kiện lọc hiện tại
            </div>
        </div>

        <div class="booking-stat">
            <div class="booking-stat-top">
                <div class="booking-stat-title">Chờ xác nhận</div>
                <div class="booking-stat-icon booking-icon-orange">◷</div>
            </div>
            <div class="booking-stat-value">
                <c:set var="pendingCount" value="0"/>
                <c:forEach var="row" items="${items}">
                    <c:if test="${row.trangThai == 'CHO_XAC_NHAN'}">
                        <c:set var="pendingCount"
                               value="${pendingCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:out value="${pendingCount}"/>
            </div>
            <div class="booking-stat-note">Đang chờ xử lý</div>
        </div>

        <div class="booking-stat">
            <div class="booking-stat-top">
                <div class="booking-stat-title">Đang lưu trú</div>
                <div class="booking-stat-icon booking-icon-green">⌂</div>
            </div>
            <div class="booking-stat-value">
                <c:set var="stayingCount" value="0"/>
                <c:forEach var="row" items="${items}">
                    <c:if test="${row.trangThai == 'DANG_O'}">
                        <c:set var="stayingCount"
                               value="${stayingCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:out value="${stayingCount}"/>
            </div>
            <div class="booking-stat-note">
                Khách đang ở khách sạn
            </div>
        </div>

        <div class="booking-stat">
            <div class="booking-stat-top">
                <div class="booking-stat-title">Đã trả phòng</div>
                <div class="booking-stat-icon booking-icon-purple">✓</div>
            </div>
            <div class="booking-stat-value">
                <c:set var="doneCount" value="0"/>
                <c:forEach var="row" items="${items}">
                    <c:if test="${row.trangThai == 'DA_TRA_PHONG'}">
                        <c:set var="doneCount"
                               value="${doneCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:out value="${doneCount}"/>
            </div>
            <div class="booking-stat-note">
                Đã hoàn tất lưu trú
            </div>
        </div>

    </section>

    <!-- Bộ lọc -->
    <section class="booking-panel">

        <div class="booking-panel-heading">
            <div>
                <div class="booking-panel-title">Bộ lọc đặt phòng</div>
                <div class="booking-panel-description">
                    Nhập một hoặc nhiều tiêu chí để tìm kiếm.
                </div>
            </div>
        </div>

        <form class="booking-filter"
              method="get"
              action="${pageContext.request.contextPath}/dat-phong">

            <input type="hidden" name="action" value="list">

            <div class="booking-filter-grid">

                <div class="booking-field">
                    <label for="maDatPhong">Mã đặt phòng</label>
                    <input id="maDatPhong"
                           type="text"
                           name="maDatPhong"
                           value="<c:out value="${param.maDatPhong}"/>"
                           placeholder="VD: DP001">
                </div>

                <div class="booking-field">
                    <label for="khachHang">Khách hàng</label>
                    <input id="khachHang"
                           type="text"
                           name="khachHang"
                           value="<c:out value="${param.khachHang}"/>"
                           placeholder="Tên khách hoặc số điện thoại">
                </div>

                <div class="booking-field">
                    <label for="trangThai">Trạng thái</label>
                    <select id="trangThai" name="trangThai">
                        <option value="">Tất cả trạng thái</option>

                        <c:forEach var="tt" items="${trangThais}">
                            <option value="${tt}"
                                ${tt == param.trangThai ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${tt == 'CHO_XAC_NHAN'}">
                                        Chờ xác nhận
                                    </c:when>
                                    <c:when test="${tt == 'DA_XAC_NHAN'}">
                                        Đã xác nhận
                                    </c:when>
                                    <c:when test="${tt == 'DANG_O'}">
                                        Đang ở
                                    </c:when>
                                    <c:when test="${tt == 'DA_TRA_PHONG'}">
                                        Đã trả phòng
                                    </c:when>
                                    <c:when test="${tt == 'DA_HUY'}">
                                        Đã hủy
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${tt}"/>
                                    </c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="booking-field">
                    <label for="tuNgay">Ngày nhận từ</label>
                    <input id="tuNgay"
                           type="date"
                           name="tuNgay"
                           value="<c:out value="${param.tuNgay}"/>">
                </div>

                <div class="booking-field">
                    <label for="denNgay">Đến ngày</label>
                    <input id="denNgay"
                           type="date"
                           name="denNgay"
                           value="<c:out value="${param.denNgay}"/>">
                </div>

            </div>

            <div class="booking-filter-actions">
                <button class="booking-btn booking-btn-primary"
                        type="submit">
                    ⌕ Tra cứu
                </button>

                <a class="booking-btn booking-btn-light"
                   href="${pageContext.request.contextPath}/dat-phong?action=list">
                    Đặt lại bộ lọc
                </a>
            </div>
        </form>

    </section>

    <!-- Danh sách đặt phòng -->
    <section class="booking-panel">

        <div class="booking-panel-heading">
            <div>
                <div class="booking-panel-title">Danh sách đặt phòng</div>
                <div class="booking-panel-description">
                    Thông tin đặt phòng và các thao tác nghiệp vụ.
                </div>
            </div>

            <span class="booking-count">
                <c:out value="${items.size()}"/> bản ghi
            </span>
        </div>

        <div class="booking-table-wrap">
            <table class="booking-table">

                <thead>
                <tr>
                    <th>Mã đặt phòng</th>
                    <th>Khách hàng</th>
                    <th>Nhân viên xử lý</th>
                    <th>Ngày đặt</th>
                    <th>Trạng thái</th>
                    <th>Ghi chú</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>

                        <td>
                            <span class="booking-code">
                                <c:out value="${item.maDatPhong}"/>
                            </span>
                        </td>

                        <td>
                            <div class="booking-customer">
                                <c:out value="${item.tenKhachHang}"/>
                            </div>
                            <div class="booking-secondary">
                                Mã KH:
                                <c:out value="${item.maKH}"/>
                            </div>
                        </td>

                        <td>
                            <c:out value="${item.maNVXuLy}"/>
                        </td>

                        <td>
                            <span class="booking-date">
                                <c:out value="${item.ngayDat}"/>
                            </span>
                        </td>

                        <td>
                            <c:set var="tt" value="${item.trangThai}"/>

                            <c:choose>
                                <c:when test="${tt == 'CHO_XAC_NHAN'}">
                                    <span class="booking-status booking-status-pending">
                                        Chờ xác nhận
                                    </span>
                                </c:when>

                                <c:when test="${tt == 'DA_XAC_NHAN'}">
                                    <span class="booking-status booking-status-confirmed">
                                        Đã xác nhận
                                    </span>
                                </c:when>

                                <c:when test="${tt == 'DANG_O'}">
                                    <span class="booking-status booking-status-staying">
                                        Đang ở
                                    </span>
                                </c:when>

                                <c:when test="${tt == 'DA_TRA_PHONG'}">
                                    <span class="booking-status booking-status-done">
                                        Đã trả phòng
                                    </span>
                                </c:when>

                                <c:when test="${tt == 'DA_HUY'}">
                                    <span class="booking-status booking-status-cancelled">
                                        Đã hủy
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="booking-status booking-status-done">
                                        <c:out value="${tt}"/>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="booking-note" title="<c:out value="${item.ghiChu}"/>">
                            <c:choose>
                                <c:when test="${not empty item.ghiChu}">
                                    <c:out value="${item.ghiChu}"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <div class="booking-actions">

                                <a class="booking-action booking-action-primary"
                                   href="${pageContext.request.contextPath}/dat-phong?action=detail&amp;ma=${item.maDatPhong}">
                                    Chi tiết
                                </a>

                                <c:if test="${item.trangThai == 'CHO_XAC_NHAN'}">
                                    <a class="booking-action booking-action-primary"
                                       href="${pageContext.request.contextPath}/dat-phong?action=confirm&amp;ma=${item.maDatPhong}">
                                        Xác nhận
                                    </a>

                                    <a class="booking-action booking-action-danger"
                                       href="${pageContext.request.contextPath}/dat-phong?action=cancel&amp;ma=${item.maDatPhong}"
                                       onclick="return confirm('Bạn có chắc muốn hủy đặt phòng này?');">
                                        Hủy
                                    </a>
                                </c:if>

                                <c:if test="${item.trangThai == 'DA_XAC_NHAN'}">
                                    <a class="booking-action booking-action-success"
                                       href="${pageContext.request.contextPath}/dat-phong?action=checkin&amp;ma=${item.maDatPhong}">
                                        Check-in
                                    </a>

                                    <a class="booking-action booking-action-danger"
                                       href="${pageContext.request.contextPath}/dat-phong?action=cancel&amp;ma=${item.maDatPhong}"
                                       onclick="return confirm('Bạn có chắc muốn hủy đặt phòng này?');">
                                        Hủy
                                    </a>
                                </c:if>

                                <c:if test="${item.trangThai == 'DANG_O'}">
                                    <a class="booking-action booking-action-success"
                                       href="${pageContext.request.contextPath}/dat-phong?action=checkout&amp;ma=${item.maDatPhong}">
                                        Check-out
                                    </a>
                                </c:if>

                                <c:if test="${item.trangThai == 'DA_TRA_PHONG'}">
                                    <a class="booking-action booking-action-primary"
                                       href="${pageContext.request.contextPath}/hoa-don?action=by-dat-phong&amp;maDatPhong=${item.maDatPhong}">
                                        Hóa đơn
                                    </a>
                                </c:if>

                            </div>
                        </td>

                    </tr>
                </c:forEach>

                <c:if test="${empty items}">
                    <tr>
                        <td colspan="7" class="booking-empty">
                            <div class="booking-empty-icon">▤</div>
                            <strong>Không tìm thấy đặt phòng</strong>
                            <div style="margin-top:7px">
                                Hãy thử thay đổi điều kiện tìm kiếm.
                            </div>
                        </td>
                    </tr>
                </c:if>

                </tbody>
            </table>
        </div>

        <div class="booking-table-footer">
            <span>
                Đang hiển thị
                <strong><c:out value="${items.size()}"/></strong>
                bản ghi theo điều kiện hiện tại.
            </span>
            <span>Horizon Hotel · Hotel Management System</span>
        </div>

    </section>

</div>

<!-- Sidebar và topbar được tạo từ layout dùng chung -->
<script src="${pageContext.request.contextPath}/js/shared-layout.js" defer></script>

</body>
</html>