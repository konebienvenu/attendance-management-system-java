# 🎓 Enterprise Attendance Management System
[![Java](https://img.shields.io/badge/Java-8%20%7C%2011%20%7C%2017%20%7C%2021-orange.svg)](https://www.oracle.com/java/)
[![Jakarta / Java EE](https://img.shields.io/badge/JavaEE-Servlets%203.1%20%7C%20JSP%202.3-blue.svg)](https://tomcat.apache.org/)
[![Database](https://img.shields.io/badge/Database-MySQL%208.0-blue.svg)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Frontend-Bootstrap%205.3-purple.svg)](https://getbootstrap.com/)
[![Chart.js](https://img.shields.io/badge/Analytics-Chart.js-pink.svg)](https://www.chartjs.org/)
[![IDE](https://img.shields.io/badge/IDE-Apache%20NetBeans-success.svg)](https://netbeans.apache.org/)

An enterprise-grade Java Web Application designed for universities to manage students, faculty, course enrollments, and daily attendance tracking. Features real-time visual analytics, role-based access control (RBAC), and automated enforcement of the **academic 75% minimum attendance rule**.

> **Course Reference :** AJT - Advanced Java Technologies (`01CE0308`)  
> **Evaluation :** Semester 3 Project (40 Marks)

---

## 📸 Key Features & Capabilities

- 🔐 **Role-Based Authentication (RBAC) :**
  - **Administrator Dashboard :** Comprehensive KPI metrics, Donut and Bar charts powered by Chart.js, complete CRUD operations for Students, Faculty, Courses, and Enrollments.
  - **Faculty Portal :** Personalized dashboard showing assigned subjects, interactive attendance sheet with one-click *"Mark All Present"* / *"Mark All Absent"*, and attendance history.
- ⚡ **Atomic Batch Processing :** Attendance for full classes is recorded via transactional JDBC (`setAutoCommit(false)`, `PreparedStatement.addBatch()`, `commit()`, `rollback()`) with conflict resolution (`ON DUPLICATE KEY UPDATE`).
- ⚠️ **Academic 75% Attendance Rule :** Computes real-time attendance percentage per student per course. Automatically flags at-risk students with prominent red badges and warning alerts.
- 🔍 **Instant Search & Filtration :** Real-time client-side search filtering across all tabular views without page reloads.
- 🛡️ **Enterprise Security :** Servlet `AuthenticationFilter` guarding administrative and teacher paths, passwords secured with SHA-256 hashing, 100% parameter-bound queries preventing SQL injections.

---

## 🏛️ System Architecture

```
                  ┌─────────────────────────────────────────┐
                  │      Client Browser (HTTP Requests)     │
                  └────────────────────┬────────────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │   AuthenticationFilter (RBAC Security)  │
                  └────────────────────┬────────────────────┘
                                       │
        ┌──────────────────────────────┴──────────────────────────────┐
        ▼                                                             ▼
┌───────────────────────────────┐                             ┌───────────────────────────────┐
│     Controller (Servlets)     │                             │     View (JSP / JSTL / EL)    │
│ • AuthServlet (Login/Logout)  │ ── Sends Data / Attributes ─▶ • Responsive Bootstrap UI     │
│ • StudentServlet / Teacher... │                             │ • Interactive Chart.js Charts │
│ • AttendanceServlet / Reports │                             │ • Modals & Live Search Filters│
└───────────────┬───────────────┘                             └───────────────────────────────┘
                │
                ▼
┌───────────────────────────────┐
│      DAO Layer (JDBC)         │
│ • UserDAO / StudentDAO        │
│ • AttendanceDAO (Batch Trans) │
│ • Singleton DBConnection      │
└───────────────┬───────────────┘
                │
                ▼
┌───────────────────────────────┐
│    MySQL 8.0 Relational DB    │
│ attendance_management_system  │
│ (6 Normalized 3NF Tables)     │
└───────────────────────────────┘
```

---

## 🗄️ Database Design (6 Normalized Tables)

| Table | Description | Primary & Foreign Keys |
| :--- | :--- | :--- |
| `system_user` | Authentication credentials & roles (`ADMIN`, `TEACHER`) | `user_id` (PK) |
| `student` | Student details with semester & unique enrollment number | `student_id` (PK), `enrollment_no` (UNIQUE) |
| `teacher` | Faculty details mapped to a login account | `teacher_id` (PK), `user_id` (FK) |
| `subject` | Academic courses assigned to teachers | `subject_id` (PK), `teacher_id` (FK) |
| `enrollment` | Many-to-Many association linking students to subjects | `enrollment_id` (PK), `(student_id, subject_id)` (UNIQUE) |
| `attendance` | Daily attendance records (`PRESENT` / `ABSENT`) | `attendance_id` (PK), `(enrollment_id, attendance_date)` (UNIQUE) |

---

## 🚀 Setup & Execution Guide

### 1. Database Setup
1. Launch **XAMPP Control Panel** and start **MySQL**.
2. Open phpMyAdmin (`http://localhost/phpmyadmin`) or MySQL Command Line.
3. Import [`AttendanceSystem/database/schema.sql`](AttendanceSystem/database/schema.sql).
4. Import [`AttendanceSystem/database/seed_data.sql`](AttendanceSystem/database/seed_data.sql) to populate demo data.
5. If your MySQL has a password, update [`AttendanceSystem/src/main/resources/db.properties`](AttendanceSystem/src/main/resources/db.properties).

### 2. Opening & Running in Apache NetBeans
1. Launch **Apache NetBeans**.
2. Select **File -> Open Project...**
3. Navigate to and select the `AttendanceSystem` folder.
4. Right-click the project $\rightarrow$ **Run** (or press `F6`).
5. Choose your server (**Apache Tomcat** or **GlassFish**).
6. Open your browser at: `http://localhost:8080/AttendanceManagementSystem/`

---

## 🔑 Demo Credentials

| Role | Username | Password | Features Accessible |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Complete administrative control, CRUD, system metrics, enrollment management |
| **Teacher (AJT)** | `kunal.khimani` | `teacher123` | AJT module attendance sheet, "Mark All Present", 75% rule reports |
| **Teacher (DBMS)** | `sweta.khatana` | `teacher123` | DBMS module attendance sheet, "Mark All Present", 75% rule reports |

---

## 📁 Project Structure

```
attendance-management-system/
├── PRESENTATION_PROJET_JURY.md         # Complete slide-by-slide presentation & jury defense guide
├── README.md                            # GitHub repository overview
└── AttendanceSystem/                    # Maven Java Web Project
    ├── pom.xml                          # Maven build configuration & dependencies
    ├── database/
    │   ├── schema.sql                   # MySQL DDL (6 tables with constraints)
    │   └── seed_data.sql                # Initial demo dataset
    └── src/
        └── main/
            ├── java/com/attendance/
            │   ├── controller/          # Java Servlets (Auth, Admin, Teacher, Attendance, Report)
            │   ├── dao/                 # Data Access Objects (JDBC with transactions)
            │   ├── filter/              # Servlet Authentication & RBAC Filter
            │   ├── model/               # POJOs & DTOs
            │   └── util/                # DBConnection & SHA-256 PasswordUtil
            ├── resources/               # db.properties
            └── webapp/
                ├── assets/ (css, js)    # Modern stylesheets & scripts
                └── WEB-INF/views/       # JSP Views (login, admin, teacher dashboards)
```

---

## 📄 License & Attribution
Developed for the **Advanced Java Technologies (AJT - 01CE0308)** university course evaluation.
