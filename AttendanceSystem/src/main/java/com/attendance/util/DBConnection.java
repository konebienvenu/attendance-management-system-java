package com.attendance.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Singleton database connection manager for MySQL JDBC.
 * Reads configuration from db.properties with secure fallback defaults.
 */
public class DBConnection {
    private static String url = "jdbc:mysql://localhost:3306/attendance_management_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String user = "root";
    private static String password = "";
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Properties props = new Properties();
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    props.load(input);
                    if (props.getProperty("db.url") != null) url = props.getProperty("db.url");
                    if (props.getProperty("db.user") != null) user = props.getProperty("db.user");
                    if (props.getProperty("db.password") != null) password = props.getProperty("db.password");
                    if (props.getProperty("db.driver") != null) driver = props.getProperty("db.driver");
                }
            } catch (Exception e) {
                System.err.println("[DBConnection] db.properties not found, using default configuration.");
            }

            Class.forName(driver);
            System.out.println("[DBConnection] MySQL JDBC Driver loaded successfully: " + driver);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERROR: JDBC Driver not found in classpath! " + e.getMessage());
        }
    }

    /**
     * Returns an active database connection.
     * @return JDBC Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Safely closes open database resources.
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
