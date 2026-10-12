# Nhật ký thay đổi – Đồng bộ giao diện

Ngày: 2026-10-12

## Mục tiêu
Dùng chung sidebar và topbar cho các màn hình quản trị, giữ nguyên URL và logic nghiệp vụ JSP/Servlet.

## File mới
- `src/main/webapp/js/shared-layout.js`: tạo/thống nhất sidebar, đánh dấu menu hiện tại và chuẩn hóa topbar dựa trên URL đang mở.

## File cập nhật
- `src/main/webapp/css/app.css`: bổ sung quy tắc bố cục dùng chung và responsive.
- Các JSP quản trị dưới `src/main/webapp/` (trừ `login/login.jsp`): nạp CSS dùng chung và script layout dùng chung.

## Lưu ý
- Không sửa Servlet, DAO, Service hoặc schema SQL trong thay đổi giao diện này.
- Các liên kết menu dùng các URL hiện có trong ứng dụng. Nếu một URL chưa có Servlet mapping, mục menu tương ứng cần được nối với mapping thực tế.
- Cần Clean and Build và chạy kiểm thử trên Tomcat; chưa xác nhận runtime trong môi trường này.
