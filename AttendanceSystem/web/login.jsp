<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | SkillHub Attendance System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: radial-gradient(circle at top right, #6a11cb, #2575fc);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            position: relative;
            color: white;
        }

        /* Subtle background glow animation */
        .glow {
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(255,255,255,0.15), transparent 70%);
            animation: floatGlow 8s ease-in-out infinite alternate;
            z-index: 0;
        }

        @keyframes floatGlow {
            from { transform: translate(-100px, -50px) scale(1); }
            to { transform: translate(100px, 50px) scale(1.2); }
        }

        .login-card {
            z-index: 1;
            width: 380px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            padding: 40px 35px;
            color: #fff;
            animation: fadeIn 1s ease;
        }

        .login-card h2 {
            text-align: center;
            margin-bottom: 10px;
            font-size: 28px;
            letter-spacing: 1px;
        }

        .login-card p {
            text-align: center;
            font-size: 14px;
            color: #dcdcdc;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #eaeaea;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: none;
            border-radius: 8px;
            outline: none;
            font-size: 15px;
            background: rgba(255, 255, 255, 0.15);
            color: #fff;
            transition: background 0.3s ease, box-shadow 0.3s ease;
        }

        input:focus {
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 0 10px rgba(255,255,255,0.3);
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.3s ease;
        }

        button:hover {
            transform: scale(1.03);
            box-shadow: 0 5px 20px rgba(118, 75, 162, 0.4);
        }

        .error {
            color: #ff6b6b;
            text-align: center;
            margin-bottom: 15px;
            background: rgba(255, 107, 107, 0.15);
            border: 1px solid rgba(255, 107, 107, 0.3);
            padding: 8px;
            border-radius: 6px;
        }

        .footer-text {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #d1d1d1;
        }

        .footer-text strong {
            color: #fff;
        }

        .credits {
            position: absolute;
            bottom: 10px;
            width: 100%;
            text-align: center;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 420px) {
            .login-card {
                width: 90%;
                padding: 30px 25px;
            }
            .login-card h2 { font-size: 24px; }
        }
    </style>
</head>
<body>
    <div class="glow"></div>
    <div class="login-card">
        <h2>Welcome Back 👋</h2>
        <p>Login to your SkillHub Attendance Portal</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit">Login</button>
        </form>

        <div class="footer-text">
            <p>Forgot your password? <strong>Contact Admin</strong></p>
        </div>
    </div>

    <div class="credits">✨ Designed with ❤️ by Rudra </div>
</body>
</html>
