package com.attendance.dao;

import java.util.Date;
import java.util.Calendar;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import com.attendance.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.text.SimpleDateFormat;

public class TeacherDAO {

    public int getTeacherIdByUserId(int userId) {
        int teacherId = 0;
        String sql = "SELECT id FROM teachers WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                teacherId = rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teacherId;
    }

    public List<Map<String, Object>> getTodaysPendingLectures(int userId) {
        List<Map<String, Object>> lectures = new ArrayList<>();
        String sql = "SELECT t.id as timetable_id, s.subject_code, s.subject_name, "
                + "t.lecture_number, t.start_time, t.end_time, s.id as subject_id, "
                + "te.id as teacher_db_id "
                + "FROM timetable t "
                + "JOIN subjects s ON t.subject_id = s.id "
                + "JOIN teachers te ON t.teacher_id = te.id "
                + "WHERE te.user_id = ? AND t.day_of_week = ? "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 FROM attendance a "
                + "    WHERE a.subject_id = t.subject_id "
                + "    AND a.lecture_number = t.lecture_number "
                + "    AND a.attendance_date = CURDATE() "
                + ") "
                + "ORDER BY t.lecture_number";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            Calendar cal = Calendar.getInstance();
            String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
            String today = days[cal.get(Calendar.DAY_OF_WEEK) - 1];

            stmt.setInt(1, userId);
            stmt.setString(2, today);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> lecture = new HashMap<>();
                lecture.put("timetable_id", rs.getInt("timetable_id"));
                lecture.put("subject_code", rs.getString("subject_code"));
                lecture.put("subject_name", rs.getString("subject_name"));
                lecture.put("lecture_number", rs.getInt("lecture_number"));
                lecture.put("start_time", rs.getTime("start_time"));
                lecture.put("end_time", rs.getTime("end_time"));
                lecture.put("subject_id", rs.getInt("subject_id"));
                lecture.put("teacher_db_id", rs.getInt("teacher_db_id"));
                lectures.add(lecture);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lectures;
    }

    public String getTeacherSubject(int userId) {
        String subject = "";
        String sql = "SELECT s.subject_name FROM subjects s "
                + "JOIN teacher_subjects ts ON s.id = ts.subject_id "
                + "JOIN teachers t ON ts.teacher_id = t.id "
                + "WHERE t.user_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                subject = rs.getString("subject_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subject;
    }

    public boolean isLectureAttendanceMarked(int timetableId) {
        String sql = "SELECT COUNT(*) as count FROM attendance a "
                + "JOIN timetable t ON a.subject_id = t.subject_id AND a.lecture_number = t.lecture_number "
                + "WHERE t.id = ? AND a.attendance_date = CURDATE()";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, timetableId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // NEW METHOD: Get pending lectures for any specific date
    public List<Map<String, Object>> getPendingLecturesForDate(int userId, String selectedDate) {
        List<Map<String, Object>> lectures = new ArrayList<>();

        try {
            // Get day of week for the selected date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date = sdf.parse(selectedDate);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);

            String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
            String dayOfWeek = days[cal.get(Calendar.DAY_OF_WEEK) - 1];

            String sql = "SELECT t.id as timetable_id, s.subject_code, s.subject_name, "
                    + "t.lecture_number, t.start_time, t.end_time, s.id as subject_id, "
                    + "te.id as teacher_db_id "
                    + "FROM timetable t "
                    + "JOIN subjects s ON t.subject_id = s.id "
                    + "JOIN teachers te ON t.teacher_id = te.id "
                    + "WHERE te.user_id = ? AND t.day_of_week = ? "
                    + "AND NOT EXISTS ( "
                    + "    SELECT 1 FROM attendance a "
                    + "    WHERE a.subject_id = t.subject_id "
                    + "    AND a.lecture_number = t.lecture_number "
                    + "    AND a.attendance_date = ? "
                    + "    AND a.teacher_id = te.id "
                    + ") "
                    + "ORDER BY t.lecture_number";

            try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, userId);
                stmt.setString(2, dayOfWeek);
                stmt.setString(3, selectedDate);

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> lecture = new HashMap<>();
                    lecture.put("timetable_id", rs.getInt("timetable_id"));
                    lecture.put("subject_code", rs.getString("subject_code"));
                    lecture.put("subject_name", rs.getString("subject_name"));
                    lecture.put("lecture_number", rs.getInt("lecture_number"));
                    lecture.put("start_time", rs.getTime("start_time"));
                    lecture.put("end_time", rs.getTime("end_time"));
                    lecture.put("subject_id", rs.getInt("subject_id"));
                    lecture.put("teacher_db_id", rs.getInt("teacher_db_id"));
                    lecture.put("selected_date", selectedDate);
                    lectures.add(lecture);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lectures;
    }

    // NEW METHOD: Validate if date is not in future and within semester
    public boolean isValidAttendanceDate(String date) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date inputDate = sdf.parse(date);
            Date today = new Date();

            // Check if date is not in future
            if (inputDate.after(today)) {
                return false;
            }

            // Check if date is within semester (July 1, 2024 to Dec 22, 2024)
            Date semesterStart = sdf.parse("2025-07-01");
            Date semesterEnd = sdf.parse("2025-12-22");

            return !inputDate.before(semesterStart) && !inputDate.after(semesterEnd);

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW METHOD: Check if attendance already marked for specific date and lecture
    public boolean isAttendanceMarkedForDate(int timetableId, String date) {
        String sql = "SELECT COUNT(*) as count FROM attendance a "
                + "JOIN timetable t ON a.subject_id = t.subject_id AND a.lecture_number = t.lecture_number "
                + "WHERE t.id = ? AND a.attendance_date = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, timetableId);
            stmt.setString(2, date);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Map<String, Object>> getAttendanceReportByTeacher(int teacherId) {
    List<Map<String, Object>> report = new ArrayList<>();
    String sql = "SELECT s.roll_number, u.name, sub.subject_name, " +
                 "COUNT(a.id) AS total_classes, " +
                 "SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_classes " +
                 "FROM attendance a " +
                 "JOIN students s ON a.student_id = s.id " +
                 "JOIN users u ON s.user_id = u.id " +
                 "JOIN subjects sub ON a.subject_id = sub.id " +
                 "WHERE a.teacher_id = ? " +
                 "GROUP BY s.id, sub.subject_name, u.name, s.roll_number " +
                 "ORDER BY sub.subject_name, s.roll_number";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, teacherId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("roll_number", rs.getString("roll_number"));
            row.put("name", rs.getString("name"));
            row.put("subject_name", rs.getString("subject_name"));
            row.put("total_classes", rs.getInt("total_classes"));
            row.put("present_classes", rs.getInt("present_classes"));
            report.add(row);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return report;
}

}
