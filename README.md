# Online-Attendance-Management-System
# 🧑‍🏫 Attendance Management System

A complete **web-based attendance tracking platform** built using **Java (JSP + Servlets)**, **MySQL**, and **HTML/CSS** — designed with a modern purple-blue theme, clean UI, and full role-based functionality for **Admin, Teachers, and Students**.

---

## 🚀 Features

### 👨‍💼 Admin Panel
- ➕ Add new students directly from the dashboard  
- 📊 View all student attendance reports  
- 🧑‍🏫 Manage attendance data  
- 🔐 Secure login with role-based access  
- 🌓 Dark/Light mode toggle  

### 👩‍🏫 Teacher Dashboard
- 📅 View and select lectures by date  
- 📝 Mark attendance for each class  
- 📈 View subject-wise attendance reports  
- 🎨 Beautiful, modern purple-blue UI  
- 🌓 Dark/Light mode support  

### 👨‍🎓 Student Dashboard
- 📊 Interactive circular attendance progress bar  
- ⚠️ Alerts when attendance drops below 75%  
- 💡 Automatic “classes needed” calculator  
- 📅 Upcoming class display (future update ready)  
- 📈 Weekly attendance trend line chart  
- 🌓 Dark/Light mode with local preference saving  

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | HTML5, CSS3, JavaScript |
| **Backend** | Java Servlets, JSP |
| **Database** | MySQL |
| **Server** | Apache Tomcat |
| **IDE** | NetBeans / IntelliJ IDEA |
| **Version Control** | Git & GitHub |

---

## 🗂️ Folder Structure
AttendanceManagementSystem/
│
├── src/
│ ├── com/attendance/dao/ # Database access (DAO) classes
│ ├── com/attendance/model/ # Java model classes
│ ├── com/attendance/controller/ # Servlets and controllers
│ └── com/attendance/util/ # Utility files (e.g., DBConnection)
│
├── web/
│ ├── login.jsp
│ ├── adminDashboard.jsp
│ ├── teacherDashboard.jsp
│ ├── studentDashboard.jsp
│ ├── markLectureAttendance.jsp
│ └── logout.jsp
│
├── build/
├── nbproject/
├── attendance_system.sql # Database file
├── README.md
└── web.xml # Deployment descriptor


