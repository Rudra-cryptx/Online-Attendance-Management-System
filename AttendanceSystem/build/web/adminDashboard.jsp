<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User, com.attendance.dao.StudentDAO, java.util.List, java.util.Map" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    StudentDAO studentDAO = new StudentDAO();
    List<Map<String, Object>> students = studentDAO.getAllStudentsWithAttendance();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard | Attendance Management System</title>
        <style>
            :root {
                --bg-color: #f5f5f5;
                --text-color: #333;
                --card-bg: #fff;
                --sidebar-bg: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
                --accent1: #667eea;
                --accent2: #764ba2;
                --border-color: #ddd;
            }

            body.dark {
                --bg-color: #121212;
                --text-color: #f1f1f1;
                --card-bg: #1e1e2f;
                --sidebar-bg: linear-gradient(180deg, #4b5ac7 0%, #5a3985 100%);
                --border-color: #2c2c3c;
            }

            body {
                margin: 0;
                font-family: 'Poppins', sans-serif;
                background: var(--bg-color);
                color: var(--text-color);
                display: flex;
                transition: all 0.3s ease;
            }

            /* Sidebar */
            .sidebar {
                width: 250px;
                background: var(--sidebar-bg);
                color: white;
                height: 100vh;
                position: fixed;
                display: flex;
                flex-direction: column;
                align-items: center;
                padding-top: 30px;
                box-shadow: 5px 0 15px rgba(0, 0, 0, 0.2);
                transition: background 0.3s ease;
            }

            .sidebar h2 {
                font-size: 22px;
                margin-bottom: 40px;
                text-align: center;
                letter-spacing: 1px;
            }

            .nav-links {
                display: flex;
                flex-direction: column;
                width: 100%;
            }

            .nav-links a {
                text-decoration: none;
                color: white;
                padding: 15px 30px;
                display: block;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .nav-links a:hover {
                background: rgba(255, 255, 255, 0.15);
                padding-left: 40px;
            }

            .logout-btn {
                margin-top: auto;
                margin-bottom: 30px;
                background: #dc3545;
                color: white;
                padding: 12px 25px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .logout-btn:hover {
                background: #c82333;
                transform: scale(1.05);
            }

            /* Mode toggle */

            .mode-toggle {
                position: fixed;
                bottom: 25px;
                left: 25px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                font-size: 20px;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(0,0,0,0.3);
                transition: all 0.3s ease;
                z-index: 999;
            }

            .mode-toggle:hover {
                transform: scale(1.1);
                box-shadow: 0 0 15px rgba(118, 75, 162, 0.7);
            }


            /* Main content */
            .main-content {
                margin-left: 250px;
                flex: 1;
                padding: 30px;
                transition: margin-left 0.3s ease;
            }

            .header {
                background: linear-gradient(135deg, var(--accent1), var(--accent2));
                color: white;
                padding: 20px 25px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: relative;
            }

            .header h1 {
                margin: 0;
                font-size: 24px;
            }

            .header span {
                font-weight: 600;
            }

            .card {
                background: var(--card-bg);
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                margin-bottom: 25px;
                border: 1px solid var(--border-color);
                transition: all 0.3s ease;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid var(--border-color);
            }

            th {
                background: linear-gradient(135deg, var(--accent1), var(--accent2));
                color: white;
            }

            tr:hover {
                background: rgba(118, 75, 162, 0.05);
            }

            .btn {
                padding: 8px 15px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-weight: 500;
            }

            .btn-present {
                background: #28a745;
                color: white;
            }

            .btn-present:hover {
                background: #218838;
            }

            .btn-absent {
                background: #dc3545;
                color: white;
            }

            .btn-absent:hover {
                background: #c82333;
            }

            .success {
                background: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #c3e6cb;
                margin-bottom: 15px;
            }

            .error {
                background: #f8d7da;
                color: #721c24;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #f5c6cb;
                margin-bottom: 15px;
            }

            @media (max-width: 900px) {
                .sidebar {
                    width: 200px;
                }
                .main-content {
                    margin-left: 200px;
                }
                .nav-links a {
                    font-size: 14px;
                    padding: 12px 20px;
                }
            }

            @media (max-width: 700px) {
                .sidebar {
                    display: none;
                }
                .main-content {
                    margin: 0;
                    padding: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Attendance<br>Management System</h2>
            <div class="nav-links">
                <a href="adminDashboard.jsp">🏠 Dashboard</a>
                <a href="#attendance">📋 Mark Attendance</a>
                <a href="#reports">📊 Attendance Report</a>
            </div>
            <form action="logout.jsp" method="post">
                <button type="submit" class="logout-btn">🚪 Logout</button>
            </form>
        </div>

        <div class="main-content">
            <div class="header">
                <h1>Welcome, <span><%= user.getName()%></span></h1>
                <p><%= new java.util.Date()%></p>
                <button class="mode-toggle" id="modeToggle">🌙</button>
            </div>

            <% if (request.getParameter("success") != null) {%>
            <div class="success">✅ <%= request.getParameter("success")%></div>
            <% } %>
            <% if (request.getParameter("error") != null) {%>
            <div class="error">❌ <%= request.getParameter("error")%></div>
            <% } %>

            <div class="card" id="attendance">
                <h2>📅 Mark Attendance for Today</h2>
                <form action="markAttendance" method="post">
                    <table>
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Mark Attendance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> student : students) {%>
                            <tr>
                                <td><%= student.get("roll_number")%></td>
                                <td><%= student.get("name")%></td>
                                <td>
                                    <button type="submit" name="action" value="present_<%= student.get("student_id")%>" class="btn btn-present">Present</button>
                                    <button type="submit" name="action" value="absent_<%= student.get("student_id")%>" class="btn btn-absent">Absent</button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </form>
            </div>

            <div class="card" id="reports">
                <h2>📊 Student Attendance Report</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th>Student Name</th>
                            <th>Total Classes</th>
                            <th>Present</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> student : students) {
                                int total = (Integer) student.get("total_classes");
                                int present = (Integer) student.get("present_classes");
                                double percentage = total > 0 ? (present * 100.0 / total) : 0;
                        %>
                        <tr>
                            <td><%= student.get("roll_number")%></td>
                            <td><%= student.get("name")%></td>
                            <td><%= total%></td>
                            <td><%= present%></td>
                            <td style="color: <%= (percentage < 75) ? "red" : "green"%>;">
                                <%= String.format("%.1f%%", percentage)%>
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>

        <script>
            const toggleBtn = document.getElementById("modeToggle");
            const body = document.body;

            if (localStorage.getItem("theme") === "dark") {
                body.classList.add("dark");
                toggleBtn.textContent = "☀️";
            }

            toggleBtn.addEventListener("click", () => {
                body.classList.toggle("dark");
                const mode = body.classList.contains("dark") ? "dark" : "light";
                toggleBtn.textContent = mode === "dark" ? "☀️" : "🌙";
                localStorage.setItem("theme", mode);
            });
        </script>
    </body>
</html>
