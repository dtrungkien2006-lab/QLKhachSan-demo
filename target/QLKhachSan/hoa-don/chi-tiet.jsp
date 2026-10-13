<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết hóa đơn | Horizon Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        :root {
            --invoice-blue: #2563eb;
            --invoice-bg: #f4f7fc;
            --invoice-text: #172b4d;
            --invoice-muted: #718096;
            --invoice-border: #e3eaf3;
            --invoice-green: #15803d;
            --invoice-orange: #b45309;
            --invoice-red: #b91c1c;
            --invoice-shadow: 0 8px 26px rgba(15, 35, 65, .045);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            color: var(--invoice-text);
            background: var(--invoice-bg);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .invoice-page {
            max-width: 1450px;
            margin: 0 auto;
            padding: 30px 32px 45px;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 24px;
        }

        .eyebrow {
            color: var(--invoice-blue);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.1px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .page-heading h1 {
            margin: 0;
            font-size: 28px;
            letter-spacing: -.6px;
        }

        .page-description {
            color: var(--invoice-muted);
            font-size: 13px;
            margin: 9px 0 0;
        }

        .heading-actions,
        .bottom-actions {
            display: flex;
            gap: 9px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 40px;
            padding: 10px 15px;
            border: 1px solid var(--invoice-border);
            border-radius: 9px;
            background: #fff;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: .18s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15, 35, 65, .08);
        }

        .btn-primary {
            background: var(--invoice-blue);
            border-color: var(--invoice-blue);
            color: #fff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-disabled {
            opacity: .55;
            cursor: not-allowed;
        }

        .invoice-card {
            overflow: hidden;
            background: #fff;
            border: 1px solid var(--invoice-border);
            border-radius: 16px;
            box-shadow: var(--invoice-shadow);
            margin-bottom: 20px;
        }

        .invoice-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            padding: 23px 26px;
            border-bottom: 1px solid var(--invoice-border);
        }

        .invoice-label {
            color: var(--invoice-muted);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .6px;
            text-transform: uppercase;
        }

        .invoice-number {
            font-size: 23px;
            font-weight: 800;
            margin-top: 7px;
            color: var(--invoice-blue);
        }

        .invoice-date {
            color: var(--invoice-muted);
            font-size: 12px;
            margin-top: 6px;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            border-radius: 30px;
            padding: 8px 12px;
            font-size: 11px;
            font-weight: 800;
            white-space: nowrap;
        }

        .status::before {
            content: "";
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: currentColor;
        }

        .status-draft {
            color: #a16207;
            background: #fff7e6;
        }

        .status-issued {
            color: var(--invoice-green);
            background: #ecfdf3;
        }

        .status-cancelled {
            color: var(--invoice-red);
            background: #fff1f2;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            padding: 23px 26px;
        }

        .info-item {
            min-width: 0;
            padding: 15px;
            background: #f8fafc;
            border: 1px solid #edf1f6;
            border-radius: 11px;
        }

        .info-label {
            display: block;
            color: var(--invoice-muted);
            font-size: 11px;
            margin-bottom: 8px;
        }

        .info-value {
            font-size: 14px;
            font-weight: 750;
            overflow-wrap: anywhere;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 21px 25px;
            border-bottom: 1px solid var(--invoice-border);
        }

        .section-title {
            font-size: 15px;
            font-weight: 800;
        }

        .section-description {
            margin-top: 5px;
            font-size: 12px;
            color: var(--invoice-muted);
        }

        .item-count {
            padding: 7px 10px;
            border-radius: 20px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .table-wrap {
            overflow-x: auto;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            white-space: nowrap;
        }

        .invoice-table thead {
            background: #f8fafc;
        }

        .invoice-table th {
            padding: 14px 20px;
            color: #64748b;
            text-align: left;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .55px;
            text-transform: uppercase;
            border-bottom: 1px solid var(--invoice-border);
        }

        .invoice-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #edf1f6;
            font-size: 13px;
        }

        .invoice-table tbody tr:hover {
            background: #f8fbff;
        }

        .invoice-table tbody tr:last-child td {
            border-bottom: none;
        }

        .item-name {
            font-weight: 700;
            color: #243b53;
        }

        .money {
            font-variant-numeric: tabular-nums;
        }

        .text-right {
            text-align: right !important;
        }

        .total-section {
            display: flex;
            justify-content: flex-end;
            padding: 22px 26px 25px;
            background: #fbfcff;
            border-top: 1px solid var(--invoice-border);
        }

        .total-box {
            width: 100%;
            max-width: 390px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 8px 0;
            color: #64748b;
            font-size: 13px;
        }

        .total-row strong {
            color: var(--invoice-text);
            font-variant-numeric: tabular-nums;
        }

        .grand-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-top: 10px;
            padding-top: 17px;
            border-top: 1px dashed #cbd5e1;
        }

        .grand-total span {
            font-size: 13px;
            font-weight: 800;
        }

        .grand-total strong {
            color: var(--invoice-blue);
            font-size: 23px;
            font-weight: 850;
            font-variant-numeric: tabular-nums;
        }

        .invoice-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            padding-top: 4px;
        }

        .footer-note {
            color: var(--invoice-muted);
            font-size: 12px;
        }

        @media (max-width: 900px) {
            .invoice-page {
                padding: 24px 18px;
            }

            .info-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 600px) {
            .invoice-page {
                padding: 18px 12px;
            }

            .page-heading {
                flex-direction: column;
            }

            .page-heading h1 {
                font-size: 23px;
            }

            .invoice-card-header {
                flex-direction: column;
                padding: 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
                padding: 16px;
            }

            .section-header {
                padding: 18px;
            }

            .total-section {
                padding: 20px;
            }

            .grand-total strong {
                font-size: 20px;
            }

            .invoice-table th,
            .invoice-table td {
                padding: 13px 15px;
            }
        }
    </style>
