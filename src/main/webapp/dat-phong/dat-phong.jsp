<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo đặt phòng | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        /* ===== Booking page ===== */
        .booking-page {
            width: 100%;
            max-width: 1180px;
            margin: 0 auto;
            padding: 28px 32px 48px;
            box-sizing: border-box;
            color: #172b4d;
        }

        .booking-page *,
        .booking-page *::before,
        .booking-page *::after {
            box-sizing: border-box;
        }

        .booking-breadcrumb {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 22px;
            color: #748198;
            font-size: 13px;
        }

        .booking-breadcrumb a {
            color: #64748b;
            text-decoration: none;
        }

        .booking-breadcrumb a:hover {
            color: #2458a6;
        }

        .booking-breadcrumb .current {
            color: #172b4d;
            font-weight: 700;
        }

        .booking-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 26px;
        }

        .booking-title-group {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .booking-title-icon {
            width: 54px;
            height: 54px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
            background: #e8efff;
            color: #2458a6;
            font-size: 25px;
        }

        .booking-heading h1 {
            margin: 0 0 7px;
            color: #172b4d;
            font-size: 27px;
            font-weight: 750;
            letter-spacing: -.6px;
        }

        .booking-heading p {
            margin: 0;
            color: #778399;
            font-size: 14px;
            line-height: 1.6;
        }

        .booking-heading-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 13px;
            border: 1px solid #dbe7ff;
            border-radius: 9px;
            background: #f0f5ff;
            color: #2458a6;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .booking-alert {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 15px 17px;
            margin-bottom: 22px;
            border: 1px solid;
            border-radius: 12px;
            font-size: 14px;
            line-height: 1.65;
        }

        .booking-alert.error {
            color: #a42b36;
            background: #fff1f2;
            border-color: #fecdd3;
        }

        .booking-alert.info {
            color: #2458a6;
            background: #eff6ff;
            border-color: #cfe0ff;
        }

        .booking-alert.success {
            color: #176b4d;
            background: #ecfdf5;
            border-color: #bbf7d0;
        }

        .booking-alert-icon {
            font-size: 19px;
            font-weight: 700;
            line-height: 1.3;
        }

        .booking-card {
            margin-bottom: 24px;
            overflow: hidden;
            border: 1px solid #e3e9f2;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 18px rgba(27, 52, 91, .045);
        }

        .booking-card-header {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 21px 24px;
            border-bottom: 1px solid #edf0f5;
        }

        .booking-section-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 11px;
            background: #eef4ff;
            color: #2458a6;
            font-size: 19px;
        }

        .booking-card-header h2 {
            margin: 0 0 5px;
            color: #172b4d;
            font-size: 17px;
            font-weight: 750;
        }

        .booking-card-header p {
            margin: 0;
            color: #8390a5;
            font-size: 12px;
            line-height: 1.5;
        }

        .booking-card-body {
            padding: 24px;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .booking-field {
            min-width: 0;
        }

        .booking-field.full-width {
            grid-column: 1 / -1;
        }

        .booking-field label {
            display: block;
            margin: 0 0 9px;
            color: #34445e;
            font-size: 13px;
            font-weight: 700;
        }

        .booking-field .required {
            color: #dc3545;
        }

        .booking-control {
            display: block;
            width: 100%;
            min-width: 0;
            height: 46px;
            padding: 0 13px;
            border: 1px solid #d8e0eb;
            border-radius: 9px;
            outline: none;
            background: #fff;
            color: #243550;
            font-family: inherit;
            font-size: 14px;
            transition: border-color .2s, box-shadow .2s;
        }

        .booking-control:focus {
            border-color: #5286e5;
            box-shadow: 0 0 0 3px rgba(67, 120, 218, .12);
        }

        .booking-control::placeholder {
            color: #a0aabd;
        }

        .booking-help {
            display: block;
            margin-top: 7px;
            color: #8591a4;
            font-size: 12px;
            line-height: 1.5;
        }

        .booking-tip {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            margin-top: 23px;
            padding: 15px 16px;
            border: 1px solid #dce8ff;
            border-radius: 10px;
            background: #f5f8ff;
        }

        .booking-tip-icon {
            color: #356bc4;
            font-size: 19px;
        }

        .booking-tip strong {
            display: block;
            margin-bottom: 5px;
            color: #294f8c;
            font-size: 13px;
        }

        .booking-tip p {
            margin: 0;
            color: #6f7f99;
            font-size: 12px;
            line-height: 1.7;
        }

        .booking-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 25px;
        }

        .booking-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 45px;
            padding: 0 19px;
            border: 1px solid transparent;
            border-radius: 9px;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: background .2s, transform .2s, box-shadow .2s;
        }

        .booking-btn:hover {
            transform: translateY(-1px);
        }

        .booking-btn-primary {
            background: #2458a6;
            color: #fff;
            box-shadow: 0 4px 10px rgba(36, 88, 166, .15);
        }

        .booking-btn-primary:hover {
            background: #194887;
            box-shadow: 0 6px 15px rgba(36, 88, 166, .2);
        }

        .booking-btn-secondary {
            border-color: #dce3ed;
            background: #fff;
            color: #52617a;
        }

        .booking-btn-secondary:hover {
            background: #f7f9fc;
        }

        .booking-required-note {
            color: #8b96a8;
            font-size: 12px;
        }

        .booking-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .booking-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
            white-space: nowrap;
        }

        .booking-table th {
            padding: 15px 16px;
            border-bottom: 1px solid #e7edf5;
            background: #f7f9fc;
            color: #60708a;
            text-align: left;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .45px;
            text-transform: uppercase;
        }

        .booking-table td {
            padding: 16px;
            border-bottom: 1px solid #edf1f6;
            color: #52617a;
            vertical-align: middle;
        }

        .booking-table tbody tr:last-child td {
            border-bottom: none;
        }

        .booking-table tbody tr:hover {
            background: #f8faff;
        }

        .booking-table input[type="checkbox"] {
            width: 17px;
            height: 17px;
            accent-color: #2458a6;
            cursor: pointer;
        }

        .booking-room-number {
            color: #234f95;
            font-weight: 800;
        }

        .booking-room-type {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 6px;
            background: #f0f4fa;
            color: #52617a;
            font-size: 11px;
            font-weight: 700;
        }

        .booking-price {
            color: #1c754f !important;
            font-weight: 800;
        }

        .booking-table-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding: 15px 20px;
            border-top: 1px solid #edf1f6;
            background: #fbfcfe;
            color: #748198;
            font-size: 12px;
        }

        .booking-select-all {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #52617a;
            font-weight: 600;
            cursor: pointer;
        }

        .booking-select-all input {
            accent-color: #2458a6;
        }

        .booking-textarea {
            height: auto;
            min-height: 100px;
            padding: 12px 13px;
            resize: vertical;
            line-height: 1.6;
        }

        .booking-form-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            padding-top: 22px;
            margin-top: 22px;
            border-top: 1px solid #edf0f5;
        }

        .booking-form-footer p {
            margin: 0;
            color: #8591a4;
            font-size: 12px;
            line-height: 1.6;
        }

        .booking-footer-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        @media (max-width: 760px) {
            .booking-page {
                padding: 20px 14px 32px;
            }

            .booking-heading {
                align-items: flex-start;
            }

            .booking-heading h1 {
                font-size: 23px;
            }

            .booking-heading-badge {
                display: none;
            }

            .booking-card-header,
            .booking-card-body {
                padding: 18px;
            }

            .booking-form-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }

            .booking-field.full-width {
                grid-column: auto;
            }

            .booking-actions,
            .booking-form-footer {
                align-items: stretch;
                flex-direction: column;
            }

            .booking-btn {
                width: 100%;
            }

            .booking-footer-actions {
                width: 100%;
            }

            .booking-required-note {
                line-height: 1.6;
            }
        }
    </style>
