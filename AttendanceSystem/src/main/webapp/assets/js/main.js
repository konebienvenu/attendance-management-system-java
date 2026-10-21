/**
 * Attendance Management System - Main JS Helper
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Instant Table Search
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

    // 2. Mark All as Present
    const markAllPresentBtn = document.getElementById('btnMarkAllPresent');
    if (markAllPresentBtn) {
        markAllPresentBtn.addEventListener('click', function () {
            const presentRadios = document.querySelectorAll('input[type="radio"][value="PRESENT"]');
            presentRadios.forEach(r => {
                r.checked = true;
            });
        });
    }

    // 3. Mark All as Absent
    const markAllAbsentBtn = document.getElementById('btnMarkAllAbsent');
    if (markAllAbsentBtn) {
        markAllAbsentBtn.addEventListener('click', function () {
            const absentRadios = document.querySelectorAll('input[type="radio"][value="ABSENT"]');
            absentRadios.forEach(r => {
                r.checked = true;
            });
        });
    }

    // 4. Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });
});
