<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Rapports & Statistiques d'Assiduité" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="reports" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Rapports & Analyse d'Assiduité" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <!-- Sélecteur de Matière -->
            <div class="card p-4 mb-4">
                <form action="" method="get" class="row g-3 align-items-end">
                    <div class="col-12 col-md-8">
                        <label class="form-label fw-semibold small text-secondary">Sélectionner la Matière à Analyser</label>
                        <select name="subjectId" class="form-select" required onchange="this.form.submit()">
                            <option value="">-- Choisir un cours --</option>
                            <c:forEach var="s" items="${subjects}">
                                <option value="${s.subjectId}" ${s.subjectId == selectedSubject.subjectId ? 'selected' : ''}>
                                    [${s.subjectCode}] ${s.subjectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-12 col-md-4">
                        <button type="submit" class="btn btn-outline-primary w-100">
                            <i class="fa-solid fa-chart-pie me-1"></i> Générer le Rapport
                        </button>
                    </div>
                </form>
            </div>

            <c:choose>
                <c:when test="${not empty selectedSubject}">
                    <!-- KPI Cards for Selected Subject -->
                    <div class="row g-3 mb-4">
                        <div class="col-12 col-md-4">
                            <div class="card p-3 stat-card h-100" style="border-left-color: #4f46e5;">
                                <div class="text-muted small fw-semibold text-uppercase">Module Analysé</div>
                                <h5 class="fw-bold my-1 text-truncate">${selectedSubject.subjectName}</h5>
                                <div class="small text-muted font-monospace">${selectedSubject.subjectCode}</div>
                            </div>
                        </div>

                        <div class="col-12 col-md-4">
                            <div class="card p-3 stat-card h-100" style="border-left-color: #10b981;">
                                <div class="text-muted small fw-semibold text-uppercase">Taux Moyen d'Assiduité</div>
                                <h3 class="fw-bold my-1 text-success">${avgPercentage}%</h3>
                                <div class="small text-muted">Sur l'ensemble des étudiants</div>
                            </div>
                        </div>

                        <div class="col-12 col-md-4">
                            <div class="card p-3 stat-card h-100" style="border-left-color: #ef4444;">
                                <div class="text-muted small fw-semibold text-uppercase">Alerte Règle des 75%</div>
                                <h3 class="fw-bold my-1 text-danger">${warningCount}</h3>
                                <div class="small text-danger">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i>Étudiants sous le seuil minimal
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tableau du rapport -->
                    <div class="card p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h5 class="fw-bold text-dark mb-1">Détail Individuel par Étudiant</h5>
                                <p class="text-muted small mb-0">Le seuil universitaire d'admissibilité aux examens est fixé à <strong>75%</strong>.</p>
                            </div>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="window.print()">
                                <i class="fa-solid fa-print me-1"></i> Imprimer / Exporter PDF
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-modern table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>N° Enrôlement</th>
                                        <th>Nom de l'Étudiant</th>
                                        <th>Email</th>
                                        <th class="text-center">Séances Totales</th>
                                        <th class="text-center">Présences</th>
                                        <th style="min-width: 200px;">Assiduité (%)</th>
                                        <th class="text-end">Statut Universitaire</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${reports}">
                                        <tr class="${r.warning ? 'table-danger-subtle' : ''}">
                                            <td>
                                                <span class="badge bg-light text-primary border font-monospace fw-bold">
                                                    ${r.enrollmentNo}
                                                </span>
                                            </td>
                                            <td class="fw-semibold text-dark">${r.studentName}</td>
                                            <td class="text-muted small">${r.email}</td>
                                            <td class="text-center fw-semibold">${r.totalClasses}</td>
                                            <td class="text-center text-success fw-bold">${r.attendedClasses}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="progress flex-grow-1" style="height: 8px;">
                                                        <div class="progress-bar ${r.warning ? 'bg-danger' : 'bg-success'}" 
                                                             role="progressbar" 
                                                             style="width: ${r.percentage}%;" 
                                                             aria-valuenow="${r.percentage}" 
                                                             aria-valuemin="0" 
                                                             aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                    <span class="small fw-bold ${r.warning ? 'text-danger' : 'text-success'}">
                                                        ${r.percentage}%
                                                    </span>
                                                </div>
                                            </td>
                                            <td class="text-end">
                                                <c:choose>
                                                    <c:when test="${r.warning}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                            <i class="fa-solid fa-triangle-exclamation me-1"></i> Risque (< 75%)
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                            <i class="fa-solid fa-check me-1"></i> Admissible (>= 75%)
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card p-5 text-center text-muted">
                        <i class="fa-solid fa-file-chart-column fs-1 mb-3 text-secondary"></i>
                        <h5>Sélectionnez une matière pour afficher les rapports d'assiduité</h5>
                        <p class="small mb-0">Les données de présence consolidées et les avertissements pour les étudiants en difficulté seront calculés automatiquement.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
