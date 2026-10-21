package com.attendance.controller;

import com.attendance.dao.AttendanceDAO;
import com.attendance.dao.SubjectDAO;
import com.attendance.dao.TeacherDAO;
import com.attendance.model.StudentReportDTO;
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
 * Contrôleur des rapports et statistiques de présence.
 */
@WebServlet(urlPatterns = {"/teacher/reports", "/admin/reports"})
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AttendanceDAO attendanceDAO;
    private SubjectDAO subjectDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        this.attendanceDAO = new AttendanceDAO();
        this.subjectDAO = new SubjectDAO();
        this.teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");

        if (teacher == null && user != null && user.isTeacher()) {
            teacher = teacherDAO.getTeacherByUserId(user.getUserId());
            session.setAttribute("currentTeacher", teacher);
        }

        List<Subject> subjects;
        if (user != null && user.isAdmin()) {
            subjects = subjectDAO.getAllSubjects();
        } else if (teacher != null) {
            subjects = subjectDAO.getSubjectsByTeacherId(teacher.getTeacherId());
        } else {
            subjects = subjectDAO.getAllSubjects();
        }
        req.setAttribute("subjects", subjects);

        String subjectIdParam = req.getParameter("subjectId");
        if (subjectIdParam != null && !subjectIdParam.trim().isEmpty()) {
            try {
                int subjectId = Integer.parseInt(subjectIdParam);
                Subject selectedSubject = subjectDAO.getSubjectById(subjectId);
                req.setAttribute("selectedSubject", selectedSubject);

                List<StudentReportDTO> reports = attendanceDAO.getStudentReportsBySubject(subjectId);
                req.setAttribute("reports", reports);

                // Statistiques résumées pour cette matière
                long warningCount = reports.stream().filter(StudentReportDTO::isWarning).count();
                double avgPercentage = reports.stream()
                        .mapToDouble(StudentReportDTO::getPercentage)
                        .average().orElse(0.0);

                req.setAttribute("warningCount", warningCount);
                req.setAttribute("avgPercentage", Math.round(avgPercentage * 10.0) / 10.0);
            } catch (NumberFormatException ignored) {
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/teacher/reports.jsp").forward(req, resp);
    }
}
