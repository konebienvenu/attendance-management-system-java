<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Interactive Attendance Sheet" />
</jsp:include>

<div class="d-flex min-vh-100 app-layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="attendance" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column main-wrapper">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Interactive Attendance Sheet" />
        </jsp:include>

        <main class="p-3 p-md-4 flex-grow-1">
            <c:if test="${param.msg == 'attendance_saved'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Attendance sheet saved successfully to the database!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'save_failed'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>An error occurred while saving attendance records.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Course & Date Filter -->
            <div class="card p-4 mb-4">
                <form action="${pageContext.request.contextPath}/teacher/attendance" method="get" class="row g-3 align-items-end">
                    <div class="col-12 col-md-5">
                        <label class="form-label fw-semibold small text-secondary">Select Course Module</label>
                        <select name="subjectId" class="form-select" required onchange="this.form.submit()">
                            <option value="">-- Choose a Course --</option>
                            <c:forEach var="s" items="${subjects}">
                                <option value="${s.subjectId}" ${s.subjectId == selectedSubjectId ? 'selected' : ''}>
                                    [${s.subjectCode}] ${s.subjectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="form-label fw-semibold small text-secondary">Session Date</label>
                        <input type="date" name="date" class="form-control" value="${selectedDate}" onchange="this.form.submit()" required>
                    </div>

                    <div class="col-12 col-md-3">
                        <button type="submit" class="btn btn-outline-primary w-100">
                            <i class="fa-solid fa-filter me-1"></i> Load Roll Call
                        </button>
                    </div>
                </form>
            </div>

            <!-- Attendance Roll Call Sheet -->
            <c:choose>
                <c:when test="${not empty selectedSubjectId}">
                    <div class="card p-4">
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                            <div>
                                <h5 class="fw-bold text-dark mb-1">
                                    ${selectedSubject.subjectName} <span class="badge bg-primary-subtle text-primary font-monospace ms-2">${selectedSubject.subjectCode}</span>
                                </h5>
                                <p class="text-muted small mb-0">
                                    <i class="fa-regular fa-calendar me-1"></i> Class Date: <strong>${selectedDate}</strong> | 
                                    <span class="badge bg-light text-dark border ms-1">${attendanceSheet.size()} enrolled students</span>
                                </p>
                            </div>

                            <!-- Fast Action Helpers -->
                            <div class="d-flex gap-2 align-items-center flex-wrap">
                                <div class="btn-group" role="group" title="Scroll Table Left / Right">
                                    <button type="button" class="btn btn-outline-secondary btn-sm px-2" onclick="scrollTableLeft(this)" title="Scroll Left">
                                        <i class="fa-solid fa-chevron-left"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary btn-sm px-2" onclick="scrollTableRight(this)" title="Scroll Right">
                                        <i class="fa-solid fa-chevron-right"></i>
                                    </button>
                                </div>
                                <button type="button" class="btn btn-outline-success btn-sm" id="btnMarkAllPresent">
                                    <i class="fa-solid fa-check-double me-1"></i> Mark All Present
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm" id="btnMarkAllAbsent">
                                    <i class="fa-solid fa-xmark me-1"></i> Mark All Absent
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
                                                    <th>Enrollment No</th>
                                                    <th>Student Name</th>
                                                    <th>University Email</th>
                                                    <th class="text-center" style="width: 280px;">Attendance Status</th>
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
                                                                    <i class="fa-solid fa-check me-1"></i> Present
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

                                    <div class="d-flex justify-content-between align-items-center mt-2 px-1 text-muted small">
                                        <span><i class="fa-solid fa-arrows-left-right text-primary me-1"></i> Use arrow buttons, scroll wheel, or drag to scroll table horizontally</span>
                                        <span>Total: ${attendanceSheet.size()} enrolled students</span>
                                    </div>

                                    <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                        <button type="submit" class="btn btn-primary px-4 py-2 fs-6">
                                            <i class="fa-solid fa-floppy-disk me-2"></i> Save Attendance Records
                                        </button>
                                    </div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-user-slash fs-1 mb-3 text-secondary"></i>
                                    <h5>No students currently enrolled in this course</h5>
                                    <p class="small mb-0">Please request the administrator to assign students using the "Course Enrollments" menu.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card p-5 text-center text-muted">
                        <i class="fa-solid fa-arrow-up-from-bracket fs-1 mb-3 text-primary"></i>
                        <h5>Please select a course module from above</h5>
                        <p class="small mb-0">The class roll call sheet and status selectors will populate automatically.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
