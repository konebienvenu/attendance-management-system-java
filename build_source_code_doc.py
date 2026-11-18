import os
import sys
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml, OxmlElement
from docx.oxml.ns import nsdecls, qn

BASE_DIR = r"c:\Users\HP\Desktop\projets-react-njs\VERSIONS PRINCIPALES\attendance-management-system"
APP_DIR = os.path.join(BASE_DIR, "AttendanceSystem")
TEMPLATE_DOC = os.path.join(BASE_DIR, "Project_AJT_Technologies_Implementation.docx")
OUTPUT_DOC = os.path.join(BASE_DIR, "Project_AJT_Technologies_Source_Code_Final_Submission.docx")
GITHUB_REPO_URL = "https://github.com/konebienvenu/attendance-management-system-java"

def set_cell_background(cell, hex_color):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('w:top', top), ('w:bottom', bottom), ('w:left', left), ('w:right', right)]:
        node = OxmlElement(m)
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def add_header_callout(doc, title, items, border_color="4F46E5", bg_color="EEF2FF"):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    tbl.columns[0].width = Inches(6.5)
    cell = tbl.cell(0, 0)
    set_cell_background(cell, bg_color)
    set_cell_margins(cell, top=140, bottom=140, left=200, right=160)

    tcPr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>'
        f'<w:top w:val="single" w:sz="6" w:space="0" w:color="{border_color}"/>'
        f'<w:left w:val="single" w:sz="36" w:space="0" w:color="{border_color}"/>'
        f'<w:bottom w:val="single" w:sz="6" w:space="0" w:color="{border_color}"/>'
        f'<w:right w:val="single" w:sz="6" w:space="0" w:color="{border_color}"/>'
        f'</w:tcBorders>'
    )
    tcPr.append(borders)

    p0 = cell.paragraphs[0]
    p0.paragraph_format.space_before = Pt(2)
    p0.paragraph_format.space_after = Pt(4)
    run_t = p0.add_run(title)
    run_t.font.name = 'Calibri'
    run_t.font.size = Pt(11.0)
    run_t.font.bold = True
    run_t.font.color.rgb = RGBColor(30, 41, 59)

    for label, val in items:
        p = cell.add_paragraph()
        p.paragraph_format.space_before = Pt(1)
        p.paragraph_format.space_after = Pt(2)
        r_lbl = p.add_run(f"• {label}: ")
        r_lbl.font.name = 'Calibri'
        r_lbl.font.size = Pt(9.5)
        r_lbl.font.bold = True
        r_lbl.font.color.rgb = RGBColor(79, 70, 229)

        r_val = p.add_run(str(val))
        r_val.font.name = 'Calibri'
        r_val.font.size = Pt(9.5)
        r_val.font.color.rgb = RGBColor(51, 65, 85)

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

def add_code_block(doc, code_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    tbl.columns[0].width = Inches(6.5)
    cell = tbl.cell(0, 0)
    set_cell_background(cell, "F8FAFC")
    set_cell_margins(cell, top=120, bottom=120, left=160, right=140)

    tcPr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>'
        f'<w:top w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>'
        f'<w:left w:val="single" w:sz="24" w:space="0" w:color="4F46E5"/>'
        f'<w:bottom w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>'
        f'<w:right w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>'
        f'</w:tcBorders>'
    )
    tcPr.append(borders)

    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.line_spacing = 1.05
    run = p.add_run(code_text.rstrip())
    run.font.name = 'Consolas'
    run.font.size = Pt(8.2)
    run.font.color.rgb = RGBColor(30, 41, 59)

    doc.add_paragraph().paragraph_format.space_after = Pt(8)

def read_file_safe(file_path):
    for enc in ['utf-8', 'utf-8-sig', 'latin1', 'cp1252']:
        try:
            with open(file_path, 'r', encoding=enc) as f:
                return f.read()
        except Exception:
            continue
    return f"// Error reading file: {file_path}"

