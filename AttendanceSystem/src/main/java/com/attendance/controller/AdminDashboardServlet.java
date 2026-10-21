package com.attendance.controller;

import com.attendance.dao.AttendanceDAO;
import com.attendance.model.DashboardStatsDTO;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Contrôleur du tableau de bord Administrateur.
 * Aggrège les métriques globales et prépare les données pour les graphiques Chart.js.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AttendanceDAO attendanceDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.attendanceDAO = new AttendanceDAO();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardStatsDTO stats = attendanceDAO.getDashboardStats();
        req.setAttribute("stats", stats);
        req.setAttribute("subjectStatsJson", gson.toJson(stats.getSubjectStats()));

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
