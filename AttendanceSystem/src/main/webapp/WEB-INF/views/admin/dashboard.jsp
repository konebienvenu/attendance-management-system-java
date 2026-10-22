<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Administrator Dashboard" />
</jsp:include>

<div class="d-flex min-vh-100">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
    </jsp:include>

    <div class="flex-grow-1 d-flex flex-column">
        <jsp:include page="/WEB-INF/views/common/navbar.jsp">
            <jsp:param name="pageHeading" value="Administrator Dashboard" />
        </jsp:include>

        <main class="p-4 flex-grow-1">
            <!-- Welcome Banner -->
            <div class="card bg-primary text-white p-4 mb-4 border-0 shadow-sm" 
                 style="background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%) !important;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-1">Welcome to the Administration Panel</h4>
                        <p class="mb-0 text-white-50">Centralized management of students, faculty, course curricula, and attendance metrics.</p>
                    </div>
                    <div class="d-none d-md-block">
                        <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-light text-primary fw-semibold me-2">
                            <i class="fa-solid fa-user-plus me-1"></i> Add Student
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/enrollments" class="btn btn-outline-light">
                            <i class="fa-solid fa-link me-1"></i> Manage Enrollments
                        </a>
                    </div>
                </div>
            </div>

            <!-- KPI Metric Cards Row -->
            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card p-3 stat-card h-100" style="border-left-color: #4f46e5;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted small fw-semibold text-uppercase">Total Students</div>
                                <h3 class="fw-bold my-1">${stats.totalStudents}</h3>
                                <div class="small text-success"><i class="fa-solid fa-user-check me-1"></i>Enrolled this semester</div>
                            </div>
                            <div class="stat-icon bg-primary-subtle text-primary">
                                <i class="fa-solid fa-user-graduate"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card p-3 stat-card h-100" style="border-left-color: #0ea5e9;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted small fw-semibold text-uppercase">Faculty Members</div>
                                <h3 class="fw-bold my-1">${stats.totalTeachers}</h3>
                                <div class="small text-info"><i class="fa-solid fa-chalkboard me-1"></i>Active professors</div>
                            </div>
                            <div class="stat-icon bg-info-subtle text-info">
                                <i class="fa-solid fa-chalkboard-user"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card p-3 stat-card h-100" style="border-left-color: #10b981;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted small fw-semibold text-uppercase">Active Courses</div>
                                <h3 class="fw-bold my-1">${stats.totalSubjects}</h3>
                                <div class="small text-success"><i class="fa-solid fa-book-open me-1"></i>Curriculum modules</div>
                            </div>
                            <div class="stat-icon bg-success-subtle text-success">
                                <i class="fa-solid fa-book-bookmark"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card p-3 stat-card h-100" style="border-left-color: #f59e0b;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted small fw-semibold text-uppercase">Overall Attendance</div>
                                <h3 class="fw-bold my-1">${stats.overallAttendanceRate}%</h3>
                                <div class="small text-warning">
                                    <i class="fa-solid fa-chart-line me-1"></i>Institutional average
                                </div>
                            </div>
                            <div class="stat-icon bg-warning-subtle text-warning">
                                <i class="fa-solid fa-percent"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row g-4 mb-4">
                <div class="col-12 col-lg-7">
                    <div class="card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0 text-dark">
                                <i class="fa-solid fa-chart-simple text-primary me-2"></i>Attendance Distribution by Course
                            </h6>
                            <span class="badge bg-light text-muted border">Analytics</span>
                        </div>
                        <div style="height: 280px;">
                            <canvas id="subjectBarChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-5">
                    <div class="card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0 text-dark">
                                <i class="fa-solid fa-chart-pie text-info me-2"></i>Overall Record Ratio
                            </h6>
                            <span class="badge bg-light text-muted border">Logged Sessions</span>
                        </div>
                        <div style="height: 240px;" class="d-flex justify-content-center">
                            <canvas id="attendanceDoughnutChart"></canvas>
                        </div>
                        <div class="d-flex justify-content-around text-center mt-3 pt-2 border-top">
                            <div>
                                <span class="d-block small text-muted">Total Present</span>
                                <strong class="text-success fs-5">${stats.totalPresentRecords}</strong>
                            </div>
                            <div>
                                <span class="d-block small text-muted">Total Absent</span>
                                <strong class="text-danger fs-5">${stats.totalAbsentRecords}</strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Fast Action Shortcuts -->
            <div class="card p-4">
                <h6 class="fw-bold mb-3 text-dark">Quick Administrative Actions</h6>
                <div class="row g-3">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-primary w-100 py-3 text-start">
                            <i class="fa-solid fa-user-graduate fs-4 d-block mb-2 text-primary"></i>
                            <div class="fw-semibold">Manage Students</div>
                            <small class="text-muted">Register, edit, or remove student profiles</small>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-outline-info w-100 py-3 text-start">
                            <i class="fa-solid fa-chalkboard-user fs-4 d-block mb-2 text-info"></i>
                            <div class="fw-semibold">Manage Faculty</div>
                            <small class="text-muted">Create faculty credentials and user accounts</small>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/subjects" class="btn btn-outline-success w-100 py-3 text-start">
                            <i class="fa-solid fa-book-bookmark fs-4 d-block mb-2 text-success"></i>
                            <div class="fw-semibold">Manage Courses</div>
                            <small class="text-muted">Configure curricula and assign instructors</small>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-warning w-100 py-3 text-start">
                            <i class="fa-solid fa-triangle-exclamation fs-4 d-block mb-2 text-warning"></i>
                            <div class="fw-semibold">Academic 75% Rule</div>
                            <small class="text-muted">Audit students falling below threshold</small>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // 1. Doughnut Chart
    const doughnutCtx = document.getElementById('attendanceDoughnutChart').getContext('2d');
    new Chart(doughnutCtx, {
        type: 'doughnut',
        data: {
            labels: ['Present', 'Absent'],
            datasets: [{
                data: [${stats.totalPresentRecords}, ${stats.totalAbsentRecords}],
                backgroundColor: ['#10b981', '#ef4444'],
                hoverOffset: 4,
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            },
            cutout: '70%'
        }
    });

    // 2. Bar Chart by Subject
    const subjectStats = ${subjectStatsJson != null ? subjectStatsJson : '[]'};
    const labels = subjectStats.map(s => s.subjectName);
    const presentData = subjectStats.map(s => s.presentCount);
    const absentData = subjectStats.map(s => s.absentCount);

    const barCtx = document.getElementById('subjectBarChart').getContext('2d');
    new Chart(barCtx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                {
                    label: 'Present Records',
                    data: presentData,
                    backgroundColor: '#4f46e5',
                    borderRadius: 6
                },
                {
                    label: 'Absent Records',
                    data: absentData,
                    backgroundColor: '#cbd5e1',
                    borderRadius: 6
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: '#f1f5f9' } }
            },
            plugins: {
                legend: { position: 'top' }
            }
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
