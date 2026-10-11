package com.hotel.dto;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Bảng báo cáo tổng quát: một JSP và một bộ xuất CSV dùng chung cho mọi loại báo cáo. */
public class BaoCaoDTO {
    private String tieuDe;
    private String kyBaoCao;
    private List<String> cot = new ArrayList<>();
    private List<List<String>> dong = new ArrayList<>();
    private Map<String, String> tongKet = new LinkedHashMap<>();

    /** Dữ liệu biểu đồ (tùy chọn): "bar" hoặc "doughnut". Null/rỗng nghĩa là báo cáo không có biểu đồ. */
    private String loaiBieuDo;
    private String tieuDeBieuDo;
    private List<String> nhanBieuDo = new ArrayList<>();
    /** tên chuỗi số liệu -> danh sách giá trị, cùng thứ tự với nhanBieuDo. */
    private Map<String, List<Number>> chuoiBieuDo = new LinkedHashMap<>();
    private boolean xepChong;

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String v) { this.tieuDe = v; }
    public String getKyBaoCao() { return kyBaoCao; }
    public void setKyBaoCao(String v) { this.kyBaoCao = v; }
    public List<String> getCot() { return cot; }
    public void setCot(List<String> v) { this.cot = v; }
    public List<List<String>> getDong() { return dong; }
    public void setDong(List<List<String>> v) { this.dong = v; }
    public String getLoaiBieuDo() { return loaiBieuDo; }
    public void setLoaiBieuDo(String v) { this.loaiBieuDo = v; }
    public String getTieuDeBieuDo() { return tieuDeBieuDo; }
    public void setTieuDeBieuDo(String v) { this.tieuDeBieuDo = v; }
    public List<String> getNhanBieuDo() { return nhanBieuDo; }
    public void setNhanBieuDo(List<String> v) { this.nhanBieuDo = v; }
    public Map<String, List<Number>> getChuoiBieuDo() { return chuoiBieuDo; }
    public void setChuoiBieuDo(Map<String, List<Number>> v) { this.chuoiBieuDo = v; }
    public boolean isXepChong() { return xepChong; }
    public void setXepChong(boolean v) { this.xepChong = v; }
    public boolean isCoBieuDo() { return loaiBieuDo != null && !nhanBieuDo.isEmpty(); }
    /** JSON mảng nhãn, dùng trực tiếp trong JSP: const labels = ${baoCao.nhanJson}; */
    public String getNhanJson() {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < nhanBieuDo.size(); i++) {
            if (i > 0) sb.append(',');
            sb.append(json(nhanBieuDo.get(i)));
        }
        return sb.append(']').toString();
    }

    /** JSON mảng chuỗi số liệu: [{"ten":"...","gia":[1,2,3]}, ...] */
    public String getChuoiJson() {
        StringBuilder sb = new StringBuilder("[");
        boolean dau = true;
        for (Map.Entry<String, List<Number>> e : chuoiBieuDo.entrySet()) {
            if (!dau) sb.append(',');
            dau = false;
            sb.append("{\"ten\":").append(json(e.getKey())).append(",\"gia\":[");
            for (int i = 0; i < e.getValue().size(); i++) {
                if (i > 0) sb.append(',');
                sb.append(e.getValue().get(i));
            }
            sb.append("]}");
        }
        return sb.append(']').toString();
    }

    private static String json(String v) {
        if (v == null) return "\"\"";
        StringBuilder sb = new StringBuilder("\"");
        for (char c : v.toCharArray()) {
            switch (c) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '<' -> sb.append("\\u003c");
                case '>' -> sb.append("\\u003e");
                case '&' -> sb.append("\\u0026");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                default -> sb.append(c);
            }
        }
        return sb.append('"').toString();
    }

    public Map<String, String> getTongKet() { return tongKet; }
    public void setTongKet(Map<String, String> v) { this.tongKet = v; }
}
