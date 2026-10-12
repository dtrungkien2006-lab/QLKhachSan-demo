package com.hotel.service;

import com.hotel.config.TransactionManager;
import com.hotel.dao.DatPhongDAO;
import com.hotel.dao.DichVuDAO;
import com.hotel.dao.SuDungDichVuDAO;
import com.hotel.entity.DatPhong;
import com.hotel.entity.DichVu;
import com.hotel.entity.SuDungDichVu;
import com.hotel.enums.TrangThaiDatPhong;
import com.hotel.util.MaCodeGenerator;
import jakarta.persistence.EntityManager;

import java.time.LocalDateTime;
import java.util.List;

public class SuDungDichVuService {

    private final SuDungDichVuDAO dao = new SuDungDichVuDAO();
    private final DatPhongDAO datPhongDAO = new DatPhongDAO();
    private final DichVuDAO dichVuDAO = new DichVuDAO();

    public void them(SuDungDichVu x) {
        validate(x);

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            if (x.getMaSuDungDichVu() == null
                    || x.getMaSuDungDichVu().isBlank()) {
                x.setMaSuDungDichVu(
                    MaCodeGenerator.nextId(
                        dao.findAll(em),
                        "maSuDungDichVu",
                        "SD"
                    )
                );
            }

            if (dao.findById(em, x.getMaSuDungDichVu()) != null) {
                throw new IllegalArgumentException(
                    "Mã sử dụng dịch vụ đã tồn tại."
                );
            }

            if (x.getDatPhong() == null
                    || x.getDatPhong().getMaDatPhong() == null) {
                throw new IllegalArgumentException(
                    "Thiếu mã đặt phòng."
                );
            }

            if (x.getDichVu() == null
                    || x.getDichVu().getMaDichVu() == null) {
                throw new IllegalArgumentException(
                    "Thiếu mã dịch vụ."
                );
            }

            DatPhong dp = datPhongDAO.findById(
                em, x.getDatPhong().getMaDatPhong()
            );

            DichVu dv = dichVuDAO.findById(
                em, x.getDichVu().getMaDichVu()
            );

            if (dp == null) {
                throw new IllegalArgumentException(
                    "Không tìm thấy đặt phòng."
                );
            }

            if (dv == null) {
                throw new IllegalArgumentException(
                    "Không tìm thấy dịch vụ."
                );
            }

            if (dp.getTrangThai() == TrangThaiDatPhong.DA_HUY
                    || dp.getTrangThai()
                        == TrangThaiDatPhong.DA_TRA_PHONG) {
                throw new IllegalStateException(
                    "Không thể thêm dịch vụ cho đặt phòng đã kết thúc/hủy."
                );
            }

            if (!Boolean.TRUE.equals(dv.getDangKinhDoanh())) {
                throw new IllegalStateException(
                    "Dịch vụ hiện không kinh doanh."
                );
            }

            x.setDatPhong(dp);
            x.setDichVu(dv);
            x.setDonGia(dv.getDonGia());

            if (x.getThoiGianSuDung() == null) {
                x.setThoiGianSuDung(LocalDateTime.now());
            }

            dao.save(em, x);
            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }

        if (x.getDatPhong() != null
                && x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DANG_O) {
            new HoaDonService().taoHoaDon(
                x.getDatPhong().getMaDatPhong()
            );
        }
    }

    /**
     * Lấy một bản ghi sử dụng dịch vụ.
     * Khởi tạo quan hệ trước khi đóng EntityManager.
     */
    public SuDungDichVu findById(String id) {
        TransactionManager tm = new TransactionManager();

        try {
            EntityManager em = tm.getEntityManager();

            SuDungDichVu x = dao.findById(em, id);

            if (x != null) {
                initializeRelations(x);
            }

            return x;
        } finally {
            tm.close();
        }
    }

    /**
     * Danh sách sử dụng dịch vụ theo đặt phòng.
     * DAO sử dụng JOIN FETCH để tải quan hệ.
     */
    public List<SuDungDichVu> findByDatPhong(String maDatPhong) {
        TransactionManager tm = new TransactionManager();

        try {
            return dao.findByDatPhong(
                tm.getEntityManager(), maDatPhong
            );
        } finally {
            tm.close();
        }
    }

    /**
     * Lấy toàn bộ danh sách, tải trước các quan hệ cần cho JSP.
     */
    public List<SuDungDichVu> findAll() {
        TransactionManager tm = new TransactionManager();

        try {
            EntityManager em = tm.getEntityManager();

            return dao.findAllWithDichVu(em);
        } finally {
            tm.close();
        }
    }

    public void capNhatSoLuong(String id, int soLuong) {
        if (soLuong <= 0) {
            throw new IllegalArgumentException(
                "Số lượng phải lớn hơn 0."
            );
        }

        String maDatPhong;
        boolean dangO;

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            SuDungDichVu x = dao.findById(em, id);

            if (x == null) {
                throw new IllegalArgumentException(
                    "Không tìm thấy lần sử dụng dịch vụ: " + id
                );
            }

            if (x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DA_HUY
                    || x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DA_TRA_PHONG) {
                throw new IllegalStateException(
                    "Đặt phòng đã kết thúc/hủy."
                );
            }

            maDatPhong = x.getDatPhong().getMaDatPhong();
            dangO = x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DANG_O;

            x.setSoLuong(soLuong);

            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }

        if (dangO) {
            new HoaDonService().taoHoaDon(maDatPhong);
        }
    }

    public void xoa(String id) {
        String maDatPhong;
        boolean dangO;

        TransactionManager tm = new TransactionManager();

        try {
            tm.begin();
            EntityManager em = tm.getEntityManager();

            SuDungDichVu x = dao.findById(em, id);

            if (x == null) {
                throw new IllegalArgumentException(
                    "Không tìm thấy lần sử dụng dịch vụ: " + id
                );
            }

            if (x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DA_TRA_PHONG) {
                throw new IllegalStateException(
                    "Không thể xóa dịch vụ sau khi trả phòng."
                );
            }

            maDatPhong = x.getDatPhong().getMaDatPhong();
            dangO = x.getDatPhong().getTrangThai()
                    == TrangThaiDatPhong.DANG_O;

            dao.delete(em, x);
            tm.commit();

        } catch (Exception e) {
            tm.rollback();
            throw e;
        } finally {
            tm.close();
        }

        if (dangO) {
            new HoaDonService().taoHoaDon(maDatPhong);
        }
    }

    private void initializeRelations(SuDungDichVu x) {
        // Chỉ truy cập getter để khởi tạo quan hệ trong Session.
        if (x.getDichVu() != null) {
            x.getDichVu().getTenDichVu();
            x.getDichVu().getMaDichVu();
        }

        if (x.getDatPhong() != null) {
            x.getDatPhong().getMaDatPhong();
        }
    }

    private void validate(SuDungDichVu x) {
        if (x == null
                || x.getSoLuong() == null
                || x.getSoLuong() <= 0) {
            throw new IllegalArgumentException(
                "Thông tin sử dụng dịch vụ không hợp lệ."
            );
        }
    }
}