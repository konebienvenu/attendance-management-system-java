package com.attendance.controller;

import com.attendance.dao.TeacherDAO;
import com.attendance.dao.UserDAO;
import com.attendance.model.Teacher;
import com.attendance.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling user authentication (Login, Logout, and Role Routing).
 */
@WebServlet(urlPatterns = {"/login", "/logout", ""})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
        this.teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Sign out action
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
            return;
        }

        // If user is already authenticated, redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                return;
            } else if (user.isTeacher()) {
                resp.sendRedirect(req.getContextPath() + "/teacher/dashboard");
                return;
            }
        }

        // Forward to login page
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both username and password.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password.trim());

        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if (user.isTeacher()) {
                Teacher teacher = teacherDAO.getTeacherByUserId(user.getUserId());
                session.setAttribute("currentTeacher", teacher);
                resp.sendRedirect(req.getContextPath() + "/teacher/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login?error=unknown_role");
            }
        } else {
            req.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            req.setAttribute("enteredUsername", username);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
