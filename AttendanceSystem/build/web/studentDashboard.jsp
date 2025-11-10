<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User, com.attendance.dao.AttendanceDAO, com.attendance.dao.StudentDAO, java.util.Map" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    AttendanceDAO attendanceDAO = new AttendanceDAO();
    StudentDAO studentDAO = new StudentDAO();
    int studentId = studentDAO.getStudentIdByUserId(user.getId());
    int totalClasses = attendanceDAO.getTotalClasses();
    int presentClasses = studentDAO.getPresentClasses(studentId);
    double percentage = (totalClasses > 0) ? (presentClasses * 100.0 / totalClasses) : 0;

    Map<String, Object> nextClass = studentDAO.getNextClassForStudent(studentId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard | Attendance Management System</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --bg-color: #f5f5f5;
            --text-color: #333;
            --card-bg: #fff;
            --card-border: #ddd;
            --accent1: #667eea;
            --accent2: #764ba2;
        }

        body.dark {
            --bg-color: #121212;
            --text-color: #f1f1f1;
            --card-bg: #1e1e2f;
            --card-border: #2c2c3c;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: var(--bg-color);
            color: var(--text-color);
            transition: all 0.4s ease;
        }

        .header {
            background: linear-gradient(135deg, var(--accent1), var(--accent2));
            color: white;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            border-radius: 0 0 20px 20px;
            position: relative;
        }

        .mode-toggle {
            position: absolute;
            top: 20px;
            left: 25px;
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

        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 15px;
            position: absolute;
            top: 20px;
            right: 25px;
        }

        .logout-btn:hover {
            background: #c82333;
        }

        .container {
            max-width: 950px;
            margin: 40px auto;
            background: var(--card-bg);
            border-radius: 15px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
            border: 1px solid var(--card-border);
        }

        /* Circular progress bar */
        .progress-wrapper {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 40px auto;
        }

        svg {
            width: 200px;
            height: 200px;
            transform: rotate(-90deg);
        }

        circle {
            fill: none;
            stroke-width: 12;
            stroke-linecap: round;
        }

        .bg {
            stroke: rgba(102,126,234,0.2);
            filter: drop-shadow(0 0 6px rgba(118,75,162,0.5));
        }

        .progress {
            stroke: url(#gradient);
            stroke-dasharray: 565.48;
            stroke-dashoffset: 565.48;
            transition: stroke-dashoffset 1.5s ease;
        }

        .progress-inner {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .progress-inner h2 {
            margin: 0;
            font-size: 30px;
            color: var(--accent1);
        }

        .progress-inner p {
            font-size: 14px;
            color: #999;
        }

        /* Stats */
        .stats {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 25px;
            margin-top: 20px;
        }

        .stat-card {
            flex: 1;
            min-width: 250px;
            background: var(--card-bg);
            border-radius: 12px;
            padding: 20px;
            border-left: 6px solid var(--accent1);
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.1);
        }

        .stat-card h3 {
            margin-bottom: 8px;
            color: var(--text-color);
        }

        .stat-card .number {
            font-size: 32px;
            font-weight: bold;
            color: var(--accent1);
        }

        .alert {
            margin-top: 25px;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .next-class, .chart-container {
            margin-top: 40px;
            padding: 20px;
            background: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            text-align: left;
        }

        .next-class h3, .chart-container h3 {
            color: var(--accent2);
        }
    </style>
</head>
<body>
    <div class="header">
        <button class="mode-toggle" id="modeToggle">🌙</button>
        <h1>Student Dashboard</h1>
        <span>Welcome, <%= user.getName() %></span>
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </div>

    <div class="container">
        <h2>📊 Attendance Overview</h2>

        <div class="progress-wrapper">
            <svg>
                <defs>
                    <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stop-color="#667eea"/>
                        <stop offset="100%" stop-color="#764ba2"/>
                    </linearGradient>
                </defs>
                <circle class="bg" cx="100" cy="100" r="90"></circle>
                <circle class="progress" id="progressCircle" cx="100" cy="100" r="90"></circle>
            </svg>
            <div class="progress-inner">
                <h2 id="percentageText">0%</h2>
                <p>Attendance</p>
            </div>
        </div>

        <div class="stats">
            <div class="stat-card">
                <h3>Total Classes</h3>
                <div class="number"><%= totalClasses %></div>
            </div>
            <div class="stat-card">
                <h3>Present</h3>
                <div class="number"><%= presentClasses %></div>
            </div>
            <div class="stat-card">
                <h3>Classes Needed (75%)</h3>
                <div class="number">
                    <%
                        int required = (int)Math.ceil((0.75 * totalClasses) - presentClasses);
                        if (required <= 0) out.print("✅ OK");
                        else out.print(required);
                    %>
                </div>
            </div>
        </div>

        <% if (percentage < 75.0) { %>
        <div class="alert alert-danger">
            ⚠️ Warning: Your attendance is below 75%! Please attend more lectures.
        </div>
        <% } else { %>
        <div class="alert alert-success">
            ✅ Great! Your attendance is above 75%.
        </div>
        <% } %>

        <div class="next-class">
            <h3>📅 Next Class</h3>
            <% if (nextClass != null && !nextClass.isEmpty()) { %>
                <p><strong>Subject:</strong> <%= nextClass.get("subject_name") %> (<%= nextClass.get("subject_code") %>)</p>
                <p><strong>Time:</strong> <%= nextClass.get("start_time") %> – <%= nextClass.get("end_time") %></p>
            <% } else { %>
                <p>🎉 You have no upcoming classes today!</p>
            <% } %>
        </div>

        <!-- Chart Section -->
        <div class="chart-container">
            <h3>📈 Attendance Trend (Past 7 Days)</h3>
            <canvas id="attendanceChart"></canvas>
        </div>
    </div>

    <script>
        // Dark/Light Mode Toggle
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

        // Circular Progress Animation
        const circle = document.getElementById("progressCircle");
        const percentText = document.getElementById("percentageText");
        const targetPercent = Math.round(<%= percentage %>);
        const radius = 90;
        const circumference = 2 * Math.PI * radius;

        circle.style.strokeDasharray = circumference;
        circle.style.strokeDashoffset = circumference;

        let current = 0;
        function animateCircle() {
            if (current <= targetPercent) {
                const offset = circumference - (current / 100) * circumference;
                circle.style.strokeDashoffset = offset;
                percentText.textContent = current + "%";
                current++;
                requestAnimationFrame(animateCircle);
            }
        }
        window.addEventListener("load", () => setTimeout(() => requestAnimationFrame(animateCircle), 150));

        // Attendance Line Chart
        const ctx = document.getElementById("attendanceChart").getContext("2d");
        new Chart(ctx, {
            type: "line",
            data: {
                labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                datasets: [{
                    label: "Attendance %",
                    data: [60, 65, 70, 68, 74, 76, <%= (int)percentage %>],
                    borderColor: "#667eea",
                    backgroundColor: "rgba(118, 75, 162, 0.1)",
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: "#764ba2",
                    pointRadius: 5,
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false }},
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: { color: body.classList.contains("dark") ? "#ccc" : "#555" },
                        grid: { color: body.classList.contains("dark") ? "#333" : "#eee" }
                    },
                    x: {
                        ticks: { color: body.classList.contains("dark") ? "#ccc" : "#555" },
                        grid: { display: false }
                    }
                }
            }
        });
    </script>
</body>
</html>
