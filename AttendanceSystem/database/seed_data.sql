-- ====================================================================
-- AJT PROJECT (01CE0308) - SEED DATA (INITIAL DEMO DATASET)
-- Developed by: Kone Bienvenu, Avinash, Kabwe
-- CSE-CS Student Semester 3 at Marwadi University
-- Guided by: Prof. Sweta Kathana
-- ====================================================================

USE attendance_management_system;

-- Clear existing data safely to allow clean re-seeding
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE attendance;
TRUNCATE TABLE enrollment;
TRUNCATE TABLE subject;
TRUNCATE TABLE teacher;
TRUNCATE TABLE student;
TRUNCATE TABLE system_user;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. System Users (Passwords: admin123 for admin, teacher123 for teachers)
-- SHA-256 Hashes:
-- admin123   -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- teacher123 -> cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416

INSERT INTO system_user (user_id, username, password, role) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN'),
(2, 'sweta.kathana', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'TEACHER'),
(3, 'kunal.khimani', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'TEACHER'),
(4, 'reshma.sunil', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'TEACHER');

-- 2. Faculty / Teachers
INSERT INTO teacher (teacher_id, user_id, teacher_name, email) VALUES
(1, 2, 'Prof. Sweta Kathana', 'sweta.kathana@marwadiuniversity.ac.in'),
(2, 3, 'Prof. Kunal Khimani', 'kunal.khimani@marwadiuniversity.ac.in'),
(3, 4, 'Prof. Reshma Sunil', 'reshma.sunil@marwadiuniversity.ac.in');

-- 3. Courses / Subjects
INSERT INTO subject (subject_id, subject_code, subject_name, teacher_id) VALUES
(1, '01CE0308', 'Advanced Java Technologies (AJT)', 1),
(2, '01CE0305', 'Database Management Systems (DBMS)', 1),
(3, '01CE0306', 'Software Engineering (SE)', 3),
(4, '01CE0307', 'Operating Systems (OS)', 2);

-- 4. Students (CSE-CS Semester 3 at Marwadi University)
INSERT INTO student (student_id, enrollment_no, student_name, email, semester) VALUES
(1, '23CE001', 'Kone Bienvenu', 'kone.bienvenu@marwadiuniversity.ac.in', 3),
(2, '23CE002', 'Avinash', 'avinash@marwadiuniversity.ac.in', 3),
(3, '23CE003', 'Kabwe', 'kabwe@marwadiuniversity.ac.in', 3),
(4, '23CE004', 'Aarav Sharma', 'aarav.sharma@marwadiuniversity.ac.in', 3),
(5, '23CE005', 'Diya Patel', 'diya.patel@marwadiuniversity.ac.in', 3),
(6, '23CE006', 'Rohan Mehta', 'rohan.mehta@marwadiuniversity.ac.in', 3),
(7, '23CE007', 'Ananya Iyer', 'ananya.iyer@marwadiuniversity.ac.in', 3),
(8, '23CE008', 'Vikram Singh', 'vikram.singh@marwadiuniversity.ac.in', 3);

-- 5. Course Enrollments
-- Enroll all 8 students in AJT (subject_id = 1)
INSERT INTO enrollment (enrollment_id, student_id, subject_id, enrollment_date, status) VALUES
(1, 1, 1, '2026-07-20', 'ACTIVE'),
(2, 2, 1, '2026-07-20', 'ACTIVE'),
(3, 3, 1, '2026-07-20', 'ACTIVE'),
(4, 4, 1, '2026-07-20', 'ACTIVE'),
(5, 5, 1, '2026-07-20', 'ACTIVE'),
(6, 6, 1, '2026-07-20', 'ACTIVE'),
(7, 7, 1, '2026-07-20', 'ACTIVE'),
(8, 8, 1, '2026-07-20', 'ACTIVE'),

-- Enroll 6 students in DBMS (subject_id = 2)
(9,  1, 2, '2026-07-20', 'ACTIVE'),
(10, 2, 2, '2026-07-20', 'ACTIVE'),
(11, 3, 2, '2026-07-20', 'ACTIVE'),
(12, 4, 2, '2026-07-20', 'ACTIVE'),
(13, 5, 2, '2026-07-20', 'ACTIVE'),
(14, 6, 2, '2026-07-20', 'ACTIVE'),

-- Enroll 6 students in SE (subject_id = 3)
(15, 1, 3, '2026-07-20', 'ACTIVE'),
(16, 2, 3, '2026-07-20', 'ACTIVE'),
(17, 3, 3, '2026-07-20', 'ACTIVE'),
(18, 4, 3, '2026-07-20', 'ACTIVE'),
(19, 7, 3, '2026-07-20', 'ACTIVE'),
(20, 8, 3, '2026-07-20', 'ACTIVE'),

-- Enroll 6 students in OS (subject_id = 4)
(21, 1, 4, '2026-07-20', 'ACTIVE'),
(22, 2, 4, '2026-07-20', 'ACTIVE'),
(23, 3, 4, '2026-07-20', 'ACTIVE'),
(24, 5, 4, '2026-07-20', 'ACTIVE'),
(25, 6, 4, '2026-07-20', 'ACTIVE'),
(26, 8, 4, '2026-07-20', 'ACTIVE');

