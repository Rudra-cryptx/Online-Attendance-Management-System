package com.attendance.controller;

import com.attendance.dao.AttendanceDAO;
import com.attendance.dao.TeacherDAO;
import com.attendance.dao.StudentDAO;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.Enumeration;

@WebServlet("/markLectureAttendance")
public class MarkLectureAttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String timetableId = request.getParameter("timetable_id");
            String subjectId = request.getParameter("subject_id");
            String lectureNumber = request.getParameter("lecture_number");
            String teacherId = request.getParameter("teacher_id");
            String attendanceDate = request.getParameter("attendance_date");
            
            System.out.println("MarkLectureAttendanceServlet - Date: " + attendanceDate);
            
            // Validate parameters
            if (timetableId == null || subjectId == null || lectureNumber == null || teacherId == null || attendanceDate == null) {
                response.sendRedirect("teacherDashboard.jsp?error=Missing required parameters");
                return;
            }
            
            AttendanceDAO attendanceDAO = new AttendanceDAO();
            TeacherDAO teacherDAO = new TeacherDAO();
            StudentDAO studentDAO = new StudentDAO();
            
            int teacherDbId = teacherDAO.getTeacherIdByUserId(Integer.parseInt(teacherId));
            boolean allSuccess = true;
            int markedCount = 0;
            
            // Process all attendance parameters
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("attendance_")) {
                    String studentIdStr = paramName.substring("attendance_".length());
                    String status = request.getParameter(paramName);
                    
                    try {
                        int studentId = Integer.parseInt(studentIdStr);
                        int subjectIdInt = Integer.parseInt(subjectId);
                        int lectureNumberInt = Integer.parseInt(lectureNumber);
                        
                        boolean success = attendanceDAO.markLectureAttendance(
                            studentId,
                            subjectIdInt,
                            teacherDbId,
                            attendanceDate,  // Use the selected date instead of current date
                            lectureNumberInt,
                            status,
                            3, // current semester
                            "2024-2025" // academic year
                        );
                        
                        if (success) {
                            markedCount++;
                        } else {
                            allSuccess = false;
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid number format for student ID: " + studentIdStr);
                        allSuccess = false;
                    }
                }
            }
            
            if (allSuccess && markedCount > 0) {
                response.sendRedirect("teacherDashboard.jsp?selected_date=" + attendanceDate + "&success=Attendance marked successfully for " + markedCount + " students on " + attendanceDate);
            } else if (markedCount > 0) {
                response.sendRedirect("teacherDashboard.jsp?selected_date=" + attendanceDate + "&error=Some attendance records failed to save. " + markedCount + " records saved.");
            } else {
                response.sendRedirect("teacherDashboard.jsp?selected_date=" + attendanceDate + "&error=No attendance records were saved. Please check the form data.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("teacherDashboard.jsp?error=Server error: " + e.getMessage());
        }
    }
}