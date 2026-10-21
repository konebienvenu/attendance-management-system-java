package com.attendance.model;

import java.io.Serializable;

/**
 * DTO utilisé pour afficher la liste des étudiants lors de la saisie des présences.
 */
public class AttendanceSheetRowDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int enrollmentId;
    private int studentId;
    private String enrollmentNo;
    private String studentName;
    private String email;
    private String currentStatus; // "PRESENT", "ABSENT", ou null (non marqué)

    public AttendanceSheetRowDTO() {
    }

    public AttendanceSheetRowDTO(int enrollmentId, int studentId, String enrollmentNo, String studentName, String email, String currentStatus) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.enrollmentNo = enrollmentNo;
        this.studentName = studentName;
        this.email = email;
        this.currentStatus = currentStatus;
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

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public boolean isPresent() {
        return "PRESENT".equalsIgnoreCase(currentStatus);
    }

    public boolean isAbsent() {
        return "ABSENT".equalsIgnoreCase(currentStatus);
    }
}
