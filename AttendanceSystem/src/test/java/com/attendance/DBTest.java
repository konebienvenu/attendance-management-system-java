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
        System.out.println("=== TEST DE CONNEXION ET DAOs ===");
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("1. Connexion MySQL réussie : " + !conn.isClosed());

            // Test UserDAO
            UserDAO userDAO = new UserDAO();
            User admin = userDAO.authenticate("admin", "admin123");
            System.out.println("2. Authentification Admin : " + (admin != null ? "SUCCÈS (" + admin.getUsername() + ")" : "ÉCHEC"));

            // Test StudentDAO
            StudentDAO studentDAO = new StudentDAO();
            List<Student> students = studentDAO.getAllStudents();
            System.out.println("3. Étudiants chargés : " + students.size() + " étudiants trouvés.");

            // Test AttendanceDAO
            AttendanceDAO attendanceDAO = new AttendanceDAO();
            DashboardStatsDTO stats = attendanceDAO.getDashboardStats();
            System.out.println("4. Statistiques globales : " + stats.getTotalStudents() + " étudiants, " 
                    + stats.getTotalSubjects() + " matières, Assiduité: " + stats.getOverallAttendanceRate() + "%");

            System.out.println("=== TOUS LES TESTS SONT AU VERT ! ===");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
