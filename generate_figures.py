import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

os.makedirs('generated_figures', exist_ok=True)

# Set common font styling
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial', 'Helvetica']

def save_fig(fig, filename):
    filepath = os.path.join('generated_figures', filename)
    fig.savefig(filepath, dpi=200, bbox_inches='tight', facecolor='white')
    plt.close(fig)
    print(f"Saved {filepath}")

# Figure 1: MVC Architecture
def make_fig1():
    fig, ax = plt.subplots(figsize=(9, 4.8), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.axis('off')
    
    # Title
    ax.text(5, 5.6, "Enterprise Java EE Multi-Tier MVC Architecture", ha='center', va='center', fontsize=13, fontweight='bold', color='#1e293b')
    ax.text(5, 5.25, "Attendance Management System (AJT - 01CE0308)", ha='center', va='center', fontsize=9, color='#64748b')

    # Client Browser
    box_client = patches.FancyBboxPatch((0.5, 3.8), 2.2, 0.9, boxstyle="round,pad=0.1", fc='#e0e7ff', ec='#4f46e5', lw=1.5)
    ax.add_patch(box_client)
    ax.text(1.6, 4.35, "Client Browser\n(HTTP GET / POST)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#312e81')

    # Security Filter
    box_filter = patches.FancyBboxPatch((3.4, 3.8), 2.4, 0.9, boxstyle="round,pad=0.1", fc='#fef3c7', ec='#d97706', lw=1.5)
    ax.add_patch(box_filter)
    ax.text(4.6, 4.35, "AuthenticationFilter\n(RBAC & Session Guard)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#92400e')

    # Controller Servlets
    box_ctrl = patches.FancyBboxPatch((6.6, 3.8), 2.9, 0.9, boxstyle="round,pad=0.1", fc='#dbeafe', ec='#2563eb', lw=1.5)
    ax.add_patch(box_ctrl)
    ax.text(8.05, 4.35, "Controller Layer\n(Java Servlets 3.1)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#1e40af')

    # View Layer (JSP)
    box_view = patches.FancyBboxPatch((6.6, 1.8), 2.9, 1.0, boxstyle="round,pad=0.1", fc='#fce7f3', ec='#db2777', lw=1.5)
    ax.add_patch(box_view)
    ax.text(8.05, 2.3, "View Layer (JSP 2.3)\nJSTL 1.2 & EL 3.0\nBootstrap 5 + Chart.js", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#831843')

    # Model & DAO Layer
    box_dao = patches.FancyBboxPatch((3.4, 1.8), 2.4, 1.0, boxstyle="round,pad=0.1", fc='#dcfce7', ec='#16a34a', lw=1.5)
    ax.add_patch(box_dao)
    ax.text(4.6, 2.3, "DAO & Model Layer\nJDBC Transactions\nPOJOs & DTOs", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#14532d')

    # Database
    box_db = patches.FancyBboxPatch((0.5, 1.8), 2.2, 1.0, boxstyle="round,pad=0.1", fc='#f1f5f9', ec='#475569', lw=1.5)
    ax.add_patch(box_db)
    ax.text(1.6, 2.3, "MySQL 8.0 Database\n6 Relational 3NF Tables\nACID Compliance", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#0f172a')

    # Arrows
    arrow_props = dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.3)
    ax.annotate('', xy=(3.4, 4.25), xytext=(2.7, 4.25), arrowprops=arrow_props)
    ax.annotate('', xy=(6.6, 4.25), xytext=(5.8, 4.25), arrowprops=arrow_props)
    ax.annotate('', xy=(8.05, 2.8), xytext=(8.05, 3.8), arrowprops=dict(facecolor='#db2777', edgecolor='#db2777', arrowstyle='->', lw=1.3))
    ax.annotate('', xy=(4.6, 2.8), xytext=(6.6, 3.9), arrowprops=dict(facecolor='#16a34a', edgecolor='#16a34a', arrowstyle='->', lw=1.3))
    ax.annotate('', xy=(2.7, 2.3), xytext=(3.4, 2.3), arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='<->', lw=1.3))
    
    # Legend note
    ax.text(5, 0.6, "Strict MVC Separation: Presentation decoupled from Business Logic & Persistence", 
            ha='center', va='center', fontsize=8, style='italic', color='#475569',
            bbox=dict(boxstyle='square,pad=0.3', facecolor='#f8fafc', edgecolor='#cbd5e1'))

    save_fig(fig, 'fig1_mvc_architecture.png')

# Figure 2: Filter & RBAC Security Pipeline
def make_fig2():
    fig, ax = plt.subplots(figsize=(9, 4.2), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 5)
    ax.axis('off')

    ax.text(5, 4.7, "AuthenticationFilter: RBAC Request Interception & Security Pipeline", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 4.35, "Centralized HTTP Request Gatekeeper implemented via javax.servlet.Filter", ha='center', va='center', fontsize=8.5, color='#64748b')

    # Stages
    steps = [
        ("Incoming HTTP\nRequest", "#e0e7ff", "#4338ca", 1.0),
        ("URI Check:\nStatic or /login?", "#fef3c7", "#b45309", 3.2),
        ("Active Session\n& User Object?", "#ede9fe", "#6d28d9", 5.6),
        ("Role Check:\nADMIN / TEACHER", "#dcfce7", "#15803d", 8.2)
    ]
    for text, fc, ec, cx in steps:
        box = patches.FancyBboxPatch((cx-0.9, 2.2), 1.8, 1.0, boxstyle="round,pad=0.08", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.7, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    # Connections
    for i in range(len(steps)-1):
        ax.annotate('', xy=(steps[i+1][3]-0.9, 2.7), xytext=(steps[i][3]+0.9, 2.7),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    # Outcomes
    # Direct pass for static
    ax.annotate('Yes (Public)', xy=(3.2, 1.4), xytext=(3.2, 2.2),
                arrowprops=dict(facecolor='#16a34a', edgecolor='#16a34a', arrowstyle='->', lw=1.2))
    ax.text(3.2, 1.1, "chain.doFilter()\n(Direct Pass)", ha='center', va='center', fontsize=7.5, color='#15803d', fontweight='bold')

    # Session null -> Redirect login
    ax.annotate('No User in Session', xy=(5.6, 1.4), xytext=(5.6, 2.2),
                arrowprops=dict(facecolor='#ea580c', edgecolor='#ea580c', arrowstyle='->', lw=1.2))
    ax.text(5.6, 1.1, "sendRedirect(\n/login?error=expired)", ha='center', va='center', fontsize=7.5, color='#c2410c', fontweight='bold')

    # Role failed -> 403 Forbidden
    ax.annotate('Unauthorized Role', xy=(8.2, 1.4), xytext=(8.2, 2.2),
                arrowprops=dict(facecolor='#dc2626', edgecolor='#dc2626', arrowstyle='->', lw=1.2))
    ax.text(8.2, 1.1, "sendError(\nSC_FORBIDDEN 403)", ha='center', va='center', fontsize=7.5, color='#b91c1c', fontweight='bold')

    save_fig(fig, 'fig2_filter_rbac.png')

# Figure 3: Session Management Lifecycle
def make_fig3():
    fig, ax = plt.subplots(figsize=(9, 4.0), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    ax.text(5, 4.2, "HttpSession Management & State Lifecycle", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.85, "Stateful authentication over stateless HTTP protocol in AuthServlet", ha='center', va='center', fontsize=8.5, color='#64748b')

    # States
    states = [
        ("1. Anonymous\nVisitor", "#f1f5f9", "#64748b", 1.2),
        ("2. Credentials\nVerified (SHA-256)", "#dbeafe", "#2563eb", 3.7),
        ("3. Session Created\nsession.setAttribute()", "#dcfce7", "#16a34a", 6.2),
        ("4. Session Terminated\nsession.invalidate()", "#fee2e2", "#dc2626", 8.7)
    ]
    for text, fc, ec, cx in states:
        box = patches.FancyBboxPatch((cx-1.0, 1.6), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.15, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    # Arrows
    for i in range(len(states)-1):
        ax.annotate('', xy=(states[i+1][3]-1.0, 2.15), xytext=(states[i][3]+1.0, 2.15),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    # Notes below
    ax.text(1.2, 0.8, "GET /login\nNo Cookie JSESSIONID", ha='center', va='center', fontsize=7, color='#64748b')
    ax.text(3.7, 0.8, "POST /login\nUserDAO.authenticate()", ha='center', va='center', fontsize=7, color='#2563eb')
    ax.text(6.2, 0.8, "Cookie: JSESSIONID\nTimeout: 30 min (web.xml)", ha='center', va='center', fontsize=7, color='#16a34a')
    ax.text(8.7, 0.8, "GET /logout\nMemory Cleared", ha='center', va='center', fontsize=7, color='#dc2626')

    save_fig(fig, 'fig3_session_lifecycle.png')

# Figure 4: Batch JDBC Transaction
def make_fig4():
    fig, ax = plt.subplots(figsize=(9, 4.2), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.8)
    ax.axis('off')

    ax.text(5, 4.5, "ACID Batch Transaction Execution (AttendanceDAO.saveBatchAttendance)", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 4.15, "Transactional JDBC execution with ON DUPLICATE KEY UPDATE conflict resolution", ha='center', va='center', fontsize=8.5, color='#64748b')

    steps = [
        ("conn.setAutoCommit(false)\n[Begin ACID Boundary]", "#fef3c7", "#d97706", 1.4),
        ("PreparedStatement Loop\nstmt.addBatch() [N Rows]", "#e0e7ff", "#4f46e5", 4.1),
        ("stmt.executeBatch()\n[Single SQL Network Call]", "#dbeafe", "#0284c7", 6.8),
        ("conn.commit()\n[Atomic Success]", "#dcfce7", "#16a34a", 8.8)
    ]
    for text, fc, ec, cx in steps:
        box = patches.FancyBboxPatch((cx-1.0, 1.9), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.45, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    for i in range(len(steps)-1):
        ax.annotate('', xy=(steps[i+1][3]-1.0, 2.45), xytext=(steps[i][3]+1.0, 2.45),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    # Catch rollback arrow
    ax.annotate('catch (SQLException e)', xy=(6.8, 0.9), xytext=(6.8, 1.9),
                arrowprops=dict(facecolor='#dc2626', edgecolor='#dc2626', arrowstyle='->', lw=1.2))
    box_rollback = patches.FancyBboxPatch((5.8, 0.3), 2.0, 0.6, boxstyle="round,pad=0.1", fc='#fee2e2', ec='#dc2626', lw=1.3)
    ax.add_patch(box_rollback)
    ax.text(6.8, 0.6, "conn.rollback() [Zero Partial Writes]", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#991b1b')

    save_fig(fig, 'fig4_batch_transaction.png')

# Figure 5: Dynamic 75% Rule Calculation & Analytics
def make_fig5():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 4.0), dpi=200, gridspec_kw={'width_ratios': [1.2, 1]})
    
    # Bar Chart: Course Attendance
    courses = ['AJT (01CE0308)', 'DBMS (01CE0302)', 'OS (01CE0304)', 'DS (01CE0301)']
    attendance_rates = [86.5, 78.2, 69.4, 82.0]
    colors = ['#10b981' if rate >= 75.0 else '#ef4444' for rate in attendance_rates]

    bars = ax1.bar(courses, attendance_rates, color=colors, width=0.55, edgecolor='#334155', linewidth=0.8)
    ax1.axhline(75.0, color='#dc2626', linestyle='--', linewidth=1.5, label='Mandatory 75% Threshold')
    ax1.set_ylim(0, 100)
    ax1.set_ylabel('Attendance Percentage (%)', fontsize=8.5, fontweight='bold')
    ax1.set_title('Course-Wise Attendance Compliance', fontsize=10, fontweight='bold', color='#1e293b')
    ax1.tick_params(axis='x', labelsize=7.5, rotation=15)
    ax1.tick_params(axis='y', labelsize=8)
    ax1.legend(loc='lower right', fontsize=7.5)
    ax1.grid(axis='y', linestyle=':', alpha=0.6)

    for bar in bars:
        h = bar.get_height()
        ax1.text(bar.get_x() + bar.get_width()/2., h + 1.5, f'{h}%', ha='center', va='bottom', fontsize=7.5, fontweight='bold')

    # Donut Chart: Student Risk Classification
    labels = ['Compliant (>=75%)', 'At Risk (<75%)']
    sizes = [42, 8]
    donut_colors = ['#10b981', '#ef4444']
    explode = (0, 0.1)

    wedges, texts, autotexts = ax2.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
                                       startangle=140, colors=donut_colors,
                                       textprops=dict(color="#1e293b", fontsize=8, fontweight='bold'),
                                       wedgeprops=dict(width=0.45, edgecolor='#ffffff', linewidth=2))
    ax2.set_title('Student Eligibility Status (isWarning)', fontsize=10, fontweight='bold', color='#1e293b')

    plt.tight_layout()
    save_fig(fig, 'fig5_attendance_75_rule.png')

# Figure 6: Modular JSP View Composition
def make_fig6():
    fig, ax = plt.subplots(figsize=(9, 4.4), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 5.5)
    ax.axis('off')

    ax.text(5, 5.2, "Modular JSP 2.3 View Architecture (/WEB-INF/views/)", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 4.85, "Component-based layout with <jsp:include> directives and Bootstrap 5.3", ha='center', va='center', fontsize=8.5, color='#64748b')

    # Outer Layout Frame
    frame = patches.Rectangle((1.0, 0.5), 8.0, 4.0, linewidth=1.5, edgecolor='#64748b', facecolor='#f8fafc', linestyle='--')
    ax.add_patch(frame)
    ax.text(1.2, 4.3, "Browser Window: mark_attendance.jsp", fontsize=7.5, fontweight='bold', color='#475569')

    # Header / Navbar
    navbar = patches.Rectangle((3.2, 3.4), 5.6, 0.7, linewidth=1.2, edgecolor='#2563eb', facecolor='#dbeafe')
    ax.add_patch(navbar)
    ax.text(6.0, 3.75, "<jsp:include page=\"/common/navbar.jsp\" />\nUser Profile & Logout Action", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e40af')

    # Sidebar
    sidebar = patches.Rectangle((1.2, 0.7), 1.8, 3.4, linewidth=1.2, edgecolor='#4f46e5', facecolor='#e0e7ff')
    ax.add_patch(sidebar)
    ax.text(2.1, 2.4, "<jsp:include\npage=\"sidebar.jsp\">\n\nDashboard\nAttendance\nReports\nStudents", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#3730a3')

    # Main Body Content (JSTL Table)
    body = patches.Rectangle((3.2, 1.4), 5.6, 1.8, linewidth=1.2, edgecolor='#16a34a', facecolor='#dcfce7')
    ax.add_patch(body)
    ax.text(6.0, 2.3, "Dynamic Page Content (JSTL <c:forEach> Table)\nCourse Dropdown | Date Picker | One-Click Mark All\nRoll Call Sheet with Status Toggles", ha='center', va='center', fontsize=8, fontweight='bold', color='#166534')

    # Footer
    footer = patches.Rectangle((3.2, 0.7), 5.6, 0.5, linewidth=1.2, edgecolor='#94a3b8', facecolor='#f1f5f9')
    ax.add_patch(footer)
    ax.text(6.0, 0.95, "<jsp:include page=\"/common/footer.jsp\" /> (Bootstrap JS & Custom Scripts)", ha='center', va='center', fontsize=7, color='#475569')

    save_fig(fig, 'fig6_modular_jsp_layout.png')

# Figure 7: JSON Analytics Pipeline with GSON
def make_fig7():
    fig, ax = plt.subplots(figsize=(9, 4.0), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    ax.text(5, 4.2, "RESTful JSON Serialization & Chart.js Visual Analytics Pipeline", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.85, "Bridging backend Java DTOs with frontend interactive charts via Google GSON", ha='center', va='center', fontsize=8.5, color='#64748b')

    pipeline = [
        ("AttendanceDAO\ngetDashboardStats()", "#dcfce7", "#16a34a", 1.2),
        ("DashboardStatsDTO\nJava Object Graph", "#dbeafe", "#2563eb", 3.7),
        ("Google GSON\ngson.toJson(stats)", "#fef3c7", "#d97706", 6.2),
        ("Chart.js in JSP\nnew Chart(ctx, config)", "#fce7f3", "#db2777", 8.7)
    ]
    for text, fc, ec, cx in pipeline:
        box = patches.FancyBboxPatch((cx-1.0, 1.6), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.15, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    for i in range(len(pipeline)-1):
        ax.annotate('', xy=(pipeline[i+1][3]-1.0, 2.15), xytext=(pipeline[i][3]+1.0, 2.15),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    ax.text(1.2, 0.8, "SQL Aggregations\nCOUNT, SUM, GROUP BY", ha='center', va='center', fontsize=7, color='#15803d')
    ax.text(3.7, 0.8, "Strongly-typed DTO\nList<SubjectStatDTO>", ha='center', va='center', fontsize=7, color='#1d4ed8')
    ax.text(6.2, 0.8, "Serialized JSON String\nBound to Request Scope", ha='center', va='center', fontsize=7, color='#b45309')
    ax.text(8.7, 0.8, "Interactive Canvas\nResponsive Donut & Bar", ha='center', va='center', fontsize=7, color='#be185d')

    save_fig(fig, 'fig7_json_analytics_pipeline.png')

# Figure 8: Password Hashing SHA-256
def make_fig8():
    fig, ax = plt.subplots(figsize=(9, 3.8), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.2)
    ax.axis('off')

    ax.text(5, 3.9, "Cryptographic Password Security via SHA-256 (PasswordUtil)", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.55, "One-way cryptographic hashing ensuring zero plaintext password persistence", ha='center', va='center', fontsize=8.5, color='#64748b')

    steps = [
        ("Plaintext Password\n\"admin123\"", "#fee2e2", "#ef4444", 1.3),
        ("MessageDigest\nSHA-256 Algorithm", "#fef3c7", "#f59e0b", 4.1),
        ("32-byte Binary\nDigest Array", "#e0e7ff", "#6366f1", 6.8),
        ("64-char Hex Hash\n\"240be518fab...\"", "#dcfce7", "#10b981", 8.8)
    ]
    for text, fc, ec, cx in steps:
        box = patches.FancyBboxPatch((cx-1.0, 1.4), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 1.95, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    for i in range(len(steps)-1):
        ax.annotate('', xy=(steps[i+1][3]-1.0, 1.95), xytext=(steps[i][3]+1.0, 1.95),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    ax.text(5, 0.5, "Database Verification: hashPassword(input).equalsIgnoreCase(storedHash)", 
            ha='center', va='center', fontsize=8, style='italic', color='#1e293b',
            bbox=dict(boxstyle='square,pad=0.3', facecolor='#f1f5f9', edgecolor='#cbd5e1'))

    save_fig(fig, 'fig8_sha256_security.png')

make_fig1()
make_fig2()
make_fig3()
make_fig4()
make_fig5()
make_fig6()
make_fig7()
make_fig8()
print("All 8 figures generated successfully!")
