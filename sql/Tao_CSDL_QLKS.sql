-- =========================================================
-- CSDL QUẢN LÝ KHÁCH SẠN
-- Phiên bản đã đồng bộ với thiết kế 12 Entity + 6 Enum (thêm TaiKhoan)
-- =========================================================

DROP DATABASE IF EXISTS QLKhachSan;

CREATE DATABASE QLKhachSan
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE QLKhachSan;

-- =========================================================
-- 1. KHACH_HANG
-- =========================================================
DROP TABLE IF EXISTS KHACH_HANG;

CREATE TABLE KHACH_HANG (
    maKH            VARCHAR(20)  NOT NULL,
    hoTen           VARCHAR(100) NOT NULL,
    cccd            VARCHAR(20)  NULL,
    ngaySinh        DATE         NULL,
    gioiTinh        VARCHAR(10)  NULL,
    soDienThoai     VARCHAR(15)  NOT NULL,
    email           VARCHAR(100) NULL,
    diaChi          VARCHAR(255) NULL,

    CONSTRAINT PK_KHACH_HANG PRIMARY KEY (maKH),
    CONSTRAINT UQ_KHACH_HANG_SoDienThoai UNIQUE (soDienThoai),
    CONSTRAINT UQ_KHACH_HANG_Email UNIQUE (email),
    CONSTRAINT CK_KHACH_HANG_GioiTinh
        CHECK (gioiTinh IS NULL OR gioiTinh IN ('NAM', 'NU'))
);

-- =========================================================
-- 2. NHAN_VIEN
-- =========================================================
CREATE TABLE NHAN_VIEN (
    maNV            VARCHAR(20)  NOT NULL,
    hoTen           VARCHAR(100) NOT NULL,
    ngaySinh        DATE         NULL,
    gioiTinh        VARCHAR(10)  NULL,
    soDienThoai     VARCHAR(15)  NOT NULL,
    email           VARCHAR(100) NOT NULL,
    diaChi          VARCHAR(255) NULL,

    CONSTRAINT PK_NHAN_VIEN PRIMARY KEY (maNV),
    CONSTRAINT UQ_NHAN_VIEN_SoDienThoai UNIQUE (soDienThoai),
    CONSTRAINT UQ_NHAN_VIEN_Email UNIQUE (email),
    CONSTRAINT CK_NHAN_VIEN_GioiTinh
        CHECK (gioiTinh IS NULL OR gioiTinh IN ('NAM', 'NU'))
);

-- =========================================================
-- 3. TAI_KHOAN
-- Mỗi nhân viên có một tài khoản; mật khẩu được lưu bằng BCrypt.
-- =========================================================
CREATE TABLE TAI_KHOAN (
    maTK            VARCHAR(20)  NOT NULL,
    maNV            VARCHAR(20)  NOT NULL,
    matKhauHash     VARCHAR(255) NOT NULL,
    vaiTro          VARCHAR(20)  NOT NULL,
    trangThai       VARCHAR(20)  NOT NULL DEFAULT 'HOAT_DONG',

    CONSTRAINT PK_TAI_KHOAN PRIMARY KEY (maTK),
    CONSTRAINT UQ_TAI_KHOAN_MaNV UNIQUE (maNV),
    CONSTRAINT FK_TAI_KHOAN_NHAN_VIEN
        FOREIGN KEY (maNV) REFERENCES NHAN_VIEN(maNV)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT CK_TAI_KHOAN_VaiTro
        CHECK (vaiTro IN ('ADMIN', 'QUAN_LY', 'LE_TAN')),
    CONSTRAINT CK_TAI_KHOAN_TrangThai
        CHECK (trangThai IN ('HOAT_DONG', 'KHOA'))
);

-- =========================================================
-- 4. LOAI_PHONG
-- =========================================================
CREATE TABLE LOAI_PHONG (
    maLoaiPhong     VARCHAR(20)   NOT NULL,
    tenLoaiPhong    VARCHAR(100)  NOT NULL,
    moTa            VARCHAR(500)  NULL,
    giaCoBan        DECIMAL(12,2) NOT NULL,
    soNguoiToiDa    INT           NOT NULL,

    CONSTRAINT PK_LOAI_PHONG PRIMARY KEY (maLoaiPhong),
    CONSTRAINT UQ_LOAI_PHONG_TenLoai UNIQUE (tenLoaiPhong),
    CONSTRAINT CK_LOAI_PHONG_GiaCoBan CHECK (giaCoBan >= 0),
    CONSTRAINT CK_LOAI_PHONG_SoNguoiToiDa CHECK (soNguoiToiDa > 0)
);

