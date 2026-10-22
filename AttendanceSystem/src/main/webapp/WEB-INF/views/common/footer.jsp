<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Bootstrap 5.3 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Main Custom JS with Cache Buster -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js?v=<%= System.currentTimeMillis() %>"></script>

    <!-- Guaranteed Inline Horizontal Scroll & Drag Controllers -->
    <script>
    window.scrollTableLeft = function(btn) {
        const container = btn.closest('.card') || document;
        const tableResp = container.querySelector('.table-responsive');
        if (tableResp) {
            tableResp.scrollBy({ left: -320, behavior: 'smooth' });
        }
    };

    window.scrollTableRight = function(btn) {
        const container = btn.closest('.card') || document;
        const tableResp = container.querySelector('.table-responsive');
        if (tableResp) {
            tableResp.scrollBy({ left: 320, behavior: 'smooth' });
        }
    };

    document.addEventListener('DOMContentLoaded', function () {
        // 1. Sidebar Toggle
        const toggleBtn = document.getElementById('sidebarToggle');
        if (toggleBtn) {
            toggleBtn.onclick = function() {
                document.body.classList.toggle('sidebar-collapsed');
            };
        }

        // 2. Drag to scroll & mousewheel on all .table-responsive
        document.querySelectorAll('.table-responsive').forEach(function(slider) {
            let isDown = false;
            let startX, scrollLeft;

            slider.addEventListener('mousedown', function(e) {
                if (['INPUT', 'BUTTON', 'A', 'SELECT', 'I', 'LABEL'].includes(e.target.tagName)) return;
                isDown = true;
                slider.classList.add('table-dragging');
                startX = e.pageX - slider.offsetLeft;
                scrollLeft = slider.scrollLeft;
            });

            slider.addEventListener('mouseleave', function() {
                isDown = false;
                slider.classList.remove('table-dragging');
            });

            slider.addEventListener('mouseup', function() {
                isDown = false;
                slider.classList.remove('table-dragging');
            });

            slider.addEventListener('mousemove', function(e) {
                if (!isDown) return;
                e.preventDefault();
                const x = e.pageX - slider.offsetLeft;
                const walk = (x - startX) * 2;
                slider.scrollLeft = scrollLeft - walk;
            });

            slider.addEventListener('wheel', function(e) {
                if (slider.scrollWidth > slider.clientWidth && !e.shiftKey) {
                    if (Math.abs(e.deltaX) === 0 && e.deltaY !== 0) {
                        slider.scrollLeft += e.deltaY;
                    }
                }
            }, { passive: true });
        });
    });
    </script>
</body>
</html>
