<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : "Attendance Management System"} | AJT Project</title>
    
    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom CSS with Cache Buster -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=<%= System.currentTimeMillis() %>">
    
    <!-- Guaranteed Layout & Horizontal Scrolling Styles (Immune to browser cache) -->
    <style>
        html, body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            width: 100%;
        }

        .app-layout {
            display: flex !important;
            min-height: 100vh;
            width: 100% !important;
            max-width: 100vw !important;
            overflow-x: hidden;
        }

        .sidebar {
            width: 260px !important;
            min-width: 260px !important;
            max-width: 260px !important;
            flex-shrink: 0 !important;
            transition: margin-left 0.25s ease-in-out;
        }

        body.sidebar-collapsed .sidebar {
            margin-left: -260px !important;
        }

        .main-wrapper {
            flex: 1 1 0% !important;
            min-width: 0 !important;
            max-width: calc(100vw - 260px) !important;
            width: calc(100vw - 260px) !important;
            overflow-x: hidden !important;
            display: flex;
            flex-direction: column;
        }

        body.sidebar-collapsed .main-wrapper {
            max-width: 100vw !important;
            width: 100vw !important;
        }

        /* High-Visibility Table Horizontal Scroll Container */
        .table-responsive {
            overflow-x: auto !important;
            -webkit-overflow-scrolling: touch;
            width: 100% !important;
            max-width: 100% !important;
            margin-bottom: 0.75rem;
            padding-bottom: 6px;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            background: #ffffff;
            cursor: grab;
            scrollbar-width: thin;
            scrollbar-color: #4f46e5 #e2e8f0;
        }

        .table-responsive.table-dragging {
            cursor: grabbing !important;
            user-select: none;
        }

        /* 12px High-Visibility Purple/Indigo Horizontal Scrollbar */
        .table-responsive::-webkit-scrollbar {
            height: 12px !important;
            display: block !important;
        }

        .table-responsive::-webkit-scrollbar-track {
            background: #f1f5f9 !important;
            border-bottom-left-radius: 0.75rem;
            border-bottom-right-radius: 0.75rem;
        }

        .table-responsive::-webkit-scrollbar-thumb {
            background: #4f46e5 !important;
            border-radius: 8px;
            border: 2px solid #f1f5f9;
        }

        .table-responsive::-webkit-scrollbar-thumb:hover {
            background: #3730a3 !important;
        }

        /* Ensures columns are never squished and horizontal scroll ALWAYS works */
        .table-modern {
            min-width: 950px !important;
            width: 100%;
            margin-bottom: 0;
        }

        .table-modern th, .table-modern td {
            white-space: nowrap !important;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
