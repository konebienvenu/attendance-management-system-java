package com.attendance.controller;

import com.attendance.dao.SubjectDAO;
import com.attendance.dao.TeacherDAO;
import com.attendance.model.Subject;
import com.attendance.model.Teacher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller managing academic courses and faculty assignments.
 */
@WebServlet("/admin/subjects")
public class SubjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private SubjectDAO subjectDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        this.subjectDAO = new SubjectDAO();
        this.teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Subject subject = subjectDAO.getSubjectById(id);
                req.setAttribute("subjectToEdit", subject);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Teacher> teachers = teacherDAO.getAllTeachers();

        req.setAttribute("subjects", subjects);
        req.setAttribute("teachers", teachers);
        req.getRequestDispatcher("/WEB-INF/views/admin/subjects.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                String code = req.getParameter("subjectCode");
                String name = req.getParameter("subjectName");
                int teacherId = Integer.parseInt(req.getParameter("teacherId"));

                Subject subject = new Subject(code, name, teacherId);
                boolean success = subjectDAO.addSubject(subject);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=added");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=duplicate_code");
                }
                return;
            } else if ("update".equals(action)) {
                int subjectId = Integer.parseInt(req.getParameter("subjectId"));
                String code = req.getParameter("subjectCode");
                String name = req.getParameter("subjectName");
                int teacherId = Integer.parseInt(req.getParameter("teacherId"));

                Subject subject = new Subject(subjectId, code, name, teacherId);
                subjectDAO.updateSubject(subject);
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=updated");
                return;
            } else if ("delete".equals(action)) {
                int subjectId = Integer.parseInt(req.getParameter("id"));
                subjectDAO.deleteSubject(subjectId);
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=server_error");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/subjects");
    }
}
