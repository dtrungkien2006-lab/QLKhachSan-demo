<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật thông tin nhân viên | UTE Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .nv-form-page {
            max-width: 1120px;
            margin: 0 auto;
            padding: 30px 32px 40px;
            color: #172b43;
        }

        .nv-form-breadcrumb {
            margin-bottom: 24px;
            color: #64748b;
            font-size: 13px;
        }

        .nv-form-breadcrumb strong {
            color: #0f766e;
        }

        .nv-form-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .nv-form-heading h1 {
            margin: 0 0 8px;
            color: #172b43;
            font-size: 27px;
            font-weight: 750;
        }

        .nv-form-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }

        .nv-form-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            padding: 10px 17px;
            border: 1px solid #dbe3ed;
            border-radius: 9px;
            background: #fff;
            color: #334155;
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
            cursor: pointer;
            transition: .2s ease;
        }

        .nv-form-btn:hover {
            border-color: #0f766e;
            background: #f0fdfa;
            color: #0f766e;
        }

        .nv-form-btn-primary {
            border-color: #0f766e;
            background: #0f766e;
            color: #fff;
        }

        .nv-form-btn-primary:hover {
            border-color: #115e59;
            background: #115e59;
            color: #fff;
        }

        .nv-form-card {
            overflow: hidden;
            border: 1px solid #e5eaf1;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 5px 18px rgba(15, 23, 42, .045);
        }

        .nv-form-card-header {
            padding: 24px 30px;
            background: linear-gradient(120deg, #10243b, #164e63);
            color: #fff;
        }

        .nv-form-card-header h2 {
            margin: 0 0 7px;
            font-size: 18px;
            font-weight: 700;
        }

        .nv-form-card-header p {
            margin: 0;
            color: #d5e7ef;
            font-size: 14px;
            line-height: 1.6;
        }

        .nv-form-card-body {
            padding: 28px 30px 30px;
        }

        .nv-form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 20px;
            color: #172b43;
            font-size: 16px;
            font-weight: 700;
        }

        .nv-form-section-title::before {
            content: "";
            width: 4px;
            height: 20px;
            border-radius: 4px;
            background: #0f766e;
        }

        .nv-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px 24px;
        }

        .nv-form-field {
            min-width: 0;
        }

        .nv-form-field-full {
            grid-column: 1 / -1;
        }

        .nv-form-label {
            display: block;
            margin-bottom: 9px;
            color: #334155;
            font-size: 13px;
            font-weight: 650;
        }

        .nv-form-required {
            color: #dc2626;
        }

        .nv-form-control {
            box-sizing: border-box;
            display: block;
            width: 100%;
            min-height: 45px;
            padding: 10px 13px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            background: #fff;
            color: #172b43;
            font-family: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .nv-form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .nv-form-control::placeholder {
            color: #94a3b8;
        }

        .nv-form-help {
            margin-top: 7px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.5;
        }

        .nv-form-alert {
            margin-bottom: 22px;
            padding: 13px 15px;
            border: 1px solid #fecaca;
            border-radius: 9px;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 14px;
        }

        .nv-form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #edf1f5;
        }

        @media (max-width: 700px) {
            .nv-form-page {
                padding: 20px 14px 30px;
            }

            .nv-form-card-header,
            .nv-form-card-body {
                padding: 21px 18px;
            }

            .nv-form-grid {
                grid-template-columns: 1fr;
                gap: 19px;
            }

            .nv-form-field-full {
                grid-column: auto;
            }

            .nv-form-actions {
                flex-direction: column-reverse;
                align-items: stretch;
            }

            .nv-form-btn {
                width: 100%;
                box-sizing: border-box;
            }
        }
    </style>
</head>

<body>

<main class="nv-form-page">

    <div class="nv-form-breadcrumb">
        UTE Hotel / Nhân viên / <strong>Cập nhật thông tin</strong>
    </div>

    <div class="nv-form-heading">
        <div>
            <h1>Cập nhật thông tin nhân viên</h1>
            <p>Chỉnh sửa thông tin cá nhân của nhân viên trong hệ thống.</p>
        </div>

        <a class="nv-form-btn"
           href="${pageContext.request.contextPath}/nhan-vien?action=list">
            &#8592; Danh sách nhân viên
        </a>
    </div>

    <section class="nv-form-card">

        <header class="nv-form-card-header">
            <h2>Thông tin nhân viên</h2>
            <p>Vui lòng kiểm tra thông tin trước khi lưu thay đổi.</p>
        </header>

        <div class="nv-form-card-body">

            <c:if test="${not empty error}">
                <div class="nv-form-alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <h3 class="nv-form-section-title">Thông tin cá nhân</h3>

            <form method="post"
                  action="${pageContext.request.contextPath}/nhan-vien?action=edit">

                <input type="hidden"
                       name="id"
                       value="<c:out value='${item.maNV}'/>">

                <div class="nv-form-grid">

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="hoTen">
                            Họ và tên <span class="nv-form-required">*</span>
                        </label>
                        <input class="nv-form-control"
                               type="text"
                               id="hoTen"
                               name="hoTen"
                               value="<c:out value='${item.hoTen}'/>"
                               placeholder="Nhập họ và tên"
                               maxlength="100"
                               required>
                    </div>

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="ngaySinh">
                            Ngày sinh <span class="nv-form-required">*</span>
                        </label>
                        <input class="nv-form-control"
                               type="date"
                               id="ngaySinh"
                               name="ngaySinh"
                               value="${item.ngaySinh}"
                               required>
                    </div>

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="gioiTinh">
                            Giới tính <span class="nv-form-required">*</span>
                        </label>
                        <select class="nv-form-control"
                                id="gioiTinh"
                                name="gioiTinh"
                                required>
                            <option value="NAM"
                                ${item.gioiTinh == 'NAM' ? 'selected' : ''}>
                                Nam
                            </option>
                            <option value="NU"
                                ${item.gioiTinh == 'NU' ? 'selected' : ''}>
                                Nữ
                            </option>
                        </select>
                    </div>

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="soDienThoai">
                            Số điện thoại <span class="nv-form-required">*</span>
                        </label>
                        <input class="nv-form-control"
                               type="tel"
                               id="soDienThoai"
                               name="soDienThoai"
                               value="<c:out value='${item.soDienThoai}'/>"
                               placeholder="Nhập số điện thoại"
                               maxlength="15"
                               required>
                    </div>

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="email">
                            Email <span class="nv-form-required">*</span>
                        </label>
                        <input class="nv-form-control"
                               type="email"
                               id="email"
                               name="email"
                               value="<c:out value='${item.email}'/>"
                               placeholder="example@hotel.com"
                               maxlength="150"
                               required>
                    </div>

                    <div class="nv-form-field">
                        <label class="nv-form-label" for="diaChi">
                            Địa chỉ <span class="nv-form-required">*</span>
                        </label>
                        <input class="nv-form-control"
                               type="text"
                               id="diaChi"
                               name="diaChi"
                               value="<c:out value='${item.diaChi}'/>"
                               placeholder="Nhập địa chỉ"
                               maxlength="255"
                               required>
                    </div>

                </div>

                <div class="nv-form-actions">
                    <a class="nv-form-btn"
                       href="${pageContext.request.contextPath}/nhan-vien?action=list">
                        Hủy
                    </a>

                    <button class="nv-form-btn nv-form-btn-primary"
                            type="submit">
                        &#10003; Lưu thay đổi
                    </button>
                </div>

            </form>
        </div>
    </section>
</main>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

</body>
</html>