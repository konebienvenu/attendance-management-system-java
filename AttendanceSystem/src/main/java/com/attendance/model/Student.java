package com.attendance.model;

import java.io.Serializable;

/**
 * Entity representing a student.
 */
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private String enrollmentNo;
    private String studentName;
    private String email;
    private int semester;

    public Student() {
    }

    public Student(int studentId, String enrollmentNo, String studentName, String email, int semester) {
        this.studentId = studentId;
        this.enrollmentNo = enrollmentNo;
        this.studentName = studentName;
        this.email = email;
        this.semester = semester;
    }

    public Student(String enrollmentNo, String studentName, String email, int semester) {
        this.enrollmentNo = enrollmentNo;
        this.studentName = studentName;
        this.email = email;
        this.semester = semester;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getEnrollmentNo() {
        return enrollmentNo;
    }

    public void setEnrollmentNo(String enrollmentNo) {
        this.enrollmentNo = enrollmentNo;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }
}
