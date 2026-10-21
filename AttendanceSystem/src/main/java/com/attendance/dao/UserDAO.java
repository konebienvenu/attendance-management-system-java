package com.attendance.dao;

import com.attendance.model.User;
import com.attendance.util.DBConnection;
import com.attendance.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Data Access Object pour la table system_user.
 */
public class UserDAO {

    /**
     * Authentifie un utilisateur par son nom d'utilisateur et son mot de passe.
     */
    public User authenticate(String username, String plainPassword) {
        String sql = "SELECT user_id, username, password, role FROM system_user WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(plainPassword, storedPassword)) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        storedPassword,
                        rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    /**
     * Récupère un utilisateur par son identifiant.
     */
    public User getUserById(int userId) {
        String sql = "SELECT user_id, username, password, role FROM system_user WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    /**
     * Crée un utilisateur avec mot de passe haché.
     * @return ID généré ou -1 en cas d'erreur
     */
    public int createUser(String username, String plainPassword, String role) {
        String sql = "INSERT INTO system_user (username, password, role) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, username);
            stmt.setString(2, PasswordUtil.hashPassword(plainPassword));
            stmt.setString(3, role);
            int affected = stmt.executeUpdate();

            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return -1;
    }

    /**
     * Supprime un utilisateur par ID.
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM system_user WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }
}
