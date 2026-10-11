# TV5 – Thống kê & Báo cáo (có biểu đồ) + tìm kiếm hóa đơn

## Cách chạy
1. Chạy `TaoCSDL.sql` rồi `DuLieuMau.sql`, đăng nhập (vd. tài khoản `24110261`).
2. Mở trang chủ → **Thống kê** hoặc **Báo cáo**.
3. Dữ liệu mẫu nằm ở **tháng 9/2026**, nên chọn Từ ngày `2026-09-01` – Đến ngày `2026-09-30`
   (mặc định trang lấy 60 ngày gần nhất tính từ hôm nay).
4. Biểu đồ dùng Chart.js qua CDN nên máy cần có Internet.

## URL
| URL | Chức năng |
|---|---|
| `/thong-ke?loai=tong-quan\|phong\|dat-phong\|khach-hang\|doanh-thu&tuNgay=&denNgay=&kieu=NGAY\|THANG\|NAM&nhap=1` | Thống kê + biểu đồ |
| `/bao-cao?loai=doanh-thu\|su-dung-phong\|dat-phong\|luu-tru&tuNgay=&denNgay=&kieu=&nhap=1` | Báo cáo + biểu đồ, in |
| `/bao-cao?...&format=csv` | Xuất CSV (mở bằng Excel) |
| `/hoa-don?action=search&q=&trangThai=` | Tìm kiếm hóa đơn |

`nhap=1`: tính cả hóa đơn NHAP (doanh thu dự kiến). Mặc định chỉ tính DA_PHAT_HANH.

## Các file và vị trí
| Việc | File |
|---|---|
| Nhận request thống kê | `controller/ThongKeServlet.java` |
| Nhận request báo cáo, xuất CSV | `controller/BaoCaoServlet.java` |
| Tính số liệu thống kê | `service/ThongKeService.java` |
| Dựng báo cáo (bảng + dữ liệu biểu đồ) + CSV | `service/BaoCaoService.java` |
| Truy vấn JPQL chỉ đọc | `dao/ThongKeDAO.java` |
| Đối tượng chứa kết quả | `dto/ThongKe*DTO.java`, `dto/DoanhThuDTO.java`, `dto/BaoCaoDTO.java` |
| Gom theo ngày/tháng/năm | `enums/KieuThoiGian.java` |
| Giao diện + biểu đồ thống kê | `webapp/thong-ke/thong-ke.jsp` |
| Giao diện + biểu đồ báo cáo | `webapp/bao-cao/bao-cao.jsp` |

## Quy ước số liệu
- Doanh thu theo `HoaDon.ngayLap` (không tính DA_HUY; NHAP chỉ tính khi bật `nhap=1`).
- Thực thu theo phương thức: `ThanhToan` DA_THANH_TOAN, theo `thoiGianThanhToan`.
- Công suất phòng trong kỳ = số đêm phòng đã bán / (tổng phòng × số ngày); chỉ tính đặt phòng DANG_O, DA_TRA_PHONG.
- Khoảng thời gian tính cả ngày bắt đầu và ngày kết thúc.