-- =========================================================
-- 5. PHONG
-- =========================================================
CREATE TABLE PHONG (
    maPhong        VARCHAR(20) NOT NULL,
    soPhong        VARCHAR(20) NOT NULL,
    viTri          VARCHAR(100) NULL,
    maLoaiPhong    VARCHAR(20) NOT NULL,
    trangThai      VARCHAR(30) NOT NULL DEFAULT 'TRONG',

    CONSTRAINT PK_PHONG PRIMARY KEY (maPhong),
    CONSTRAINT UQ_PHONG_SoPhong UNIQUE (soPhong),
    CONSTRAINT FK_PHONG_LOAI_PHONG
        FOREIGN KEY (maLoaiPhong)
        REFERENCES LOAI_PHONG(maLoaiPhong),
    CONSTRAINT CK_PHONG_TrangThai
        CHECK (trangThai IN ('TRONG', 'DANG_SU_DUNG', 'DA_DAT'))
);

-- =========================================================
-- 6. DAT_PHONG
-- =========================================================
CREATE TABLE DAT_PHONG (
    maDatPhong     VARCHAR(20)  NOT NULL,
    maKH           VARCHAR(20)  NOT NULL,
    maNVXuLy       VARCHAR(20)  NOT NULL,
    maNVCheckIn    VARCHAR(20)  NULL,
    maNVCheckOut   VARCHAR(20)  NULL,
    ngayDat        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trangThai      VARCHAR(30)  NOT NULL DEFAULT 'CHO_XAC_NHAN',
    ghiChu         VARCHAR(500) NULL,

    CONSTRAINT PK_DAT_PHONG PRIMARY KEY (maDatPhong),
    CONSTRAINT FK_DAT_PHONG_KHACH_HANG
        FOREIGN KEY (maKH)
        REFERENCES KHACH_HANG(maKH),
    CONSTRAINT FK_DAT_PHONG_NV_XU_LY
        FOREIGN KEY (maNVXuLy) REFERENCES NHAN_VIEN(maNV),
    CONSTRAINT FK_DAT_PHONG_NV_CHECK_IN
        FOREIGN KEY (maNVCheckIn) REFERENCES NHAN_VIEN(maNV),
    CONSTRAINT FK_DAT_PHONG_NV_CHECK_OUT
        FOREIGN KEY (maNVCheckOut) REFERENCES NHAN_VIEN(maNV),
    CONSTRAINT CK_DAT_PHONG_TrangThai
        CHECK (
            trangThai IN (
                'CHO_XAC_NHAN',
                'DA_XAC_NHAN',
                'DANG_O',
                'DA_TRA_PHONG',
                'DA_HUY'
            )
        )
);

-- =========================================================
-- 7. CT_DAT_PHONG
-- =========================================================
CREATE TABLE CT_DAT_PHONG (
    maCTDatPhong   VARCHAR(20)   NOT NULL,
    maDatPhong     VARCHAR(20)   NOT NULL,
    maPhong        VARCHAR(20)   NOT NULL,
    ngayNhan       DATE          NOT NULL,
    ngayTra        DATE          NOT NULL,
    giaPhong       DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_CT_DAT_PHONG PRIMARY KEY (maCTDatPhong),
    CONSTRAINT FK_CT_DAT_PHONG_DAT_PHONG
        FOREIGN KEY (maDatPhong)
        REFERENCES DAT_PHONG(maDatPhong),
    CONSTRAINT FK_CT_DAT_PHONG_PHONG
        FOREIGN KEY (maPhong)
        REFERENCES PHONG(maPhong),
    CONSTRAINT UQ_CT_DAT_PHONG_DatPhong_Phong
        UNIQUE (maDatPhong, maPhong),
    CONSTRAINT CK_CT_DAT_PHONG_Ngay
        CHECK (ngayTra > ngayNhan),
    CONSTRAINT CK_CT_DAT_PHONG_GiaPhong
        CHECK (giaPhong >= 0)
);

-- =========================================================
-- 8. DICH_VU
-- =========================================================
CREATE TABLE DICH_VU (
    maDichVu       VARCHAR(20)   NOT NULL,
    tenDichVu      VARCHAR(100)  NOT NULL,
    moTa           VARCHAR(500)  NULL,
    donGia         DECIMAL(12,2) NOT NULL,
    loaiDichVu     VARCHAR(50)   NULL,
    dangKinhDoanh  BOOLEAN       NOT NULL DEFAULT TRUE,

    CONSTRAINT PK_DICH_VU PRIMARY KEY (maDichVu),
    CONSTRAINT CK_DICH_VU_DonGia CHECK (donGia >= 0)
);

