package com.attendance.dao;

import com.attendance.model.Teacher;
import com.attendance.util.DBConnection;
import com.attendance.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object pour la table teacher.
 */
public class TeacherDAO {

    public List<Teacher> getAllTeachers() {
        List<Teacher> list = new ArrayList<>();
        String sql = "SELECT t.teacher_id, t.user_id, t.teacher_name, t.email, u.username " +
                     "FROM teacher t " +
                     "JOIN system_user u ON t.user_id = u.user_id " +
                     "ORDER BY t.teacher_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Teacher t = new Teacher(
                    rs.getInt("teacher_id"),
                    rs.getInt("user_id"),
                    rs.getString("teacher_name"),
                    rs.getString("email")
                );
                t.setUsername(rs.getString("username"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public Teacher getTeacherById(int teacherId) {
        String sql = "SELECT t.teacher_id, t.user_id, t.teacher_name, t.email, u.username " +
                     "FROM teacher t " +
                     "JOIN system_user u ON t.user_id = u.user_id " +
                     "WHERE t.teacher_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, teacherId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Teacher t = new Teacher(
                    rs.getInt("teacher_id"),
                    rs.getInt("user_id"),
                    rs.getString("teacher_name"),
                    rs.getString("email")
                );
                t.setUsername(rs.getString("username"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    public Teacher getTeacherByUserId(int userId) {
        String sql = "SELECT t.teacher_id, t.user_id, t.teacher_name, t.email, u.username " +
                     "FROM teacher t " +
                     "JOIN system_user u ON t.user_id = u.user_id " +
                     "WHERE t.user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Teacher t = new Teacher(
                    rs.getInt("teacher_id"),
                    rs.getInt("user_id"),
                    rs.getString("teacher_name"),
                    rs.getString("email")
                );
                t.setUsername(rs.getString("username"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    /**
     * Crée à la fois le compte utilisateur et la fiche enseignant dans une seule transaction atomique.
     */
    public boolean addTeacherWithAccount(String teacherName, String email, String username, String password) {
        String insertUserSql = "INSERT INTO system_user (username, password, role) VALUES (?, ?, 'TEACHER')";
        String insertTeacherSql = "INSERT INTO teacher (user_id, teacher_name, email) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement userStmt = null;
        PreparedStatement teacherStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Démarrage transaction

            userStmt = conn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, username);
            userStmt.setString(2, PasswordUtil.hashPassword(password));
            userStmt.executeUpdate();

            rs = userStmt.getGeneratedKeys();
            if (!rs.next()) {
                conn.rollback();
                return false;
            }
            int newUserId = rs.getInt(1);

            teacherStmt = conn.prepareStatement(insertTeacherSql);
            teacherStmt.setInt(1, newUserId);
            teacherStmt.setString(2, teacherName);
            teacherStmt.setString(3, email);
            teacherStmt.executeUpdate();

            conn.commit(); // Validation
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            return false;
        } finally {
            DBConnection.close(rs, userStmt, teacherStmt, conn);
        }
    }

    public boolean updateTeacher(Teacher teacher) {
        String sql = "UPDATE teacher SET teacher_name = ?, email = ? WHERE teacher_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, teacher.getTeacherName());
            stmt.setString(2, teacher.getEmail());
            stmt.setInt(3, teacher.getTeacherId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean deleteTeacher(int teacherId) {
        // En supprimant le compte system_user associé, la clé étrangère ON DELETE CASCADE supprime aussi teacher
        Teacher t = getTeacherById(teacherId);
        if (t == null) return false;

        String sql = "DELETE FROM system_user WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, t.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM teacher";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return 0;
    }
}
