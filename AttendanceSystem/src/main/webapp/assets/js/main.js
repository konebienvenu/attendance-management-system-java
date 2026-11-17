/**
 * Attendance Management System - Main JS Helper
 */

// Global Horizontal Scroll Helpers for table arrow buttons
window.scrollTableLeft = function(btn) {
    const container = btn.closest('.card') || document;
    const tableResp = container.querySelector('.table-responsive');
    if (tableResp) {
        tableResp.scrollBy({ left: -280, behavior: 'smooth' });
    }
};

window.scrollTableRight = function(btn) {
    const container = btn.closest('.card') || document;
    const tableResp = container.querySelector('.table-responsive');
    if (tableResp) {
        tableResp.scrollBy({ left: 280, behavior: 'smooth' });
    }
};

// Global Password Visibility Toggle Helper
window.togglePasswordVisibility = function(inputId, iconId) {
    const pwdInput = document.getElementById(inputId);
    const icon = document.getElementById(iconId);
    if (!pwdInput) return;
    if (pwdInput.type === 'password') {
        pwdInput.type = 'text';
        if (icon) {
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        }
    } else {
        pwdInput.type = 'password';
        if (icon) {
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
};

document.addEventListener('DOMContentLoaded', function () {
    // 0. Inject Academic Attribution Footer on Dashboard / Internal Pages
    const mainWrapper = document.querySelector('.main-wrapper');
    if (mainWrapper && !mainWrapper.querySelector('.app-footer')) {
        const footer = document.createElement('footer');
        footer.className = 'app-footer mt-auto py-3 px-4 bg-white border-top d-flex flex-column flex-md-row justify-content-between align-items-center gap-2 small text-muted';
        footer.innerHTML = '<div>&copy; 2026 &mdash; Developed by <strong class="text-dark">Kone Bienvenu, Avinash, Kabwe</strong> &bull; <span class="text-primary fw-semibold">CSE-CS student Semester 3 at Marwadi University</span></div>' +
                           '<div><i class="fa-solid fa-chalkboard-user text-primary me-1"></i>Guided by <strong class="text-dark">Prof. Sweta Kathana</strong> (AJT - 01CE0308)</div>';
        mainWrapper.appendChild(footer);
    }

    // 1. Sidebar Toggle Button
    const sidebarToggleBtn = document.getElementById('sidebarToggle');
    if (sidebarToggleBtn) {
        // Restore saved preference
        if (localStorage.getItem('ams_sidebar_collapsed') === 'true') {
            document.body.classList.add('sidebar-collapsed');
        }

        sidebarToggleBtn.addEventListener('click', function () {
            document.body.classList.toggle('sidebar-collapsed');
            const isCollapsed = document.body.classList.contains('sidebar-collapsed');
            localStorage.setItem('ams_sidebar_collapsed', isCollapsed);
        });
    }

    // 2. Interactive Drag-to-Scroll & Mousewheel on all .table-responsive
    const responsiveTables = document.querySelectorAll('.table-responsive');
    responsiveTables.forEach(function (slider) {
        let isDown = false;
        let startX;
        let scrollLeft;

        slider.addEventListener('mousedown', function (e) {
            // Don't hijack clicks on interactive elements (inputs, buttons, modals, links, forms)
            if (e.target.closest('button, a, input, select, textarea, label, form, .modal')) return;
            isDown = true;
            slider.classList.add('table-dragging');
            startX = e.pageX - slider.offsetLeft;
            scrollLeft = slider.scrollLeft;
        });

        slider.addEventListener('mouseleave', function () {
            isDown = false;
            slider.classList.remove('table-dragging');
        });

        slider.addEventListener('mouseup', function () {
            isDown = false;
            slider.classList.remove('table-dragging');
        });

        slider.addEventListener('mousemove', function (e) {
            if (!isDown) return;
            e.preventDefault();
            const x = e.pageX - slider.offsetLeft;
            const walk = (x - startX) * 1.5;
            slider.scrollLeft = scrollLeft - walk;
        });

        // Mousewheel horizontal scrolling if table is wider than container
        slider.addEventListener('wheel', function (e) {
            if (slider.scrollWidth > slider.clientWidth) {
                if (Math.abs(e.deltaX) === 0 && e.deltaY !== 0) {
                    if (!e.shiftKey) {
                        // Allow natural shift-wheel, but if user uses regular wheel over overflowing table:
                        // Scroll horizontally smoothly
                        slider.scrollBy({ left: e.deltaY, behavior: 'auto' });
                    }
                }
            }
        }, { passive: true });
    });

    // 3. Instant Table Search
    const searchInputs = document.querySelectorAll('.table-search-input');
    searchInputs.forEach(input => {
        input.addEventListener('keyup', function () {
            const query = this.value.toLowerCase();
            const targetTableId = this.getAttribute('data-table');
            const table = document.getElementById(targetTableId);
            if (!table) return;

            const rows = table.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    });

    // 4. Mark All as Present
    const markAllPresentBtn = document.getElementById('btnMarkAllPresent');
    if (markAllPresentBtn) {
        markAllPresentBtn.addEventListener('click', function () {
            const presentRadios = document.querySelectorAll('input[type="radio"][value="PRESENT"]');
            presentRadios.forEach(r => {
                r.checked = true;
            });
        });
    }

    // 5. Mark All as Absent
    const markAllAbsentBtn = document.getElementById('btnMarkAllAbsent');
    if (markAllAbsentBtn) {
        markAllAbsentBtn.addEventListener('click', function () {
            const absentRadios = document.querySelectorAll('input[type="radio"][value="ABSENT"]');
            absentRadios.forEach(r => {
                r.checked = true;
            });
        });
    }

    // 6. Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });
});
