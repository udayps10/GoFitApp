<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>GoFit – Your Fitness, Simplified</title>
  <link href="https://fonts.googleapis.com/css2?family=Ginto+Normal:wght@400;700&family=ABC+Diatype:wght@400;700&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --green: #23A55A;
      --green-light: #2DC76D;
      --green-glow: rgba(35,165,90,0.25);
      --dark: #0e0f11;
      --card-bg: #1a1c22;
      --card-border: #2a2d36;
      --text-primary: #f2f3f5;
      --text-muted: #9ea3b0;
      --white: #fff;
      --accent-yellow: #FEE75C;
      --accent-blue: #5865F2;
      --accent-red: #ED4245;
      --radius: 16px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      font-family: 'Whitney', 'Helvetica Neue', Helvetica, Arial, 'Segoe UI Emoji', 'Noto Color Emoji', 'Apple Color Emoji', sans-serif;
      background: var(--dark);
      color: var(--text-primary);
      overflow-x: hidden;
    }

    /* NAV */
    nav {
      position: fixed; top: 0; left: 0; right: 0; z-index: 100;
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 40px; height: 68px;
      background: rgba(14,15,17,0.88);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid rgba(255,255,255,0.05);
    }
    .nav-logo { display: flex; align-items: center; gap: 10px; font-size: 22px; font-weight: 800; letter-spacing: -0.5px; color: var(--white); }
    .nav-logo .dot { color: var(--green); }
    .logo-icon { width: 36px; height: 36px; background: var(--green); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
    .nav-links { display: flex; gap: 32px; list-style: none; }
    .nav-links a { color: var(--text-muted); text-decoration: none; font-size: 15px; font-weight: 500; transition: color .2s; }
    .nav-links a:hover { color: var(--white); }
    .nav-cta { background: var(--white); color: #000; padding: 10px 22px; border-radius: 24px; font-weight: 700; font-size: 14px; text-decoration: none; transition: background .2s, transform .15s; }
    .nav-cta:hover { background: var(--green); color: #fff; transform: scale(1.03); }

    /* HERO */
    .hero { min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 120px 24px 80px; position: relative; text-align: center; overflow: hidden; }
    .hero-bg { position: absolute; inset: 0; z-index: 0; background: radial-gradient(ellipse 900px 600px at 50% 20%, rgba(35,165,90,0.13) 0%, transparent 70%), radial-gradient(ellipse 500px 400px at 80% 80%, rgba(88,101,242,0.08) 0%, transparent 60%), var(--dark); }
    .hero-blob { position: absolute; top: 10%; left: 50%; transform: translateX(-50%); width: 700px; height: 400px; background: radial-gradient(ellipse, rgba(35,165,90,0.18) 0%, transparent 70%); filter: blur(40px); z-index: 0; pointer-events: none; animation: blobPulse 6s ease-in-out infinite; }
    @keyframes blobPulse { 0%,100% { transform: translateX(-50%) scale(1); opacity: .7; } 50% { transform: translateX(-50%) scale(1.08); opacity: 1; } }

    .hero-badge { position: relative; z-index: 1; display: inline-flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; letter-spacing: .4px; margin-bottom: 28px; animation: fadeUp .6s ease both; }
    .badge-dot { width: 7px; height: 7px; background: var(--green); border-radius: 50%; animation: ping 2s infinite; }
    @keyframes ping { 0%,100% { transform: scale(1); opacity:1; } 50% { transform: scale(1.4); opacity:.5; } }

    .hero h1 { position: relative; z-index: 1; font-size: clamp(44px, 8vw, 88px); font-weight: 900; line-height: 1.04; letter-spacing: -2px; color: var(--white); max-width: 900px; animation: fadeUp .7s .1s ease both; }
    .hero h1 .highlight { color: var(--green); display: inline-block; }
    .hero-sub { position: relative; z-index: 1; font-size: 18px; color: var(--text-muted); max-width: 500px; line-height: 1.6; margin-top: 20px; animation: fadeUp .7s .2s ease both; }

    .hero-actions { position: relative; z-index: 1; display: flex; gap: 14px; margin-top: 36px; flex-wrap: wrap; justify-content: center; animation: fadeUp .7s .3s ease both; }
    .btn-primary { background: var(--green); color: #fff; padding: 16px 34px; border-radius: 28px; font-weight: 800; font-size: 16px; text-decoration: none; transition: background .2s, transform .15s, box-shadow .2s; box-shadow: 0 0 0 0 var(--green-glow); }
    .btn-primary:hover { background: var(--green-light); transform: translateY(-2px); box-shadow: 0 8px 30px rgba(35,165,90,0.4); }
    .btn-ghost { background: rgba(255,255,255,0.07); color: var(--white); border: 1px solid rgba(255,255,255,0.12); padding: 16px 28px; border-radius: 28px; font-weight: 700; font-size: 16px; text-decoration: none; transition: background .2s, transform .15s; }
    .btn-ghost:hover { background: rgba(255,255,255,0.12); transform: translateY(-2px); }
    .hero-note { position: relative; z-index: 1; font-size: 13px; color: var(--text-muted); margin-top: 16px; animation: fadeUp .7s .4s ease both; }

    /* PREVIEW */
    .preview-wrap { position: relative; z-index: 1; margin-top: 60px; width: 100%; max-width: 860px; animation: fadeUp .8s .5s ease both; }
    .preview-shell { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 20px; overflow: hidden; box-shadow: 0 40px 100px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.04); }
    .preview-bar { background: #13141a; padding: 12px 20px; display: flex; align-items: center; gap: 8px; border-bottom: 1px solid var(--card-border); }
    .preview-bar-dot { width: 12px; height: 12px; border-radius: 50%; }
    .preview-bar-url { margin-left: 12px; flex: 1; background: rgba(255,255,255,0.05); border-radius: 8px; padding: 5px 14px; font-size: 12px; color: var(--text-muted); }
    .preview-body { display: grid; grid-template-columns: 200px 1fr; min-height: 280px; }
    .preview-sidebar { background: #13141a; padding: 20px 16px; border-right: 1px solid var(--card-border); display: flex; flex-direction: column; gap: 8px; }
    .sidebar-label { font-size: 11px; font-weight: 700; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase; margin-bottom: 6px; padding: 0 8px; }
    .sidebar-item { display: flex; align-items: center; gap: 10px; padding: 8px 10px; border-radius: 8px; font-size: 14px; font-weight: 500; color: var(--text-muted); cursor: pointer; transition: background .15s, color .15s; }
    .sidebar-item.active { background: rgba(35,165,90,0.15); color: var(--green-light); }
    .sidebar-item:not(.active):hover { background: rgba(255,255,255,0.05); color: var(--text-primary); }
    .sidebar-icon { font-size: 16px; width: 20px; text-align: center; }
    .preview-main { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
    .preview-title { font-size: 18px; font-weight: 800; color: var(--white); }
    .preview-stats { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; }
    .stat-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.07); border-radius: 12px; padding: 14px 16px; }
    .stat-label { font-size: 11px; color: var(--text-muted); font-weight: 600; letter-spacing: .5px; text-transform: uppercase; }
    .stat-val { font-size: 26px; font-weight: 900; margin-top: 4px; }
    .stat-sub { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
    .stat-green { color: var(--green); }
    .stat-yellow { color: var(--accent-yellow); }
    .stat-blue { color: #7289DA; }
    .preview-bar-chart { display: flex; align-items: flex-end; gap: 6px; height: 60px; }
    .bar { width: 100%; background: rgba(35,165,90,0.2); border-radius: 4px; }
    .bar.active { background: var(--green); }

    /* FEATURES */
    .section { padding: 100px 24px; max-width: 1100px; margin: 0 auto; }
    .section-label { text-align: center; font-size: 13px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--green); margin-bottom: 16px; }
    .section-title { text-align: center; font-size: clamp(32px, 5vw, 54px); font-weight: 900; letter-spacing: -1.5px; line-height: 1.1; color: var(--white); max-width: 700px; margin: 0 auto 60px; }

    .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px,1fr)); gap: 20px; }
    .feature-card { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 20px; padding: 36px 32px; position: relative; overflow: hidden; transition: transform .25s, box-shadow .25s, border-color .25s; cursor: default; }
    .feature-card::before { content: ''; position: absolute; inset: 0; opacity: 0; transition: opacity .3s; background: radial-gradient(circle at top left, var(--glow,rgba(35,165,90,0.06)), transparent 60%); }
    .feature-card:hover { transform: translateY(-6px); box-shadow: 0 20px 60px rgba(0,0,0,0.4); border-color: rgba(255,255,255,0.12); }
    .feature-card:hover::before { opacity: 1; }

    .feature-icon-wrap { width: 56px; height: 56px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 26px; margin-bottom: 22px; }
    .feat-green { background: rgba(35,165,90,0.15); }
    .feat-yellow { background: rgba(254,231,92,0.12); }
    .feat-blue { background: rgba(88,101,242,0.15); }
    .feat-purple { background: rgba(168,85,247,0.15); }
    .feat-orange { background: rgba(249,115,22,0.15); }
    .feature-card h3 { font-size: 22px; font-weight: 800; color: var(--white); margin-bottom: 10px; }
    .feature-card p { font-size: 15px; color: var(--text-muted); line-height: 1.65; }

    /* mini visuals */
    .feat-visual { margin-top: 24px; }
    .progress-row { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
    .progress-label { font-size: 12px; color: var(--text-muted); width: 60px; flex-shrink: 0; }
    .progress-track { flex: 1; height: 8px; background: rgba(255,255,255,0.07); border-radius: 99px; overflow: hidden; }
    .progress-fill { height: 100%; border-radius: 99px; }
    .pf-green { background: var(--green); }
    .pf-yellow { background: var(--accent-yellow); }
    .pf-blue { background: #7289DA; }
    .pf-orange { background: #f97316; }
    .progress-val { font-size: 12px; color: var(--text-primary); font-weight: 700; width: 36px; text-align: right; }

    .weight-chart { display: flex; align-items: flex-end; gap: 4px; height: 50px; margin-top: 20px; }
    .weight-bar { flex: 1; border-radius: 3px; background: rgba(88,101,242,0.25); }
    .weight-bar.hi { background: #7289DA; }

    .steps-row { display: flex; gap: 4px; flex-wrap: wrap; margin-top: 20px; }
    .step-dot { width: 14px; height: 14px; border-radius: 3px; background: rgba(35,165,90,0.15); }
    .step-dot.done { background: var(--green); }

    /* Strength chart */
    .strength-chart { display: flex; align-items: flex-end; gap: 5px; height: 60px; margin-top: 20px; }
    .str-bar { flex: 1; border-radius: 4px; background: rgba(249,115,22,0.2); transition: height 1s ease; }
    .str-bar.hi { background: #f97316; }
    .progress-text { font-size: 12px; color: var(--text-muted); margin-top: 8px; }

    /* AI typing card */
    .ai-terminal {
      background: rgba(0,0,0,0.35);
      border: 1px solid rgba(168,85,247,0.25);
      border-radius: 12px;
      padding: 14px 16px;
      margin-top: 20px;
      min-height: 90px;
    }
    .ai-terminal-header {
      display: flex; align-items: center; gap: 6px;
      font-size: 11px; color: rgba(168,85,247,0.7);
      font-weight: 600; letter-spacing: 1px; text-transform: uppercase;
      margin-bottom: 10px;
    }
    .ai-pulse { width: 6px; height: 6px; background: #a855f7; border-radius: 50%; animation: ping 1.5s infinite; }
    .ai-typed-text {
      font-size: 13px;
      color: var(--text-primary);
      line-height: 1.7;
      min-height: 60px;
    }
    .ai-cursor {
      display: inline-block;
      width: 2px; height: 14px;
      background: #a855f7;
      margin-left: 2px;
      vertical-align: middle;
      animation: blink 0.8s step-end infinite;
    }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }

    /* HOW IT WORKS */
    .how-bg { background: linear-gradient(180deg, var(--dark) 0%, #111318 50%, var(--dark) 100%); padding: 100px 24px; }
    .steps-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 32px; max-width: 900px; margin: 0 auto; }
    .step-item { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 16px; }
    .step-num { width: 52px; height: 52px; border-radius: 16px; background: rgba(35,165,90,0.12); border: 1px solid rgba(35,165,90,0.3); color: var(--green); font-size: 22px; font-weight: 900; display: flex; align-items: center; justify-content: center; }
    .step-item h4 { font-size: 17px; font-weight: 800; color: var(--white); }
    .step-item p { font-size: 14px; color: var(--text-muted); line-height: 1.6; }

    /* CTA */
    .cta-section { padding: 100px 24px; text-align: center; }
    .cta-inner { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 28px; padding: 72px 40px; max-width: 780px; margin: 0 auto; position: relative; overflow: hidden; }
    .pill { display:inline-flex; align-items:center; gap:8px; background:rgba(167,139,250,0.1); border:1px solid rgba(167,139,250,0.3); padding:6px 16px; border-radius:99px; font-size:13px; font-weight:600; color:#a78bfa; margin-bottom:28px; }
    .pill-s { animation:spin 3s linear infinite; display:inline-block; }
    @keyframes spin { to { transform:rotate(360deg) } }
    .cta-inner::before { content:''; position:absolute; top:-100px; left:50%; transform:translateX(-50%); width:500px; height:300px; background:radial-gradient(ellipse, rgba(35,165,90,0.15), transparent 70%); pointer-events:none; }
    .cta-inner h2 { font-size: clamp(30px,5vw,50px); font-weight: 900; letter-spacing: -1.5px; color: var(--white); line-height: 1.1; margin-bottom: 16px; }
    .cta-inner p { font-size: 16px; color: var(--text-muted); margin-bottom: 36px; }
    .cta-actions { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; }

    /* FOOTER */
    footer { border-top: 1px solid var(--card-border); padding: 40px 40px 32px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; color: var(--text-muted); font-size: 14px; }
    .footer-logo { font-size: 18px; font-weight: 800; color: var(--white); }
    .footer-logo span { color: var(--green); }
    .footer-links { display: flex; gap: 24px; }
    .footer-links a { color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color .2s; }
    .footer-links a:hover { color: var(--white); }

    @keyframes fadeUp { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: translateY(0); } }
    .animate-in { opacity: 0; transform: translateY(30px); transition: opacity .6s ease, transform .6s ease; }
    .animate-in.visible { opacity: 1; transform: translateY(0); }

    @media (max-width: 700px) {
      nav { padding: 0 20px; }
      .nav-links { display: none; }
      .preview-body { grid-template-columns: 1fr; }
      .preview-sidebar { display: none; }
      .preview-stats { grid-template-columns: 1fr 1fr; }
      footer { flex-direction: column; align-items: flex-start; }
    }
  </style>
</head>
<body>

<!-- NAV -->
<nav>
  <div class="nav-logo">
    <div class="logo-icon">💪</div>
    GoFit<span class="dot">.</span>
  </div>
  <ul class="nav-links">
    
    <li><a href="#">GoFit</a></li>
  
  </ul>
  <a href="register.jsp" class="nav-cta">Get Started for Free</a>
</nav>

<!-- HERO -->
<section class="hero">
  <div class="hero-bg"></div>
  <div class="hero-blob"></div>

  <div class="hero-badge">
    <div class="pill"><span class="pill-s">✦</span> Now with AI-powered insights</div>
  </div>

  <h1>Fitness tracking,<br><span class="highlight">finally simple.</span></h1>
  <p class="hero-sub">No noise. No overwhelm. Just calories, weight, steps and strength — everything you need to stay consistent.</p>

  <div class="hero-actions">
    <a href="login.jsp?tab=📊" class="btn-primary">Login</a>
    <a href="register.jsp" class="btn-ghost">Register</a>
  </div>

  <p class="hero-note">• Free forever &nbsp;·&nbsp; • No credit card &nbsp;·&nbsp;  • Ready in 60 seconds</p>

  <!-- App Preview -->
  <div class="preview-wrap">
    <div class="preview-shell">
      <div class="preview-bar">
        <div class="preview-bar-dot" style="background:#ED4245"></div>
        <div class="preview-bar-dot" style="background:#FEE75C"></div>
        <div class="preview-bar-dot" style="background:#23A55A"></div>
        <div class="preview-bar-url">app.gofit.io/dashboard</div>
      </div>
      <div class="preview-body">
        <div class="preview-sidebar">
          <div class="sidebar-label">GoFit</div>
          <div class="sidebar-item active"><span class="sidebar-icon">📊</span> Dashboard</div>
          <div class="sidebar-item"><span class="sidebar-icon">🍎</span> Calories</div>
          <div class="sidebar-item"><span class="sidebar-icon">⚖️</span> Weight</div>
          <div class="sidebar-item"><span class="sidebar-icon">👟</span> Steps</div>
          <div class="sidebar-item"><span class="sidebar-icon">🏋️</span> Strength</div>
          <div class="sidebar-item"><span class="sidebar-icon">🤖</span> AI Insights</div>
          <div class="sidebar-item"><span class="sidebar-icon">⚙️</span> Settings</div>
        </div>
        <div class="preview-main">
          <div class="preview-title">Good morning, Alex 👋</div>
          <div class="preview-stats">
            <div class="stat-card">
              <div class="stat-label">Calories</div>
              <div class="stat-val stat-green">1,840</div>
              <div class="stat-sub">/ 2,200 goal</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">Weight</div>
              <div class="stat-val stat-blue">73.2 kg</div>
              <div class="stat-sub">↓ 0.4 this week</div>
            </div>
            <div class="stat-card">
              <div class="stat-label">Steps</div>
              <div class="stat-val stat-yellow">7,412</div>
              <div class="stat-sub">/ 10,000 goal</div>
            </div>
          </div>
          <div class="preview-bar-chart">
            <div class="bar" style="height:40%"></div>
            <div class="bar" style="height:65%"></div>
            <div class="bar" style="height:50%"></div>
            <div class="bar" style="height:80%"></div>
            <div class="bar active" style="height:70%"></div>
            <div class="bar" style="height:55%"></div>
            <div class="bar" style="height:45%"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="section">
  <div class="section-label">Features</div>
  <h2 class="section-title">Five tools. One habit.</h2>

  <div class="features-grid">

    <!-- Calorie -->
    <div class="feature-card animate-in" style="--glow: rgba(35,165,90,0.08)">
      <div class="feature-icon-wrap feat-green">🍎</div>
      <h3>Calorie Tracking</h3>
      <p>Log meals in seconds and see how you're tracking against your daily goal — no diet degree required.</p>
      <div class="feat-visual">
        <div class="progress-row">
          <div class="progress-label" style="font-size:11px">Breakfast</div>
          <div class="progress-track"><div class="progress-fill pf-green" style="width:70%"></div></div>
          <div class="progress-val">420</div>
        </div>
        <div class="progress-row">
          <div class="progress-label" style="font-size:11px">Lunch</div>
          <div class="progress-track"><div class="progress-fill pf-green" style="width:50%"></div></div>
          <div class="progress-val">610</div>
        </div>
        <div class="progress-row">
          <div class="progress-label" style="font-size:11px">Dinner</div>
          <div class="progress-track"><div class="progress-fill pf-green" style="width:35%"></div></div>
          <div class="progress-val">810</div>
        </div>
      </div>
    </div>

    <!-- Weight -->
    <div class="feature-card animate-in" style="--glow: rgba(88,101,242,0.08)">
      <div class="feature-icon-wrap feat-blue">⚖️</div>
      <h3>Weight Tracking</h3>
      <p>Record your weight and watch the trend over time. Small drops feel big when you can actually see them.</p>
      <div class="feat-visual">
        <div class="weight-chart">
          <div class="weight-bar" style="height:55%"></div>
          <div class="weight-bar" style="height:62%"></div>
          <div class="weight-bar" style="height:50%"></div>
          <div class="weight-bar" style="height:68%"></div>
          <div class="weight-bar hi" style="height:60%"></div>
          <div class="weight-bar hi" style="height:52%"></div>
          <div class="weight-bar hi" style="height:45%"></div>
          <div class="weight-bar hi" style="height:40%"></div>
        </div>
        <div style="font-size:12px; color:var(--text-muted); margin-top:8px">↓ 1.8 kg in 30 days</div>
      </div>
    </div>

    <!-- Steps -->
    <div class="feature-card animate-in" style="--glow: rgba(254,231,92,0.06)">
      <div class="feature-icon-wrap feat-yellow">👟</div>
      <h3>Step Tracking</h3>
      <p>Hit your daily step goal and build an active lifestyle one day at a time. Every step counts.</p>
      <div class="feat-visual">
        <div class="steps-row">
          <div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div>
          <div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div>
          <div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div><div class="step-dot done"></div>
          <div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div><div class="step-dot"></div>
        </div>
        <div style="font-size:12px; color:var(--text-muted); margin-top:10px">20 / 28 days this month 🔥</div>
      </div>
    </div>

    <!-- Strength Tracking -->
    <div class="feature-card animate-in" style="--glow: rgba(249,115,22,0.08)">
      <div class="feature-icon-wrap feat-orange">🏋️</div>
      <h3>Strength Tracking</h3>
      <p>Track your lifts and see your strength improve over time. Progressive overload made simple.</p>
      <div class="feat-visual">
        <div class="strength-chart" id="strengthChart">
          <div class="str-bar" style="height:40%"></div>
          <div class="str-bar" style="height:50%"></div>
          <div class="str-bar" style="height:55%"></div>
          <div class="str-bar" style="height:65%"></div>
          <div class="str-bar hi" style="height:75%"></div>
          <div class="str-bar hi" style="height:85%"></div>
          <div class="str-bar hi" style="height:95%"></div>
        </div>
        <div class="progress-text" style="margin-top:10px;">↑ +20 kg in 6 weeks 💪</div>
        <div class="progress-row" style="margin-top:14px;">
          <div class="progress-label" style="font-size:11px">Bench</div>
          <div class="progress-track"><div class="progress-fill pf-orange" style="width:72%"></div></div>
          <div class="progress-val" style="color:#f97316">80kg</div>
        </div>
        <div class="progress-row">
          <div class="progress-label" style="font-size:11px">Squat</div>
          <div class="progress-track"><div class="progress-fill pf-orange" style="width:85%"></div></div>
          <div class="progress-val" style="color:#f97316">100kg</div>
        </div>
        <div class="progress-row">
          <div class="progress-label" style="font-size:11px">Deadlift</div>
          <div class="progress-track"><div class="progress-fill pf-orange" style="width:90%"></div></div>
          <div class="progress-val" style="color:#f97316">120kg</div>
        </div>
      </div>
    </div>

    <!-- AI Insights - typing effect -->
    <div class="feature-card animate-in" style="--glow: rgba(168,85,247,0.08)">
      <div class="feature-icon-wrap feat-purple">🤖</div>
      <h3>AI Insights</h3>
      <p>Your habits analyzed daily. Get personalized nudges to improve your nutrition, activity, and consistency.</p>
      <div class="feat-visual">
        <div class="ai-terminal">
          <div class="ai-terminal-header">
            <div class="ai-pulse"></div> GoFit AI · Live Analysis
          </div>
          <div class="ai-typed-text" id="aiTypedText"><span class="ai-cursor"></span></div>
        </div>
      </div>
    </div>

  </div>
</section>

<!-- HOW IT WORKS -->
<div class="how-bg">
  <div style="max-width:1100px; margin:0 auto;">
    <div class="section-label">How it works</div>
    <h2 class="section-title animate-in">Up and running in minutes.</h2>
    <div class="steps-list">
      <div class="step-item animate-in">
        <div class="step-num">1</div>
        <h4>Create your account</h4>
        <p>Sign up in under a minute — just an email and a goal.</p>
      </div>
      <div class="step-item animate-in">
        <div class="step-num">2</div>
        <h4>Set your targets</h4>
        <p>Tell us your calorie budget, goal weight, and daily steps target.</p>
      </div>
      <div class="step-item animate-in">
        <div class="step-num">3</div>
        <h4>Log daily</h4>
        <p>Take 30 seconds each day to log food, weight, steps and lifts.</p>
      </div>
      <div class="step-item animate-in">
        <div class="step-num">4</div>
        <h4>Watch progress</h4>
        <p>See trends, hit streaks, and stay consistent week after week.</p>
      </div>
    </div>
  </div>
</div>

<!-- CTA -->
<section class="cta-section">
  <div class="cta-inner animate-in">
    <h2>Ready to start showing up for yourself?</h2>
    <p>Join thousands of everyday people building healthier habits with GoFit.</p>
    <div class="cta-actions">
      <a href="register.jsp" class="btn-primary">Get started for free →</a>
      <a href="login.jsp" class="btn-ghost">Already a User ?</a>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="footer-logo">GoFit<span>.</span></div>
  <div class="footer-links">
    <a href="#">Privacy</a>
    <a href="#">Terms</a>
    <a href="#">Contact</a>
  </div>
  <div style="font-size:13px;">© 2026 GoFit. All rights reserved.</div>
</footer>

<script>
  // Scroll animations
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((e, i) => {
      if (e.isIntersecting) {
        setTimeout(() => e.target.classList.add('visible'), i * 80);
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.15 });
  document.querySelectorAll('.animate-in').forEach(el => observer.observe(el));

  // Animate progress bars on load
  window.addEventListener('load', () => {
    document.querySelectorAll('.progress-fill').forEach(bar => {
      const w = bar.style.width;
      bar.style.width = '0';
      setTimeout(() => { bar.style.transition = 'width 1s ease'; bar.style.width = w; }, 800);
    });
  });

  // AI typing effect
  const aiMessages = [
    "⚡ Your protein intake today is low — try adding chicken or eggs to hit your target.",
    "📉 Great news! Your weight trend is steadily improving over the last 2 weeks.",
    "🔥 You're 300 kcal under your daily goal — a healthy snack could help.",
    "💪 Your bench press has improved by 15% this month. Keep pushing!",
    "🥗 You skipped breakfast 3 days this week. Try a quick smoothie to stay on track.",
    "👟 You're 2,500 steps away from your goal — a 20-min walk will get you there!"
  ];

  let msgIdx = 0;
  let charIdx = 0;
  let isDeleting = false;
  let pauseTimer = null;
  const typedEl = document.getElementById('aiTypedText');

  function typeAI() {
    const currentMsg = aiMessages[msgIdx];

    if (!isDeleting) {
      // typing
      charIdx++;
      typedEl.innerHTML = currentMsg.slice(0, charIdx) + '<span class="ai-cursor"></span>';
      if (charIdx === currentMsg.length) {
        // pause then delete
        pauseTimer = setTimeout(() => { isDeleting = true; typeAI(); }, 2800);
        return;
      }
      setTimeout(typeAI, 38);
    } else {
      // deleting
      charIdx--;
      typedEl.innerHTML = currentMsg.slice(0, charIdx) + '<span class="ai-cursor"></span>';
      if (charIdx === 0) {
        isDeleting = false;
        msgIdx = (msgIdx + 1) % aiMessages.length;
        setTimeout(typeAI, 400);
        return;
      }
      setTimeout(typeAI, 18);
    }
  }

  // Start typing after a short delay
  setTimeout(typeAI, 1200);
</script>
</body>
</html>
