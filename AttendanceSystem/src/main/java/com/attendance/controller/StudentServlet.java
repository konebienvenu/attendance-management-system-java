package com.attendance.controller;

import com.attendance.dao.StudentDAO;
import com.attendance.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller managing student records (CRUD operations).
 */
@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        this.studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Student student = studentDAO.getStudentById(id);
                req.setAttribute("studentToEdit", student);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Student> students = studentDAO.getAllStudents();
        req.setAttribute("students", students);
        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                String enrollmentNo = req.getParameter("enrollmentNo");
                String name = req.getParameter("studentName");
                String email = req.getParameter("email");
                int semester = Integer.parseInt(req.getParameter("semester"));

                Student student = new Student(enrollmentNo, name, email, semester);
                boolean success = studentDAO.addStudent(student);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/students?msg=added");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/students?error=duplicate_enrollment");
                }
                return;
            } else if ("update".equals(action)) {
                int studentId = Integer.parseInt(req.getParameter("studentId"));
                String enrollmentNo = req.getParameter("enrollmentNo");
                String name = req.getParameter("studentName");
                String email = req.getParameter("email");
                int semester = Integer.parseInt(req.getParameter("semester"));

                Student student = new Student(studentId, enrollmentNo, name, email, semester);
                studentDAO.updateStudent(student);
                resp.sendRedirect(req.getContextPath() + "/admin/students?msg=updated");
                return;
            } else if ("delete".equals(action)) {
                int studentId = Integer.parseInt(req.getParameter("id"));
                studentDAO.deleteStudent(studentId);
                resp.sendRedirect(req.getContextPath() + "/admin/students?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/students?error=server_error");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/students");
    }
}
