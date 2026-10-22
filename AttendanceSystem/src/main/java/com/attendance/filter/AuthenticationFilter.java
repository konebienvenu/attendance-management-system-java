package com.attendance.filter;

import com.attendance.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet security filter handling authentication and Role-Based Access Control (RBAC).
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI().substring(contextPath.length());

        // Static assets and public entry points
        boolean isStatic = uri.startsWith("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg");
        boolean isPublic = uri.equals("/login") || uri.equals("/") || uri.equals("/logout") || uri.equals("/index.jsp");

        if (isStatic || isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Validate session
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            res.sendRedirect(contextPath + "/login?error=session_expired");
            return;
        }

        // Role-Based Access Control (RBAC)
        if (uri.startsWith("/admin") && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Restricted: Administrator privileges required.");
            return;
        }

        if (uri.startsWith("/teacher") && !user.isTeacher() && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Restricted: Faculty credentials required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
