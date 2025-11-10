package com.attendance.controller;

import com.attendance.dao.UserDAO;
import com.attendance.model.User;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt - Username: " + username + ", Password: " + password);
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            System.out.println("Login successful - User: " + user.getName() + ", Role: " + user.getRole());
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            if ("admin".equals(user.getRole())) {
                System.out.println("Redirecting to admin dashboard");
                response.sendRedirect("adminDashboard.jsp");
            } else if ("teacher".equals(user.getRole())) {
                System.out.println("Redirecting to teacher dashboard");
                response.sendRedirect("teacherDashboard.jsp");
            } else {
                System.out.println("Redirecting to student dashboard");
                response.sendRedirect("studentDashboard.jsp");
            }
        } else {
            System.out.println("Login failed - Invalid credentials");
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}