# Define all project source files categorized
SECTIONS = [
    {
        "category_title": "1. Configuration & Enterprise Deployment Descriptors",
        "category_desc": "Essential Java EE configuration files specifying Maven dependencies, compiler levels, Servlet API, Tomcat context mapping, and session timeout parameters.",
        "files": [
            {
                "title": "1.1 Maven Project Object Model (pom.xml)",
                "rel_path": "pom.xml",
                "role": "Dependency management declaring Java Servlet API 3.1, JSP 2.3, JSTL 1.2, MySQL Connector/J 8.3, and Google GSON 2.10.",
                "tech": "Apache Maven 3, Java 1.8 compatibility, WAR packaging plugin"
            },
            {
                "title": "1.2 Web Application Deployment Descriptor (web.xml)",
                "rel_path": r"src\main\webapp\WEB-INF\web.xml",
                "role": "Servlet specification 3.1 descriptor configuring welcome file redirection, HTTP-only secure cookie policies, and 30-minute session expiration.",
                "tech": "Java EE 3.1 Deployment Descriptor, Cookie Config, Session Tracking"
            },
            {
                "title": "1.3 Apache Tomcat Context Configuration (context.xml)",
                "rel_path": r"src\main\webapp\META-INF\context.xml",
                "role": "Servlet container context definition mapping the web application context path to /AttendanceManagementSystem.",
                "tech": "Apache Tomcat 9.0 Context Specification"
            },
            {
                "title": "1.4 Database Connection Configuration (db.properties)",
                "rel_path": r"src\main\resources\db.properties",
                "role": "Externalized configuration isolating database URL, JDBC driver name, root credentials, and character encoding.",
                "tech": "Java Resource Bundle, JDBC Driver Configuration"
            }
        ]
    },
    {
        "category_title": "2. Relational Database Schema & Data Dumps (MySQL / XAMPP)",
        "category_desc": "Relational database definitions adhering to Boyce-Codd Normal Form (BCNF), foreign key cascades, unique compound indexes, and seed datasets.",
        "files": [
            {
                "title": "2.1 Database Definition Schema (schema.sql)",
                "rel_path": r"database\schema.sql",
                "role": "DDL script creating database attendance_management_system and 6 relational tables: system_user, student, teacher, subject, enrollment, and attendance.",
                "tech": "MySQL 8.0 / MariaDB 10.4, InnoDB Storage Engine, Foreign Keys, UTF8MB4"
            },
            {
                "title": "2.2 Initial Seed Data & Demo Records (seed_data.sql)",
                "rel_path": r"database\seed_data.sql",
                "role": "DML script provisioning faculty accounts, student cohorts, course assignments, and historical attendance logs with SHA-256 password hashes.",
                "tech": "SQL DML, Truncate Cascades, SHA-256 Hashed Passwords, Multi-Course Data"
            }
        ]
    },
    {
        "category_title": "3. Domain Models & Data Transfer Objects (JavaBeans & DTOs)",
        "category_desc": "Serializable domain entities encapsulating business records and specialized DTOs for multi-table roll call sheets and academic 75% rule compliance.",
        "files": [
            {
                "title": "3.1 System User Entity (User.java)",
                "rel_path": r"src\main\java\com\attendance\model\User.java",
                "role": "Authentication identity JavaBean encapsulating user_id, username, password hash, and role (ADMIN or TEACHER).",
                "tech": "JavaBean, Serializable, Role-Based Access Control (RBAC)"
            },
            {
                "title": "3.2 Student Entity (Student.java)",
                "rel_path": r"src\main\java\com\attendance\model\Student.java",
                "role": "Student directory entity encapsulating enrollment number, student name, email, and current semester.",
                "tech": "JavaBean, Domain Model Entity"
            },
            {
                "title": "3.3 Faculty / Teacher Entity (Teacher.java)",
                "rel_path": r"src\main\java\com\attendance\model\Teacher.java",
                "role": "Faculty directory entity mapped 1-to-1 with a system_user account for faculty dashboard operations.",
                "tech": "JavaBean, 1-to-1 Database Association Entity"
            },
            {
                "title": "3.4 Academic Course / Subject Entity (Subject.java)",
                "rel_path": r"src\main\java\com\attendance\model\Subject.java",
                "role": "Curriculum course entity encapsulating subject code, subject title, and assigned faculty instructor ID.",
                "tech": "JavaBean, Course Management Model"
            },
            {
                "title": "3.5 Course Enrollment Entity (Enrollment.java)",
                "rel_path": r"src\main\java\com\attendance\model\Enrollment.java",
                "role": "Associative entity modeling the Many-to-Many relationship between students and courses with ACTIVE/INACTIVE status.",
                "tech": "JavaBean, Many-to-Many Association Entity"
            },
            {
                "title": "3.6 Attendance Log Entity (Attendance.java)",
                "rel_path": r"src\main\java\com\attendance\model\Attendance.java",
                "role": "Daily attendance record entity linking enrollment_id, attendance_date, PRESENT/ABSENT status, and faculty auditor ID.",
                "tech": "JavaBean, Daily Attendance Tracking Entity"
            },
            {
                "title": "3.7 Roll Call Sheet Row DTO (AttendanceSheetRowDTO.java)",
                "rel_path": r"src\main\java\com\attendance\model\AttendanceSheetRowDTO.java",
                "role": "Optimized Data Transfer Object combining student bio data with existing daily status for interactive roll call forms.",
                "tech": "Java DTO Pattern, UI-Optimized Query Projection"
            },
            {
                "title": "3.8 Executive Dashboard Statistics DTO (DashboardStatsDTO.java)",
                "rel_path": r"src\main\java\com\attendance\model\DashboardStatsDTO.java",
                "role": "Aggregated metrics DTO holding overall student counts, attendance percentages, and course-wise breakdown for Chart.js.",
                "tech": "Java DTO, Nested Static Class, Chart Data Model"
            },
            {
                "title": "3.9 Student Attendance Compliance Report DTO (StudentReportDTO.java)",
                "rel_path": r"src\main\java\com\attendance\model\StudentReportDTO.java",
                "role": "Analytics DTO calculating total classes, classes attended, percentage, and dynamically evaluating the Academic 75% Rule isWarning() flag.",
                "tech": "Business Logic Evaluation, 75% Rule Compliance Engine"
            }
        ]
    },
    {
        "category_title": "4. Data Access Layer & Security Utilities (DAO & JDBC)",
        "category_desc": "Thread-safe JDBC persistence layer using PreparedStatement parameter-binding, atomic batch transactions, and SHA-256 cryptography.",
        "files": [
            {
                "title": "4.1 Thread-Safe JDBC Connection Manager (DBConnection.java)",
                "rel_path": r"src\main\java\com\attendance\util\DBConnection.java",
                "role": "Singleton JDBC connection factory loading properties with auto-close helper methods and resource leak prevention.",
                "tech": "Singleton Pattern, JDBC DriverManager, Safe Resource Handling"
            },
            {
                "title": "4.2 Cryptographic Password Hashing Utility (PasswordUtil.java)",
                "rel_path": r"src\main\java\com\attendance\util\PasswordUtil.java",
                "role": "Security helper implementing SHA-256 cryptographic message digests for non-reversible user password protection.",
                "tech": "java.security.MessageDigest, SHA-256, Hex Encoding"
            },
            {
                "title": "4.3 User Authentication DAO (UserDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\UserDAO.java",
                "role": "Data access object validating user credentials against SHA-256 hashes and querying user accounts.",
                "tech": "JDBC PreparedStatement, SQL Injection Prevention, Secure Auth"
            },
            {
                "title": "4.4 Student Directory DAO (StudentDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\StudentDAO.java",
                "role": "Complete CRUD persistence layer managing student records with enrollment number uniqueness validation.",
                "tech": "JDBC CRUD Operations, Duplicate Key Exception Handling"
            },
            {
                "title": "4.5 Faculty & Account Provisioning DAO (TeacherDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\TeacherDAO.java",
                "role": "Manages teacher profiles and orchestrates transactional user account generation for newly registered faculty.",
                "tech": "Multi-Table Transactional Operations, Foreign Key Binding"
            },
            {
                "title": "4.6 Academic Subject Catalog DAO (SubjectDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\SubjectDAO.java",
                "role": "CRUD operations for academic subjects and faculty assignment joins.",
                "tech": "Relational JOIN Queries, Course Catalog Persistence"
            },
            {
                "title": "4.7 Student Course Enrollment DAO (EnrollmentDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\EnrollmentDAO.java",
                "role": "Handles Many-to-Many student-to-subject enrollments, status toggles (ACTIVE/INACTIVE), and deletion cascades.",
                "tech": "Many-to-Many Persistence, Unique Compound Key Management"
            },
            {
                "title": "4.8 Atomic Attendance Roll Call & Analytics DAO (AttendanceDAO.java)",
                "rel_path": r"src\main\java\com\attendance\dao\AttendanceDAO.java",
                "role": "Enterprise DAO featuring atomic batch execution (setAutoCommit(false), addBatch(), commit(), rollback()) and ON DUPLICATE KEY UPDATE.",
                "tech": "ACID JDBC Transactions, PreparedStatement Batch Processing, SQL Aggregates"
            }
        ]
    },
    {
        "category_title": "5. Security Filter & Access Control (Java EE Filter)",
        "category_desc": "Centralized HTTP interceptor protecting administrative and faculty URL routes against unauthenticated or unauthorized access.",
        "files": [
            {
                "title": "5.1 Enterprise Role-Based Access Control Filter (AuthenticationFilter.java)",
                "rel_path": r"src\main\java\com\attendance\filter\AuthenticationFilter.java",
                "role": "WebFilter intercepting all requests, enforcing session validation, UTF-8 encoding, browser cache prevention, and role segregation.",
                "tech": "javax.servlet.Filter, Role-Based Access Control (RBAC), Cache-Control Headers"
            }
        ]
    },
    {
        "category_title": "6. Controller Layer - Java Servlets (MVC Controllers)",
        "category_desc": "HTTP Controllers processing client requests, orchestrating business logic with DAOs, and routing results to JSP presentation views.",
        "files": [
            {
                "title": "6.1 Authentication & Session Controller (AuthServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\AuthServlet.java",
                "role": "Handles user login, session creation, credential verification, and role-based redirect to Admin or Teacher dashboards.",
                "tech": "HttpServlet, HttpSession, Form Validation, Role Routing"
            },
            {
                "title": "6.2 Administrator Dashboard & Analytics Controller (AdminDashboardServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\AdminDashboardServlet.java",
                "role": "Gathers university-wide KPI metrics and serializes course-wise statistics to JSON using Google GSON for Chart.js rendering.",
                "tech": "HttpServlet, Google GSON Serialization, Dashboard Analytics"
            },
            {
                "title": "6.3 Faculty Portal Dashboard Controller (TeacherDashboardServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\TeacherDashboardServlet.java",
                "role": "Loads assigned academic courses for the currently logged-in teacher and forwards to the faculty portal.",
                "tech": "HttpServlet, Session User Resolution, Course Filtering"
            },
            {
                "title": "6.4 Class Attendance Roll Call Controller (AttendanceServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\AttendanceServlet.java",
                "role": "Processes daily roll call sheets, parses dynamic multi-student status radio inputs, and invokes batch attendance persistence.",
                "tech": "HttpServlet, Dynamic Parameter Enumeration, Batch Transaction Trigger"
            },
            {
                "title": "6.5 Student Directory Management Controller (StudentServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\StudentServlet.java",
                "role": "Dispatches administrative student CRUD operations (Add, Edit, Update, Delete) with server-side validation.",
                "tech": "HttpServlet, RESTful Action Dispatching, CRUD Management"
            },
            {
                "title": "6.6 Faculty Directory Management Controller (TeacherServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\TeacherServlet.java",
                "role": "Manages faculty member registrations, creates linked system user accounts, and handles deletions.",
                "tech": "HttpServlet, Multi-Entity Provisioning, Error Handling"
            },
            {
                "title": "6.7 Course Curriculum Management Controller (SubjectServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\SubjectServlet.java",
                "role": "Manages academic course offerings and maps assigned teachers to specific subject codes.",
                "tech": "HttpServlet, Subject-Teacher Relationship Mapping"
            },
            {
                "title": "6.8 Course Enrollment Management Controller (EnrollmentServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\EnrollmentServlet.java",
                "role": "Enrolls students into courses, toggles enrollment status between ACTIVE and INACTIVE, and removes enrollments.",
                "tech": "HttpServlet, Association Entity Control, Status Toggling"
            },
            {
                "title": "6.9 Academic Attendance Reports Controller (ReportServlet.java)",
                "rel_path": r"src\main\java\com\attendance\controller\ReportServlet.java",
                "role": "Generates real-time attendance reports per course, computes cohort averages, and highlights 75% rule defaulters.",
                "tech": "HttpServlet, Java 8 Stream API Aggregations, Academic 75% Rule Evaluation"
            }
        ]
    },
    {
        "category_title": "7. Web Presentation Layer (JSP Views & Modular Components)",
        "category_desc": "Modular JSP 2.3 views utilizing JSTL 1.2 core tags and EL 3.0 expressions, stored securely under /WEB-INF/views/ to prevent unauthorized direct URL access.",
        "files": [
            {
                "title": "7.1 Application Entry Redirection (index.jsp)",
                "rel_path": r"src\main\webapp\index.jsp",
                "role": "Root application forwarder immediately directing visitors to the secure /login servlet endpoint.",
                "tech": "JSP 2.3, Context Redirection"
            },
            {
                "title": "7.2 University Login View (login.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\login.jsp",
                "role": "Modern authentication interface with academic attribution, password show/hide toggle, and quick demo credentials helper.",
                "tech": "JSP, JSTL, Password Eye Toggle, Quick Demo Panel"
            },
            {
                "title": "7.3 Common Header Component (header.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\common\header.jsp",
                "role": "Shared HTML head layout importing Bootstrap 5.3 CSS, FontAwesome 6 icons, Inter font, and custom theme styles.",
                "tech": "JSP Modular Component, CDN Dependencies, Meta Viewport"
            },
            {
                "title": "7.4 Common Footer Component (footer.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\common\footer.jsp",
                "role": "Shared script bundle loading Bootstrap JS and custom main.js scripts.",
                "tech": "JSP Modular Component, JavaScript Bundle Injection"
            },
            {
                "title": "7.5 Navigation Topbar Component (navbar.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\common\navbar.jsp",
                "role": "Topbar displaying sidebar toggle, logged-in user profile, role badge, and quick logout button.",
                "tech": "JSP Component, Role Badge, Responsive Hamburger Toggle"
            },
            {
                "title": "7.6 Navigation Sidebar Component (sidebar.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\common\sidebar.jsp",
                "role": "Collapsible sidebar menu rendering role-specific navigation links for Admin and Faculty portals.",
                "tech": "JSP Component, Active Link Highlighting, JSTL Role Conditional"
            },
            {
                "title": "7.7 Administrator Executive Dashboard View (admin/dashboard.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\admin\dashboard.jsp",
                "role": "Visual analytics dashboard with KPI counter cards, interactive Chart.js bar and donut charts, and quick-action shortcuts.",
                "tech": "JSP, Chart.js Visualizations, GSON JSON Dataset Binding"
            },
            {
                "title": "7.8 Student Directory Management View (admin/students.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\admin\students.jsp",
                "role": "CRUD interface for student directory with real-time search filter, modal add/edit forms, and horizontal scroll controls.",
                "tech": "JSP, Bootstrap Modals, JSTL ForEach Iteration, Scroll Arrows"
            },
            {
                "title": "7.9 Faculty Directory Management View (admin/teachers.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\admin\teachers.jsp",
                "role": "CRUD interface for faculty management with dual faculty profile and user credentials creation.",
                "tech": "JSP, Bootstrap Modals, Dual Entity Form Fields"
            },
            {
                "title": "7.10 Course Curriculum Management View (admin/subjects.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\admin\subjects.jsp",
                "role": "Curriculum management view mapping academic subjects to designated professors with search and edit modal.",
                "tech": "JSP, Dynamic Dropdowns, JSTL Foreach"
            },
            {
                "title": "7.11 Course Enrollment Management View (admin/enrollments.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\admin\enrollments.jsp",
                "role": "Course enrollment table with student-course association modals, status toggle switches, and quick filters.",
                "tech": "JSP, Many-to-Many Management View, Status Badges"
            },
            {
                "title": "7.12 Faculty Portal Dashboard View (teacher/dashboard.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\teacher\dashboard.jsp",
                "role": "Faculty personal home screen displaying assigned courses, quick links to mark attendance, and report generators.",
                "tech": "JSP, Faculty Portal, Course Cards"
            },
            {
                "title": "7.13 Interactive Daily Attendance Sheet View (teacher/mark_attendance.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\teacher\mark_attendance.jsp",
                "role": "Interactive roll call view with date selector, Mark All Present/Absent bulk buttons, and green/red radio toggles.",
                "tech": "JSP, Dynamic Radio Controls, Instant Bulk Buttons, AJAX-Ready"
            },
            {
                "title": "7.14 Academic Attendance & 75% Rule Compliance Report View (teacher/reports.jsp)",
                "rel_path": r"src\main\webapp\WEB-INF\views\teacher\reports.jsp",
                "role": "Report view calculating total classes, attendance percentage, and prominent red warning badges for < 75% defaulters.",
                "tech": "JSP, Progress Bars, 75% Rule Academic Alert Badges"
            }
        ]
    },
    {
        "category_title": "8. Frontend Stylesheets & Client Scripts (CSS & JavaScript)",
        "category_desc": "Modern responsive theme styling, custom horizontal scrolling engines, instant client-side table search, and UI helpers.",
        "files": [
            {
                "title": "8.1 Application Master Stylesheet (style.css)",
                "rel_path": r"src\main\webapp\assets\css\style.css",
                "role": "Defines CSS custom properties, responsive flexbox layout, custom indigo scrollbars, card elevation shadows, and status badges.",
                "tech": "CSS3 Variables, Flexbox Layout, Webkit Scrollbars, Media Queries"
            },
            {
                "title": "8.2 Application Client-Side Script Helpers (main.js)",
                "rel_path": r"src\main\webapp\assets\js\main.js",
                "role": "JavaScript helpers implementing drag-to-scroll, wheel horizontal scroll, live table search filtering, password eye toggle, and academic footer.",
                "tech": "Vanilla JavaScript ES6, Event Listeners, DOM Manipulation"
            }
        ]
    },
    {
        "category_title": "9. Unit & Integration Testing",
        "category_desc": "Verification test suites verifying JDBC driver loading, database connection pooling, and sample query execution.",
        "files": [
            {
                "title": "9.1 JDBC Database Connection Test (DBTest.java)",
                "rel_path": r"src\test\java\com\attendance\DBTest.java",
                "role": "Integration test validating database connection establishment, schema availability, and user record queries.",
                "tech": "Java Test Suite, JDBC Connection Validation"
            }
        ]
    }
]

