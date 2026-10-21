package com.attendance.controller;

import com.attendance.dao.EnrollmentDAO;
import com.attendance.dao.StudentDAO;
import com.attendance.dao.SubjectDAO;
import com.attendance.model.Enrollment;
import com.attendance.model.Student;
import com.attendance.model.Subject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 * Contrôleur d'inscription des étudiants aux matières (relation N:M).
 */
@WebServlet("/admin/enrollments")
public class EnrollmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private EnrollmentDAO enrollmentDAO;
    private StudentDAO studentDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        this.enrollmentDAO = new EnrollmentDAO();
        this.studentDAO = new StudentDAO();
        this.subjectDAO = new SubjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Enrollment> enrollments = enrollmentDAO.getAllEnrollments();
        List<Student> students = studentDAO.getAllStudents();
        List<Subject> subjects = subjectDAO.getAllSubjects();

        req.setAttribute("enrollments", enrollments);
        req.setAttribute("students", students);
        req.setAttribute("subjects", subjects);

        req.getRequestDispatcher("/WEB-INF/views/admin/enrollments.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("enroll".equals(action)) {
                int studentId = Integer.parseInt(req.getParameter("studentId"));
                int subjectId = Integer.parseInt(req.getParameter("subjectId"));
                String dateStr = req.getParameter("enrollmentDate");
                Date enrollmentDate = (dateStr != null && !dateStr.isEmpty()) 
                        ? Date.valueOf(dateStr) 
                        : Date.valueOf(LocalDate.now());

                boolean success = enrollmentDAO.enrollStudent(studentId, subjectId, enrollmentDate);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/enrollments?msg=enrolled");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/enrollments?error=already_enrolled");
                }
                return;
            } else if ("toggle".equals(action)) {
                int enrollmentId = Integer.parseInt(req.getParameter("id"));
                String currentStatus = req.getParameter("status");
                String newStatus = "ACTIVE".equalsIgnoreCase(currentStatus) ? "INACTIVE" : "ACTIVE";
                enrollmentDAO.updateStatus(enrollmentId, newStatus);
                resp.sendRedirect(req.getContextPath() + "/admin/enrollments?msg=status_updated");
                return;
            } else if ("delete".equals(action)) {
                int enrollmentId = Integer.parseInt(req.getParameter("id"));
                enrollmentDAO.deleteEnrollment(enrollmentId);
                resp.sendRedirect(req.getContextPath() + "/admin/enrollments?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/enrollments?error=server_error");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/enrollments");
    }
}
