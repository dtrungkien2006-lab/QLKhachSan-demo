USE QLKhachSan;

INSERT INTO LOAI_PHONG (maLoaiPhong, tenLoaiPhong, soNguoiToiDa, giaCoBan, moTa) VALUES
('LP01','Phòng Đơn Tiêu Chuẩn',1,500000,'Phòng 1 giường đơn, máy lạnh, wifi, TV'),
('LP02','Phòng Đôi Tiêu Chuẩn',2,800000,'Phòng 1 giường đôi lớn, ban công thoáng mát'),
('LP03','Phòng VIP Hướng Biển',4,1500000,'Phòng suite cao cấp, 2 giường đôi, bồn tắm, minibar');

INSERT INTO PHONG (maPhong, soPhong, viTri, maLoaiPhong, trangThai) VALUES
('P101','101','Tầng 1','LP01','TRONG'),('P102','102','Tầng 1','LP01','DA_DAT'),('P103','103','Tầng 1','LP01','DANG_SU_DUNG'),
('P201','201','Tầng 2','LP02','TRONG'),('P202','202','Tầng 2','LP02','DANG_SU_DUNG'),('P203','203','Tầng 2','LP02','TRONG'),
('P301','301','Tầng 3','LP03','TRONG'),('P302','302','Tầng 3','LP03','DA_DAT');

INSERT INTO DICH_VU (maDichVu,tenDichVu,moTa,donGia,loaiDichVu,dangKinhDoanh) VALUES
('DV01','Nước suối Aquafina','Nước suối đóng chai',15000,'DoUong',TRUE),
('DV02','Bia Heineken','Bia lon',30000,'DoUong',TRUE),
('DV03','Cơm chiên hải sản','Món ăn',75000,'DoAn',TRUE),
('DV04','Mì xào bò','Món ăn',60000,'DoAn',TRUE),
('DV05','Giặt ủi quần áo','Dịch vụ giặt ủi',35000,'GiatDo',TRUE);

INSERT INTO NHAN_VIEN (maNV,hoTen,ngaySinh,gioiTinh,soDienThoai,email,diaChi) VALUES
('24110261','Nhân viên 24110261','2003-01-01','NAM','0900000261','24110261@hotel.com','TP. Hồ Chí Minh'),
('24110214','Nhân viên 24110214','2003-02-01','NAM','0900000214','24110214@hotel.com','TP. Hồ Chí Minh'),
('24110268','Nhân viên 24110268','2003-03-01','NAM','0900000268','24110268@hotel.com','TP. Hồ Chí Minh'),
('24110262','Nhân viên 24110262','2003-04-01','NAM','0900000262','24110262@hotel.com','TP. Hồ Chí Minh'),
('24110167','Nhân viên 24110167','2003-05-01','NAM','0900000167','24110167@hotel.com','TP. Hồ Chí Minh');

INSERT INTO TAI_KHOAN (maTK,maNV,matKhauHash,vaiTro,trangThai) VALUES
('TK24110261','24110261','$2y$12$nCj6Yd4brL5nmz5bBvs63uXeFoYeb.ufKiw0GW/QB9vEPciQVFwau','QUAN_LY','HOAT_DONG'),
('TK24110214','24110214','$2y$12$nCj6Yd4brL5nmz5bBvs63uXeFoYeb.ufKiw0GW/QB9vEPciQVFwau','LE_TAN','HOAT_DONG'),
('TK24110268','24110268','$2y$12$nCj6Yd4brL5nmz5bBvs63uXeFoYeb.ufKiw0GW/QB9vEPciQVFwau','ADMIN','HOAT_DONG'),
('TK24110262','24110262','$2y$12$nCj6Yd4brL5nmz5bBvs63uXeFoYeb.ufKiw0GW/QB9vEPciQVFwau','LE_TAN','HOAT_DONG'),
('TK24110167','24110167','$2y$12$nCj6Yd4brL5nmz5bBvs63uXeFoYeb.ufKiw0GW/QB9vEPciQVFwau','LE_TAN','HOAT_DONG');

INSERT INTO KHACH_HANG
    (maKH, hoTen, cccd, ngaySinh, gioiTinh, soDienThoai, email, diaChi)
