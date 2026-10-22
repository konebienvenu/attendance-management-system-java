package com.attendance.model;

import java.io.Serializable;

/**
 * Entity representing a faculty instructor.
 */
public class Teacher implements Serializable {
    private static final long serialVersionUID = 1L;

    private int teacherId;
    private int userId;
    private String teacherName;
    private String email;

    // Joined attribute for display convenience
    private String username;

    public Teacher() {
    }

    public Teacher(int teacherId, int userId, String teacherName, String email) {
        this.teacherId = teacherId;
        this.userId = userId;
        this.teacherName = teacherName;
        this.email = email;
    }

    public Teacher(int userId, String teacherName, String email) {
        this.userId = userId;
        this.teacherName = teacherName;
        this.email = email;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
