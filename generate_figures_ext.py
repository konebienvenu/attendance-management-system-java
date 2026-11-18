import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches

os.makedirs('generated_figures', exist_ok=True)
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial', 'Helvetica']

def save_fig(fig, filename):
    filepath = os.path.join('generated_figures', filename)
    fig.savefig(filepath, dpi=200, bbox_inches='tight', facecolor='white')
    plt.close(fig)
    print(f"Saved {filepath}")

# Figure 9: Student CRUD & Validation
def make_fig9():
    fig, ax = plt.subplots(figsize=(9, 4.0), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    ax.text(5, 4.2, "Administrative StudentServlet: Action Dispatcher & Validation", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.85, "Multi-action CRUD controller managing Student entity with server-side validation", ha='center', va='center', fontsize=8.5, color='#64748b')

    steps = [
        ("HTTP Request\n(add/edit/delete)", "#f1f5f9", "#475569", 1.2),
        ("Server Validation\n(nulls, regex, semester)", "#fef3c7", "#d97706", 3.7),
        ("StudentDAO Execution\n(PreparedStatement)", "#dbeafe", "#2563eb", 6.2),
        ("Redirect / View\n(?msg=added / updated)", "#dcfce7", "#16a34a", 8.7)
    ]
    for text, fc, ec, cx in steps:
        box = patches.FancyBboxPatch((cx-1.0, 1.6), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.15, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    for i in range(len(steps)-1):
        ax.annotate('', xy=(steps[i+1][3]-1.0, 2.15), xytext=(steps[i][3]+1.0, 2.15),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    ax.text(1.2, 0.8, "POST /admin/students\naction=add / update", ha='center', va='center', fontsize=7, color='#475569')
    ax.text(3.7, 0.8, "Sanitize Strings\nInteger.parseInt()", ha='center', va='center', fontsize=7, color='#b45309')
    ax.text(6.2, 0.8, "INSERT / UPDATE\nUNIQUE enrollment_no", ha='center', va='center', fontsize=7, color='#1e40af')
    ax.text(8.7, 0.8, "sendRedirect()\nFlash Alert Display", ha='center', va='center', fontsize=7, color='#15803d')

    save_fig(fig, 'fig9_student_crud_validation.png')

# Figure 10: web.xml Deployment Descriptor
def make_fig10():
    fig, ax = plt.subplots(figsize=(9, 4.2), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.8)
    ax.axis('off')

    ax.text(5, 4.5, "Enterprise Web Deployment Descriptor (web.xml)", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 4.15, "Java EE 7 / Servlet 3.1 Specification configuration & session security flags", ha='center', va='center', fontsize=8.5, color='#64748b')

    configs = [
        ("<display-name>\nAttendance Management System", "#e0e7ff", "#4338ca", 1.8, 2.8),
        ("<welcome-file-list>\n<welcome-file>login</welcome-file>", "#ede9fe", "#7c3aed", 5.0, 2.8),
        ("<session-timeout>\n30 Minutes Inactivity", "#fef3c7", "#d97706", 8.2, 2.8),
        ("<cookie-config>\n<http-only>true</http-only>\n[Anti-XSS Session Theft]", "#fee2e2", "#dc2626", 3.4, 1.2),
        ("<tracking-mode>\nCOOKIE\n[Prevents URL Rewriting Leaks]", "#dcfce7", "#16a34a", 6.6, 1.2)
    ]

    for title, fc, ec, cx, cy in configs:
        box = patches.FancyBboxPatch((cx-1.4, cy-0.55), 2.8, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, cy, title, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    save_fig(fig, 'fig10_webxml_configuration.png')

# Figure 11: DBConnection Singleton
def make_fig11():
    fig, ax = plt.subplots(figsize=(9, 4.0), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    ax.text(5, 4.2, "Singleton JDBC Connection Manager & Resource Handling", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.85, "DBConnection class: externalized properties, static loading & auto-close utility", ha='center', va='center', fontsize=8.5, color='#64748b')

    components = [
        ("db.properties\n(Externalized Config)", "#fef3c7", "#d97706", 1.4),
        ("DBConnection\nStatic Block Initializer", "#dbeafe", "#2563eb", 4.2),
        ("DriverManager\ngetConnection()", "#dcfce7", "#16a34a", 6.8),
        ("AutoCloseable...\nDBConnection.close()", "#fee2e2", "#dc2626", 8.8)
    ]

    for text, fc, ec, cx in components:
        box = patches.FancyBboxPatch((cx-1.0, 1.6), 2.0, 1.1, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.15, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    for i in range(len(components)-1):
        ax.annotate('', xy=(components[i+1][3]-1.0, 2.15), xytext=(components[i][3]+1.0, 2.15),
                    arrowprops=dict(facecolor='#475569', edgecolor='#475569', arrowstyle='->', lw=1.2))

    ax.text(1.4, 0.8, "URL, User, Password\nMySQL Driver Class", ha='center', va='center', fontsize=7, color='#b45309')
    ax.text(4.2, 0.8, "Class.forName()\nExecuted Once", ha='center', va='center', fontsize=7, color='#1d4ed8')
    ax.text(6.8, 0.8, "Active Connection\nHanded to DAO", ha='center', va='center', fontsize=7, color='#15803d')
    ax.text(8.8, 0.8, "Closes PreparedStatement\n& Connection Safely", ha='center', va='center', fontsize=7, color='#991b1b')

    save_fig(fig, 'fig11_dbconnection_singleton.png')

# Figure 12: JSTL & EL Usage
def make_fig12():
    fig, ax = plt.subplots(figsize=(9, 4.0), dpi=200)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4.5)
    ax.axis('off')

    ax.text(5, 4.2, "JSTL 1.2 Tag Library & Expression Language (EL 3.0) Integration", ha='center', va='center', fontsize=12, fontweight='bold', color='#1e293b')
    ax.text(5, 3.85, "Decoupled MVC Presentation: Scriptlet-free dynamic templating in JSP views", ha='center', va='center', fontsize=8.5, color='#64748b')

    tags = [
        ("<c:forEach>\nIterates through Collections\n${students}, ${subjects}", "#dbeafe", "#1d4ed8", 1.8),
        ("<c:if>\nConditional Evaluation\ntest=\"${not empty msg}\"", "#fef3c7", "#b45309", 4.3),
        ("<c:choose> / <c:when>\nMulti-Branch Flow\nFlags Warning if < 75%", "#fee2e2", "#b91c1c", 6.8),
        ("${expression}\nDirect Scope Access\nRequest / Session / Page", "#dcfce7", "#15803d", 8.8)
    ]

    for text, fc, ec, cx in tags:
        box = patches.FancyBboxPatch((cx-0.95, 1.4), 1.9, 1.3, boxstyle="round,pad=0.1", fc=fc, ec=ec, lw=1.3)
        ax.add_patch(box)
        ax.text(cx, 2.05, text, ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e293b')

    ax.text(5, 0.5, "Replaces legacy scriptlets (<% ... %>) with standardized, maintainable XML syntax", 
            ha='center', va='center', fontsize=8, style='italic', color='#1e293b',
            bbox=dict(boxstyle='square,pad=0.3', facecolor='#f8fafc', edgecolor='#cbd5e1'))

    save_fig(fig, 'fig12_jstl_el_engine.png')

make_fig9()
make_fig10()
make_fig11()
make_fig12()
print("All 12 figures generated!")
