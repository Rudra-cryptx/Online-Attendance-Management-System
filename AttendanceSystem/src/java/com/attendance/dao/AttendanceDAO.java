package com.attendance.dao;

import com.attendance.util.DBConnection;
import java.sql.*;

public class AttendanceDAO {
    
    public int getTotalClasses() {
    int total = 0;
    // Count distinct class sessions (date + lecture combinations)
    String sql = "SELECT COUNT(DISTINCT CONCAT(attendance_date, '-', COALESCE(lecture_number, 0))) as total FROM attendance";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        if (rs.next()) {
            total = rs.getInt("total");
            System.out.println("DEBUG getTotalClasses - Total: " + total);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return total;
}
    
    // NEW METHOD: Mark lecture attendance with subject details
    public boolean markLectureAttendance(int studentId, int subjectId, int teacherId, 
                                       String date, int lectureNumber, String status, 
                                       int semester, String academicYear) {
        String sql = "INSERT INTO attendance (student_id, subject_id, teacher_id, attendance_date, lecture_number, status, semester, academic_year) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, subjectId);
            stmt.setInt(3, teacherId);
            stmt.setString(4, date);
            stmt.setInt(5, lectureNumber);
            stmt.setString(6, status);
            stmt.setInt(7, semester);
            stmt.setString(8, academicYear);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // NEW METHOD: Check if attendance already marked for a lecture
    public boolean isAttendanceAlreadyMarked(int studentId, String date) {
    String sql = "SELECT COUNT(*) as count FROM attendance WHERE student_id = ? AND attendance_date = ? AND lecture_number = 1";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, studentId);
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
    public boolean markAttendance(int studentId, String date, String status) {
    String sql = "INSERT INTO attendance (student_id, attendance_date, status, lecture_number, semester, academic_year) VALUES (?, ?, ?, 1, 3, '2024-2025')";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, studentId);
        stmt.setString(2, date);
        stmt.setString(3, status);
        
        System.out.println("Marking attendance - Student: " + studentId + ", Date: " + date + ", Status: " + status);
        int result = stmt.executeUpdate();
        System.out.println("Rows affected: " + result);
        
        return result > 0;
    } catch (SQLException e) {
        System.err.println("SQL Error in markAttendance: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}
    
}
