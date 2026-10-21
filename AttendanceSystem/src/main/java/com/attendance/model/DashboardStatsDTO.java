package com.attendance.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO agrégeant les statistiques globales pour les tableaux de bord.
 */
public class DashboardStatsDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalStudents;
    private int totalTeachers;
    private int totalSubjects;
    private int totalEnrollments;
    private int totalPresentRecords;
    private int totalAbsentRecords;
    private double overallAttendanceRate;

    // Pour graphiques par matière
    private List<SubjectStat> subjectStats = new ArrayList<>();

    public static class SubjectStat implements Serializable {
        private String subjectName;
        private int presentCount;
        private int absentCount;

        public SubjectStat(String subjectName, int presentCount, int absentCount) {
            this.subjectName = subjectName;
            this.presentCount = presentCount;
            this.absentCount = absentCount;
        }

        public String getSubjectName() {
            return subjectName;
        }

        public int getPresentCount() {
            return presentCount;
        }

        public int getAbsentCount() {
            return absentCount;
        }

        public double getRate() {
            int total = presentCount + absentCount;
            return total > 0 ? Math.round(((double) presentCount / total) * 1000.0) / 10.0 : 0.0;
        }
    }

    public DashboardStatsDTO() {
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalTeachers() {
        return totalTeachers;
    }

    public void setTotalTeachers(int totalTeachers) {
        this.totalTeachers = totalTeachers;
    }

    public int getTotalSubjects() {
        return totalSubjects;
    }

    public void setTotalSubjects(int totalSubjects) {
        this.totalSubjects = totalSubjects;
    }

    public int getTotalEnrollments() {
        return totalEnrollments;
    }

    public void setTotalEnrollments(int totalEnrollments) {
        this.totalEnrollments = totalEnrollments;
    }

    public int getTotalPresentRecords() {
        return totalPresentRecords;
    }

    public void setTotalPresentRecords(int totalPresentRecords) {
        this.totalPresentRecords = totalPresentRecords;
        recalculateRate();
    }

    public int getTotalAbsentRecords() {
        return totalAbsentRecords;
    }

    public void setTotalAbsentRecords(int totalAbsentRecords) {
        this.totalAbsentRecords = totalAbsentRecords;
        recalculateRate();
    }

    public double getOverallAttendanceRate() {
        return overallAttendanceRate;
    }

    public void setOverallAttendanceRate(double overallAttendanceRate) {
        this.overallAttendanceRate = overallAttendanceRate;
    }

    private void recalculateRate() {
        int total = totalPresentRecords + totalAbsentRecords;
        this.overallAttendanceRate = total > 0 ? Math.round(((double) totalPresentRecords / total) * 1000.0) / 10.0 : 0.0;
    }

    public List<SubjectStat> getSubjectStats() {
        return subjectStats;
    }

    public void setSubjectStats(List<SubjectStat> subjectStats) {
        this.subjectStats = subjectStats;
    }

    public void addSubjectStat(String subjectName, int presentCount, int absentCount) {
        this.subjectStats.add(new SubjectStat(subjectName, presentCount, absentCount));
    }
}
