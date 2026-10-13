<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tạo thanh toán | Horizon Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        :root {
            --pay-blue: #2563eb;
            --pay-bg: #f4f7fc;
            --pay-text: #172b4d;
            --pay-muted: #718096;
            --pay-border: #e3eaf3;
            --pay-green: #15803d;
            --pay-shadow: 0 8px 26px rgba(15, 35, 65, .045);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--pay-bg);
            color: var(--pay-text);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .payment-page {
            width: 100%;
            max-width: 1250px;
            margin: 0 auto;
            padding: 30px 32px 45px;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 25px;
        }

        .eyebrow {
            color: var(--pay-blue);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.1px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .page-heading h1 {
            margin: 0;
            font-size: 28px;
            letter-spacing: -.5px;
        }

        .subtitle {
            margin: 9px 0 0;
            color: var(--pay-muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 41px;
            padding: 10px 15px;
            border: 1px solid var(--pay-border);
            border-radius: 9px;
            background: #fff;
            color: #334155;
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
            text-decoration: none;
            transition: .18s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15, 35, 65, .08);
        }

        .btn-primary {
            background: var(--pay-blue);
            border-color: var(--pay-blue);
            color: #fff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .payment-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.5fr) minmax(280px, .85fr);
            align-items: start;
            gap: 22px;
        }

        .card {
            background: #fff;
            border: 1px solid var(--pay-border);
            border-radius: 15px;
            box-shadow: var(--pay-shadow);
            overflow: hidden;
        }

        .card-heading {
            padding: 22px 24px;
            border-bottom: 1px solid var(--pay-border);
        }

        .card-title {
            font-size: 15px;
            font-weight: 800;
        }

        .card-description {
            margin-top: 6px;
            color: var(--pay-muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .card-body {
            padding: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px 16px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 0;
        }

        .field-full {
            grid-column: 1 / -1;
        }

        .field label {
            font-size: 12px;
            font-weight: 750;
            color: #334155;
        }

        .required {
            color: #dc2626;
        }

        .field input,
        .field select {
            width: 100%;
            min-height: 44px;
            padding: 11px 13px;
            border: 1px solid #dbe4ef;
            border-radius: 9px;
            background: #fff;
            color: var(--pay-text);
            font: inherit;
            font-size: 13px;
            outline: none;
            transition: .18s ease;
        }

        .field input:focus,
        .field select:focus {
            border-color: #80aaf8;
            box-shadow: 0 0 0 3px #dbeafe;
        }

        .field input[readonly] {
            background: #f8fafc;
            color: #475569;
            font-weight: 750;
        }

        .field-help {
            color: var(--pay-muted);
            font-size: 11px;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #edf1f6;
        }

        .alert {
            margin-bottom: 18px;
            padding: 13px 16px;
            border: 1px solid;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.6;
        }

        .alert-error {
            color: #b91c1c;
            background: #fff1f2;
            border-color: #fecdd3;
        }

        .summary-body {
            padding: 22px;
        }

        .summary-icon {
            display: grid;
            place-items: center;
            width: 48px;
            height: 48px;
            border-radius: 13px;
            background: #eaf2ff;
            color: var(--pay-blue);
            font-size: 23px;
            margin-bottom: 18px;
        }

        .summary-label {
            color: var(--pay-muted);
            font-size: 12px;
        }

        .summary-amount {
            margin-top: 7px;
            color: var(--pay-blue);
            font-size: clamp(23px, 2.3vw, 30px);
            font-weight: 850;
            letter-spacing: -.6px;
            overflow-wrap: anywhere;
            font-variant-numeric: tabular-nums;
        }

        .summary-currency {
            margin-top: 4px;
            color: var(--pay-muted);
            font-size: 11px;
        }

        .summary-divider {
            height: 1px;
            background: var(--pay-border);
            margin: 22px 0;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin: 14px 0;
            font-size: 12px;
        }

        .summary-row span {
            color: var(--pay-muted);
        }

        .summary-row strong {
            text-align: right;
            overflow-wrap: anywhere;
        }

        .summary-note {
            padding: 12px;
            border-radius: 9px;
            background: #f0fdf4;
            color: #166534;
            font-size: 11px;
            line-height: 1.7;
        }

        .summary-note strong {
            display: block;
            margin-bottom: 3px;
        }

        .empty-summary {
            color: var(--pay-muted);
            font-size: 12px;
            line-height: 1.7;
        }

        @media (max-width: 850px) {
            .payment-layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {
            .payment-page {
                padding: 20px 13px 30px;
            }

            .page-heading {
                flex-direction: column;
            }

            .page-heading h1 {
                font-size: 24px;
            }

            .card-heading,
            .card-body,
            .summary-body {
                padding: 18px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 17px;
            }

            .field-full {
                grid-column: auto;
            }

            .form-actions .btn {
                flex: 1;
            }
        }
    </style>
</head>

<body>
<main class="payment-page">

    <header class="page-heading">
        <div>
            <div class="eyebrow">Horizon Hotel / Tài chính</div>
            <h1>Tạo thanh toán</h1>
            <p class="subtitle">
                Ghi nhận giao dịch thanh toán cho hóa đơn của khách hàng.
            </p>
        </div>

        <a class="btn"
           href="${pageContext.request.contextPath}/thanh-toan">
            ← Danh sách thanh toán
        </a>
    </header>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <strong>Không thể tạo thanh toán.</strong>
            <c:out value="${error}"/>
        </div>
    </c:if>

    <div class="payment-layout">

        <section class="card">
            <div class="card-heading">
                <div class="card-title">Thông tin giao dịch</div>
                <div class="card-description">
                    Chọn hóa đơn và phương thức thanh toán.
                    Mã giao dịch có thể để trống để hệ thống tự sinh.
                </div>
            </div>

            <div class="card-body">
                <form method="post"
                      action="${pageContext.request.contextPath}/thanh-toan">

                    <div class="form-grid">

                        <div class="field field-full">
                            <label for="maThanhToan">
                                Mã thanh toán
                            </label>
                            <input
                                type="text"
                                id="maThanhToan"
                                name="maThanhToan"
                                value="<c:out value='${item.maThanhToan}'/>"
                                placeholder="Để trống để hệ thống tự sinh">
                            <div class="field-help">
                                Không cần nhập nếu muốn hệ thống tạo mã tự động.
                            </div>
                        </div>

                        <div class="field field-full">
                            <label for="maHoaDon">
                                Hóa đơn cần thanh toán
                                <span class="required">*</span>
                            </label>

                            <select id="maHoaDon"
                                    name="maHoaDon"
                                    required>
                                <option value=""
                                        data-amount=""
                                        data-booking="">
                                    -- Chọn hóa đơn --
                                </option>

                                <c:forEach var="hd" items="${hoaDons}">
                                    <option
                                        value="${hd.maHoaDon}"
                                        data-amount="${hd.tongTien}"
                                        data-booking="${hd.datPhong.maDatPhong}"
                                        <c:if test="${not empty item and item.datPhong.maDatPhong == hd.datPhong.maDatPhong}">
                                            selected
                                        </c:if>>
                                        <c:out value="${hd.maHoaDon}"/>
                                        — Đặt phòng
                                        <c:out value="${hd.datPhong.maDatPhong}"/>
                                        — <fmt:formatNumber
                                            value="${hd.tongTien}"
                                            pattern="#,##0"/> đ
                                    </option>
                                </c:forEach>
                            </select>

                            <div class="field-help">
                                Số tiền còn phải trả sẽ được backend tính theo số dư còn lại.
                            </div>
                        </div>

                        <div class="field field-full">
                            <label for="tongTien">
                                Tổng tiền hóa đơn
                            </label>
                            <input
                                type="text"
                                id="tongTien"
                                value=""
                                placeholder="Chọn hóa đơn để xem tổng tiền"
                                readonly>
                        </div>

                        <div class="field field-full">
                            <label for="phuongThuc">
                                Phương thức thanh toán
                                <span class="required">*</span>
                            </label>

                            <select id="phuongThuc"
                                    name="phuongThuc"
                                    required>
                                <option value="TIEN_MAT">Tiền mặt</option>
                                <option value="VNPAY">VNPay</option>
                                <option value="MOMO">MoMo</option>
                            </select>

                            <div class="field-help">
                                Chọn phương thức khách sử dụng cho giao dịch này.
                            </div>
                        </div>

                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            ✓ Tạo thanh toán
                        </button>

                        <a class="btn"
                           href="${pageContext.request.contextPath}/thanh-toan">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </section>

        <aside class="card">
            <div class="card-heading">
                <div class="card-title">Tóm tắt hóa đơn</div>
                <div class="card-description">
                    Kiểm tra thông tin trước khi tạo giao dịch.
                </div>
            </div>

            <div class="summary-body">
                <div class="summary-icon">₫</div>

                <div class="summary-label">Tổng tiền hóa đơn</div>
                <div class="summary-amount" id="summaryAmount">
                    Chưa chọn
                </div>
                <div class="summary-currency">Đơn vị: Việt Nam đồng (VND)</div>

                <div class="summary-divider"></div>

                <div class="summary-row">
                    <span>Mã hóa đơn</span>
                    <strong id="summaryInvoice">—</strong>
                </div>

                <div class="summary-row">
                    <span>Mã đặt phòng</span>
                    <strong id="summaryBooking">—</strong>
                </div>

                <div class="summary-row">
                    <span>Phương thức</span>
                    <strong id="summaryMethod">Tiền mặt</strong>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-note">
                    <strong>Thông tin thanh toán</strong>
                    Đây là tổng giá trị hóa đơn. Số tiền thực thu và số dư còn lại
                    được backend xác định khi xử lý giao dịch.
                </div>
            </div>
        </aside>

    </div>
</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

<script>
(function () {
    const invoiceSelect = document.getElementById('maHoaDon');
    const amountInput = document.getElementById('tongTien');
    const summaryAmount = document.getElementById('summaryAmount');
    const summaryInvoice = document.getElementById('summaryInvoice');
    const summaryBooking = document.getElementById('summaryBooking');
    const methodSelect = document.getElementById('phuongThuc');
    const summaryMethod = document.getElementById('summaryMethod');

    const moneyFormatter = new Intl.NumberFormat('vi-VN', {
        maximumFractionDigits: 0
    });

    function updateInvoice() {
        const option = invoiceSelect.options[invoiceSelect.selectedIndex];

        if (!option || !option.value || option.dataset.amount === '') {
            amountInput.value = '';
            summaryAmount.textContent = 'Chưa chọn';
            summaryInvoice.textContent = '—';
            summaryBooking.textContent = '—';
            return;
        }

        const amount = Number(option.dataset.amount);

        amountInput.value = Number.isFinite(amount)
            ? moneyFormatter.format(amount) + ' đ'
            : '';

        summaryAmount.textContent = Number.isFinite(amount)
            ? moneyFormatter.format(amount) + ' đ'
            : 'Chưa có dữ liệu';

        summaryInvoice.textContent = option.value;
        summaryBooking.textContent = option.dataset.booking || '—';
    }

    function updateMethod() {
        const labels = {
            TIEN_MAT: 'Tiền mặt',
            VNPAY: 'VNPay',
            MOMO: 'MoMo'
        };

        summaryMethod.textContent =
            labels[methodSelect.value] || methodSelect.value;
    }

    invoiceSelect.addEventListener('change', updateInvoice);
    methodSelect.addEventListener('change', updateMethod);

    updateInvoice();
    updateMethod();
})();
</script>

</body>
</html>