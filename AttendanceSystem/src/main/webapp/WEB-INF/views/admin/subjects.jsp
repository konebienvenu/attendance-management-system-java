<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Course & Subject Management" />
</jsp:include>

<div class="d-flex min-vh-100 app-layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="subjects" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column main-wrapper">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Course & Subject Management" />
        </jsp:include>

        <main class="p-3 p-md-4 flex-grow-1">
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Course registered successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Course details updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-trash me-2"></i>Course removed from curriculum.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'duplicate_code'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Error: A course with this code already exists.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h5 class="fw-bold text-dark mb-1">Course Curriculum Catalog</h5>
                        <p class="text-muted small mb-0">Total: ${subjects.size()} configured academic courses</p>
                    </div>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <div class="input-group" style="max-width: 250px;">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control border-start-0 table-search-input" data-table="subjectsTable" placeholder="Search courses...">
                        </div>
                        <div class="btn-group" role="group" title="Scroll Table Left / Right">
                            <button type="button" class="btn btn-outline-secondary btn-sm px-2" onclick="scrollTableLeft(this)" title="Scroll Left">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm px-2" onclick="scrollTableRight(this)" title="Scroll Right">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>
                        <button type="button" class="btn btn-primary text-nowrap" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                            <i class="fa-solid fa-plus me-1"></i> Add Course
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover align-middle" id="subjectsTable">
                        <thead>
                            <tr>
                                <th># ID</th>
                                <th>Course Code</th>
                                <th>Course Title</th>
                                <th>Assigned Faculty</th>
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
                                        ${sub.teacherName != null ? sub.teacherName : "Unassigned"}
                                    </td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" data-bs-target="#editSubjectModal${sub.subjectId}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/subjects" method="post" class="d-inline"
                                              onsubmit="return confirm('Are you sure you want to delete this course?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${sub.subjectId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>

                                <!-- Edit Subject Modal -->
                                <div class="modal fade" id="editSubjectModal${sub.subjectId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="subjectId" value="${sub.subjectId}">
                                                <div class="modal-header">
                                                    <h5 class="modal-title fw-bold">Edit Course Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Course Code</label>
                                                        <input type="text" name="subjectCode" class="form-control" value="${sub.subjectCode}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Course Title</label>
                                                        <input type="text" name="subjectName" class="form-control" value="${sub.subjectName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold small">Assigned Faculty Member</label>
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
                    <span>Total: ${subjects.size()} courses</span>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Add Subject Modal -->
<div class="modal fade" id="addSubjectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Register New Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Course Code</label>
                        <input type="text" name="subjectCode" class="form-control" placeholder="e.g. 01CE0308" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Course Title</label>
                        <input type="text" name="subjectName" class="form-control" placeholder="e.g. Advanced Java Technologies (AJT)" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Assigned Faculty Member</label>
                        <select name="teacherId" class="form-select" required>
                            <option value="">Select an instructor...</option>
                            <c:forEach var="t" items="${teachers}">
                                <option value="${t.teacherId}">${t.teacherName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
