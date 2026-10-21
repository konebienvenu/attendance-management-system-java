<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Gestion des Enseignants" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="teachers" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Gestion des Enseignants" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Enseignant et compte utilisateur créés avec succès !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Informations enseignant mises à jour !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Enseignant et son compte utilisateur supprimés.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'duplicate_username'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Erreur : Ce nom d'utilisateur (Username) est déjà utilisé.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Corps Professoral</h5>
                        <p class="text-muted small mb-0">Total : ${teachers.size()} enseignants enregistrés</p>
                    </div>
                    <div class="d-flex gap-2">
                        <div class="input-group" style="max-width: 280px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="teachersTable" placeholder="Rechercher...">
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#addTeacherModal">
                            <i class="fa-solid fa-user-plus me-1"></i> Nouvel Enseignant
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="teachersTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Nom de l'Enseignant</th>
                                <th>Compte Système (Username)</th>
                                <th>Email</th>
                                <th>Rôle</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${teachers}">
                                <tr>
                                    <td class="text-muted fw-semibold">${t.teacherId}</td>
                                    <td class="fw-semibold text-dark">
                                        <i class="fa-solid fa-chalkboard-user text-primary me-2"></i>${t.teacherName}
                                    </td>
                                    <td><span class="badge bg-light text-dark border font-monospace">${t.username}</span></td>
                                    <td class="text-muted">${t.email}</td>
                                    <td><span class="badge badge-role badge-teacher">TEACHER</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" data-bs-target="#editModalTeacher${t.teacherId}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/teachers" method="post" class="d-inline"
                                              onsubmit="return confirm('Confirmez-vous la suppression de cet enseignant ?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${t.teacherId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Modal Modification Enseignant -->
                                <div class="modal fade" id="editModalTeacher${t.teacherId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="teacherId" value="${t.teacherId}">
                                                <div class="modal-header">
                                                    <h5 class="modal-title fw-bold">Modifier l'Enseignant</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Nom Complet</label>
                                                        <input type="text" name="teacherName" class="form-control" value="${t.teacherName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Adresse Email</label>
                                                        <input type="email" name="email" class="form-control" value="${t.email}" required>
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

<!-- Modal Ajout Enseignant -->
<div class="modal fade" id="addTeacherModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Ajouter un Enseignant (avec compte de connexion)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Nom Complet</label>
                        <input type="text" name="teacherName" class="form-control" placeholder="Ex: Prof. Marc Blanc" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Adresse Email</label>
                        <input type="email" name="email" class="form-control" placeholder="marc.blanc@university.edu" required>
                    </div>
                    <hr>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Nom d'utilisateur (Username pour le login)</label>
                        <input type="text" name="username" class="form-control" placeholder="Ex: marc.blanc" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Mot de passe initial</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Créer l'enseignant et son compte</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
