package com.attendance.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Gestionnaire de connexion Singleton pour MySQL JDBC.
 * Lit la configuration depuis db.properties avec repli automatique sécurisé.
 */
public class DBConnection {
    private static String url = "jdbc:mysql://localhost:3306/attendance_management_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String user = "root";
    private static String password = "";
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            // Tentative de chargement du fichier db.properties
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
                System.err.println("[DBConnection] db.properties non trouvé, utilisation des paramètres par défaut.");
            }

            // Chargement dynamique de la classe du driver JDBC
            Class.forName(driver);
            System.out.println("[DBConnection] MySQL Driver chargé avec succès : " + driver);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERREUR : Driver JDBC non trouvé dans le classpath ! " + e.getMessage());
        }
    }

    /**
     * Retourne une nouvelle connexion active vers la base de données.
     * @return Connection JDBC
     * @throws SQLException si la connexion échoue
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Ferme proprement des ressources ouvertes (ResultSet, Statement, Connection).
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
