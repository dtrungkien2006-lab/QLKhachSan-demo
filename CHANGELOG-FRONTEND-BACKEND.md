# Nhật ký thay đổi - QLKhachSan

Bản chỉnh sửa từ `Web-HotelManagement-master(2).zip`. Không thay đổi file SQL của người dùng và không tự chạy script `DROP DATABASE`.

## Đã thực hiện

1. Thêm `src/main/webapp/css/app.css`: giao diện dùng chung, responsive cho dashboard và các trang nghiệp vụ mới.
2. Viết lại `src/main/webapp/index.jsp` thành dashboard điều hướng, liên kết đến các Servlet hiện có: phòng, loại phòng, đặt phòng, khách hàng, dịch vụ, sử dụng dịch vụ, hóa đơn, thanh toán và nhân viên (chỉ hiển thị mục nhân viên với ADMIN).
3. Làm mới `src/main/webapp/login/login.jsp`, giữ nguyên endpoint `POST /login` và tên tham số `maNV`, `matKhau` để không phá luồng đăng nhập hiện có.
4. Bổ sung các JSP còn thiếu mà Servlet đã gọi:
   - `phong/danh-sach.jsp`, `phong/form.jsp`, `phong/chi-tiet.jsp`
   - `loai-phong/danh-sach.jsp`, `loai-phong/form.jsp`, `loai-phong/chi-tiet.jsp`
   - `dich-vu/danh-sach.jsp`, `dich-vu/form.jsp`, `dich-vu/chi-tiet.jsp`
   - `dich-vu/su-dung-danh-sach.jsp`, `dich-vu/su-dung-form.jsp`, `dich-vu/su-dung-chi-tiet.jsp`
5. Đồng bộ một số metadata Entity với SQL đã gửi: độ dài `cccd` 20; `ghiChu` và `moTa` 500; độ dài trường trạng thái/phương thức thanh toán 30 theo định nghĩa bảng.

## Giữ nguyên

- Không đổi tên bảng/cột SQL.
- Không đổi URL Servlet và tên tham số của form đăng nhập.
- Không thay đổi nghiệp vụ Service/DAO ngoài các metadata Entity nêu trên.
- Không thêm dữ liệu mẫu và không tự chạy SQL.

## Cấu hình chạy

`DataSourceConfig` đang đọc các biến môi trường hoặc Java system properties `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`. Nếu không khai báo, mã nguồn hiện có dùng mặc định `jdbc:mysql://localhost:3306/QLKhachSan`, user `root`, mật khẩu `123456`. Hãy đặt lại thông tin phù hợp máy của bạn trước khi chạy; không đưa mật khẩu thật lên Git.

## Kiểm thử

Đã rà soát danh sách `getRequestDispatcher(...)` của các Servlet và xác nhận các đường dẫn JSP được gọi đều tồn tại trong bản chỉnh sửa. Chưa thể xác nhận build Maven hoặc chạy Tomcat/MySQL trong môi trường tạo bản này vì Maven không có sẵn và không có máy chủ cơ sở dữ liệu để kiểm thử tích hợp. Cần chạy `mvn clean package` và thử trên Tomcat 10.1 cùng MySQL đã import schema `QLKhachSan`.
