package com.hotel.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DataSourceConfig {

    private static final HikariDataSource DATA_SOURCE;
    static {
        HikariConfig config = new HikariConfig();

        // Lấy trực tiếp từ biến môi trường Railway, nếu không có mới dùng localhost để test local
        String dbUrl = getConfig("DB_URL", "jdbc:mysql://localhost:3306/railway?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8");
        String dbUser = getConfig("DB_USERNAME", "root");
        String dbPassword = getConfig("DB_PASSWORD", "");

        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPassword);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Connection pool
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);

        // Timeout
        config.setConnectionTimeout(30_000);
        config.setIdleTimeout(600_000);
        config.setMaxLifetime(1_800_000);

        config.setPoolName("QLKhachSan-HikariPool");

        DATA_SOURCE = new HikariDataSource(config);
    }

    private DataSourceConfig() {}
    public static HikariDataSource getDataSource() {return DATA_SOURCE;}

    private static String getConfig(String key, String defaultValue) {
        String environmentVariable = System.getenv(key);
        if (environmentVariable != null && !environmentVariable.isBlank()) {return environmentVariable;}
        String systemProperty = System.getProperty(key);
        if (systemProperty != null && !systemProperty.isBlank()) {return systemProperty;}
        return defaultValue;
    }

    public static void close() {if (DATA_SOURCE != null && !DATA_SOURCE.isClosed()) {DATA_SOURCE.close();}}
}