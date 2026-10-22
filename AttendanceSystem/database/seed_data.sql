-- ====================================================================
-- AJT PROJECT (01CE0308) - SEED DATA (INITIAL DEMO DATASET)
-- ====================================================================

USE attendance_management_system;

-- 1. System Users (Passwords: admin123 for admin, teacher123 for teachers)
-- SHA-256 Hashes:
-- admin123   -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- teacher123 -> 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8

INSERT INTO system_user (user_id, username, password, role) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN'),
(2, 'kunal.khimani', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'TEACHER'),
(3, 'sweta.khatana', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'TEACHER'),
(4, 'reshma.sunil', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'TEACHER');

-- 2. Faculty / Teachers
INSERT INTO teacher (teacher_id, user_id, teacher_name, email) VALUES
(1, 2, 'Prof. Kunal Khimani', 'kunal.khimani@university.edu'),
(2, 3, 'Prof. Sweta Khatana', 'sweta.khatana@university.edu'),
(3, 4, 'Prof. Reshma Sunil', 'reshma.sunil@university.edu');

-- 3. Courses / Subjects
INSERT INTO subject (subject_id, subject_code, subject_name, teacher_id) VALUES
(1, '01CE0308', 'Advanced Java Technologies (AJT)', 1),
(2, '01CE0305', 'Database Management Systems (DBMS)', 2),
(3, '01CE0306', 'Software Engineering (SE)', 3),
(4, '01CE0307', 'Operating Systems (OS)', 1);

-- 4. Students
INSERT INTO student (student_id, enrollment_no, student_name, email, semester) VALUES
(1, '23CE001', 'Aarav Sharma', 'aarav.sharma@student.edu', 3),
(2, '23CE002', 'Diya Patel', 'diya.patel@student.edu', 3),
(3, '23CE003', 'Rohan Mehta', 'rohan.mehta@student.edu', 3),
(4, '23CE004', 'Ananya Iyer', 'ananya.iyer@student.edu', 3),
(5, '23CE005', 'Kabir Joshi', 'kabir.joshi@student.edu', 3),
(6, '23CE006', 'Sneha Verma', 'sneha.verma@student.edu', 3),
(7, '23CE007', 'Vikram Singh', 'vikram.singh@student.edu', 3),
(8, '23CE008', 'Pooja Nair', 'pooja.nair@student.edu', 3);

-- 5. Course Enrollments
-- Enroll 8 students in AJT (subject_id = 1)
INSERT INTO enrollment (enrollment_id, student_id, subject_id, enrollment_date, status) VALUES
(1, 1, 1, '2026-07-20', 'ACTIVE'),
(2, 2, 1, '2026-07-20', 'ACTIVE'),
(3, 3, 1, '2026-07-20', 'ACTIVE'),
(4, 4, 1, '2026-07-20', 'ACTIVE'),
(5, 5, 1, '2026-07-20', 'ACTIVE'),
(6, 6, 1, '2026-07-20', 'ACTIVE'),
(7, 7, 1, '2026-07-20', 'ACTIVE'),
(8, 8, 1, '2026-07-20', 'ACTIVE'),

-- Enroll students in DBMS (subject_id = 2)
(9, 1, 2, '2026-07-20', 'ACTIVE'),
(10, 2, 2, '2026-07-20', 'ACTIVE'),
(11, 3, 2, '2026-07-20', 'ACTIVE'),
(12, 4, 2, '2026-07-20', 'ACTIVE'),
(13, 5, 2, '2026-07-20', 'ACTIVE'),
(14, 6, 2, '2026-07-20', 'ACTIVE'),

-- Enroll students in SE (subject_id = 3)
(15, 1, 3, '2026-07-20', 'ACTIVE'),
(16, 2, 3, '2026-07-20', 'ACTIVE'),
(17, 3, 3, '2026-07-20', 'ACTIVE'),
(18, 7, 3, '2026-07-20', 'ACTIVE'),
(19, 8, 3, '2026-07-20', 'ACTIVE');

-- 6. Historical Attendance Records for AJT (subject_id = 1, marked_by = 1)
-- Session 1 : 2026-10-10
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(1, '2026-10-10', 'PRESENT', 1),
(2, '2026-10-10', 'PRESENT', 1),
(3, '2026-10-10', 'PRESENT', 1),
(4, '2026-10-10', 'PRESENT', 1),
(5, '2026-10-10', 'ABSENT',  1),
(6, '2026-10-10', 'PRESENT', 1),
(7, '2026-10-10', 'PRESENT', 1),
(8, '2026-10-10', 'ABSENT',  1);

-- Session 2 : 2026-10-14
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(1, '2026-10-14', 'PRESENT', 1),
(2, '2026-10-14', 'PRESENT', 1),
(3, '2026-10-14', 'ABSENT',  1),
(4, '2026-10-14', 'PRESENT', 1),
(5, '2026-10-14', 'PRESENT', 1),
(6, '2026-10-14', 'PRESENT', 1),
(7, '2026-10-14', 'PRESENT', 1),
(8, '2026-10-14', 'PRESENT', 1);

-- Session 3 : 2026-10-18
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(1, '2026-10-18', 'PRESENT', 1),
(2, '2026-10-18', 'PRESENT', 1),
(3, '2026-10-18', 'PRESENT', 1),
(4, '2026-10-18', 'ABSENT',  1),
(5, '2026-10-18', 'PRESENT', 1),
(6, '2026-10-18', 'PRESENT', 1),
(7, '2026-10-18', 'ABSENT',  1),
(8, '2026-10-18', 'PRESENT', 1);
