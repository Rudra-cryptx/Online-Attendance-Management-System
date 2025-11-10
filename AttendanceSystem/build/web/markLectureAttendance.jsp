<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User, com.attendance.dao.StudentDAO, com.attendance.dao.TeacherDAO, java.util.List, java.util.Map, java.text.SimpleDateFormat, java.util.Date" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"teacher".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String timetableId = request.getParameter("timetable_id");
    String subjectId = request.getParameter("subject_id");
    String lectureNumber = request.getParameter("lecture_number");
    String teacherId = request.getParameter("teacher_id");
    String attendanceDate = request.getParameter("attendance_date");

    if (attendanceDate == null || attendanceDate.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        attendanceDate = sdf.format(new Date());
    }

    StudentDAO studentDAO = new StudentDAO();
    TeacherDAO teacherDAO = new TeacherDAO();
    List<Map<String, Object>> students = studentDAO.getAllStudents();
    String teacherSubject = teacherDAO.getTeacherSubject(user.getId());

    SimpleDateFormat displayFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
    Date dateObj = new SimpleDateFormat("yyyy-MM-dd").parse(attendanceDate);
    String displayDate = displayFormat.format(dateObj);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mark Attendance | Attendance Management System</title>
    <style>
        :root {
            --bg-color: #f5f5f5;
            --text-color: #333;
            --card-bg: #ffffff;
            --accent1: #667eea;
            --accent2: #764ba2;
            --header-bg: linear-gradient(135deg, var(--accent1), var(--accent2));
            --table-border: #ddd;
        }

        body.dark {
            --bg-color: #121212;
            --text-color: #f1f1f1;
            --card-bg: #1e1e2f;
            --header-bg: linear-gradient(135deg, #4b5ac7, #5a3985);
            --table-border: #2c2c3c;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            transition: all 0.3s ease;
        }

        .header {
            background: var(--header-bg);
            color: white;
            text-align: center;
            padding: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            position: relative;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
        }

        /* Dark mode toggle */
        .mode-toggle {
            position: absolute;
            top: 20px;
            right: 25px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            border-radius: 50%;
            width: 42px;
            height: 42px;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s;
        }

        .mode-toggle:hover {
            background: rgba(255,255,255,0.35);
        }

        .container {
            max-width: 950px;
            margin: 30px auto;
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transition: background 0.3s ease, color 0.3s ease;
        }

        .lecture-info {
            background: rgba(102,126,234,0.08);
            border-left: 6px solid var(--accent1);
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .lecture-info h3 {
            color: var(--accent2);
            margin-bottom: 5px;
        }

        .lecture-info p {
            margin: 3px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px 10px;
            border-bottom: 1px solid var(--table-border);
            text-align: left;
        }

        th {
            background: var(--header-bg);
            color: white;
        }

        tr:hover {
            background: rgba(118,75,162,0.05);
        }

        .attendance-options {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .attendance-options label {
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: 500;
            cursor: pointer;
        }

        input[type="radio"] {
            transform: scale(1.3);
            accent-color: var(--accent1);
        }

        .btn-submit {
            background: var(--header-bg);
            color: white;
            border: none;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 25px;
        }

        .btn-submit:hover {
            transform: scale(1.05);
            opacity: 0.9;
        }

        .btn-cancel {
            display: inline-block;
            text-decoration: none;
            background: #6c757d;
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            margin-left: 10px;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover {
            background: #5a6268;
            transform: scale(1.03);
        }

        .date-highlight {
            background: rgba(118,75,162,0.08);
            border: 1px solid rgba(118,75,162,0.2);
            color: var(--accent2);
            padding: 12px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .note {
            text-align: center;
            margin-top: 15px;
            font-size: 13px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📝 Mark Lecture Attendance</h1>
        <button class="mode-toggle" id="modeToggle">🌙</button>
    </div>

    <div class="container">
        <div class="date-highlight">
            📅 Marking Attendance for: <strong><%= displayDate %></strong>
        </div>

        <div class="lecture-info">
            <h3>📋 Lecture Details</h3>
            <p><strong>Subject:</strong> <%= teacherSubject %></p>
            <p><strong>Lecture Number:</strong> <%= lectureNumber %></p>
            <p><strong>Date:</strong> <%= displayDate %></p>
        </div>

        <form action="markLectureAttendance" method="post">
            <input type="hidden" name="timetable_id" value="<%= timetableId %>">
            <input type="hidden" name="subject_id" value="<%= subjectId %>">
            <input type="hidden" name="lecture_number" value="<%= lectureNumber %>">
            <input type="hidden" name="teacher_id" value="<%= teacherId %>">
            <input type="hidden" name="attendance_date" value="<%= attendanceDate %>">

            <table>
                <thead>
                    <tr>
                        <th>Roll Number</th>
                        <th>Student Name</th>
                        <th>Attendance</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> student : students) { %>
                    <tr>
                        <td><%= student.get("roll_number") %></td>
                        <td><%= student.get("name") %></td>
                        <td>
                            <div class="attendance-options">
                                <label><input type="radio" name="attendance_<%= student.get("student_id") %>" value="Present" required> ✅ Present</label>
                                <label><input type="radio" name="attendance_<%= student.get("student_id") %>" value="Absent"> ❌ Absent</label>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div style="text-align: center;">
                <button type="submit" class="btn-submit">💾 Submit Attendance</button>
                <a href="teacherDashboard.jsp?selected_date=<%= attendanceDate %>" class="btn-cancel">↩ Back</a>
            </div>

            <p class="note">⚠️ Once submitted, attendance cannot be modified for this date.</p>
        </form>
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
