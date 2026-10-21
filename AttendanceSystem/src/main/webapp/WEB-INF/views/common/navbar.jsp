<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header class="topbar d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-3">
        <h5 class="mb-0 fw-bold text-dark">
            <i class="fa-solid fa-graduation-cap text-primary me-2"></i>
            ${param.pageHeading != null ? param.pageHeading : "Tableau de Bord"}
        </h5>
        <span class="badge bg-light text-muted border px-2 py-1">AJT Semestre 3</span>
    </div>

    <div class="d-flex align-items-center gap-3">
        <div class="d-flex align-items-center gap-2">
            <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold" style="width: 38px; height: 38px;">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        ${sessionScope.currentUser.username.substring(0, 1).toUpperCase()}
                    </c:when>
                    <c:otherwise>U</c:otherwise>
                </c:choose>
            </div>
            <div class="d-none d-md-block text-start">
                <div class="fw-semibold text-dark small">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentTeacher}">
                            ${sessionScope.currentTeacher.teacherName}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.currentUser.username}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="small">
                    <c:if test="${sessionScope.currentUser.admin}">
                        <span class="badge badge-role badge-admin">ADMINISTRATEUR</span>
                    </c:if>
                    <c:if test="${sessionScope.currentUser.teacher}">
                        <span class="badge badge-role badge-teacher">ENSEIGNANT</span>
                    </c:if>
                </div>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm px-3 rounded-pill" title="Se déconnecter">
            <i class="fa-solid fa-arrow-right-from-bracket me-1"></i>
            <span class="d-none d-sm-inline">Déconnexion</span>
        </a>
    </div>
</header>
