package com.attendance.controller;

import com.attendance.dao.AttendanceDAO;
import com.attendance.dao.SubjectDAO;
import com.attendance.dao.TeacherDAO;
import com.attendance.model.AttendanceSheetRowDTO;
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
import java.sql.Date;
import java.time.LocalDate;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for interactive class attendance roll call.
 */
@WebServlet("/teacher/attendance")
public class AttendanceServlet extends HttpServlet {
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

        if (user != null && user.isTeacher()) {
            teacher = teacherDAO.getTeacherByUserId(user.getUserId());
            session.setAttribute("currentTeacher", teacher);
        }

        // Accessible courses
        List<Subject> subjects;
        if (user != null && user.isAdmin()) {
            subjects = subjectDAO.getAllSubjects();
        } else if (teacher != null) {
            subjects = subjectDAO.getSubjectsByTeacherId(teacher.getTeacherId());
        } else {
            subjects = subjectDAO.getAllSubjects();
        }
        req.setAttribute("subjects", subjects);

        // Selected date (defaults to current date)
        String dateParam = req.getParameter("date");
        Date attendanceDate;
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                attendanceDate = Date.valueOf(dateParam);
            } catch (IllegalArgumentException e) {
                attendanceDate = Date.valueOf(LocalDate.now());
            }
        } else {
            attendanceDate = Date.valueOf(LocalDate.now());
        }
        req.setAttribute("selectedDate", attendanceDate.toString());

        // Selected course module (defaults to first available course for seamless UX)
        String subjectIdParam = req.getParameter("subjectId");
        int subjectIdToLoad = -1;
        if (subjectIdParam != null && !subjectIdParam.trim().isEmpty()) {
            try {
                subjectIdToLoad = Integer.parseInt(subjectIdParam);
            } catch (NumberFormatException ignored) {
            }
        } else if (subjects != null && !subjects.isEmpty()) {
            subjectIdToLoad = subjects.get(0).getSubjectId();
        }

        if (subjectIdToLoad > 0) {
            req.setAttribute("selectedSubjectId", subjectIdToLoad);
            Subject selectedSubject = subjectDAO.getSubjectById(subjectIdToLoad);
            req.setAttribute("selectedSubject", selectedSubject);

            // Fetch roll call sheet (enrolled students + recorded statuses)
            List<AttendanceSheetRowDTO> sheet = attendanceDAO.getAttendanceSheet(subjectIdToLoad, attendanceDate);
            req.setAttribute("attendanceSheet", sheet);
        }

        req.getRequestDispatcher("/WEB-INF/views/teacher/mark_attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");
        int subjectId = Integer.parseInt(req.getParameter("subjectId"));

        int teacherId = 1;
        if (teacher != null) {
            teacherId = teacher.getTeacherId();
        } else {
            Subject subj = subjectDAO.getSubjectById(subjectId);
            if (subj != null && subj.getTeacherId() > 0) {
                teacherId = subj.getTeacherId();
            }
        }
        String dateParam = req.getParameter("attendanceDate");
        Date attendanceDate = Date.valueOf(dateParam);

        // Read attendance status per student enrollment: status_{enrollmentId}
        Map<Integer, String> statusMap = new HashMap<>();
        Enumeration<String> paramNames = req.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("status_")) {
                int enrollmentId = Integer.parseInt(paramName.substring("status_".length()));
                String status = req.getParameter(paramName);
                if ("PRESENT".equalsIgnoreCase(status) || "ABSENT".equalsIgnoreCase(status)) {
                    statusMap.put(enrollmentId, status.toUpperCase());
                }
            }
        }

        boolean success = attendanceDAO.saveBatchAttendance(teacherId, attendanceDate, statusMap);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance?subjectId=" + subjectId 
                    + "&date=" + attendanceDate.toString() + "&msg=attendance_saved");
        } else {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance?subjectId=" + subjectId 
                    + "&date=" + attendanceDate.toString() + "&error=save_failed");
        }
    }
}
