package com.attendance.dao;

import com.attendance.model.Subject;
import com.attendance.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object pour la table subject.
 */
public class SubjectDAO {

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, s.teacher_id, t.teacher_name " +
                     "FROM subject s " +
                     "JOIN teacher t ON s.teacher_id = t.teacher_id " +
                     "ORDER BY s.subject_code ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Subject s = new Subject(
                    rs.getInt("subject_id"),
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("teacher_id")
                );
                s.setTeacherName(rs.getString("teacher_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public List<Subject> getSubjectsByTeacherId(int teacherId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, s.teacher_id, t.teacher_name " +
                     "FROM subject s " +
                     "JOIN teacher t ON s.teacher_id = t.teacher_id " +
                     "WHERE s.teacher_id = ? " +
                     "ORDER BY s.subject_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, teacherId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Subject s = new Subject(
                    rs.getInt("subject_id"),
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("teacher_id")
                );
                s.setTeacherName(rs.getString("teacher_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public Subject getSubjectById(int subjectId) {
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, s.teacher_id, t.teacher_name " +
                     "FROM subject s " +
                     "JOIN teacher t ON s.teacher_id = t.teacher_id " +
                     "WHERE s.subject_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, subjectId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Subject s = new Subject(
                    rs.getInt("subject_id"),
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("teacher_id")
                );
                s.setTeacherName(rs.getString("teacher_name"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    public boolean addSubject(Subject subject) {
        String sql = "INSERT INTO subject (subject_code, subject_name, teacher_id) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, subject.getSubjectCode());
            stmt.setString(2, subject.getSubjectName());
            stmt.setInt(3, subject.getTeacherId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean updateSubject(Subject subject) {
        String sql = "UPDATE subject SET subject_code = ?, subject_name = ?, teacher_id = ? WHERE subject_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, subject.getSubjectCode());
            stmt.setString(2, subject.getSubjectName());
            stmt.setInt(3, subject.getTeacherId());
            stmt.setInt(4, subject.getSubjectId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean deleteSubject(int subjectId) {
        String sql = "DELETE FROM subject WHERE subject_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, subjectId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM subject";
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
