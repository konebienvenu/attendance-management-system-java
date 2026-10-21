<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Prise de Présence Interactive" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="attendance" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Prise de Présence Interactive" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <c:if test="${param.msg == 'attendance_saved'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Feuille de présence enregistrée avec succès dans la base de données !
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'save_failed'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Une erreur est survenue lors de l'enregistrement de la présence.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Filtre Matière & Date -->
            <div class="card p-4 mb-4">
                <form action="${pageContext.request.contextPath}/teacher/attendance" method="get" class="row g-3 align-items-end">
                    <div class="col-12 col-md-5">
                        <label class="form-label fw-semibold small text-secondary">Sélectionner la Matière</label>
                        <select name="subjectId" class="form-select" required onchange="this.form.submit()">
                            <option value="">-- Choisir un cours --</option>
                            <c:forEach var="s" items="${subjects}">
                                <option value="${s.subjectId}" ${s.subjectId == selectedSubjectId ? 'selected' : ''}>
                                    [${s.subjectCode}] ${s.subjectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="form-label fw-semibold small text-secondary">Date de la séance</label>
                        <input type="date" name="date" class="form-control" value="${selectedDate}" onchange="this.form.submit()" required>
                    </div>

                    <div class="col-12 col-md-3">
                        <button type="submit" class="btn btn-outline-primary w-100">
                            <i class="fa-solid fa-filter me-1"></i> Charger la feuille
                        </button>
                    </div>
                </form>
            </div>

            <!-- Feuille d'appel -->
            <c:choose>
                <c:when test="${not empty selectedSubjectId}">
                    <div class="card p-4">
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                            <div>
                                <h5 class="fw-bold text-dark mb-1">
                                    ${selectedSubject.subjectName} <span class="badge bg-primary-subtle text-primary font-monospace ms-2">${selectedSubject.subjectCode}</span>
                                </h5>
                                <p class="text-muted small mb-0">
                                    <i class="fa-regular fa-calendar me-1"></i> Séance du <strong>${selectedDate}</strong> | 
                                    <span class="badge bg-light text-dark border ms-1">${attendanceSheet.size()} étudiants inscrits</span>
                                </p>
                            </div>

                            <!-- Actions Rapides -->
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-success btn-sm" id="btnMarkAllPresent">
                                    <i class="fa-solid fa-check-double me-1"></i> Tous Présents
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm" id="btnMarkAllAbsent">
                                    <i class="fa-solid fa-xmark me-1"></i> Tous Absents
                                </button>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty attendanceSheet}">
                                <form action="${pageContext.request.contextPath}/teacher/attendance" method="post">
                                    <input type="hidden" name="subjectId" value="${selectedSubjectId}">
                                    <input type="hidden" name="attendanceDate" value="${selectedDate}">

                                    <div class="table-responsive">
                                        <table class="table table-modern table-hover align-middle">
                                            <thead>
                                                <tr>
                                                    <th>N° Enrôlement</th>
                                                    <th>Nom de l'Étudiant</th>
                                                    <th>Email</th>
                                                    <th class="text-center" style="width: 280px;">Statut de Présence</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="row" items="${attendanceSheet}">
                                                    <tr>
                                                        <td>
                                                            <span class="badge bg-light text-primary border font-monospace fw-bold">
                                                                ${row.enrollmentNo}
                                                            </span>
                                                        </td>
                                                        <td class="fw-semibold text-dark">${row.studentName}</td>
                                                        <td class="text-muted small">${row.email}</td>
                                                        <td class="text-center">
                                                            <div class="btn-group" role="group">
                                                                <input type="radio" class="btn-check" 
                                                                       name="status_${row.enrollmentId}" 
                                                                       id="pres_${row.enrollmentId}" 
                                                                       value="PRESENT" 
                                                                       ${row.present || empty row.currentStatus ? 'checked' : ''} required>
                                                                <label class="btn btn-outline-success btn-sm px-3" for="pres_${row.enrollmentId}">
                                                                    <i class="fa-solid fa-check me-1"></i> Présent
                                                                </label>

                                                                <input type="radio" class="btn-check" 
                                                                       name="status_${row.enrollmentId}" 
                                                                       id="abs_${row.enrollmentId}" 
                                                                       value="ABSENT" 
                                                                       ${row.absent ? 'checked' : ''}>
                                                                <label class="btn btn-outline-danger btn-sm px-3" for="abs_${row.enrollmentId}">
                                                                    <i class="fa-solid fa-xmark me-1"></i> Absent
                                                                </label>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                        <button type="submit" class="btn btn-primary px-4 py-2 fs-6">
                                            <i class="fa-solid fa-floppy-disk me-2"></i> Enregistrer la Présence
                                        </button>
                                    </div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-user-slash fs-1 mb-3 text-secondary"></i>
                                    <h5>Aucun étudiant n'est encore inscrit à cette matière</h5>
                                    <p class="small mb-0">Demandez à l'administrateur d'inscrire des étudiants via le menu "Inscriptions (N:M)".</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card p-5 text-center text-muted">
                        <i class="fa-solid fa-arrow-up-from-bracket fs-1 mb-3 text-primary"></i>
                        <h5>Veuillez sélectionner une matière ci-dessus</h5>
                        <p class="small mb-0">La liste des étudiants inscrits et leur feuille de présence s'afficheront instantanément.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
