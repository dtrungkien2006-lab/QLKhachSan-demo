(function () {
    const script = document.currentScript;

    if (!script) return;

    const scriptPath = new URL(script.src, window.location.href).pathname;
    const contextPath = scriptPath.replace(/\/js\/shared-layout\.js$/, '');
    const path = window.location.pathname.substring(contextPath.length) || '/';

    const links = [
        {
            label: 'Dashboard',
            icon: '▦',
            href: '/',
            match: p => p === '/' || p === '/index.jsp'
        },
        {
            label: 'Quản lý phòng',
            icon: '▤',
            href: '/phong',
            match: p => p.startsWith('/phong')
        },
        {
            label: 'Loại phòng',
            icon: '▧',
            href: '/loai-phong',
            match: p => p.startsWith('/loai-phong')
        },
        {
            label: 'Đặt phòng',
            icon: '▣',
            href: '/dat-phong?action=list',
            match: p => p.startsWith('/dat-phong')
        },
        {
            label: 'Khách hàng',
            icon: '♙',
            href: '/khach-hang',
            match: p => p.startsWith('/khach-hang')
        },
        {
            label: 'Dịch vụ',
            icon: '✧',
            href: '/dich-vu',
            match: p => p.startsWith('/dich-vu')
        },
        {
            label: 'Sử dụng dịch vụ',
            icon: '🛎',
            href: '/su-dung-dich-vu',
            match: p => p.startsWith('/su-dung-dich-vu')
        },
        {
            label: 'Hóa đơn',
            icon: '▧',
            href: '/hoa-don',
            match: p => p.startsWith('/hoa-don')
        },
        {
            label: 'Thanh toán',
            icon: '＄',
            href: '/thanh-toan',
            match: p => p.startsWith('/thanh-toan')
        },
        {
            label: 'Nhân viên',
            icon: '♧',
            href: '/nhan-vien',
            match: p => p.startsWith('/nhan-vien')
        },
        {
            label: 'Báo cáo',
            icon: '📊',
            href: '/bao-cao',
            match: p => p.startsWith('/bao-cao')
        },
        {
            label: 'Thống kê',
            icon: '📈',
            href: '/thong-ke',
            match: p => p.startsWith('/thong-ke')
        }
    ];

    function sidebarHtml() {
        const nav = links.map(item => `
            <a class="nav-link ${item.match(path) ? 'active' : ''}"
               href="${contextPath}${item.href}">
                <span class="nav-icon">${item.icon}</span>
                <span>${item.label}</span>
            </a>
        `).join('');

        return `
            <a class="brand" href="${contextPath}/">
                <span class="brand-mark">UTE</span>
                <span>
                    <span class="brand-name">UTE Hotel</span>
                    <br>
                    <span class="brand-sub">HOTEL MANAGEMENT</span>
                </span>
            </a>

            <div class="nav-label">Hệ thống</div>

            <nav class="nav-list">
                ${nav}
            </nav>

            <div class="sidebar-foot">
                Hệ thống quản lý khách sạn
                <a class="logout" href="${contextPath}/logout">
                    ↪ Đăng xuất
                </a>
            </div>
        `;
    }

    function topbarHtml() {
        const current = links.find(item => item.match(path));

        return `
            <div class="crumb">
                UTE Hotel /
                <strong>${current ? current.label : 'Quản lý'}</strong>
            </div>

            <div class="topbar-actions">
                <span class="topbar-system-name">
                    Hệ thống quản lý khách sạn
                </span>

                <a class="topbar-logout"
                   href="${contextPath}/logout"
                   onclick="return confirm('Bạn có chắc chắn muốn đăng xuất?')">
                    <span aria-hidden="true">↪</span>
                    Đăng xuất
                </a>
            </div>
        `;
    }

    function loadTopbarUser() {
        const nameEl = document.querySelector('.topbar-user-name');
        const metaEl = document.querySelector('.topbar-user-meta');
        const avatarEl = document.querySelector('.topbar-avatar');

        if (!nameEl || !metaEl || !avatarEl) return;

        fetch(`${contextPath}/session-info`, {
            method: 'GET',
            credentials: 'same-origin',
            headers: {
                'Accept': 'application/json'
            },
            cache: 'no-store'
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Không lấy được thông tin đăng nhập');
            }

            return response.json();
        })
        .then(user => {
            if (!user.authenticated) {
                nameEl.textContent = 'Chưa đăng nhập';
                metaEl.textContent = '';
                avatarEl.textContent = 'H';
                return;
            }

            const hoTen = user.hoTen || 'Nhân viên';
            const maNV = user.maNV || '';
            const vaiTro = user.vaiTro || '';

            nameEl.textContent = hoTen;
            metaEl.textContent =
                `Mã NV: ${maNV} · ${vaiTro}`;

            avatarEl.textContent =
                hoTen.trim().charAt(0).toUpperCase() || 'H';
        })
        .catch(error => {
            console.error('Lỗi tải thông tin nhân viên:', error);
            nameEl.textContent = 'Không tải được thông tin';
            metaEl.textContent = '';
            avatarEl.textContent = 'H';
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (path.startsWith('/login')) return;

        let shell = document.querySelector('.app-shell');
        let sidebar = document.querySelector('.sidebar');
        let main = document.querySelector('.main');
        let topbar = document.querySelector('.topbar');
        let page = document.querySelector('.page');

        // Nếu trang chưa có khung dùng chung thì tạo khung.
        if (!shell || !sidebar || !main) {
            const body = document.body;

            shell = document.createElement('div');
            shell.className = 'app-shell';

            sidebar = document.createElement('aside');
            sidebar.className = 'sidebar';

            main = document.createElement('main');
            main.className = 'main';

            topbar = document.createElement('header');
            topbar.className = 'topbar';

            page = document.createElement('div');
            page.className = 'page';

            // Giữ nguyên nội dung nghiệp vụ và không chuyển
            // script shared-layout.js vào vùng nội dung.
            Array.from(body.childNodes).forEach(node => {
                if (
                    node.nodeType === 1 &&
                    node.tagName === 'SCRIPT' &&
                    node.src &&
                    node.src.includes('/js/shared-layout.js')
                ) {
                    return;
                }

                page.appendChild(node);
            });

            shell.appendChild(sidebar);
            shell.appendChild(main);
            main.appendChild(topbar);
            main.appendChild(page);

            body.appendChild(shell);
        } else {
            page = page || main.querySelector('.page');

            if (!page) {
                page = document.createElement('div');
                page.className = 'page';

                Array.from(main.childNodes).forEach(node => {
                    if (node !== topbar) {
                        page.appendChild(node);
                    }
                });

                main.appendChild(page);
            }
        }

        // Cập nhật menu sidebar.
        sidebar.innerHTML = sidebarHtml();

        // Tạo topbar nếu trang chưa có.
        if (!topbar) {
            topbar = document.createElement('header');
            topbar.className = 'topbar';
            main.insertBefore(topbar, main.firstChild);
        }

        // Cập nhật nội dung topbar.
        topbar.innerHTML = topbarHtml();

        // Nạp CSS dùng chung nếu chưa được nạp.
        const cssUrl = `${contextPath}/css/app.css`;

        const hasCss = Array.from(
            document.querySelectorAll('link[rel="stylesheet"]')
        ).some(link => {
            return new URL(link.href, window.location.href).pathname === cssUrl;
        });

        if (!hasCss) {
            const css = document.createElement('link');
            css.rel = 'stylesheet';
            css.href = cssUrl;
            document.head.appendChild(css);
        }

        // Lấy thông tin nhân viên từ session thông qua Servlet.
        loadTopbarUser();
    });
})();