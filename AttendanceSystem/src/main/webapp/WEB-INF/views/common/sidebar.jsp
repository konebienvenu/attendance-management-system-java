<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="sidebar d-flex flex-column flex-shrink-0">
    <div class="brand d-flex align-items-center">
        <i class="fa-solid fa-clipboard-user fs-4 me-2"></i>
        <span>Attendance<span class="text-primary-emphasis">Hub</span></span>
    </div>

    <div class="p-3">
        <small class="text-uppercase text-secondary fw-semibold px-3" style="font-size: 0.7rem; letter-spacing: 0.08em;">
            Main Navigation
        </small>
    </div>

    <ul class="nav nav-pills flex-column mb-auto">
        <!-- Administrator Links -->
        <c:if test="${sessionScope.currentUser.admin}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" 
                   class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-pie"></i>
                    Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/students" 
                   class="nav-link ${param.activeMenu == 'students' ? 'active' : ''}">
                    <i class="fa-solid fa-user-graduate"></i>
                    Students
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/teachers" 
                   class="nav-link ${param.activeMenu == 'teachers' ? 'active' : ''}">
                    <i class="fa-solid fa-chalkboard-user"></i>
                    Faculty
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/subjects" 
                   class="nav-link ${param.activeMenu == 'subjects' ? 'active' : ''}">
                    <i class="fa-solid fa-book-bookmark"></i>
                    Courses & Subjects
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/enrollments" 
                   class="nav-link ${param.activeMenu == 'enrollments' ? 'active' : ''}">
                    <i class="fa-solid fa-user-check"></i>
                    Course Enrollments (N:M)
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/reports" 
                   class="nav-link ${param.activeMenu == 'reports' ? 'active' : ''}">
                    <i class="fa-solid fa-file-invoice"></i>
                    Reports & 75% Rule
                </a>
            </li>
        </c:if>

        <!-- Faculty Links -->
        <c:if test="${sessionScope.currentUser.teacher}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" 
                   class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-house-laptop"></i>
                    Faculty Portal
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/attendance" 
                   class="nav-link ${param.activeMenu == 'attendance' ? 'active' : ''}">
                    <i class="fa-solid fa-calendar-check"></i>
                    Take Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/reports" 
                   class="nav-link ${param.activeMenu == 'reports' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-column"></i>
                    Analytics & Alerts
                </a>
            </li>
        </c:if>
    </ul>

    <!-- Sidebar Footer -->
    <div class="p-3 border-top border-secondary-subtle">
        <div class="small text-secondary">
            <div><strong>AJT - 01CE0308</strong></div>
            <div class="text-white-50" style="font-size: 0.75rem;">Enterprise Java EE Project</div>
        </div>
    </div>
</div>