</head>

<body>
<div class="booking-page">

    <nav class="booking-breadcrumb" aria-label="Điều hướng">
        <a href="${pageContext.request.contextPath}/">UTE Hotel</a>
        <span>/</span>
        <a href="${pageContext.request.contextPath}/dat-phong?action=list">
            Đặt phòng
        </a>
        <span>/</span>
        <span class="current">Tạo mới</span>
    </nav>

    <header class="booking-heading">
        <div class="booking-title-group">
            <div class="booking-title-icon" aria-hidden="true">&#128197;</div>
            <div>
                <h1>Tạo đặt phòng</h1>
                <p>Chọn thời gian lưu trú và tìm phòng phù hợp cho khách hàng.</p>
            </div>
        </div>

        <div class="booking-heading-badge">
            <span aria-hidden="true">&#9679;</span>
            ĐẶT PHÒNG MỚI
        </div>
    </header>

    <c:if test="${not empty error}">
        <div class="booking-alert error" role="alert">
            <span class="booking-alert-icon" aria-hidden="true">!</span>
            <div>
                <strong>Không thể thực hiện yêu cầu</strong>
                <div><c:out value="${error}"/></div>
            </div>
        </div>
    </c:if>

    <%-- Bước 1: Chọn thời gian và lọc phòng trống --%>
    <section class="booking-card">
        <div class="booking-card-header">
            <div class="booking-section-icon" aria-hidden="true">
                &#128197;
            </div>
            <div>
                <h2>01. Thông tin lưu trú</h2>
                <p>Xác định ngày nhận phòng, ngày trả phòng và loại phòng mong muốn.</p>
            </div>
        </div>

        <div class="booking-card-body">
            <form method="get"
                  action="${pageContext.request.contextPath}/dat-phong">

                <input type="hidden" name="action" value="available">

                <div class="booking-form-grid">
                    <div class="booking-field">
                        <label for="ngayNhan">
                            Ngày nhận phòng <span class="required">*</span>
                        </label>
                        <input class="booking-control"
                               type="date"
                               id="ngayNhan"
                               name="ngayNhan"
                               min="<c:out value="${homNay}"/>"
                               value="<c:out value="${ngayNhan}"/>"
                               required>
                        <small class="booking-help">
                            Ngày khách dự kiến bắt đầu lưu trú.
                        </small>
                    </div>

                    <div class="booking-field">
                        <label for="ngayTra">
                            Ngày trả phòng <span class="required">*</span>
                        </label>
                        <input class="booking-control"
                               type="date"
                               id="ngayTra"
                               name="ngayTra"
                               value="<c:out value="${ngayTra}"/>"
                               required>
                        <small class="booking-help">
                            Ngày khách dự kiến kết thúc lưu trú.
                        </small>
                    </div>

                    <div class="booking-field full-width">
                        <label for="maLoaiPhong">Loại phòng</label>
                        <select class="booking-control" id="maLoaiPhong"
                                name="maLoaiPhong">
                            <option value="">Tất cả loại phòng</option>
                            <c:forEach var="lp" items="${loaiPhongs}">
                                <option value="${lp.maLoaiPhong}"
                                    ${lp.maLoaiPhong == param.maLoaiPhong
                                      ? 'selected' : ''}>
                                    <c:out value="${lp.tenLoaiPhong}"/>
                                </option>
                            </c:forEach>
                        </select>
                        <small class="booking-help">
                            Để trống nếu muốn tìm tất cả loại phòng còn trống.
                        </small>
                    </div>
                </div>

                <div class="booking-tip">
                    <span class="booking-tip-icon" aria-hidden="true">
                        &#8505;
                    </span>
                    <div>
                        <strong>Kiểm tra tình trạng phòng</strong>
                        <p>
                            Hệ thống sẽ tìm phòng phù hợp với khoảng thời gian
                            và loại phòng bạn chọn. Bạn có thể chọn nhiều phòng
                            ở bước tiếp theo.
                        </p>
                    </div>
                </div>

                <div class="booking-actions">
                    <a class="booking-btn booking-btn-secondary"
                       href="${pageContext.request.contextPath}/dat-phong?action=list">
                        &#8592; Danh sách đặt phòng
                    </a>

                    <button class="booking-btn booking-btn-primary"
                            type="submit">
                        &#128269; Kiểm tra phòng trống
                        <span aria-hidden="true">&#8594;</span>
                    </button>
                </div>
            </form>
        </div>
    </section>

    <%-- Không có phòng phù hợp trong khoảng thời gian đã chọn --%>
    <c:if test="${not empty ngayNhan and not empty ngayTra
                  and empty error and empty phongOptions}">
        <div class="booking-alert info" role="status">
            <span class="booking-alert-icon" aria-hidden="true">
                &#8505;
            </span>
            <div>
                <strong>Chưa tìm thấy phòng phù hợp</strong>
                <div>
                    Không còn phòng trống phù hợp trong khoảng ngày đã chọn.
                    Bạn có thể thử khoảng thời gian hoặc loại phòng khác.
                </div>
            </div>
        </div>
    </c:if>

    <%-- Bước 2: Chọn khách hàng và các phòng cần đặt --%>
    <c:if test="${not empty phongOptions}">
        <section class="booking-card">
            <div class="booking-card-header">
                <div class="booking-section-icon" aria-hidden="true">
                    &#127976;
                </div>
                <div>
                    <h2>02. Chọn phòng và khách hàng</h2>
                    <p>
                        Chọn khách hàng, nhập số lượng khách và đánh dấu
                        các phòng muốn đặt.
                    </p>
                </div>
            </div>

            <div class="booking-card-body">
                <form method="post"
                      action="${pageContext.request.contextPath}/dat-phong"
                      id="createBookingForm">

                    <input type="hidden" name="ngayNhan" value="<c:out value="${ngayNhan}"/>">
                    <input type="hidden" name="ngayTra" value="<c:out value="${ngayTra}"/>">
                    <input type="hidden" name="maLoaiPhong"
                           value="<c:out value="${param.maLoaiPhong}"/>">

                    <div class="booking-form-grid">
                        <div class="booking-field">
                            <label for="maKH">
                                Khách hàng <span class="required">*</span>
                            </label>
                            <select class="booking-control"
                                    id="maKH" name="maKH">
                                <option value="">Chọn khách hàng</option>
                                <c:forEach var="kh" items="${khachHangs}">
                                    <option value="${kh.maKH}"
                                        ${kh.maKH == maKHDaChon ? 'selected' : ''}>
                                        <c:out value="${kh.maKH}"/> -
                                        <c:out value="${kh.hoTen}"/> -
                                        <c:out value="${kh.soDienThoai}"/>
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="booking-help">
                                Chọn khách hàng đứng tên đặt phòng, hoặc nhập khách mới ở dưới.
                            </small>
                        </div>

                        <div class="booking-field">
                            <label for="soLuongKhach">
                                Số lượng khách <span class="required">*</span>
                            </label>
                            <input class="booking-control"
                                   type="number"
                                   id="soLuongKhach"
                                   name="soLuongKhach"
                                   min="1"
                                   value="<c:out value="${param.soLuongKhach}"/>"
                                   placeholder="Nhập số lượng khách"
                                   required>
                            <small class="booking-help">
                                Hệ thống sử dụng thông tin này để kiểm tra sức chứa.
                            </small>
                        </div>
                    </div>

                    <div class="booking-form-grid">
                        <div class="booking-field">
                            <label for="hoTenMoi">Họ tên khách mới</label>
                            <input class="booking-control"
                                   type="text"
                                   id="hoTenMoi"
                                   name="hoTenMoi"
                                   maxlength="100"
                                   placeholder="Chỉ nhập khi khách chưa có trong danh sách">
                        </div>

                        <div class="booking-field">
                            <label for="soDienThoaiMoi">Số điện thoại khách mới</label>
                            <input class="booking-control"
                                   type="text"
                                   id="soDienThoaiMoi"
                                   name="soDienThoaiMoi"
                                   maxlength="15"
                                   placeholder="Số điện thoại không được trùng khách khác">
                            <small class="booking-help">
                                Nhập họ tên và số điện thoại để tạo nhanh khách hàng, không cần chọn ở ô trên.
                            </small>
                        </div>
                    </div>

                    <div style="margin-top:30px;">
                        <div style="display:flex; justify-content:space-between;
                                    align-items:center; gap:12px; flex-wrap:wrap;
                                    margin-bottom:15px;">
                            <div>
                                <h3 style="margin:0 0 5px; color:#172b4d;
                                           font-size:16px;">
                                    Danh sách phòng còn trống
                                </h3>
                                <p style="margin:0; color:#8390a5;
                                          font-size:12px;">
                                    Đánh dấu một hoặc nhiều phòng cần đặt.
                                </p>
                            </div>
                            <span class="booking-room-type">
                                <c:out value="${ngayNhan}"/> &rarr;
                                <c:out value="${ngayTra}"/>
                            </span>
                        </div>

                        <div class="booking-table-wrap"
                             style="border:1px solid #e7edf5;
                                    border-radius:10px;">
                            <table class="booking-table">
                                <thead>
                                <tr>
                                    <th>
                                        <label class="booking-select-all">
                                            <input type="checkbox"
                                                   id="selectAllRooms">
                                            Chọn
                                        </label>
                                    </th>
                                    <th>Số phòng</th>
                                    <th>Loại phòng</th>
                                    <th>Sức chứa</th>
                                    <th>Giá cơ bản</th>
                                    <th>Ngày nhận</th>
                                    <th>Ngày trả</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="p" items="${phongOptions}">
                                    <tr>
                                        <td>
                                            <input type="checkbox"
                                                   class="room-checkbox"
                                                   name="maPhong"
                                                   value="${p.maPhong}"
                                                   aria-label="Chọn phòng ${p.soPhong}">
                                        </td>
                                        <td>
                                            <span class="booking-room-number">
                                                <c:out value="${p.soPhong}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="booking-room-type">
                                                <c:out value="${p.tenLoaiPhong}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <c:out value="${p.soNguoiToiDa}"/> người
                                        </td>
                                        <td class="booking-price">
                                            <fmt:formatNumber
                                                value="${p.giaCoBan}"
                                                pattern="#,##0.##"/> đ
                                        </td>
                                        <td><c:out value="${ngayNhan}"/></td>
                                        <td><c:out value="${ngayTra}"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="booking-table-footer">
                            <span id="selectedRoomCount">
                                Chưa chọn phòng nào
                            </span>
                            <span>
                                Giá hiển thị là giá cơ bản của loại phòng.
                            </span>
                        </div>
                    </div>

                    <div class="booking-field" style="margin-top:26px;">
                        <label for="ghiChu">Ghi chú</label>
                        <textarea class="booking-control booking-textarea"
                                  id="ghiChu"
                                  name="ghiChu"
                                  rows="3"
                                  maxlength="500"
                                  placeholder="Nhập yêu cầu hoặc ghi chú cho đặt phòng (nếu có)..."></textarea>
                        <small class="booking-help">
                            Tối đa 500 ký tự.
                        </small>
                    </div>

                    <div class="booking-form-footer">
                        <p>
                            <span class="required">*</span>
                            Thông tin bắt buộc. Vui lòng kiểm tra trước khi tạo đặt phòng.
                        </p>

                        <div class="booking-footer-actions">
                            <a class="booking-btn booking-btn-secondary"
                               href="${pageContext.request.contextPath}/dat-phong?action=list">
                                Hủy
                            </a>
                            <button class="booking-btn booking-btn-primary"
                                    type="submit">
                                &#10003; Tạo đặt phòng
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </section>
    </c:if>

