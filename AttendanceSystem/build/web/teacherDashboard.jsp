<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User, com.attendance.dao.TeacherDAO, java.util.List, java.util.Map, java.util.Calendar, java.text.SimpleDateFormat, java.util.Date" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"teacher".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TeacherDAO teacherDAO = new TeacherDAO();
    String teacherSubject = teacherDAO.getTeacherSubject(user.getId());

    String selectedDate = request.getParameter("selected_date");
    if (selectedDate == null || selectedDate.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        selectedDate = sdf.format(new Date());
    }

    List<Map<String, Object>> pendingLectures = teacherDAO.getPendingLecturesForDate(user.getId(), selectedDate);
    List<Map<String, Object>> reportData = teacherDAO.getAttendanceReportByTeacher(teacherDAO.getTeacherIdByUserId(user.getId()));

    Calendar calendar = Calendar.getInstance();
    String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

    String selectedDay = "";
    try {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dateObj = sdf.parse(selectedDate);
        calendar.setTime(dateObj);
        selectedDay = days[calendar.get(Calendar.DAY_OF_WEEK) - 1];
    } catch (Exception e) {
        selectedDay = "Unknown";
    }

    String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    boolean isValidDate = teacherDAO.isValidAttendanceDate(selectedDate);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Dashboard | Attendance Management System</title>
    <style>
        :root {
            --bg-color: #f5f5f5;
            --text-color: #333;
            --card-bg: #ffffff;
            --card-border: #ddd;
            --accent1: #667eea;
            --accent2: #764ba2;
            --sidebar-bg: linear-gradient(180deg, var(--accent1) 0%, var(--accent2) 100%);
        }

        body.dark {
            --bg-color: #121212;
            --text-color: #f1f1f1;
            --card-bg: #1e1e2f;
            --card-border: #2c2c3c;
            --sidebar-bg: linear-gradient(180deg, #4b5ac7 0%, #5a3985 100%);
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
            height: 100vh;
            background: var(--sidebar-bg);
            color: white;
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
            width: 100%;
            display: flex;
            flex-direction: column;
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

        /* Mode Toggle */
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
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
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
            border: 1px solid var(--card-border);
            transition: all 0.3s ease;
        }

        h2 {
            color: var(--accent2);
        }

        input[type="date"] {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-right: 10px;
            font-size: 14px;
            background: var(--card-bg);
            color: var(--text-color);
        }

        .date-submit {
            background: linear-gradient(135deg, var(--accent1), var(--accent2));
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .date-submit:hover {
            opacity: 0.9;
            transform: scale(1.03);
        }

        .lecture-card {
            border: 2px solid var(--accent2);
            border-radius: 10px;
            padding: 15px;
            margin-top: 15px;
            background: var(--card-bg);
            transition: all 0.3s ease;
        }

        .lecture-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-3px);
        }

        .btn-mark {
            background: linear-gradient(135deg, var(--accent1), var(--accent2));
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-mark:hover {
            transform: scale(1.05);
        }

        .success, .error {
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid var(--card-border);
        }

        th {
            background: linear-gradient(135deg, var(--accent1), var(--accent2));
            color: white;
        }

        tr:hover {
            background: rgba(118, 75, 162, 0.05);
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
            <a href="#lectures">📚 Lectures</a>
            <a href="#reports">📊 Reports</a>
        </div>
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-btn">🚪 Logout</button>
        </form>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Welcome, <span><%= user.getName() %></span></h1>
            <p><%= new java.util.Date() %></p>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="success">✅ <%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="error">❌ <%= request.getParameter("error") %></div>
        <% } %>

        <div class="card" id="lectures">
            <h2>📅 Select Date to Mark Attendance</h2>
            <form method="get" action="teacherDashboard.jsp">
                <input type="date" name="selected_date" value="<%= selectedDate %>" max="<%= today %>" required>
                <button type="submit" class="date-submit">View Pending Lectures</button>
            </form>
            <p><strong>Selected Date:</strong> <%= selectedDate %> (<%= selectedDay %>)</p>
        </div>

        <div class="card" id="reports">
            <h2>📋 Pending Lectures for <%= selectedDate %></h2>
            <% if (!isValidDate) { %>
                <div class="error">⚠️ Cannot mark attendance for this date. Please select a valid date.</div>
            <% } else if (pendingLectures.isEmpty()) { %>
                <div class="success">🎉 No pending lectures for this day!</div>
            <% } else { %>
                <% for (Map<String, Object> lecture : pendingLectures) { %>
                    <div class="lecture-card">
                        <h3><%= lecture.get("subject_name") %> (<%= lecture.get("subject_code") %>)</h3>
                        <p><strong>Lecture #</strong> <%= lecture.get("lecture_number") %></p>
                        <p><strong>Time:</strong> <%= lecture.get("start_time") %> - <%= lecture.get("end_time") %></p>
                        <a href="markLectureAttendance.jsp?timetable_id=<%= lecture.get("timetable_id") %>&subject_id=<%= lecture.get("subject_id") %>&lecture_number=<%= lecture.get("lecture_number") %>&teacher_id=<%= user.getId() %>&attendance_date=<%= selectedDate %>" class="btn-mark">📝 Mark Attendance</a>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="card" id="attendanceReport">
            <h2>📊 Attendance Report (Your Subjects)</h2>
            <% if (reportData.isEmpty()) { %>
                <div class="error">⚠️ No attendance records found for your subjects yet.</div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th>Student Name</th>
                            <th>Subject</th>
                            <th>Total Classes</th>
                            <th>Present</th>
                            <th>Attendance %</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> row : reportData) { 
                            int total = (Integer) row.get("total_classes");
                            int present = (Integer) row.get("present_classes");
                            double percent = (total > 0) ? (present * 100.0 / total) : 0;
                        %>
                        <tr>
                            <td><%= row.get("roll_number") %></td>
                            <td><%= row.get("name") %></td>
                            <td><%= row.get("subject_name") %></td>
                            <td><%= total %></td>
                            <td><%= present %></td>
                            <td style="color: <%= (percent < 75) ? "red" : "green" %>;">
                                <%= String.format("%.1f%%", percent) %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>

    <button class="mode-toggle" id="modeToggle">🌙</button>

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
