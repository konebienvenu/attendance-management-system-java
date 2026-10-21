# 📚 Enterprise Attendance Management System
> **AJT Project (01CE0308) - Semester 3 - Computer Engineering**  
> Developed using Java Enterprise Technologies (Servlets, JSP, JSTL/EL, JDBC, MySQL, Bootstrap 5.3, Chart.js)

---

## 🌟 Overview
The **Attendance Management System** is an enterprise-grade Java web application designed to streamline student attendance tracking, provide actionable real-time analytics, and enforce academic attendance policies (such as the **75% minimum attendance rule**).

---

## 🛠️ Technology Stack
- **Backend :** Java EE (Servlet 3.1, JSP 2.3, JSTL 1.2, JDBC)
- **Architecture :** Layered MVC (Model - View - Controller - DAO Pattern)
- **Database :** MySQL 8.0 (6 Normalized Relational Tables)
- **Frontend / UI :** Modern Bootstrap 5.3, FontAwesome 6, Chart.js, Custom CSS
- **Security :** Role-Based Access Control (RBAC), Session Management, SHA-256 Hashing, PreparedStatement SQL Injection Prevention
- **Build Tool :** Apache Maven 3.9+
- **IDE & Server Support :** Apache NetBeans, Apache Tomcat 8.5/9/10

---

## 🏛️ Database Architecture
The database `attendance_management_system` consists of 6 interconnected tables:
1. `system_user`: Role-based authentication (`ADMIN`, `TEACHER`) with SHA-256 encrypted credentials.
2. `student`: Student directory with unique enrollment numbers (`enrollment_no`).
3. `teacher`: Faculty members linked to their system user accounts.
4. `subject`: Courses mapped to assigned faculty members.
5. `enrollment`: Resolves the **Many-to-Many (N:M)** relationship between students and subjects.
6. `attendance`: Daily attendance logs (`PRESENT` / `ABSENT`) with unique compound keys `(enrollment_id, attendance_date)`.

---

## 🚀 Getting Started

### 1. Database Setup
1. Start MySQL using **XAMPP Control Panel** or MySQL Server 8.0.
2. Open phpMyAdmin (`http://localhost/phpmyadmin`) or MySQL CLI.
3. Execute `database/schema.sql`.
4. Execute `database/seed_data.sql` to load demo faculty, students, subjects, and attendance history.
5. *(Optional)* If your MySQL user `root` has a password, update `src/main/resources/db.properties`:
   ```properties
   db.password=YOUR_PASSWORD
   ```

### 2. Opening & Running in Apache NetBeans
1. Launch **Apache NetBeans**.
2. Click **File -> Open Project...**
3. Select the folder `AttendanceSystem`.
4. Right-click the project in the Projects Explorer and select **Run** (or press `F6`).
5. Select your application server (e.g., **Apache Tomcat**).
6. Access the application at: `http://localhost:8080/AttendanceManagementSystem/`

---

## 🔑 Demo Credentials
| Role | Username | Password | Permissions |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Full access: CRUD Students, Teachers, Subjects, Enrollments, System Analytics |
| **Faculty 1** | `kunal.khimani` | `teacher123` | Mark daily attendance, Attendance Sheets, 75% Rule Reports |
| **Faculty 2** | `sweta.khatana` | `teacher123` | Mark daily attendance, Attendance Sheets, 75% Rule Reports |

---

## 📊 Key Highlights for Academic Defense
- **Atomic Transactions:** Uses JDBC batch processing (`executeBatch()`, `commit()`, `rollback()`) to save entire classroom attendance sheets securely.
- **Academic 75% Rule:** Automatically flags students falling below the mandatory 75% attendance threshold with red warning badges and exam exclusion notices.
- **Real-time Analytics:** Interactive Donut and Bar charts powered by Chart.js.
- **Enterprise Security:** Servlet `AuthenticationFilter` guarding administrative and teacher paths against unauthorized access.
