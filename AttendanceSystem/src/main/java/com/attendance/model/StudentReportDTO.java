package com.attendance.model;

import java.io.Serializable;

/**
 * DTO pour les rapports de présence par étudiant et par matière.
 * Calcule le pourcentage et le statut (Alerte si < 75%).
 */
public class StudentReportDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private String enrollmentNo;
    private String studentName;
    private String email;
    private int totalClasses;
    private int attendedClasses;
    private double percentage;

    public StudentReportDTO() {
    }

    public StudentReportDTO(int studentId, String enrollmentNo, String studentName, String email, int totalClasses, int attendedClasses) {
        this.studentId = studentId;
        this.enrollmentNo = enrollmentNo;
        this.studentName = studentName;
        this.email = email;
        this.totalClasses = totalClasses;
        this.attendedClasses = attendedClasses;
        this.percentage = totalClasses > 0 ? ((double) attendedClasses / totalClasses) * 100.0 : 0.0;
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

    public int getTotalClasses() {
        return totalClasses;
    }

    public void setTotalClasses(int totalClasses) {
        this.totalClasses = totalClasses;
        recalculatePercentage();
    }

    public int getAttendedClasses() {
        return attendedClasses;
    }

    public void setAttendedClasses(int attendedClasses) {
        this.attendedClasses = attendedClasses;
        recalculatePercentage();
    }

    public double getPercentage() {
        return Math.round(percentage * 10.0) / 10.0;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }

    private void recalculatePercentage() {
        this.percentage = totalClasses > 0 ? ((double) attendedClasses / totalClasses) * 100.0 : 0.0;
    }

    public int getAbsentClasses() {
        return totalClasses - attendedClasses;
    }

    /**
     * Règle académique standard : alerte si présence < 75%
     */
    public boolean isWarning() {
        return totalClasses > 0 && percentage < 75.0;
    }
}
