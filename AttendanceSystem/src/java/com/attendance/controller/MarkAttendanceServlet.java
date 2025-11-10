package com.attendance.controller;

import com.attendance.dao.AttendanceDAO;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/markAttendance")
public class MarkAttendanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String action = request.getParameter("action");
            System.out.println("MarkAttendanceServlet - Action received: " + action);
            
            if (action != null && action.contains("_")) {
                String[] parts = action.split("_");
                String status = parts[0];
                int studentId = Integer.parseInt(parts[1]);
                
                System.out.println("Parsed - Status: " + status + ", Student ID: " + studentId);
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String currentDate = sdf.format(new Date());
                
                AttendanceDAO attendanceDAO = new AttendanceDAO();
                
                // Check if attendance already marked for today
                if (attendanceDAO.isAttendanceAlreadyMarked(studentId, currentDate)) {
                    response.sendRedirect("adminDashboard.jsp?error=Attendance already marked for this student today");
                    return;
                }
                
                boolean success = attendanceDAO.markAttendance(studentId, currentDate, status);
                
                System.out.println("Attendance marking result: " + success);
                
                if (success) {
                    response.sendRedirect("adminDashboard.jsp?success=Attendance marked as " + status + " successfully");
                } else {
                    response.sendRedirect("adminDashboard.jsp?error=Failed to mark attendance as " + status);
                }
            } else {
                System.out.println("Invalid action parameter: " + action);
                response.sendRedirect("adminDashboard.jsp?error=Invalid action parameter");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=Server error: " + e.getMessage());
        }
    }
}