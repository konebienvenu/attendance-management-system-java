<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gestion des Inscriptions (N:M)" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="enrollments" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Inscriptions aux Cours (Relation N:M)" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <c:if test="${param.msg == 'enrolled'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Étudiant inscrit à la matière avec succès !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'status_updated'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-rotate me-2"></i>Statut de l'inscription modifié.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Inscription supprimée.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'already_enrolled'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Erreur : Cet étudiant est déjà inscrit à cette matière (Contrainte d'unicité respectée).
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Inscriptions Actives & Historique</h5>
                        <p class="text-muted small mb-0">Total : ${enrollments.size()} liens d'inscription enregistrés</p>
                    </div>
                    <div class="d-flex gap-2">
                        <div class="input-group" style="max-width: 280px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="enrollmentsTable" placeholder="Filtrer...">
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#enrollModal">
                            <i class="fa-solid fa-link me-1"></i> Inscrire un Étudiant
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="enrollmentsTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Étudiant</th>
                                <th>N° Enrôlement</th>
                                <th>Matière</th>
                                <th>Date d'Inscription</th>
                                <th>Statut</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${enrollments}">
                                <tr>
                                    <td class="text-muted fw-semibold">${e.enrollmentId}</td>
                                    <td class="fw-semibold text-dark">${e.studentName}</td>
                                    <td><span class="badge bg-light text-primary border font-monospace">${e.enrollmentNo}</span></td>
                                    <td>
                                        <span class="badge bg-secondary-subtle text-secondary me-1 font-monospace">${e.subjectCode}</span>
                                        ${e.subjectName}
                                    </td>
                                    <td class="text-muted small">${e.enrollmentDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.status == 'ACTIVE'}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle">ACTIF</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-muted border">INACTIF</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/enrollments" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="toggle">
                                            <input type="hidden" name="id" value="${e.enrollmentId}">
                                            <input type="hidden" name="status" value="${e.status}">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary me-1" title="Basculer Statut">
                                                <i class="fa-solid fa-power-off"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/enrollments" method="post" class="d-inline"
                                              onsubmit="return confirm('Confirmez-vous la désinscription ?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${e.enrollmentId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Nouvelle Inscription -->
<div class="modal fade" id="enrollModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/enrollments" method="post">
                <input type="hidden" name="action" value="enroll">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Inscrire un Étudiant à un Cours</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Sélectionner l'Étudiant</label>
                        <select name="studentId" class="form-select" required>
                            <option value="">Choisir un étudiant...</option>
                            <c:forEach var="s" items="${students}">
                                <option value="${s.studentId}">[${s.enrollmentNo}] - ${s.studentName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Sélectionner la Matière</label>
                        <select name="subjectId" class="form-select" required>
                            <option value="">Choisir une matière...</option>
                            <c:forEach var="sub" items="${subjects}">
                                <option value="${sub.subjectId}">[${sub.subjectCode}] - ${sub.subjectName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Date d'Inscription</label>
                        <input type="date" name="enrollmentDate" class="form-control" value="<%= java.time.LocalDate.now() %>" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Valider l'inscription</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
