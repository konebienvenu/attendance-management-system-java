package com.attendance.model;

import java.io.Serializable;

/**
 * Entity representing an academic subject or course.
 */
public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int teacherId;

    // Joined attribute for displaying assigned faculty name
    private String teacherName;

    public Subject() {
    }

    public Subject(int subjectId, String subjectCode, String subjectName, int teacherId) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.teacherId = teacherId;
    }

    public Subject(String subjectCode, String subjectName, int teacherId) {
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.teacherId = teacherId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
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

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
}
