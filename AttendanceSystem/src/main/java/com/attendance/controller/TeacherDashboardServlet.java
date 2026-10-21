package com.attendance.controller;

import com.attendance.dao.SubjectDAO;
import com.attendance.dao.TeacherDAO;
import com.attendance.model.Subject;
import com.attendance.model.Teacher;
import com.attendance.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Contrôleur du tableau de bord Enseignant.
 */
@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {
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
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");

        // Si la session n'avait pas encore stocké le Teacher
        if (teacher == null && user != null) {
            teacher = teacherDAO.getTeacherByUserId(user.getUserId());
            session.setAttribute("currentTeacher", teacher);
        }

        if (teacher != null) {
            List<Subject> mySubjects = subjectDAO.getSubjectsByTeacherId(teacher.getTeacherId());
            req.setAttribute("mySubjects", mySubjects);
        }

        req.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(req, resp);
    }
}