</head>

<body>
<main class="invoice-page">

    <header class="page-heading">
        <div>
            <div class="eyebrow">Horizon Hotel / Tài chính</div>
            <h1>Chi tiết hóa đơn</h1>
            <p class="page-description">
                Xem thông tin chứng từ, các khoản thu và tổng chi phí lưu trú.
            </p>
        </div>

        <div class="heading-actions">
            <a class="btn"
               href="${pageContext.request.contextPath}/hoa-don">
                ← Danh sách hóa đơn
            </a>
        </div>
    </header>

    <section class="invoice-card">
        <div class="invoice-card-header">
            <div>
                <div class="invoice-label">Mã hóa đơn</div>
                <div class="invoice-number">
                    <c:out value="${item.maHoaDon}"/>
                </div>
                <div class="invoice-date">
                    Ngày lập:
                    <c:out value="${item.ngayLap}"/>
                </div>
            </div>

            <div>
                <c:choose>
                    <c:when test="${item.trangThai == 'NHAP'}">
                        <span class="status status-draft">Nháp</span>
                    </c:when>
                    <c:when test="${item.trangThai == 'DA_PHAT_HANH'}">
                        <span class="status status-issued">Đã phát hành</span>
                    </c:when>
                    <c:when test="${item.trangThai == 'DA_HUY'}">
                        <span class="status status-cancelled">Đã hủy</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status status-draft">
                            <c:out value="${item.trangThai}"/>
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">Mã đặt phòng</span>
                <div class="info-value">
                    <c:out value="${item.datPhong.maDatPhong}"/>
                </div>
            </div>

            <div class="info-item">
                <span class="info-label">Khách hàng</span>
                <div class="info-value">
                    <c:out value="${item.datPhong.khachHang.hoTen}"/>
                </div>
            </div>

            <div class="info-item">
                <span class="info-label">Ngày lập hóa đơn</span>
                <div class="info-value">
                    <c:out value="${item.ngayLap}"/>
                </div>
            </div>
        </div>
    </section>

    <section class="invoice-card">
        <div class="section-header">
            <div>
                <div class="section-title">Chi tiết các khoản thu</div>
                <div class="section-description">
                    Các khoản tiền phòng và dịch vụ được ghi nhận trên hóa đơn.
                </div>
            </div>
            <span class="item-count">
                <c:out value="${item.chiTietHoaDon.size()}"/> khoản thu
            </span>
        </div>

        <div class="table-wrap">
            <table class="invoice-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Khoản thu</th>
                        <th class="text-right">Số lượng</th>
                        <th class="text-right">Đơn giá</th>
                        <th class="text-right">Thành tiền</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="ct" items="${item.chiTietHoaDon}"
                               varStatus="st">
                        <tr>
                            <td><c:out value="${st.count}"/></td>
                            <td class="item-name">
                                <c:out value="${ct.tenKhoanThu}"/>
                            </td>
                            <td class="text-right">
                                <c:out value="${ct.soLuong}"/>
                            </td>
                            <td class="text-right money">
                                <c:out value="${ct.donGia}"/> ₫
                            </td>
                            <td class="text-right money">
                                <strong>
                                    <c:out value="${ct.thanhTien}"/> ₫
                                </strong>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty item.chiTietHoaDon}">
                        <tr>
                            <td colspan="5"
                                style="text-align:center;padding:35px;color:#718096">
                                Hóa đơn chưa có khoản thu chi tiết.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="total-section">
            <div class="total-box">
                <div class="total-row">
                    <span>Tiền phòng</span>
                    <strong>
                        <fmt:formatNumber
                            value="${item.tongTienPhong}"
                            pattern="#,##0.00"/> đ
                    </strong>
                </div>

                <div class="total-row">
                    <span>Tiền dịch vụ</span>
                    <strong>
                        <fmt:formatNumber
                            value="${item.tongTienDichVu}"
                            pattern="#,##0.00"/> đ
                    </strong>
                </div>

                <div class="grand-total">
                    <span>TỔNG CỘNG</span>
                    <strong>
                        <fmt:formatNumber
                            value="${item.tongTien}"
                            pattern="#,##0.00"/> đ
                    </strong>
                </div>
            </div>
        </div>
    </section>

    <footer class="invoice-footer">
        <div class="bottom-actions">
            <a class="btn"
               href="${pageContext.request.contextPath}/hoa-don">
                ← Quay lại danh sách
            </a>

            <a class="btn"
               href="${pageContext.request.contextPath}/su-dung-dich-vu?action=by-dat-phong&amp;maDatPhong=${item.datPhong.maDatPhong}">
                Xem dịch vụ đã sử dụng
            </a>

            <c:if test="${item.trangThai != 'DA_HUY'}">
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/thanh-toan?action=new&amp;maDatPhong=${item.datPhong.maDatPhong}">
                    Tiến hành thanh toán →
                </a>
            </c:if>
        </div>

        <div class="footer-note">
            Horizon Hotel · Quản lý hóa đơn
        </div>
    </footer>

</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>
</body>
</html>
