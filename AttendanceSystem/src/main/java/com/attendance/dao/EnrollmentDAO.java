package com.attendance.dao;

import com.attendance.model.Enrollment;
import com.attendance.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object pour la table enrollment.
 */
public class EnrollmentDAO {

    public List<Enrollment> getAllEnrollments() {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, e.student_id, e.subject_id, e.enrollment_date, e.status, " +
                     "st.student_name, st.enrollment_no, sub.subject_code, sub.subject_name " +
                     "FROM enrollment e " +
                     "JOIN student st ON e.student_id = st.student_id " +
                     "JOIN subject sub ON e.subject_id = sub.subject_id " +
                     "ORDER BY sub.subject_code, st.enrollment_no";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Enrollment e = new Enrollment(
                    rs.getInt("enrollment_id"),
                    rs.getInt("student_id"),
                    rs.getInt("subject_id"),
                    rs.getDate("enrollment_date"),
                    rs.getString("status")
                );
                e.setStudentName(rs.getString("student_name"));
                e.setEnrollmentNo(rs.getString("enrollment_no"));
                e.setSubjectCode(rs.getString("subject_code"));
                e.setSubjectName(rs.getString("subject_name"));
                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public List<Enrollment> getEnrollmentsBySubject(int subjectId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, e.student_id, e.subject_id, e.enrollment_date, e.status, " +
                     "st.student_name, st.enrollment_no, sub.subject_code, sub.subject_name " +
                     "FROM enrollment e " +
                     "JOIN student st ON e.student_id = st.student_id " +
                     "JOIN subject sub ON e.subject_id = sub.subject_id " +
                     "WHERE e.subject_id = ? AND e.status = 'ACTIVE' " +
                     "ORDER BY st.enrollment_no";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, subjectId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Enrollment e = new Enrollment(
                    rs.getInt("enrollment_id"),
                    rs.getInt("student_id"),
                    rs.getInt("subject_id"),
                    rs.getDate("enrollment_date"),
                    rs.getString("status")
                );
                e.setStudentName(rs.getString("student_name"));
                e.setEnrollmentNo(rs.getString("enrollment_no"));
                e.setSubjectCode(rs.getString("subject_code"));
                e.setSubjectName(rs.getString("subject_name"));
                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public boolean enrollStudent(int studentId, int subjectId, Date enrollmentDate) {
        String sql = "INSERT INTO enrollment (student_id, subject_id, enrollment_date, status) VALUES (?, ?, ?, 'ACTIVE')";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setDate(3, enrollmentDate);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean updateStatus(int enrollmentId, String status) {
        String sql = "UPDATE enrollment SET status = ? WHERE enrollment_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, enrollmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean deleteEnrollment(int enrollmentId) {
        String sql = "DELETE FROM enrollment WHERE enrollment_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, enrollmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM enrollment WHERE status = 'ACTIVE'";
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