VALUES
    ('KH001', 'Nguyễn Văn An', '079123456001', '1999-01-15', 'NAM', '0912345678', 'an.nguyen@gmail.com', 'TP. Hồ Chí Minh'),
    ('KH002', 'Trần Thị Bích', '079123456002', '1995-07-20', 'NU', '0918765432', 'bich.tran@gmail.com', 'TP. Hồ Chí Minh'),
    ('KH003', 'Lê Hoàng Nam', '075123456003', '1998-11-03', 'NAM', '0988112233', 'nam.le@gmail.com', 'Đồng Nai'),
    ('KH004', 'Đặng Thu Thảo', '074123456004', '1996-04-25', 'NU', '0977223344', 'thao.dang@gmail.com', 'Bình Dương');
INSERT INTO DAT_PHONG (maDatPhong,maKH,maNVXuLy,maNVCheckIn,maNVCheckOut,ngayDat,trangThai,ghiChu) VALUES
('DP001','KH001','24110261',NULL,NULL,'2026-09-20 09:00:00','CHO_XAC_NHAN','Đặt phòng được tiếp nhận tại quầy'),
('DP002','KH002','24110214','24110214',NULL,'2026-09-21 10:30:00','DA_XAC_NHAN','Đã xác nhận đặt phòng tại quầy'),
('DP003','KH003','24110262','24110262',NULL,'2026-09-22 08:00:00','DANG_O','Đang lưu trú'),
('DP004','KH004','24110167','24110167','24110167','2026-09-15 14:00:00','DA_TRA_PHONG','Đã trả phòng'),
('DP005','KH001','24110261',NULL,NULL,'2026-09-10 11:00:00','DA_HUY','Khách hủy đặt phòng');

INSERT INTO CT_DAT_PHONG (maCTDatPhong,maDatPhong,maPhong,ngayNhan,ngayTra,giaPhong) VALUES
('CT001','DP001','P102','2026-09-28','2026-09-30',500000),
('CT002','DP002','P302','2026-09-29','2026-10-02',1500000),
('CT003','DP003','P103','2026-09-23','2026-09-26',500000),
('CT004','DP003','P202','2026-09-23','2026-09-26',800000),
('CT005','DP004','P301','2026-09-18','2026-09-20',1500000);

INSERT INTO SU_DUNG_DICH_VU (maSuDungDichVu,maDatPhong,maDichVu,soLuong,donGia,thoiGianSuDung) VALUES
('SD001','DP003','DV01',4,15000,'2026-09-23 16:00:00'),('SD002','DP003','DV02',2,30000,'2026-09-23 20:00:00'),('SD003','DP003','DV05',3,35000,'2026-09-24 09:30:00'),
('SD004','DP004','DV03',2,75000,'2026-09-18 19:00:00'),('SD005','DP004','DV01',2,15000,'2026-09-19 08:00:00');

-- Mỗi đặt phòng đúng 1 hóa đơn. Hóa đơn được tạo ngay khi đặt phòng; dịch vụ được cộng khi checkout.
INSERT INTO HOA_DON (maHoaDon,maDatPhong,ngayLap,tongTienPhong,tongTienDichVu,tongTien,trangThai) VALUES
('HD001','DP001','2026-09-20 09:00:00',1000000,0,1000000,'NHAP'),
('HD002','DP002','2026-09-21 10:30:00',4500000,0,4500000,'NHAP'),
('HD003','DP003','2026-09-22 08:00:00',3900000,0,3900000,'NHAP'),
('HD004','DP004','2026-09-15 14:00:00',3000000,180000,3180000,'DA_PHAT_HANH'),
('HD005','DP005','2026-09-10 11:00:00',0,0,0,'DA_HUY');

INSERT INTO CT_HOA_DON (maCtHoaDon,maHoaDon,tenKhoanThu,soLuong,donGia,thanhTien) VALUES
('CTHD001','HD001','Tiền phòng P102',1,1000000,1000000),
('CTHD002','HD002','Tiền phòng P302',1,4500000,4500000),
('CTHD003','HD003','Tiền phòng P103',1,1500000,1500000),
('CTHD004','HD003','Tiền phòng P202',1,2400000,2400000),
('CTHD005','HD004','Tiền phòng P301',1,3000000,3000000),
('CTHD006','HD004','Cơm chiên hải sản',2,75000,150000),
('CTHD007','HD004','Nước suối Aquafina',2,15000,30000);

INSERT INTO THANH_TOAN (maThanhToan,maDatPhong,soTien,phuongThuc,trangThai,maGiaoDich,thoiGianTao,thoiGianThanhToan) VALUES
('TT001','DP004',3180000,'TIEN_MAT','DA_THANH_TOAN','POS-DEMO-001','2026-09-20 11:40:00','2026-09-20 11:45:00');