-- 6. Historical Attendance Records across ALL courses (for rich charts & 75% rule analytics)
-- AJT (subject_id = 1, marked_by = 1 - Prof. Sweta Kathana): 4 sessions
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(1, '2026-10-10', 'PRESENT', 1), (2, '2026-10-10', 'PRESENT', 1), (3, '2026-10-10', 'PRESENT', 1), (4, '2026-10-10', 'PRESENT', 1),
(5, '2026-10-10', 'PRESENT', 1), (6, '2026-10-10', 'ABSENT',  1), (7, '2026-10-10', 'PRESENT', 1), (8, '2026-10-10', 'ABSENT',  1),

(1, '2026-10-14', 'PRESENT', 1), (2, '2026-10-14', 'PRESENT', 1), (3, '2026-10-14', 'PRESENT', 1), (4, '2026-10-14', 'PRESENT', 1),
(5, '2026-10-14', 'PRESENT', 1), (6, '2026-10-14', 'PRESENT', 1), (7, '2026-10-14', 'ABSENT',  1), (8, '2026-10-14', 'ABSENT',  1),

(1, '2026-10-18', 'PRESENT', 1), (2, '2026-10-18', 'PRESENT', 1), (3, '2026-10-18', 'PRESENT', 1), (4, '2026-10-18', 'ABSENT',  1),
(5, '2026-10-18', 'PRESENT', 1), (6, '2026-10-18', 'ABSENT',  1), (7, '2026-10-18', 'PRESENT', 1), (8, '2026-10-18', 'PRESENT', 1),

(1, '2026-10-22', 'PRESENT', 1), (2, '2026-10-22', 'PRESENT', 1), (3, '2026-10-22', 'PRESENT', 1), (4, '2026-10-22', 'PRESENT', 1),
(5, '2026-10-22', 'PRESENT', 1), (6, '2026-10-22', 'PRESENT', 1), (7, '2026-10-22', 'PRESENT', 1), (8, '2026-10-22', 'ABSENT',  1);

-- DBMS (subject_id = 2, marked_by = 1 - Prof. Sweta Kathana): 3 sessions
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(9,  '2026-10-11', 'PRESENT', 1), (10, '2026-10-11', 'PRESENT', 1), (11, '2026-10-11', 'PRESENT', 1),
(12, '2026-10-11', 'PRESENT', 1), (13, '2026-10-11', 'ABSENT',  1), (14, '2026-10-11', 'PRESENT', 1),

(9,  '2026-10-15', 'PRESENT', 1), (10, '2026-10-15', 'PRESENT', 1), (11, '2026-10-15', 'PRESENT', 1),
(12, '2026-10-15', 'PRESENT', 1), (13, '2026-10-15', 'PRESENT', 1), (14, '2026-10-15', 'ABSENT',  1),

(9,  '2026-10-19', 'PRESENT', 1), (10, '2026-10-19', 'PRESENT', 1), (11, '2026-10-19', 'PRESENT', 1),
(12, '2026-10-19', 'ABSENT',  1), (13, '2026-10-19', 'PRESENT', 1), (14, '2026-10-19', 'ABSENT',  1);

-- SE (subject_id = 3, marked_by = 3 - Prof. Reshma Sunil): 3 sessions
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(15, '2026-10-12', 'PRESENT', 3), (16, '2026-10-12', 'PRESENT', 3), (17, '2026-10-12', 'PRESENT', 3),
(18, '2026-10-12', 'PRESENT', 3), (19, '2026-10-12', 'PRESENT', 3), (20, '2026-10-12', 'ABSENT',  3),

(15, '2026-10-16', 'PRESENT', 3), (16, '2026-10-16', 'PRESENT', 3), (17, '2026-10-16', 'PRESENT', 3),
(18, '2026-10-16', 'ABSENT',  3), (19, '2026-10-16', 'PRESENT', 3), (20, '2026-10-16', 'PRESENT', 3),

(15, '2026-10-20', 'PRESENT', 3), (16, '2026-10-20', 'PRESENT', 3), (17, '2026-10-20', 'PRESENT', 3),
(18, '2026-10-20', 'PRESENT', 3), (19, '2026-10-20', 'ABSENT',  3), (20, '2026-10-20', 'ABSENT',  3);

-- OS (subject_id = 4, marked_by = 2 - Prof. Kunal Khimani): 3 sessions
INSERT INTO attendance (enrollment_id, attendance_date, status, marked_by) VALUES
(21, '2026-10-13', 'PRESENT', 2), (22, '2026-10-13', 'PRESENT', 2), (23, '2026-10-13', 'PRESENT', 2),
(24, '2026-10-13', 'PRESENT', 2), (25, '2026-10-13', 'ABSENT',  2), (26, '2026-10-13', 'PRESENT', 2),

(21, '2026-10-17', 'PRESENT', 2), (22, '2026-10-17', 'PRESENT', 2), (23, '2026-10-17', 'PRESENT', 2),
(24, '2026-10-17', 'PRESENT', 2), (25, '2026-10-17', 'PRESENT', 2), (26, '2026-10-17', 'ABSENT',  2),

(21, '2026-10-21', 'PRESENT', 2), (22, '2026-10-21', 'PRESENT', 2), (23, '2026-10-21', 'PRESENT', 2),
(24, '2026-10-21', 'ABSENT',  2), (25, '2026-10-21', 'ABSENT',  2), (26, '2026-10-21', 'PRESENT', 2);
