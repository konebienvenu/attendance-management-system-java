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
 * Data Access Object for the system_user table.
 */
public class UserDAO {

    /**
     * Authenticates a user by username and password.
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
     * Retrieves a user by ID.
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
     * Creates a new user with a hashed password.
     * @return generated user ID or -1 on failure
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
     * Deletes a user by ID.
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
