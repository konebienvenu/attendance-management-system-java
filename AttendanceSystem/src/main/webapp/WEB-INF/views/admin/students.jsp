<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Student Directory" />
</jsp:include>

<div class="d-flex min-vh-100 app-layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="students" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column main-wrapper">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Student Directory" />
        </jsp:include>

        <main class="p-3 p-md-4 flex-grow-1">
            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Student profile created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Student details updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Student record deleted.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'duplicate_enrollment'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Error: An enrollment number with this value already exists.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Enrolled Students</h5>
                        <p class="text-muted small mb-0">Total: ${students.size()} registered student profiles</p>
                    </div>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <div class="input-group" style="max-width: 250px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="studentsTable" placeholder="Search students...">
                        </div>
                        <div class="btn-group btn-group-sm" role="group" aria-label="Table Horizontal Scroll">
                            <button type="button" class="btn btn-outline-primary px-2 fw-semibold" onclick="scrollTableLeft(this)" title="Scroll Table Left">
                                <i class="fa-solid fa-arrow-left me-1"></i> Left
                            </button>
                            <button type="button" class="btn btn-outline-primary px-2 fw-semibold" onclick="scrollTableRight(this)" title="Scroll Table Right">
                                Right <i class="fa-solid fa-arrow-right ms-1"></i>
                            </button>
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                            <i class="fa-solid fa-plus me-1"></i> Add Student
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="studentsTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Enrollment No</th>
                                <th>Full Name</th>
                                <th>University Email</th>
                                <th>Semester</th>
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
                                    <td><span class="badge bg-secondary-subtle text-secondary px-2">Semester ${s.semester}</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" data-bs-target="#editModal${s.studentId}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/students" method="post" class="d-inline"
                                              onsubmit="return confirm('Are you sure you want to delete this student record?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.studentId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Edit Student Modal -->
                                <div class="modal fade" id="editModal${s.studentId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="studentId" value="${s.studentId}">
                                                <div class="modal-header">
                                                    <h5 class="modal-title fw-bold">Edit Student Profile</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Enrollment Number</label>
                                                        <input type="text" name="enrollmentNo" class="form-control" value="${s.enrollmentNo}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Full Name</label>
                                                        <input type="text" name="studentName" class="form-control" value="${s.studentName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">University Email</label>
                                                        <input type="email" name="email" class="form-control" value="${s.email}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Academic Semester</label>
                                                        <input type="number" name="semester" class="form-control" value="${s.semester}" min="1" max="8" required>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-2 px-1 text-muted small">
                    <span><i class="fa-solid fa-arrows-left-right text-primary me-1"></i> Use arrow buttons, scroll wheel, or drag to scroll table horizontally</span>
                    <span>Total: ${students.size()} students</span>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Add Student Modal -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Register New Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Enrollment Number</label>
                        <input type="text" name="enrollmentNo" class="form-control" placeholder="e.g. 23CE009" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Full Name</label>
                        <input type="text" name="studentName" class="form-control" placeholder="e.g. Ethan Hunt" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">University Email</label>
                        <input type="email" name="email" class="form-control" placeholder="ethan.hunt@student.edu" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Semester</label>
                        <input type="number" name="semester" class="form-control" value="3" min="1" max="8" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Register Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
