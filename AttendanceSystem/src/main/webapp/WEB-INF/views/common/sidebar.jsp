<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="sidebar d-flex flex-column flex-shrink-0">
    <div class="brand d-flex align-items-center">
        <i class="fa-solid fa-clipboard-user fs-4 me-2"></i>
        <span>Attendance<span class="text-primary-emphasis">Hub</span></span>
    </div>

    <div class="p-3">
        <small class="text-uppercase text-secondary fw-semibold px-3" style="font-size: 0.7rem; letter-spacing: 0.08em;">
            Menu Principal
        </small>
    </div>

    <ul class="nav nav-pills flex-column mb-auto">
        <!-- Liens Administrateur -->
        <c:if test="${sessionScope.currentUser.admin}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" 
                   class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-pie"></i>
                    Tableau de bord
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/students" 
                   class="nav-link ${param.activeMenu == 'students' ? 'active' : ''}">
                    <i class="fa-solid fa-user-graduate"></i>
                    Étudiants
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/teachers" 
                   class="nav-link ${param.activeMenu == 'teachers' ? 'active' : ''}">
                    <i class="fa-solid fa-chalkboard-user"></i>
                    Enseignants
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/subjects" 
                   class="nav-link ${param.activeMenu == 'subjects' ? 'active' : ''}">
                    <i class="fa-solid fa-book-bookmark"></i>
                    Matières
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/enrollments" 
                   class="nav-link ${param.activeMenu == 'enrollments' ? 'active' : ''}">
                    <i class="fa-solid fa-user-check"></i>
                    Inscriptions (N:M)
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/reports" 
                   class="nav-link ${param.activeMenu == 'reports' ? 'active' : ''}">
                    <i class="fa-solid fa-file-invoice"></i>
                    Rapports & 75%
                </a>
            </li>
        </c:if>

        <!-- Liens Enseignant -->
        <c:if test="${sessionScope.currentUser.teacher}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" 
                   class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}">
                    <i class="fa-solid fa-house-laptop"></i>
                    Mon Tableau de bord
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/attendance" 
                   class="nav-link ${param.activeMenu == 'attendance' ? 'active' : ''}">
                    <i class="fa-solid fa-calendar-check"></i>
                    Prise de Présence
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/teacher/reports" 
                   class="nav-link ${param.activeMenu == 'reports' ? 'active' : ''}">
                    <i class="fa-solid fa-chart-column"></i>
                    Statistiques & Alertes
                </a>
            </li>
        </c:if>
    </ul>

    <!-- Footer Sidebar -->
    <div class="p-3 border-top border-secondary-subtle">
        <div class="small text-secondary">
            <div><strong>AJT - 01CE0308</strong></div>
            <div class="text-white-50" style="font-size: 0.75rem;">Projet Entreprise Java EE</div>
        </div>
    </div>
</div>
