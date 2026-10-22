# 🎓 Academic Project Defense & Technical Presentation
## Enterprise Attendance Management System
**Course Title:** Advanced Java Technologies (AJT - 01CE0308)  
**Academic Level:** Semester 3 - Computer Engineering  
**Evaluation Weight:** 40 Marks (End-Semester Project Evaluation)  
**Technology Stack:** Java EE, Servlets 3.1, JSP 2.3, JSTL 1.2, JDBC, MySQL 8.0, Bootstrap 5.3, Chart.js, Apache Maven, Apache Tomcat  

---

## 📑 TABLE OF CONTENTS
1. [Executive Summary & Problem Statement](#1-executive-summary--problem-statement)
2. [Multi-Tier MVC Architecture](#2-multi-tier-mvc-architecture)
3. [Relational Database Design (3NF Normalization)](#3-relational-database-design-3nf-normalization)
4. [Enterprise Security & Role-Based Access Control (RBAC)](#4-enterprise-security--role-based-access-control-rbac)
5. [Business Logic & Atomic Transactions (75% Rule & Batch JDBC)](#5-business-logic--atomic-transactions-75-rule--batch-jdbc)
6. [User Interface & Interactive Analytics](#6-user-interface--interactive-analytics)
7. [Step-by-Step Local Deployment Guide](#7-step-by-step-local-deployment-guide)
8. [Jury Defense Q&A: Master Key Answers](#8-jury-defense-qa-master-key-answers)

---

## 1. EXECUTIVE SUMMARY & PROBLEM STATEMENT

### Context & Challenges
Traditional paper-based roll calls in higher education institutions suffer from critical drawbacks:
- **Excessive instructional time lost** during class sessions.
- **Risk of transcription inaccuracies, proxy attendance, and data tampering**.
- **Lack of real-time visibility** into academic attendance statistics, hindering proactive intervention for students at risk of falling below the mandatory **75% institutional attendance threshold**.

### Proposed Solution
An enterprise-grade Java Web Application delivering:
- An **Administrator Portal** providing high-level KPI oversight, curriculum mapping, and comprehensive CRUD management for students, faculty, and course enrollments.
- A **Faculty Portal** enabling seamless one-click attendance recording (*Batch Processing*), interactive status toggles (*Mark All Present* / *Absent*), and real-time risk alerts.

---

## 2. MULTI-TIER MVC ARCHITECTURE

The application strictly adheres to the industry-standard **Model-View-Controller (MVC)** design pattern, decoupled into four distinct layers:

```
             ┌───────────────────────────────────────────────┐
             │         Web Client (Browser Requests)         │
             └───────────────────────┬───────────────────────┘
                                     │ HTTP Requests (GET/POST)
                                     ▼
             ┌───────────────────────────────────────────────┐
             │   Security Filter (AuthenticationFilter)      │
             └───────────────────────┬───────────────────────┘
                                     ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ CONTROLLER LAYER (Java Servlets)                                           │
│ • AuthServlet (Authentication / Session Invalidation)                      │
│ • AdminDashboardServlet / StudentServlet / TeacherServlet / SubjectServlet │
│ • AttendanceServlet (Batch Processing) & ReportServlet (75% Rule Analytics)│
└─────────────────────┬────────────────────────────────┬─────────────────────┘
                      │                                │
                      ▼                                ▼
┌──────────────────────────────────────┐   ┌─────────────────────────────────┐
│ MODEL & DTO LAYER (Java Beans)       │   │ VIEW LAYER (JSP / JSTL / EL)    │
│ • User, Student, Teacher, Subject    │   │ • Responsive Bootstrap 5.3 UI   │
│ • Enrollment, Attendance             │   │ • Chart.js Interactive Graphics │
│ • AttendanceSheetRowDTO, ReportDTO   │   │ • Client-side Search & Modals   │
└─────────────────────▲────────────────┘   └─────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ DATA ACCESS LAYER (DAO & JDBC)                                             │
│ • DBConnection (Singleton JDBC Factory reading db.properties)              │
│ • UserDAO, StudentDAO, TeacherDAO, SubjectDAO, EnrollmentDAO, AttendanceDAO│
│ • ACID Transactions (commit/rollback) & PreparedStatement (Anti-SQLi)      │
└─────────────────────┬──────────────────────────────────────────────────────┘
                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ RELATIONAL DATABASE (MySQL 8.0)                                            │
│ attendance_management_system (6 Normalized 3NF Tables)                     │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. RELATIONAL DATABASE DESIGN (3NF NORMALIZATION)

The database schema satisfies the requirements outlined in the syllabus with **6 relational tables normalized to Third Normal Form (3NF)**:

| Table Name | Purpose & Function | Primary & Foreign Keys |
| :--- | :--- | :--- |
| `system_user` | Secure authentication credentials and authorization roles (`ADMIN`, `TEACHER`). | `user_id` (PK) |
| `student` | Comprehensive student directory with university enrollment numbers. | `student_id` (PK), `enrollment_no` (UNIQUE) |
| `teacher` | Faculty profiles mapped directly to their system user accounts. | `teacher_id` (PK), `user_id` (FK $\rightarrow$ `system_user`) |
| `subject` | Academic curriculum courses assigned to faculty members. | `subject_id` (PK), `teacher_id` (FK $\rightarrow$ `teacher`) |
| `enrollment` | Association table resolving the **Many-to-Many (N:M)** student-course relationship. | `enrollment_id` (PK), `student_id` (FK), `subject_id` (FK), `(student_id, subject_id)` (UNIQUE) |
| `attendance` | Daily attendance session records per course enrollment. | `attendance_id` (PK), `enrollment_id` (FK), `(enrollment_id, attendance_date)` (UNIQUE) |

> 💡 **Defense Highlight:**
> - The `enrollment` bridge table prevents data redundancy: one student enrolls in multiple courses, and one course hosts multiple students.
> - The composite constraint `UNIQUE (enrollment_id, attendance_date)` mathematically guarantees that a student cannot have conflicting statuses recorded for the same class date.

---

## 4. ENTERPRISE SECURITY & ROLE-BASED ACCESS CONTROL (RBAC)

### 1. Role-Based Access Control (RBAC)
- **Servlet Filter (`AuthenticationFilter`)** : Intercepts every incoming HTTP request.
  - Unauthenticated access to `/admin/*` or `/teacher/*` redirects immediately to `/login?error=session_expired`.
  - Faculty members attempting to access `/admin/*` are blocked with an HTTP 403 Forbidden status.
- **Cryptographic Password Protection** : Plaintext passwords are never stored in the database. Credentials are encrypted using the **SHA-256** hashing algorithm via `PasswordUtil.java`.
- **SQL Injection Immunization** : 100% of database interactions utilize parameterized `PreparedStatement` queries (`?`), preventing SQL injection attacks entirely.

---

## 5. BUSINESS LOGIC & ATOMIC TRANSACTIONS

### A. Atomic JDBC Batch Processing (`saveBatchAttendance`)
To eliminate the risk of partial database writes during class attendance logging, the DAO implements a **strictly atomic JDBC transaction**:

```java
conn.setAutoCommit(false); // Begin ACID transaction
PreparedStatement stmt = conn.prepareStatement(
    "INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) " +
    "VALUES (?, ?, ?, ?) " +
    "ON DUPLICATE KEY UPDATE status = VALUES(status), marked_by = VALUES(marked_by)"
);

for (Map.Entry<Integer, String> entry : enrollmentStatusMap.entrySet()) {
    stmt.setInt(1, entry.getKey());
    stmt.setDate(2, date);
    stmt.setString(3, entry.getValue());
    stmt.setInt(4, teacherId);
    stmt.addBatch(); // Batch execution for high performance
}

stmt.executeBatch();
conn.commit(); // Atomic commit
```

### B. Dynamic 75% Attendance Rule Computation (`StudentReportDTO`)
The academic eligibility rule is calculated dynamically:
$$\text{Attendance Percentage} = \left( \frac{\text{Classes Attended}}{\text{Total Sessions Conducted}} \right) \times 100$$
- If $\text{Percentage} < 75.0\%$, the `isWarning()` method returns `true`, triggering a red status badge (*At Risk of Debarment*) and warning indicators across reports.

---

## 6. USER INTERFACE & INTERACTIVE ANALYTICS

The user experience is designed with high visual polish and operational efficiency:
- **Design System :** Clean Bootstrap 5.3 aesthetics, modern color accents (Indigo `#4f46e5`, Emerald `#10b981`, Crimson `#ef4444`), and typography powered by Google Fonts Inter.
- **Real-Time Visualizations (Chart.js) :** Interactive Donut Chart displaying overall attendance ratio and grouped Bar Chart illustrating attendance rates across subjects.
- **Instant Client-Side Search :** Tables filter dynamically on keystroke without page reloads.

---

## 7. STEP-BY-STEP LOCAL DEPLOYMENT GUIDE

### Prerequisites
- **Apache NetBeans IDE**
- **XAMPP** (Apache and MySQL running on port 3306)
- **Java Development Kit (JDK 17 or higher)**

### 1. Database Initialization
1. In XAMPP Control Panel, ensure **MySQL** is started.
2. Open phpMyAdmin at `http://localhost/phpmyadmin`.
3. Import `AttendanceSystem/database/schema.sql` followed by `AttendanceSystem/database/seed_data.sql`.

### 2. Opening & Running in NetBeans
1. Launch **Apache NetBeans**.
2. Select **File -> Open Project...**
3. Navigate to and select:  
   `.../attendance-management-system/AttendanceSystem`
4. Right-click the project $\rightarrow$ **Run** (or press `F6`).
5. Open your browser at: `http://localhost:8080/AttendanceManagementSystem/`

### Demo Credentials:
| Role | Username | Password | Key Permissions |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `admin123` | Full system oversight, CRUD on students/faculty/courses, institutional analytics |
| **Faculty (AJT)** | `kunal.khimani` | `teacher123` | AJT roll call sheet, "Mark All Present", 75% rule audit reports |
| **Faculty (DBMS)**| `sweta.khatana` | `teacher123` | DBMS roll call sheet, "Mark All Present", 75% rule audit reports |

---

## 8. JURY DEFENSE Q&A: MASTER KEY ANSWERS

### Q1: *"Why did you design a separate `enrollment` table instead of storing student IDs in the subject table?"*
> **Answer:**  
> *"The relationship between students and courses is Many-to-Many (N:M). A student enrolls in multiple courses, and a course contains multiple students. Creating the bridge table `enrollment` ensures Third Normal Form (3NF) compliance, eliminates data redundancy, and provides a distinct entity to capture enrollment dates, active/inactive statuses, and linked daily attendance records."*

### Q2: *"How does your application protect against SQL Injection vulnerabilities?"*
> **Answer:**  
> *"We strictly avoid inline SQL string concatenation. All database operations throughout our DAO layer utilize parameterized `PreparedStatement` instances. The SQL engine pre-compiles the query template, ensuring user input is treated strictly as typed literal values rather than executable SQL statements."*

### Q3: *"What happens if a network interruption occurs midway through marking attendance for a class of 60 students?"*
> **Answer:**  
> *"Our `saveBatchAttendance` method is wrapped in an explicit ACID transaction. Auto-commit is disabled (`conn.setAutoCommit(false)`), and changes are dispatched using `addBatch()`. Only when every single record succeeds is `conn.commit()` executed. If any error or disconnection occurs, the `catch` block invokes `conn.rollback()`, ensuring no partial or corrupted data is ever stored."*

### Q4: *"How do you prevent unauthorized users from manually typing admin URLs in the address bar?"*
> **Answer:**  
> *"We implemented a centralized `AuthenticationFilter` conforming to the Java Servlet Filter API. Every incoming request is intercepted: unauthenticated sessions are redirected to the login endpoint, and authenticated users attempting to access endpoints outside their authorized role (e.g., a teacher accessing `/admin/*`) receive an HTTP 403 Forbidden response."*

### Q5: *"Why did you use JSTL and Expression Language (EL) instead of Java scriptlets inside your JSPs?"*
> **Answer:**  
> *"In enterprise Java EE development, embedding scriptlets (`<% ... %>`) inside view pages tightly couples presentation with business logic and creates maintenance overhead. JSTL tags (`<c:forEach>`, `<c:if>`, `<c:choose>`) and EL expressions (`${...}`) cleanly decouple the presentation layer, resulting in cleaner, safer, and standard-compliant MVC architecture."*

---
*(This defense document is ready for projection or reference during your formal jury examination).*
