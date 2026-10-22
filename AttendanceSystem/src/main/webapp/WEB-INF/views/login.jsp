<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="pageTitle" value="Sign In - Attendance Management System" />
</jsp:include>

<div class="min-vh-100 d-flex align-items-center justify-content-center py-5" 
     style="background: radial-gradient(circle at 10% 20%, rgba(79, 70, 229, 0.08) 0%, rgba(248, 250, 252, 1) 90%);">
    
    <div class="container" style="max-width: 480px;">
        <div class="text-center mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-primary text-white rounded-4 p-3 shadow-lg mb-3">
                <i class="fa-solid fa-clipboard-user fs-2"></i>
            </div>
            <h3 class="fw-bold text-dark">Attendance Management</h3>
            <p class="text-muted small">Enterprise Java EE Application (AJT - 01CE0308)</p>
        </div>

        <div class="card login-card p-4 p-md-5">
            <h5 class="fw-bold text-dark mb-1">Account Login</h5>
            <p class="text-muted small mb-4">Sign in with your university credentials to continue</p>

            <!-- Error Notification -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center small" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i>
                    <div>${errorMessage}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Info Notification -->
            <c:if test="${param.msg == 'logged_out'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center small" role="alert">
                    <i class="fa-solid fa-circle-check me-2 fs-5"></i>
                    <div>You have been signed out successfully.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${param.error == 'session_expired'}">
                <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center small" role="alert">
                    <i class="fa-solid fa-clock-rotate-left me-2 fs-5"></i>
                    <div>Session expired. Please sign in again.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-secondary">Username</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-user"></i></span>
                        <input type="text" name="username" id="inputUsername" class="form-control border-start-0" 
                               placeholder="e.g. admin or kunal.khimani" required autofocus 
                               value="${enteredUsername != null ? enteredUsername : ''}">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small text-secondary">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" name="password" id="inputPassword" class="form-control border-start-0" 
                               placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fs-6">
                    <i class="fa-solid fa-right-to-bracket me-2"></i>Sign In
                </button>
            </form>

            <!-- Quick Demo Helper for Jury Defense -->
            <div class="mt-4 pt-3 border-top">
                <div class="small fw-semibold text-muted mb-2 text-center">Quick Demo Credentials:</div>
                <div class="d-flex justify-content-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-primary" 
                            onclick="fillDemo('admin', 'admin123')">
                        <i class="fa-solid fa-shield-halved me-1"></i> Admin
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary" 
                            onclick="fillDemo('kunal.khimani', 'teacher123')">
                        <i class="fa-solid fa-chalkboard-user me-1"></i> Faculty
                    </button>
                </div>
            </div>
        </div>

        <div class="text-center mt-4 text-muted small">
            &copy; 2026 - Developed for AJT Academic Evaluation
        </div>
    </div>
</div>

<script>
function fillDemo(username, password) {
    document.getElementById('inputUsername').value = username;
    document.getElementById('inputPassword').value = password;
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