def main():
    print("=" * 70)
    print("Generating Complete Source Code Final Submission Word Document...")
    print(f"Source Template : {TEMPLATE_DOC}")
    print(f"Output Target   : {OUTPUT_DOC}")
    print("=" * 70)

    # 1. Load document template and clear body while preserving sectPr
    doc = Document(TEMPLATE_DOC)
    body = doc._body._element
    sectPr = body.find(qn('w:sectPr'))

    for child in list(body):
        if child != sectPr:
            body.remove(child)

    print("Template body cleared successfully. Preserved Header & Footer XML.")

    # 2. Add Cover Page / Academic Dossier Header
    p_inst = doc.add_paragraph()
    p_inst.paragraph_format.space_before = Pt(0)
    p_inst.paragraph_format.space_after = Pt(2)
    p_inst.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_inst = p_inst.add_run("MARWADI UNIVERSITY • FACULTY OF ENGINEERING & TECHNOLOGY")
    r_inst.font.name = 'Calibri'
    r_inst.font.size = Pt(11.0)
    r_inst.font.bold = True
    r_inst.font.color.rgb = RGBColor(100, 116, 139)

    p_dept = doc.add_paragraph()
    p_dept.paragraph_format.space_before = Pt(0)
    p_dept.paragraph_format.space_after = Pt(12)
    p_dept.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_dept = p_dept.add_run("DEPARTMENT OF COMPUTER ENGINEERING")
    r_dept.font.name = 'Calibri'
    r_dept.font.size = Pt(10.5)
    r_dept.font.bold = True
    r_dept.font.color.rgb = RGBColor(79, 70, 229)

    # Document Main Title
    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(6)
    p_title.paragraph_format.space_after = Pt(2)
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_title = p_title.add_run("ADVANCE JAVA TECHNOLOGY (01CE0308)")
    r_title.font.name = 'Calibri'
    r_title.font.size = Pt(16.0)
    r_title.font.bold = True
    r_title.font.color.rgb = RGBColor(30, 41, 59)

    p_sub = doc.add_paragraph()
    p_sub.paragraph_format.space_before = Pt(0)
    p_sub.paragraph_format.space_after = Pt(4)
    p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sub = p_sub.add_run("ENTERPRISE ATTENDANCE MANAGEMENT SYSTEM")
    r_sub.font.name = 'Calibri'
    r_sub.font.size = Pt(14.0)
    r_sub.font.bold = True
    r_sub.font.color.rgb = RGBColor(79, 70, 229)

    p_sub2 = doc.add_paragraph()
    p_sub2.paragraph_format.space_before = Pt(0)
    p_sub2.paragraph_format.space_after = Pt(16)
    p_sub2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sub2 = p_sub2.add_run("COMPLETE PROJECT SOURCE CODE DOSSIER • FINAL ACADEMIC SUBMISSION")
    r_sub2.font.name = 'Calibri'
    r_sub2.font.size = Pt(11.0)
    r_sub2.font.bold = True
    r_sub2.font.color.rgb = RGBColor(16, 185, 129)

    # GITHUB REPOSITORY CALLOUT BOX (PROMINENT AT FIRST PAGE AS REQUESTED)
    add_header_callout(
        doc,
        title="🌐 OFFICIAL GITHUB REPOSITORY & REPLICATION GUIDE",
        items=[
            ("GitHub Repository URL", GITHUB_REPO_URL),
            ("Repository Visibility", "Public Open-Source Academic Repository"),
            ("Production Branch", "main"),
            ("Clone Command", f"git clone {GITHUB_REPO_URL}.git"),
            ("Database Restore Dump", "attendance_management_system_dump.sql (Included in root & database/ directory for instant 1-click import in XAMPP / phpMyAdmin)"),
            ("Full Stack Technologies", "Java EE 8 (Servlets 3.1, JSP 2.3, JSTL 1.2), Apache Tomcat 9, MySQL 8 / XAMPP MariaDB, Bootstrap 5.3, Chart.js, Maven")
        ],
        border_color="10B981",
        bg_color="ECFDF5"
    )

    # Academic Metadata Table
    p_meta_lbl = doc.add_paragraph()
    p_meta_lbl.paragraph_format.space_before = Pt(8)
    p_meta_lbl.paragraph_format.space_after = Pt(4)
    r_mlbl = p_meta_lbl.add_run("Academic Evaluation & Project Credits")
    r_mlbl.font.name = 'Calibri'
    r_mlbl.font.size = Pt(11.5)
    r_mlbl.font.bold = True
    r_mlbl.font.color.rgb = RGBColor(30, 41, 59)

    meta_tbl = doc.add_table(rows=7, cols=2)
    meta_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    meta_tbl.autofit = False
    meta_tbl.columns[0].width = Inches(2.3)
    meta_tbl.columns[1].width = Inches(4.2)

    meta_data = [
        ("Course Name & Code", "Advance Java Technology (01CE0308) - Semester 3"),
        ("Academic Year", "2026 - 2027"),
        ("Project Developed By", "Kone Bienvenu, Avinash, Kabwe (CSE-CS Student, Semester 3)"),
        ("Lead Submitter / Enrollment", "KONE GNIENNEGNINRI BIENVENU — Enrollment No: 92500119244"),
        ("Faculty Mentors & Evaluators", "Prof. Sweta Khatana & Prof. Kunal Khimani"),
        ("Architectural Architecture", "Enterprise 3-Tier MVC (Model-View-Controller) Architecture"),
        ("Database Dump Export", "Extracted from local XAMPP MySQL (attendance_management_system)")
    ]

    for idx, (label, val) in enumerate(meta_data):
        row = meta_tbl.rows[idx]
        c0 = row.cells[0]
        c1 = row.cells[1]
        set_cell_background(c0, "F1F5F9" if idx % 2 == 0 else "F8FAFC")
        set_cell_background(c1, "FFFFFF" if idx % 2 == 0 else "F8FAFC")
        set_cell_margins(c0, top=60, bottom=60, left=100, right=100)
        set_cell_margins(c1, top=60, bottom=60, left=100, right=100)

        p0 = c0.paragraphs[0]
        p0.paragraph_format.space_before = Pt(2)
        p0.paragraph_format.space_after = Pt(2)
        r0 = p0.add_run(label)
        r0.font.name = 'Calibri'
        r0.font.size = Pt(9.5)
        r0.font.bold = True
        r0.font.color.rgb = RGBColor(30, 41, 59)

        p1 = c1.paragraphs[0]
        p1.paragraph_format.space_before = Pt(2)
        p1.paragraph_format.space_after = Pt(2)
        r1 = p1.add_run(val)
        r1.font.name = 'Calibri'
        r1.font.size = Pt(9.5)
        r1.font.color.rgb = RGBColor(51, 65, 85)

    doc.add_page_break()

    # 3. Architectural Table of Contents
    p_toc = doc.add_paragraph()
    p_toc.paragraph_format.space_before = Pt(8)
    p_toc.paragraph_format.space_after = Pt(4)
    r_toc = p_toc.add_run("Comprehensive Source Code Index & Architectural Breakdown")
    r_toc.font.name = 'Calibri'
    r_toc.font.size = Pt(13.0)
    r_toc.font.bold = True
    r_toc.font.color.rgb = RGBColor(30, 41, 59)

    p_toc_desc = doc.add_paragraph()
    p_toc_desc.paragraph_format.space_before = Pt(0)
    p_toc_desc.paragraph_format.space_after = Pt(8)
    r_td = p_toc_desc.add_run(
        "This dossier provides the exhaustive, verbatim source code implementation of the Enterprise Attendance "
        "Management System. Every source component is documented with its architectural layer, relative file path, "
        "functional responsibilities, and complete production code."
    )
    r_td.font.name = 'Calibri'
    r_td.font.size = Pt(10.0)
    r_td.font.color.rgb = RGBColor(71, 85, 105)

    # Index Table
    index_tbl = doc.add_table(rows=1, cols=3)
    index_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    index_tbl.autofit = False
    index_tbl.columns[0].width = Inches(2.6)
    index_tbl.columns[1].width = Inches(1.6)
    index_tbl.columns[2].width = Inches(2.3)

    hdr_cells = index_tbl.rows[0].cells
    hdr_titles = ["Component Title", "Architectural Layer", "File Relative Path"]
    for i, t in enumerate(hdr_titles):
        set_cell_background(hdr_cells[i], "1E293B")
        set_cell_margins(hdr_cells[i], top=80, bottom=80, left=100, right=100)
        p = hdr_cells[i].paragraphs[0]
        r = p.add_run(t)
        r.font.name = 'Calibri'
        r.font.size = Pt(9.5)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)

    total_files_count = 0
    for section in SECTIONS:
        cat_name = section["category_title"]
        for f in section["files"]:
            total_files_count += 1
            row = index_tbl.add_row()
            c0, c1, c2 = row.cells
            bg = "F8FAFC" if total_files_count % 2 == 0 else "FFFFFF"
            for c in (c0, c1, c2):
                set_cell_background(c, bg)
                set_cell_margins(c, top=40, bottom=40, left=80, right=80)

            p0 = c0.paragraphs[0]
            p0.paragraph_format.space_before = Pt(1)
            p0.paragraph_format.space_after = Pt(1)
            r0 = p0.add_run(f["title"])
            r0.font.name = 'Calibri'
            r0.font.size = Pt(8.5)
            r0.font.bold = True
            r0.font.color.rgb = RGBColor(30, 41, 59)

            p1 = c1.paragraphs[0]
            p1.paragraph_format.space_before = Pt(1)
            p1.paragraph_format.space_after = Pt(1)
            r1 = p1.add_run(cat_name.split(". ")[1] if ". " in cat_name else cat_name)
            r1.font.name = 'Calibri'
            r1.font.size = Pt(8.5)
            r1.font.color.rgb = RGBColor(79, 70, 229)

            p2 = c2.paragraphs[0]
            p2.paragraph_format.space_before = Pt(1)
            p2.paragraph_format.space_after = Pt(1)
            r2 = p2.add_run(f["rel_path"])
            r2.font.name = 'Consolas'
            r2.font.size = Pt(8.0)
            r2.font.color.rgb = RGBColor(51, 65, 85)

    doc.add_page_break()

    # 4. Iterate over each section and write complete source codes
    processed_count = 0
    for s_idx, section in enumerate(SECTIONS):
        # Section Header
        p_sec = doc.add_paragraph()
        p_sec.paragraph_format.space_before = Pt(16)
        p_sec.paragraph_format.space_after = Pt(4)
        r_sec = p_sec.add_run(section["category_title"])
        r_sec.font.name = 'Calibri'
        r_sec.font.size = Pt(13.0)
        r_sec.font.bold = True
        r_sec.font.color.rgb = RGBColor(30, 41, 59)

        p_sdesc = doc.add_paragraph()
        p_sdesc.paragraph_format.space_before = Pt(0)
        p_sdesc.paragraph_format.space_after = Pt(8)
        r_sd = p_sdesc.add_run(section["category_desc"])
        r_sd.font.name = 'Calibri'
        r_sd.font.size = Pt(10.0)
        r_sd.font.italic = True
        r_sd.font.color.rgb = RGBColor(100, 116, 139)

        for f_info in section["files"]:
            processed_count += 1
            full_file_path = os.path.join(APP_DIR, f_info["rel_path"])
            if not os.path.exists(full_file_path):
                # Check root directory fallback
                alt_path = os.path.join(BASE_DIR, f_info["rel_path"])
                if os.path.exists(alt_path):
                    full_file_path = alt_path

            print(f"[{processed_count}/{total_files_count}] Processing: {f_info['title']} ({f_info['rel_path']})")

            # File Subheading
            p_fh = doc.add_paragraph()
            p_fh.paragraph_format.space_before = Pt(12)
            p_fh.paragraph_format.space_after = Pt(3)
            r_fh = p_fh.add_run(f_info["title"])
            r_fh.font.name = 'Calibri'
            r_fh.font.size = Pt(11.5)
            r_fh.font.bold = True
            r_fh.font.color.rgb = RGBColor(79, 70, 229)

            # Metadata callout
            add_header_callout(
                doc,
                title="File Metadata & Architectural Role",
                items=[
                    ("File Path", f_info["rel_path"]),
                    ("Functional Role", f_info["role"]),
                    ("Key Technologies", f_info["tech"])
                ],
                border_color="CBD5E1",
                bg_color="F8FAFC"
            )

            # Read full file code
            code_content = read_file_safe(full_file_path)

            # Code label
            p_clbl = doc.add_paragraph()
            p_clbl.paragraph_format.space_before = Pt(4)
            p_clbl.paragraph_format.space_after = Pt(2)
            r_clbl = p_clbl.add_run("Complete Source Code Implementation:")
            r_clbl.font.name = 'Calibri'
            r_clbl.font.size = Pt(9.5)
            r_clbl.font.bold = True
            r_clbl.font.color.rgb = RGBColor(51, 65, 85)

            # Add full code block
            add_code_block(doc, code_content)

    # 5. Save the final complete Word document
    print("Saving complete Word document to:", OUTPUT_DOC)
    doc.save(OUTPUT_DOC)
    print(f"SUCCESS! Final Submission Word document generated with {processed_count} complete source files.")

if __name__ == "__main__":
    main()
