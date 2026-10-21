<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gestion des Matières" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="subjects" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Gestion des Matières" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Matière ajoutée avec succès !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Matière mise à jour !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Matière supprimée.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'duplicate_code'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Erreur : Ce code matière existe déjà.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Catalogue des Matières</h5>
                        <p class="text-muted small mb-0">Total : ${subjects.size()} matières configurées</p>
                    </div>
                    <div class="d-flex gap-2">
                        <div class="input-group" style="max-width: 280px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="subjectsTable" placeholder="Rechercher...">
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                            <i class="fa-solid fa-plus me-1"></i> Nouvelle Matière
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="subjectsTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Code Matière</th>
                                <th>Nom du Module</th>
                                <th>Enseignant Responsable</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sub" items="${subjects}">
                                <tr>
                                    <td class="text-muted fw-semibold">${sub.subjectId}</td>
                                    <td><span class="badge bg-primary-subtle text-primary font-monospace fw-bold">${sub.subjectCode}</span></td>
                                    <td class="fw-semibold text-dark">${sub.subjectName}</td>
                                    <td>
                                        <i class="fa-solid fa-user-tie text-muted me-1"></i>
                                        ${sub.teacherName != null ? sub.teacherName : "Non assigné"}
                                    </td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" data-bs-target="#editSubjectModal${sub.subjectId}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/subjects" method="post" class="d-inline"
                                              onsubmit="return confirm('Confirmez-vous la suppression de cette matière ?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${sub.subjectId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Modal Modification Matière -->
                                <div class="modal fade" id="editSubjectModal${sub.subjectId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="subjectId" value="${sub.subjectId}">
                                                <div class="modal-header">
                                                    <h5 class="modal-title fw-bold">Modifier la Matière</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Code Matière</label>
                                                        <input type="text" name="subjectCode" class="form-control" value="${sub.subjectCode}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Nom de la Matière</label>
                                                        <input type="text" name="subjectName" class="form-control" value="${sub.subjectName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Enseignant Responsable</label>
                                                        <select name="teacherId" class="form-select" required>
                                                            <c:forEach var="t" items="${teachers}">
                                                                <option value="${t.teacherId}" ${t.teacherId == sub.teacherId ? 'selected' : ''}>
                                                                    ${t.teacherName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                                                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Ajout Matière -->
<div class="modal fade" id="addSubjectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Ajouter une Matière</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Code Matière</label>
                        <input type="text" name="subjectCode" class="form-control" placeholder="Ex: 01CE0308" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Nom du Module</label>
                        <input type="text" name="subjectName" class="form-control" placeholder="Ex: Advanced Java Technologies (AJT)" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Enseignant Responsable</label>
                        <select name="teacherId" class="form-select" required>
                            <option value="">Sélectionner un enseignant...</option>
                            <c:forEach var="t" items="${teachers}">
                                <option value="${t.teacherId}">${t.teacherName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Créer la matière</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
