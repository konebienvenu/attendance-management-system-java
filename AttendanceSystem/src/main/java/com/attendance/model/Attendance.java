package com.attendance.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Entity representing an individual student attendance record.
 */
public class Attendance implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attendanceId;
    private int enrollmentId;
    private Date attendanceDate;
    private String status; // 'PRESENT', 'ABSENT'
    private int markedBy;

    // Joined attributes for display convenience
    private String studentName;
    private String enrollmentNo;
    private String subjectName;
    private String teacherName;

    public Attendance() {
    }

    public Attendance(int attendanceId, int enrollmentId, Date attendanceDate, String status, int markedBy) {
        this.attendanceId = attendanceId;
        this.enrollmentId = enrollmentId;
        this.attendanceDate = attendanceDate;
        this.status = status;
        this.markedBy = markedBy;
    }

    public Attendance(int enrollmentId, Date attendanceDate, String status, int markedBy) {
        this.enrollmentId = enrollmentId;
        this.attendanceDate = attendanceDate;
        this.status = status;
        this.markedBy = markedBy;
    }

    public int getAttendanceId() {
        return attendanceId;
    }

    public void setAttendanceId(int attendanceId) {
        this.attendanceId = attendanceId;
    }

    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getMarkedBy() {
        return markedBy;
    }

    public void setMarkedBy(int markedBy) {
        this.markedBy = markedBy;
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

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
}
