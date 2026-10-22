package com.attendance.dao;

import com.attendance.model.Student;
import com.attendance.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the student table.
 * Provides complete CRUD operations with robust exception handling.
 */
public class StudentDAO {

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT student_id, enrollment_no, student_name, email, semester FROM student ORDER BY enrollment_no ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(new Student(
                    rs.getInt("student_id"),
                    rs.getString("enrollment_no"),
                    rs.getString("student_name"),
                    rs.getString("email"),
                    rs.getInt("semester")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return list;
    }

    public Student getStudentById(int studentId) {
        String sql = "SELECT student_id, enrollment_no, student_name, email, semester FROM student WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return new Student(
                    rs.getInt("student_id"),
                    rs.getString("enrollment_no"),
                    rs.getString("student_name"),
                    rs.getString("email"),
                    rs.getInt("semester")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, stmt, conn);
        }
        return null;
    }

    public boolean addStudent(Student student) {
        String sql = "INSERT INTO student (enrollment_no, student_name, email, semester) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getEnrollmentNo());
            stmt.setString(2, student.getStudentName());
            stmt.setString(3, student.getEmail());
            stmt.setInt(4, student.getSemester());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean updateStudent(Student student) {
        String sql = "UPDATE student SET enrollment_no = ?, student_name = ?, email = ?, semester = ? WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getEnrollmentNo());
            stmt.setString(2, student.getStudentName());
            stmt.setString(3, student.getEmail());
            stmt.setInt(4, student.getSemester());
            stmt.setInt(5, student.getStudentId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public boolean deleteStudent(int studentId) {
        String sql = "DELETE FROM student WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(stmt, conn);
        }
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM student";
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
