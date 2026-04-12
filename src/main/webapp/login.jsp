
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - GoFit</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0f0a;
            --card: #0e1510;
            --surface: #0a0f0a;
            --border: rgba(74,222,128,0.10);
            --text: #f0f5f0;
            --muted: #4a6650;
            --green: #4ade80;
            --green-mid: #22c55e;
            --green-glow: rgba(74,222,128,0.25);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background-color: var(--bg);
            color: var(--text);
            font-family: 'DM Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            position: relative;
            overflow: hidden;
        }

        /* Green radial glows */
        body::before {
            content: '';
            position: fixed;
            top: -25%; left: -10%;
            width: 60vw; height: 60vw;
            background: radial-gradient(circle, rgba(74,222,128,0.07) 0%, transparent 65%);
            pointer-events: none; z-index: 0;
        }
        body::after {
            content: '';
            position: fixed;
            bottom: -20%; right: -10%;
            width: 50vw; height: 50vw;
            background: radial-gradient(circle, rgba(34,197,94,0.05) 0%, transparent 65%);
            pointer-events: none; z-index: 0;
        }

        /* Permanent wave background */
        .wave-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            width: 100%; height: 100%;
        }

        .login-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 450px;
            text-align: center;
            padding: 48px 40px;
            background: rgba(14, 21, 16, 0.85);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow:
                0 40px 80px rgba(0,0,0,0.7),
                0 0 0 1px rgba(74,222,128,0.06),
                inset 0 1px 0 rgba(74,222,128,0.08);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            animation: fadeUp 0.55s cubic-bezier(0.22,1,0.36,1) both;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .logo {
            font-size: 40px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .logo-icon {
            width: 42px; height: 42px;
            background: var(--green);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 0 20px rgba(74,222,128,0.35);
        }
        .logo-icon svg { width: 22px; height: 22px; }

        .logo-name {
            font-family: 'DM Serif Display', serif;
            font-size: 1.6rem;
            letter-spacing: -0.02em;
            color: var(--text);
        }

        h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.9rem;
            font-weight: 400;
            letter-spacing: -0.03em;
            margin-top: 18px;
            margin-bottom: 6px;
            color: var(--text);
        }

        .subtitle {
            font-size: 0.85rem;
            color: var(--muted);
            margin-bottom: 28px;
            font-weight: 300;
        }

        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 0.7rem;
            font-weight: 600;
            letter-spacing: 0.09em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 6px;
            margin-top: 14px;
        }
        label:first-child { margin-top: 0; }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            background: rgba(10,15,10,0.6);
            border: 1px solid rgba(74,222,128,0.10);
            border-radius: 10px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            box-sizing: border-box;
            margin-bottom: 0;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: #1e2e1e;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: rgba(74,222,128,0.35);
            box-shadow: 0 0 0 3px rgba(74,222,128,0.08);
        }

        .register-link {
            font-size: 0.82rem;
            color: var(--green);
            display: block;
            margin-top: 18px;
            text-decoration: none;
            font-weight: 600;
            transition: opacity 0.2s;
        }
        .register-link:hover { opacity: 0.75; text-decoration: underline; }

        .btn-continue {
            width: 100%;
            padding: 13px;
            background: var(--green);
            border: none;
            border-radius: 50px;
            color: #071a0a;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 22px;
            letter-spacing: 0.01em;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 20px rgba(74,222,128,0.25);
        }

        .btn-continue:hover {
            background: var(--green-mid);
            box-shadow: 0 6px 28px rgba(74,222,128,0.40);
            transform: scale(1.02);
        }

        .btn-continue:active {
            transform: scale(0.98);
        }
    </style>
</head>
<body>

<!-- Permanent wave background -->
<svg class="wave-bg" viewBox="0 0 1440 900" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <radialGradient id="glow1" cx="20%" cy="80%" r="50%">
            <stop offset="0%" stop-color="#4ade80" stop-opacity="0.07"/>
            <stop offset="100%" stop-color="#4ade80" stop-opacity="0"/>
        </radialGradient>
        <radialGradient id="glow2" cx="80%" cy="20%" r="40%">
            <stop offset="0%" stop-color="#22c55e" stop-opacity="0.05"/>
            <stop offset="100%" stop-color="#22c55e" stop-opacity="0"/>
        </radialGradient>
    </defs>
    <ellipse cx="200" cy="750" rx="500" ry="300" fill="url(#glow1)"/>
    <ellipse cx="1250" cy="150" rx="400" ry="250" fill="url(#glow2)"/>
    <path d="M0 820 C180 780, 360 840, 540 810 C720 780, 900 830, 1080 800 C1260 770, 1350 820, 1440 800 L1440 900 L0 900 Z"
          fill="#0d1a0e" fill-opacity="0.9"/>
    <path d="M0 850 C200 820, 400 870, 600 845 C800 820, 1000 860, 1200 838 C1350 820, 1400 845, 1440 835 L1440 900 L0 900 Z"
          fill="#0a150b" fill-opacity="0.7"/>
    <path d="M0 862 C240 840, 480 875, 720 855 C960 835, 1200 868, 1440 850"
          fill="none" stroke="#4ade80" stroke-width="1.2" stroke-opacity="0.18"/>
    <line x1="0" y1="300" x2="1440" y2="300" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
    <line x1="0" y1="500" x2="1440" y2="500" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
    <line x1="0" y1="700" x2="1440" y2="700" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
    <line x1="300" y1="0" x2="300" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
    <line x1="720" y1="0" x2="720" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
    <line x1="1140" y1="0" x2="1140" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
</svg>

<div class="login-container">
    <div class="logo">
        <div class="logo-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M6 12h2M16 12h2M8 12V9a1 1 0 011-1h6a1 1 0 011 1v3M8 12v3a1 1 0 001 1h6a1 1 0 001-1v-3" stroke="#071a0a" stroke-width="2" stroke-linecap="round"/>
                <circle cx="4" cy="12" r="2" fill="#071a0a"/>
                <circle cx="20" cy="12" r="2" fill="#071a0a"/>
            </svg>
        </div>
        <span class="logo-name">GoFit</span>
    </div>

    <h1>Welcome back</h1>
    <p class="subtitle">Sign in to continue your journey.</p>

    <div class="input-group">
        <label for="user">Email or Username</label>
        <input type="text" id="user" placeholder="Email or username">

        <label for="password">Password</label>
        <input type="password" id="password" placeholder="Password">
    </div>

    <button class="btn-continue">Continue</button>

    <a href="register.jsp" class="register-link">New here? Create an account</a>
</div>

</body>
</html>