</div>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

<script>
(function () {
    const dateFrom = document.getElementById('ngayNhan');
    const dateTo = document.getElementById('ngayTra');

    if (dateFrom && dateTo) {
        dateFrom.addEventListener('change', function () {
            dateTo.min = dateFrom.value || '';
            if (dateTo.value && dateFrom.value && dateTo.value <= dateFrom.value) {
                dateTo.value = '';
            }
        });

        dateTo.addEventListener('change', function () {
            if (dateFrom.value && dateTo.value && dateTo.value <= dateFrom.value) {
                dateTo.setCustomValidity('Ngày trả phòng phải sau ngày nhận phòng.');
            } else {
                dateTo.setCustomValidity('');
            }
        });
    }

    // Khách hàng: chọn khách có sẵn HOẶC nhập khách mới (họ tên + số điện thoại)
    const customerSelect = document.getElementById('maKH');
    const newName = document.getElementById('hoTenMoi');
    const newPhone = document.getElementById('soDienThoaiMoi');

    function syncCustomerFields() {
        if (!customerSelect || !newName || !newPhone) {
            return;
        }
        const hasNew = newName.value.trim() !== '' || newPhone.value.trim() !== '';
        customerSelect.required = !hasNew;
        newName.required = hasNew;
        newPhone.required = hasNew;
    }

    if (customerSelect && newName && newPhone) {
        newName.addEventListener('input', syncCustomerFields);
        newPhone.addEventListener('input', syncCustomerFields);
        syncCustomerFields();
    }

    const selectAll = document.getElementById('selectAllRooms');
    const roomCheckboxes = Array.from(
        document.querySelectorAll('.room-checkbox')
    );
    const selectedCount = document.getElementById('selectedRoomCount');
    const bookingForm = document.getElementById('createBookingForm');

    function updateRoomSelection() {
        const checkedCount = roomCheckboxes.filter(function (checkbox) {
            return checkbox.checked;
        }).length;

        if (selectedCount) {
            selectedCount.textContent = checkedCount === 0
                ? 'Chưa chọn phòng nào'
                : 'Đã chọn ' + checkedCount + ' phòng';
        }

        if (selectAll) {
            selectAll.checked = roomCheckboxes.length > 0
                && checkedCount === roomCheckboxes.length;
            selectAll.indeterminate = checkedCount > 0
                && checkedCount < roomCheckboxes.length;
        }
    }

    if (selectAll) {
        selectAll.addEventListener('change', function () {
            roomCheckboxes.forEach(function (checkbox) {
                checkbox.checked = selectAll.checked;
            });
            updateRoomSelection();
        });
    }

    roomCheckboxes.forEach(function (checkbox) {
        checkbox.addEventListener('change', updateRoomSelection);
    });

    if (bookingForm) {
        bookingForm.addEventListener('submit', function (event) {
            const hasSelectedRoom = roomCheckboxes.some(function (checkbox) {
                return checkbox.checked;
            });

            if (!hasSelectedRoom) {
                event.preventDefault();
                alert('Vui lòng chọn ít nhất một phòng trước khi tạo đặt phòng.');
            }
        });
    }

    updateRoomSelection();
})();
</script>
</body>
</html>