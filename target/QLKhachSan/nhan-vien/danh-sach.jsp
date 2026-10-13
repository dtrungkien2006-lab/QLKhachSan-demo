<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhân viên | Horizon Hotel</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

    <style>
        .staff-page {
            max-width: 1450px;
            width: 100%;
            margin: 0 auto;
            padding: 28px 30px 45px;
            color: #172b4d;
            box-sizing: border-box;
        }

        .staff-page *,
        .staff-page *::before,
        .staff-page *::after {
            box-sizing: border-box;
        }

        .staff-breadcrumb {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 23px;
            color: #8390a5;
            font-size: 13px;
        }

        .staff-breadcrumb a {
            color: #64748b;
            text-decoration: none;
        }

        .staff-breadcrumb a:hover {
            color: #2458a6;
        }

        .staff-breadcrumb strong {
            color: #172b4d;
        }

        .staff-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 27px;
        }

        .staff-title-group {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .staff-title-icon {
            width: 56px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            border-radius: 15px;
            background: #e8efff;
            color: #2458a6;
            font-size: 25px;
        }

        .staff-heading h1 {
            margin: 0 0 7px;
            color: #172b4d;
            font-size: 26px;
            font-weight: 750;
            letter-spacing: -.5px;
        }

        .staff-heading p {
            margin: 0;
            color: #8390a5;
            font-size: 13px;
            line-height: 1.6;
        }

        .staff-btn {
            min-height: 43px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 0 17px;
            border: 1px solid transparent;
            border-radius: 9px;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: .2s ease;
        }

        .staff-btn:hover {
            transform: translateY(-1px);
        }

        .staff-btn-primary {
            background: #2458a6;
            color: #fff;
            box-shadow: 0 4px 12px rgba(36, 88, 166, .15);
        }

        .staff-btn-primary:hover {
            background: #194887;
            color: #fff;
        }

        .staff-btn-secondary {
            border-color: #dce4ef;
            background: #fff;
            color: #52617a;
        }

        .staff-btn-secondary:hover {
            background: #f5f8fc;
        }

        .staff-alert {
            margin-bottom: 20px;
            padding: 14px 17px;
            border: 1px solid;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.6;
        }

        .staff-alert.success {
            border-color: #bbf7d0;
            background: #ecfdf5;
            color: #166534;
        }

        .staff-alert.error {
            border-color: #fecdd3;
            background: #fff1f2;
            color: #a42b36;
        }

        .staff-stat-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 17px;
            margin-bottom: 24px;
        }

        .staff-stat-card {
            display: flex;
            align-items: center;
            gap: 15px;
            min-width: 0;
            padding: 21px;
            border: 1px solid #e3e9f2;
            border-radius: 13px;
            background: #fff;
            box-shadow: 0 3px 12px rgba(27, 52, 91, .035);
        }

        .staff-stat-icon {
            width: 46px;
            height: 46px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            border-radius: 12px;
            font-size: 21px;
        }

        .staff-stat-icon.blue {
            background: #e8efff;
            color: #2458a6;
        }

        .staff-stat-icon.green {
            background: #dcfce7;
            color: #15803d;
        }

        .staff-stat-icon.orange {
            background: #fff0d8;
            color: #b76e0b;
        }

        .staff-stat-label {
            margin-bottom: 5px;
            color: #8390a5;
            font-size: 12px;
        }

        .staff-stat-value {
            color: #172b4d;
            font-size: 25px;
            font-weight: 800;
        }

        .staff-card {
            overflow: visible;
            border: 1px solid #e3e9f2;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 4px 18px rgba(27, 52, 91, .04);
        }

        .staff-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            padding: 22px 24px;
            border-bottom: 1px solid #edf0f5;
        }

        .staff-card-header h2 {
            margin: 0 0 5px;
            color: #172b4d;
            font-size: 17px;
            font-weight: 750;
        }

        .staff-card-header p {
            margin: 0;
            color: #8390a5;
            font-size: 12px;
        }

        .staff-total-badge {
            padding: 7px 11px;
            border-radius: 8px;
            background: #eef4ff;
            color: #2458a6;
            font-size: 12px;
            font-weight: 700;
        }

        .staff-filters {
            display: grid;
            grid-template-columns: minmax(200px, 1fr) 190px 190px;
            gap: 12px;
            padding: 20px 24px;
            border-bottom: 1px solid #edf0f5;
        }

        .staff-search {
            position: relative;
        }

        .staff-search-icon {
            position: absolute;
            top: 50%;
            left: 13px;
            transform: translateY(-50%);
            color: #8b98ac;
            font-size: 17px;
            pointer-events: none;
        }

        .staff-control {
            display: block;
            width: 100%;
            min-width: 0;
            height: 43px;
            padding: 0 12px;
            border: 1px solid #dce4ef;
            border-radius: 8px;
            outline: none;
            background: #fff;
            color: #34445e;
            font-family: inherit;
            font-size: 13px;
        }

        .staff-search .staff-control {
            padding-left: 39px;
        }

        .staff-control:focus {
            border-color: #5286e5;
            box-shadow: 0 0 0 3px rgba(67, 120, 218, .10);
        }

        .staff-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .staff-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
        }

        .staff-table th {
            padding: 15px 17px;
            background: #f7f9fc;
            border-bottom: 1px solid #e7edf5;
            color: #64748b;
            text-align: left;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .35px;
            white-space: nowrap;
        }

        .staff-table td {
            padding: 16px 17px;
            border-bottom: 1px solid #edf1f6;
            color: #52617a;
            vertical-align: middle;
        }

        .staff-table tbody tr:last-child td {
            border-bottom: none;
        }

        .staff-table tbody tr:hover {
            background: #f9fbff;
        }

        .staff-identity {
            display: flex;
            align-items: center;
            gap: 11px;
            min-width: 180px;
        }

        .staff-avatar {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            border-radius: 12px;
            background: #e8efff;
            color: #2458a6;
            font-size: 13px;
            font-weight: 800;
        }

        .staff-identity-name {
            margin-bottom: 4px;
            color: #233650;
            font-weight: 700;
        }

        .staff-identity-code {
            color: #8b98ac;
            font-size: 11px;
        }

        .staff-contact {
            min-width: 130px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .staff-email {
            min-width: 170px;
            overflow-wrap: anywhere;
        }

        .staff-role {
            display: inline-block;
            padding: 6px 9px;
            border: 1px solid #dbe7ff;
            border-radius: 7px;
            background: #f0f5ff;
            color: #2458a6;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .staff-status {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 6px 9px;
            border-radius: 7px;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .staff-status::before {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
            content: "";
        }

        .staff-status.active {
            background: #ecfdf3;
            color: #16804a;
        }

        .staff-status.locked {
            background: #fff1f2;
            color: #b42332;
        }

        .staff-actions {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 7px;
            min-width: 250px;
        }

        .staff-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 31px;
            padding: 0 9px;
            border: 1px solid #e0e6ef;
            border-radius: 7px;
            background: #fff;
            color: #52617a;
            font-size: 11px;
            font-weight: 650;
            text-decoration: none;
            white-space: nowrap;
            transition: .15s ease;
        }

        .staff-action:hover {
            border-color: #b9cef4;
            background: #f0f5ff;
            color: #2458a6;
        }

        .staff-action.danger {
            border-color: #f5d4d7;
            color: #b42332;
        }

        .staff-action.danger:hover {
            background: #fff1f2;
            border-color: #eab3b9;
        }

        .staff-action.unlock {
            border-color: #b9e8cd;
            color: #16804a;
        }

        .staff-action.unlock:hover {
            background: #ecfdf3;
        }

        .staff-empty {
            padding: 48px 20px !important;
            text-align: center;
            color: #8390a5 !important;
        }

        .staff-empty-icon {
            display: block;
            margin-bottom: 10px;
            font-size: 30px;
        }

        .staff-card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            padding: 15px 24px;
            border-top: 1px solid #edf0f5;
            background: #fbfcfe;
            border-radius: 0 0 14px 14px;
            color: #8390a5;
            font-size: 12px;
        }

        .staff-no-results {
            display: none;
            padding: 24px;
            color: #8390a5;
            text-align: center;
            font-size: 13px;
        }

        @media (max-width: 1000px) {
            .staff-page {
                padding: 22px 18px 35px;
            }

            .staff-filters {
                grid-template-columns: 1fr 1fr;
            }

            .staff-search {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 600px) {
            .staff-page {
                padding: 18px 12px 28px;
            }

            .staff-heading h1 {
                font-size: 22px;
            }

            .staff-stat-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .staff-stat-card {
                padding: 15px;
            }

            .staff-filters {
                grid-template-columns: 1fr;
                padding: 15px;
            }

            .staff-search {
                grid-column: auto;
            }

            .staff-card-header {
                padding: 18px 15px;
            }

            .staff-card-footer {
                padding: 14px 15px;
            }

            .staff-heading > .staff-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="staff-page">

    <nav class="staff-breadcrumb" aria-label="Điều hướng">
        <a href="${pageContext.request.contextPath}/">Horizon Hotel</a>
        <span>/</span>
        <strong>Nhân viên</strong>
    </nav>

    <header class="staff-heading">
        <div class="staff-title-group">
            <div class="staff-title-icon" aria-hidden="true">&#128101;</div>
            <div>
                <h1>Quản lý nhân viên</h1>
                <p>Quản lý hồ sơ nhân sự, tài khoản và quyền truy cập hệ thống.</p>
            </div>
        </div>

        <a class="staff-btn staff-btn-primary"
           href="${pageContext.request.contextPath}/nhan-vien?action=new">
            <span aria-hidden="true">+</span> Thêm nhân viên
        </a>
    </header>

    <c:if test="${not empty param.success}">
        <div class="staff-alert success" role="status">
            &#10003; Thao tác thành công.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="staff-alert error" role="alert">
            &#9888; <c:out value="${error}"/>
        </div>
    </c:if>

    <%-- Thống kê được tính từ danh sách đang được servlet cung cấp --%>
    <c:set var="totalStaff" value="0"/>
    <c:set var="activeStaff" value="0"/>
    <c:set var="lockedStaff" value="0"/>

    <c:forEach var="staff" items="${items}">
        <c:set var="totalStaff" value="${totalStaff + 1}"/>
        <c:choose>
            <c:when test="${staff.taiKhoan.trangThai == 'HOAT_DONG'}">
                <c:set var="activeStaff" value="${activeStaff + 1}"/>
            </c:when>
            <c:otherwise>
                <c:set var="lockedStaff" value="${lockedStaff + 1}"/>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <section class="staff-stat-grid">
        <div class="staff-stat-card">
            <div class="staff-stat-icon blue" aria-hidden="true">&#128101;</div>
            <div>
                <div class="staff-stat-label">Tổng nhân viên</div>
                <div class="staff-stat-value">
                    <c:out value="${totalStaff}"/>
                </div>
            </div>
        </div>

        <div class="staff-stat-card">
            <div class="staff-stat-icon green" aria-hidden="true">&#10003;</div>
            <div>
                <div class="staff-stat-label">Tài khoản hoạt động</div>
                <div class="staff-stat-value">
                    <c:out value="${activeStaff}"/>
                </div>
            </div>
        </div>

        <div class="staff-stat-card">
            <div class="staff-stat-icon orange" aria-hidden="true">&#128274;</div>
            <div>
                <div class="staff-stat-label">Tài khoản đã khóa</div>
                <div class="staff-stat-value">
                    <c:out value="${lockedStaff}"/>
                </div>
            </div>
        </div>
    </section>

    <section class="staff-card">
        <div class="staff-card-header">
            <div>
                <h2>Danh sách nhân viên</h2>
                <p>Tra cứu thông tin và thực hiện thao tác quản lý tài khoản.</p>
            </div>
            <span class="staff-total-badge">
                <c:out value="${totalStaff}"/> nhân viên
            </span>
        </div>

        <div class="staff-filters">
            <div class="staff-search">
                <span class="staff-search-icon" aria-hidden="true">&#128269;</span>
                <input class="staff-control"
                       type="search"
                       id="staffSearch"
                       placeholder="Tìm mã, họ tên, số điện thoại, email..."
                       aria-label="Tìm kiếm nhân viên">
            </div>

            <select class="staff-control" id="roleFilter"
                    aria-label="Lọc theo vai trò">
                <option value="">Tất cả vai trò</option>
                <option value="ADMIN">Quản trị viên</option>
                <option value="QUAN_LY">Quản lý</option>
                <option value="LE_TAN">Lễ tân</option>
            </select>

            <select class="staff-control" id="statusFilter"
                    aria-label="Lọc theo trạng thái">
                <option value="">Tất cả trạng thái</option>
                <option value="HOAT_DONG">Hoạt động</option>
                <option value="DA_KHOA">Đã khóa</option>
            </select>
        </div>

        <div class="staff-table-wrap">
            <table class="staff-table">
                <thead>
                <tr>
                    <th>Nhân viên</th>
                    <th>Liên hệ</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Trạng thái tài khoản</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody id="staffTableBody">
                <c:forEach var="item" items="${items}">
                    <tr class="staff-row"
                        data-search="${item.maNV} ${item.hoTen} ${item.soDienThoai} ${item.email}"
                        data-role="${item.taiKhoan.vaiTro}"
                        data-status="${item.taiKhoan.trangThai}">

                        <td>
                            <div class="staff-identity">
                                <div class="staff-avatar" aria-hidden="true">
                                    <c:out value="${item.hoTen.substring(0, 1)}"/>
                                </div>
                                <div>
                                    <div class="staff-identity-name">
                                        <c:out value="${item.hoTen}"/>
                                    </div>
                                    <div class="staff-identity-code">
                                        Mã NV: <c:out value="${item.maNV}"/>
                                    </div>
                                </div>
                            </div>
                        </td>

                        <td>
                            <div class="staff-contact">
                                <c:out value="${item.soDienThoai}"/>
                            </div>
                        </td>

                        <td>
                            <div class="staff-email">
                                <c:out value="${item.email}"/>
                            </div>
                        </td>

                        <td>
                            <span class="staff-role">
                                <c:out value="${item.taiKhoan.vaiTro}"/>
                            </span>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${item.taiKhoan.trangThai == 'HOAT_DONG'}">
                                    <span class="staff-status active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="staff-status locked">Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <div class="staff-actions">
                                <a class="staff-action"
                                   href="${pageContext.request.contextPath}/nhan-vien?action=detail&id=${item.maNV}">
                                    Chi tiết
                                </a>

                                <a class="staff-action"
                                   href="${pageContext.request.contextPath}/nhan-vien?action=edit&id=${item.maNV}">
                                    Sửa
                                </a>

                                <a class="staff-action"
                                   href="${pageContext.request.contextPath}/nhan-vien?action=role&id=${item.maNV}">
                                    Vai trò
                                </a>

                                <a class="staff-action"
                                   href="${pageContext.request.contextPath}/nhan-vien?action=password&id=${item.maNV}">
                                    Mật khẩu
                                </a>

                                <a class="staff-action ${item.taiKhoan.trangThai == 'HOAT_DONG' ? 'danger' : 'unlock'}"
                                   href="${pageContext.request.contextPath}/nhan-vien?action=toggle&id=${item.maNV}"
                                   onclick="return confirm('Bạn có chắc muốn ${item.taiKhoan.trangThai == 'HOAT_DONG' ? 'khóa' : 'mở khóa'} tài khoản này?')">
                                    <c:choose>
                                        <c:when test="${item.taiKhoan.trangThai == 'HOAT_DONG'}">
                                            Khóa
                                        </c:when>
                                        <c:otherwise>
                                            Mở khóa
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty items}">
                    <tr>
                        <td colspan="6" class="staff-empty">
                            <span class="staff-empty-icon" aria-hidden="true">&#128101;</span>
                            <strong>Chưa có dữ liệu nhân viên</strong>
                            <div style="margin-top:8px;">
                                Hãy thêm nhân viên để bắt đầu quản lý.
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <div id="staffNoResults" class="staff-no-results">
            Không tìm thấy nhân viên phù hợp với điều kiện lọc.
        </div>

        <div class="staff-card-footer">
            <span id="staffVisibleCount">
                Hiển thị <c:out value="${totalStaff}"/> nhân viên
            </span>
            <span>Dữ liệu theo danh sách hiện tại của hệ thống.</span>
        </div>
    </section>
</div>

<script src="${pageContext.request.contextPath}/js/shared-layout.js"
        defer></script>

<script>
(function () {
    const searchInput = document.getElementById('staffSearch');
    const roleFilter = document.getElementById('roleFilter');
    const statusFilter = document.getElementById('statusFilter');
    const rows = Array.from(document.querySelectorAll('.staff-row'));
    const noResults = document.getElementById('staffNoResults');
    const visibleCount = document.getElementById('staffVisibleCount');

    function filterStaff() {
        const keyword = (searchInput.value || '').trim().toLocaleLowerCase('vi');
        const role = roleFilter.value;
        const status = statusFilter.value;
        let visible = 0;

        rows.forEach(function (row) {
            const searchText = (row.dataset.search || '').toLocaleLowerCase('vi');
            const matchesKeyword = searchText.includes(keyword);
            const matchesRole = !role || row.dataset.role === role;
            const matchesStatus = !status || row.dataset.status === status;
            const show = matchesKeyword && matchesRole && matchesStatus;

            row.style.display = show ? '' : 'none';

            if (show) {
                visible++;
            }
        });

        noResults.style.display =
            rows.length > 0 && visible === 0 ? 'block' : 'none';

        visibleCount.textContent = 'Đang hiển thị ' + visible
            + ' / ' + rows.length + ' nhân viên';
    }

    searchInput.addEventListener('input', filterStaff);
    roleFilter.addEventListener('change', filterStaff);
    statusFilter.addEventListener('change', filterStaff);
})();
</script>
</body>
</html>