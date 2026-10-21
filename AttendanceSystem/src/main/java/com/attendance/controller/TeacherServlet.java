package com.attendance.controller;

import com.attendance.dao.TeacherDAO;
import com.attendance.model.Teacher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Contrôleur de gestion des enseignants (CRUD et création de comptes).
 */
@WebServlet("/admin/teachers")
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        this.teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Teacher teacher = teacherDAO.getTeacherById(id);
                req.setAttribute("teacherToEdit", teacher);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Teacher> teachers = teacherDAO.getAllTeachers();
        req.setAttribute("teachers", teachers);
        req.getRequestDispatcher("/WEB-INF/views/admin/teachers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                String name = req.getParameter("teacherName");
                String email = req.getParameter("email");
                String username = req.getParameter("username");
                String password = req.getParameter("password");

                boolean success = teacherDAO.addTeacherWithAccount(name, email, username, password);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/teachers?msg=added");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/teachers?error=duplicate_username");
                }
                return;
            } else if ("update".equals(action)) {
                int teacherId = Integer.parseInt(req.getParameter("teacherId"));
                String name = req.getParameter("teacherName");
                String email = req.getParameter("email");

                Teacher t = new Teacher();
                t.setTeacherId(teacherId);
                t.setTeacherName(name);
                t.setEmail(email);

                teacherDAO.updateTeacher(t);
                resp.sendRedirect(req.getContextPath() + "/admin/teachers?msg=updated");
                return;
            } else if ("delete".equals(action)) {
                int teacherId = Integer.parseInt(req.getParameter("id"));
                teacherDAO.deleteTeacher(teacherId);
                resp.sendRedirect(req.getContextPath() + "/admin/teachers?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/teachers?error=server_error");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/teachers");
    }
}
