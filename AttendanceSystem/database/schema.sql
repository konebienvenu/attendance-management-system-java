-- ====================================================================
-- AJT PROJECT (01CE0308) - DATABASE SCHEMA
-- ENTERPRISE ATTENDANCE MANAGEMENT SYSTEM
-- ====================================================================

DROP DATABASE IF EXISTS attendance_management_system;
CREATE DATABASE attendance_management_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE attendance_management_system;

-- 1. Table system_user: Authentication and role-based access
CREATE TABLE system_user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'TEACHER') NOT NULL
) ENGINE=InnoDB;

-- 2. Table student: Student directory and enrollment records
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_no VARCHAR(20) NOT NULL UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    semester INT NOT NULL
) ENGINE=InnoDB;

-- 3. Table teacher: Faculty information mapped to user account
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    teacher_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    FOREIGN KEY (user_id) REFERENCES system_user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Table subject: Academic courses mapped to assigned faculty
CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_code VARCHAR(20) NOT NULL UNIQUE,
    subject_name VARCHAR(100) NOT NULL,
    teacher_id INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Table enrollment: Connects students with subjects (Many-to-Many Relationship)
CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    UNIQUE KEY uq_student_subject (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Table attendance: Daily attendance logs per enrollment
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT') NOT NULL,
    marked_by INT NOT NULL,
    UNIQUE KEY uq_enrollment_date (enrollment_id, attendance_date),
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES teacher(teacher_id)
) ENGINE=InnoDB;
