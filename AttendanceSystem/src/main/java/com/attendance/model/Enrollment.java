package com.attendance.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Entity representing student enrollment in a course module.
 */
public class Enrollment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int enrollmentId;
    private int studentId;
    private int subjectId;
    private Date enrollmentDate;
    private String status; // 'ACTIVE', 'INACTIVE'

    // Joined attributes for display convenience
    private String studentName;
    private String enrollmentNo;
    private String subjectCode;
    private String subjectName;

    public Enrollment() {
    }

    public Enrollment(int enrollmentId, int studentId, int subjectId, Date enrollmentDate, String status) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.enrollmentDate = enrollmentDate;
        this.status = status;
    }

    public Enrollment(int studentId, int subjectId, Date enrollmentDate, String status) {
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.enrollmentDate = enrollmentDate;
        this.status = status;
    }

    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public Date getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(Date enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getEnrollmentNo() {
        return enrollmentNo;
    }

    public void setEnrollmentNo(String enrollmentNo) {
        this.enrollmentNo = enrollmentNo;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
}
