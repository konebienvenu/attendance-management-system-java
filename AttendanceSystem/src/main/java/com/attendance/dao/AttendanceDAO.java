package com.attendance.dao;

import com.attendance.model.AttendanceSheetRowDTO;
import com.attendance.model.DashboardStatsDTO;
import com.attendance.model.StudentReportDTO;
import com.attendance.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for the attendance table.
 * Handles attendance roll call sheets, atomic batch transactions, and statistical reports.
 */
public class AttendanceDAO {

    /**
     * Retrieves enrolled students and their attendance status for a given course and date.
     */
    public List<AttendanceSheetRowDTO> getAttendanceSheet(int subjectId, Date date) {
        List<AttendanceSheetRowDTO> list = new ArrayList<>();
        String sql = "SELECT e.enrollment_id, s.student_id, s.enrollment_no, s.student_name, s.email, a.status " +
                     "FROM enrollment e " +
                     "JOIN student s ON e.student_id = s.student_id " +
                     "LEFT JOIN attendance a ON e.enrollment_id = a.enrollment_id AND a.attendance_date = ? " +
                     "WHERE e.subject_id = ? AND e.status = 'ACTIVE' " +
                     "ORDER BY s.enrollment_no ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, date);
            stmt.setInt(2, subjectId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(new AttendanceSheetRowDTO(
                    rs.getInt("enrollment_id"),
                    rs.getInt("student_id"),
                    rs.getString("enrollment_no"),
                    rs.getString("student_name"),
                    rs.getString("email"),
                    rs.getString("status") // 'PRESENT', 'ABSENT', or null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    /**
     * Saves class attendance using an atomic JDBC transaction.
     * Uses ON DUPLICATE KEY UPDATE to allow revisions without creating duplicates.
     */
    public boolean saveBatchAttendance(int teacherId, Date date, Map<Integer, String> enrollmentStatusMap) {
        if (enrollmentStatusMap == null || enrollmentStatusMap.isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) " +
                     "VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by)";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID transaction

            stmt = conn.prepareStatement(sql);

            for (Map.Entry<Integer, String> entry : enrollmentStatusMap.entrySet()) {
                int enrollmentId = entry.getKey();
                String status = entry.getValue();

                stmt.setInt(1, enrollmentId);
                stmt.setDate(2, date);
                stmt.setString(3, status);
                stmt.setInt(4, teacherId);
                stmt.addBatch();
            }

            stmt.executeBatch();
            conn.commit(); // Atomic commit
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on failure
                } catch (SQLException ignored) {
                }
            }
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    /**
     * Generates a consolidated attendance report for a course module.
     * Computes total classes conducted, attended classes, and percentage.
     */
    public List<StudentReportDTO> getStudentReportsBySubject(int subjectId) {
        List<StudentReportDTO> list = new ArrayList<>();
        String sql = "SELECT s.student_id, s.enrollment_no, s.student_name, s.email, " +
                     "COUNT(a.attendance_id) AS total_classes, " +
                     "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS attended_classes " +
                     "FROM enrollment e " +
                     "JOIN student s ON e.student_id = s.student_id " +
                     "LEFT JOIN attendance a ON e.enrollment_id = a.enrollment_id " +
                     "WHERE e.subject_id = ? AND e.status = 'ACTIVE' " +
                     "GROUP BY s.student_id, s.enrollment_no, s.student_name, s.email " +
                     "ORDER BY s.enrollment_no ASC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, subjectId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int total = rs.getInt("total_classes");
                int attended = rs.getInt("attended_classes");
                list.add(new StudentReportDTO(
                    rs.getInt("student_id"),
                    rs.getString("enrollment_no"),
                    rs.getString("student_name"),
                    rs.getString("email"),
                    total,
                    attended
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    /**
     * Retrieves overall system metrics for the Administrator and Faculty dashboards.
     */
    public DashboardStatsDTO getDashboardStats() {
        DashboardStatsDTO stats = new DashboardStatsDTO();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();

            // Total students, faculty, courses, enrollments, and attendance marks
            rs = stmt.executeQuery("SELECT (SELECT COUNT(*) FROM student) AS total_students, " +
                                  "(SELECT COUNT(*) FROM teacher) AS total_teachers, " +
                                  "(SELECT COUNT(*) FROM subject) AS total_subjects, " +
                                  "(SELECT COUNT(*) FROM enrollment WHERE status = 'ACTIVE') AS total_enrollments, " +
                                  "(SELECT COUNT(*) FROM attendance WHERE status = 'PRESENT') AS present_count, " +
                                  "(SELECT COUNT(*) FROM attendance WHERE status = 'ABSENT') AS absent_count");

            if (rs.next()) {
                stats.setTotalStudents(rs.getInt("total_students"));
                stats.setTotalTeachers(rs.getInt("total_teachers"));
                stats.setTotalSubjects(rs.getInt("total_subjects"));
                stats.setTotalEnrollments(rs.getInt("total_enrollments"));
                stats.setTotalPresentRecords(rs.getInt("present_count"));
                stats.setTotalAbsentRecords(rs.getInt("absent_count"));
            }
            rs.close();

            // Stats per subject for the analytical chart
            String subjectSql = "SELECT sub.subject_name, " +
                                "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS present_count, " +
                                "SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) AS absent_count " +
                                "FROM subject sub " +
                                "LEFT JOIN enrollment e ON sub.subject_id = e.subject_id " +
                                "LEFT JOIN attendance a ON e.enrollment_id = a.enrollment_id " +
                                "GROUP BY sub.subject_id, sub.subject_name " +
                                "ORDER BY sub.subject_name";

            rs = stmt.executeQuery(subjectSql);
            while (rs.next()) {
                stats.addSubjectStat(
                    rs.getString("subject_name"),
                    rs.getInt("present_count"),
                    rs.getInt("absent_count")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return stats;
    }
}