-- =========================================================
-- 9. SU_DUNG_DICH_VU
-- =========================================================
CREATE TABLE SU_DUNG_DICH_VU (
    maSuDungDichVu VARCHAR(20)   NOT NULL,
    maDatPhong     VARCHAR(20)   NOT NULL,
    maDichVu       VARCHAR(20)   NOT NULL,
    soLuong        INT           NOT NULL,
    donGia         DECIMAL(12,2) NOT NULL,
    thoiGianSuDung DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_SU_DUNG_DICH_VU PRIMARY KEY (maSuDungDichVu),
    CONSTRAINT FK_SU_DUNG_DICH_VU_DAT_PHONG
        FOREIGN KEY (maDatPhong)
        REFERENCES DAT_PHONG(maDatPhong),
    CONSTRAINT FK_SU_DUNG_DICH_VU_DICH_VU
        FOREIGN KEY (maDichVu)
        REFERENCES DICH_VU(maDichVu),
    CONSTRAINT CK_SU_DUNG_DICH_VU_SoLuong CHECK (soLuong > 0),
    CONSTRAINT CK_SU_DUNG_DICH_VU_DonGia CHECK (donGia >= 0)
);

-- =========================================================
-- 10. THANH_TOAN
-- =========================================================
CREATE TABLE THANH_TOAN (
    maThanhToan        VARCHAR(20)   NOT NULL,
    maDatPhong         VARCHAR(20)   NOT NULL,
    soTien             DECIMAL(12,2) NOT NULL,
    phuongThuc         VARCHAR(30)   NOT NULL,
    trangThai          VARCHAR(30)   NOT NULL DEFAULT 'CHO_THANH_TOAN',
    maGiaoDich         VARCHAR(100)  NULL,
    thoiGianTao        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thoiGianThanhToan  DATETIME      NULL,

    CONSTRAINT PK_THANH_TOAN PRIMARY KEY (maThanhToan),
    CONSTRAINT FK_THANH_TOAN_DAT_PHONG
        FOREIGN KEY (maDatPhong)
        REFERENCES DAT_PHONG(maDatPhong),
    CONSTRAINT CK_THANH_TOAN_PhuongThuc
        CHECK (phuongThuc IN ('TIEN_MAT', 'VNPAY', 'MOMO')),
    CONSTRAINT CK_THANH_TOAN_TrangThai
        CHECK (
            trangThai IN (
                'CHO_THANH_TOAN',
                'DA_THANH_TOAN',
                'THAT_BAI',
                'DA_HOAN_TIEN'
            )
        ),
    CONSTRAINT CK_THANH_TOAN_SoTien CHECK (soTien > 0)
);

-- =========================================================
-- 11. HOA_DON
-- =========================================================
CREATE TABLE HOA_DON (
    maHoaDon         VARCHAR(20)   NOT NULL,
    maDatPhong       VARCHAR(20)   NOT NULL,
    ngayLap          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tongTienPhong    DECIMAL(12,2) NOT NULL DEFAULT 0,
    tongTienDichVu   DECIMAL(12,2) NOT NULL DEFAULT 0,
    tongTien         DECIMAL(12,2) NOT NULL DEFAULT 0,
    trangThai        VARCHAR(30)   NOT NULL DEFAULT 'NHAP',

    CONSTRAINT PK_HOA_DON PRIMARY KEY (maHoaDon),
    CONSTRAINT FK_HOA_DON_DAT_PHONG
        FOREIGN KEY (maDatPhong)
        REFERENCES DAT_PHONG(maDatPhong),
    CONSTRAINT UQ_HOA_DON_MA_DAT_PHONG UNIQUE (maDatPhong),
    CONSTRAINT CK_HOA_DON_TrangThai
        CHECK (trangThai IN ('NHAP', 'DA_PHAT_HANH', 'DA_HUY')),
    CONSTRAINT CK_HOA_DON_Tien
        CHECK (
            tongTienPhong >= 0
            AND tongTienDichVu >= 0
            AND tongTien >= 0
        )
);

-- =========================================================
-- 12. CT_HOA_DON
-- =========================================================
CREATE TABLE CT_HOA_DON (
    maCtHoaDon      VARCHAR(20)   NOT NULL,
    maHoaDon        VARCHAR(20)   NOT NULL,
    tenKhoanThu     VARCHAR(255)  NOT NULL,
    soLuong         INT           NOT NULL,
    donGia          DECIMAL(12,2) NOT NULL,
    thanhTien       DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_CT_HOA_DON PRIMARY KEY (maCtHoaDon),
    CONSTRAINT FK_CT_HOA_DON_HOA_DON
        FOREIGN KEY (maHoaDon)
        REFERENCES HOA_DON(maHoaDon),
    CONSTRAINT CK_CT_HOA_DON_SoLuong CHECK (soLuong > 0),
    CONSTRAINT CK_CT_HOA_DON_DonGia CHECK (donGia >= 0),
    CONSTRAINT CK_CT_HOA_DON_ThanhTien CHECK (thanhTien >= 0)
);
