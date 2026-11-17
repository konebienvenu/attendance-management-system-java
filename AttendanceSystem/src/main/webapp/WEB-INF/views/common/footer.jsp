<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Bootstrap 5.3 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Main Custom JS with Cache Buster -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
