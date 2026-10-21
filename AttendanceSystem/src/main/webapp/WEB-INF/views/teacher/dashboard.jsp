<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Espace Enseignant" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Espace Enseignant" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <!-- Header Banner -->
            <div class="card bg-dark text-white p-4 mb-4 border-0 shadow-sm"
                 style="background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%) !important;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="badge bg-primary mb-2">Session Ouverte</span>
                        <h4 class="fw-bold mb-1">
                            Bonjour, ${sessionScope.currentTeacher != null ? sessionScope.currentTeacher.teacherName : sessionScope.currentUser.username} !
                        </h4>
                        <p class="mb-0 text-white-50">Sélectionnez l'une de vos matières assignées pour effectuer la saisie de présence ou éditer vos rapports.</p>
                    </div>
                    <div class="d-none d-md-block text-end">
                        <div class="small text-white-50">Date d'aujourd'hui :</div>
                        <h5 class="fw-bold text-white mb-0"><%= java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd MMMM yyyy")) %></h5>
                    </div>
                </div>
            </div>

            <!-- Matières assignées -->
            <h5 class="fw-bold text-dark mb-3">Vos Modules d'Enseignement</h5>

            <c:choose>
                <c:when test="${not empty mySubjects}">
                    <div class="row g-4">
                        <c:forEach var="sub" items="${mySubjects}">
                            <div class="col-12 col-md-6 col-lg-4">
                                <div class="card h-100 p-4 border-0 shadow-sm hover-shadow">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="badge bg-primary-subtle text-primary font-monospace fw-bold px-2 py-1">
                                            ${sub.subjectCode}
                                        </span>
                                        <div class="rounded-circle bg-light p-2 text-primary">
                                            <i class="fa-solid fa-graduation-cap fs-5"></i>
                                        </div>
                                    </div>
                                    <h5 class="fw-bold text-dark mb-2">${sub.subjectName}</h5>
                                    <p class="text-muted small mb-4">Module théorique et pratique associé au semestre 3.</p>

                                    <div class="d-flex gap-2 mt-auto">
                                        <a href="${pageContext.request.contextPath}/teacher/attendance?subjectId=${sub.subjectId}" 
                                           class="btn btn-primary btn-sm flex-grow-1">
                                            <i class="fa-solid fa-clipboard-check me-1"></i> Présences
                                        </a>
                                        <a href="${pageContext.request.contextPath}/teacher/reports?subjectId=${sub.subjectId}" 
                                           class="btn btn-outline-secondary btn-sm">
                                            <i class="fa-solid fa-chart-pie me-1"></i> Rapport
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card p-5 text-center text-muted">
                        <i class="fa-solid fa-folder-open fs-1 mb-3 text-secondary"></i>
                        <h5>Aucune matière assignée pour le moment</h5>
                        <p class="small mb-0">Veuillez contacter un administrateur pour l'affectation de vos modules d'enseignement.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
