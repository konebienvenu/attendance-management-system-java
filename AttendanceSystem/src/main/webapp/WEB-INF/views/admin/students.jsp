<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gestion des Étudiants" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="students" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Gestion des Étudiants" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <!-- Messages de retour -->
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Étudiant ajouté avec succès !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Informations de l'étudiant mises à jour !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Étudiant supprimé.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'duplicate_enrollment'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Erreur : Ce numéro d'inscription (Enrollment No) existe déjà.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Liste des Étudiants Inscrits</h5>
                        <p class="text-muted small mb-0">Total : ${students.size()} étudiants répertoriés</p>
                    </div>
                    <div class="d-flex gap-2">
                        <div class="input-group" style="max-width: 280px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="studentsTable" placeholder="Rechercher...">
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                            <i class="fa-solid fa-plus me-1"></i> Ajouter un Étudiant
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="studentsTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>N° Enrôlement</th>
                                <th>Nom Complet</th>
                                <th>Email Universitaire</th>
                                <th>Semestre</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${students}">
                                <tr>
                                    <td class="text-muted fw-semibold">${s.studentId}</td>
                                    <td><span class="badge bg-light text-primary border fw-bold">${s.enrollmentNo}</span></td>
                                    <td class="fw-semibold text-dark">${s.studentName}</td>
                                    <td class="text-muted">${s.email}</td>
                                    <td><span class="badge bg-secondary-subtle text-secondary px-2">Semestre ${s.semester}</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" data-bs-target="#editModal${s.studentId}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/students" method="post" class="d-inline"
                                              onsubmit="return confirm('Confirmez-vous la suppression de cet étudiant ?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.studentId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Modal Modification Étudiant -->
                                <div class="modal fade" id="editModal${s.studentId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="studentId" value="${s.studentId}">
                                                <div class="modal-header">
                                                    <h5 class="modal-title fw-bold">Modifier l'Étudiant</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">N° Enrôlement</label>
                                                        <input type="text" name="enrollmentNo" class="form-control" value="${s.enrollmentNo}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Nom Complet</label>
                                                        <input type="text" name="studentName" class="form-control" value="${s.studentName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Adresse Email</label>
                                                        <input type="email" name="email" class="form-control" value="${s.email}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Semestre</label>
                                                        <input type="number" name="semester" class="form-control" value="${s.semester}" min="1" max="8" required>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                                                    <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
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

<!-- Modal Ajout Étudiant -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Ajouter un Nouvel Étudiant</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">N° Enrôlement</label>
                        <input type="text" name="enrollmentNo" class="form-control" placeholder="Ex: 23CE009" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Nom Complet</label>
                        <input type="text" name="studentName" class="form-control" placeholder="Ex: Jean Dupont" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Adresse Email</label>
                        <input type="email" name="email" class="form-control" placeholder="jean.dupont@student.edu" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Semestre</label>
                        <input type="number" name="semester" class="form-control" value="3" min="1" max="8" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Ajouter l'étudiant</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
