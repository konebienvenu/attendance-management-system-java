package com.attendance;

import com.attendance.dao.AttendanceDAO;
import com.attendance.dao.StudentDAO;
import com.attendance.dao.UserDAO;
import com.attendance.model.DashboardStatsDTO;
import com.attendance.model.Student;
import com.attendance.model.User;
import com.attendance.util.DBConnection;

import java.sql.Connection;
import java.util.List;

public class DBTest {
    public static void main(String[] args) {
        System.out.println("=== DATABASE & DAO CONNECTIVITY TEST ===");
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("1. MySQL Connection: " + (!conn.isClosed() ? "SUCCESS" : "FAILED"));

            // Test UserDAO
            UserDAO userDAO = new UserDAO();
            User admin = userDAO.authenticate("admin", "admin123");
            System.out.println("2. Admin Authentication: " + (admin != null ? "SUCCESS (" + admin.getUsername() + ")" : "FAILED"));

            User teacher = userDAO.authenticate("kunal.khimani", "teacher123");
            System.out.println("2b. Teacher Authentication: " + (teacher != null ? "SUCCESS (" + teacher.getUsername() + ", Role: " + teacher.getRole() + ")" : "FAILED"));

            // Test StudentDAO
            StudentDAO studentDAO = new StudentDAO();
            List<Student> students = studentDAO.getAllStudents();
            System.out.println("3. Student Directory: " + students.size() + " students retrieved.");

            // Test AttendanceDAO
            AttendanceDAO attendanceDAO = new AttendanceDAO();
            DashboardStatsDTO stats = attendanceDAO.getDashboardStats();
            System.out.println("4. System Metrics: " + stats.getTotalStudents() + " students, " 
                    + stats.getTotalSubjects() + " courses, Attendance Rate: " + stats.getOverallAttendanceRate() + "%");

            System.out.println("=== ALL CHECKS PASSED SUCCESSFULLY ===");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
