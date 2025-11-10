package com.attendance.dao;

import com.attendance.util.DBConnection;
import java.sql.*;
import java.util.*;

public class StudentDAO {
    
    public List<Map<String, Object>> getAllStudentsWithAttendance() {
    List<Map<String, Object>> students = new ArrayList<>();
    String sql = "SELECT s.id as student_id, s.roll_number, u.name, " +
                "COUNT(DISTINCT CASE WHEN a.attendance_date IS NOT NULL THEN CONCAT(a.attendance_date, '-', COALESCE(a.lecture_number, 1)) END) as total_classes, " +
                "SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as present_classes " +
                "FROM students s " +
                "JOIN users u ON s.user_id = u.id " +
                "LEFT JOIN attendance a ON s.id = a.student_id " +
                "GROUP BY s.id, s.roll_number, u.name";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            Map<String, Object> student = new HashMap<>();
            student.put("student_id", rs.getInt("student_id"));
            student.put("roll_number", rs.getString("roll_number"));
            student.put("name", rs.getString("name"));
            student.put("total_classes", rs.getInt("total_classes"));
            student.put("present_classes", rs.getInt("present_classes"));
            students.add(student);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return students;
}
    
    public List<Map<String, Object>> getAllStudents() {
        List<Map<String, Object>> students = new ArrayList<>();
        String sql = "SELECT s.id as student_id, s.roll_number, u.name " +
                    "FROM students s " +
                    "JOIN users u ON s.user_id = u.id " +
                    "WHERE u.role = 'student'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("student_id", rs.getInt("student_id"));
                student.put("roll_number", rs.getString("roll_number"));
                student.put("name", rs.getString("name"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }
    
    // ADD THIS METHOD - This was missing!
    public int getStudentIdByUserId(int userId) {
        int studentId = 0;
        String sql = "SELECT id FROM students WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                studentId = rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return studentId;
    }
    public Map<String, Object> getNextClassForStudent(int studentId) {
    Map<String, Object> nextClass = new HashMap<>();
    String sql = """
        SELECT s.subject_name, s.subject_code, t.start_time, t.end_time
        FROM timetable t
        JOIN subjects s ON t.subject_id = s.id
        WHERE t.day_of_week = DAYNAME(CURDATE())
          AND TIME(NOW()) < t.end_time
        ORDER BY t.start_time ASC
        LIMIT 1
    """;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            nextClass.put("subject_name", rs.getString("subject_name"));
            nextClass.put("subject_code", rs.getString("subject_code"));
            nextClass.put("start_time", rs.getTime("start_time"));
            nextClass.put("end_time", rs.getTime("end_time"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nextClass;
}

    
    // ADD THIS METHOD TOO - For student attendance
    public int getPresentClasses(int studentId) {
    int present = 0;
    // Count all present records for this student
    String sql = "SELECT COUNT(*) as present FROM attendance WHERE student_id = ? AND status = 'Present'";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, studentId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            present = rs.getInt("present");
            System.out.println("DEBUG getPresentClasses - Student: " + studentId + ", Present: " + present);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return present;

}
}