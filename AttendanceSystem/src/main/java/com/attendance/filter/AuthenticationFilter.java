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
 * Filtre de sécurité Servlet vérifiant l'authentification et les autorisations par rôle.
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

        // Force l'encodage UTF-8 pour tous les échanges
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI().substring(contextPath.length());

        // Fichiers statiques et routes publiques
        boolean isStatic = uri.startsWith("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg");
        boolean isPublic = uri.equals("/login") || uri.equals("/") || uri.equals("/logout") || uri.equals("/index.jsp");

        if (isStatic || isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Vérification de la session active
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            res.sendRedirect(contextPath + "/login?error=session_expired");
            return;
        }

        // Contrôle d'accès basé sur les rôles (RBAC)
        if (uri.startsWith("/admin") && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux administrateurs");
            return;
        }

        if (uri.startsWith("/teacher") && !user.isTeacher() && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès réservé aux enseignants");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
