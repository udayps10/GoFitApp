<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ExerciseLog, model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<ExerciseLog> exerciseLogs = (List<ExerciseLog>) request.getAttribute("exerciseLogs");
    // ── Date-nav support: which day's logs are we actually showing? Set by the
    // servlet based on ?date=yyyy-MM-dd; defaults to today if not supplied. ──
    String selectedDateStr = (String) request.getAttribute("selectedDate");
    if (selectedDateStr == null) selectedDateStr = java.time.LocalDate.now().toString();
    Boolean isTodayAttr = (Boolean) request.getAttribute("isToday");
    boolean isToday = (isTodayAttr != null) ? isTodayAttr : true;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>GoFit Simple</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@400;600;700&display=swap" rel="stylesheet">

<style>

  /* ---- RESET ---- */
  * { box-sizing: border-box; margin: 0; padding: 0; }

  /* ---- BODY ---- */
  
  body {
    font-family: 'DM Sans', Arial, sans-serif;
    background: #080d14;
    color: #f0f4f8;
    min-height: 100vh;
  }
/* --- GRID DECORATION (The Green Boxes) --- */
  .grid-decoration {
    position: fixed;
    bottom: 30px;
    right: 30px;
    display: grid;
    grid-template-columns: repeat(5, 18px);
    grid-template-rows: repeat(5, 18px);
    gap: 6px;
    opacity: 0.5;
  }

  .grid-box { width: 18px; height: 18px; border-radius: 4px; background: rgba(255, 255, 255, 0.05); }
  .lvl-1 { background: #0e4429; }
  .lvl-2 { background: #006d32; }
  .lvl-3 { background: #26a641; }
  .lvl-4 { background: #39d353; box-shadow: 0 0 10px rgba(57, 211, 83, 0.2); }

  /* ---- NAVBAR (matches calorie.jsp) ---- */
  nav { background: #0b1220; border-bottom: 1px solid rgba(255,255,255,0.07); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 58px; position: sticky; top: 0; z-index: 200; }
  .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
  .logo-box { width: 32px; height: 32px; background: #4ade80; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
  .logo-text { font-family: 'DM Serif Display', serif; font-size: 1.2rem; color: #f0f4f8; }
  .nav-right { display: flex; align-items: center; gap: 10px; }
  .ham-btn { background: none; border: none; cursor: pointer; display: flex; flex-direction: column; justify-content: center; align-items: center; gap: 5px; width: 36px; height: 36px; padding: 4px; border-radius: 8px; transition: background 0.15s; flex-shrink: 0; }
  .ham-btn:hover { background: rgba(255,255,255,0.06); }
  .ham-btn span { display: block; width: 22px; height: 2px; background: #f0f4f8; border-radius: 2px; transition: transform 0.25s, opacity 0.2s; transform-origin: center; }
  .ham-btn.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
  .ham-btn.open span:nth-child(2) { opacity: 0; transform: scaleX(0); }
  .ham-btn.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
  .nav-dropdown { position: absolute; top: 58px; left: 20px; background: #0b1220; border: 1px solid rgba(255,255,255,0.10); border-radius: 14px; min-width: 210px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); display: none; flex-direction: column; overflow: hidden; z-index: 199; animation: dropIn 0.18s ease; }
  @keyframes dropIn { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }
  .nav-dropdown.open { display: flex; }
  .nav-brand-row { display: flex; align-items: center; gap: 8px; padding: 14px 16px 10px; border-bottom: 1px solid rgba(255,255,255,0.07); font-size: 15px; font-weight: 700; color: #f0f4f8; }
  .nav-brand-icon { background: #4ade80; color: #000; padding: 3px 7px; border-radius: 6px; font-size: 14px; }
  .nav-dropdown a { display: flex; align-items: center; gap: 10px; color: #5a7291; text-decoration: none; font-size: 0.92rem; font-weight: 600; padding: 11px 16px; transition: color 0.15s, background 0.15s; }
  .nav-dropdown a .nav-icon { font-size: 17px; width: 22px; text-align: center; }
  .nav-dropdown a:hover { color: #f0f4f8; background: rgba(255,255,255,0.05); }
  .nav-dropdown a.active { color: #4ade80; background: rgba(74,222,128,0.08); }
  .nav-divider { height: 1px; background: rgba(255,255,255,0.07); margin: 4px 0; }
  .nav-logout { display: flex; align-items: center; gap: 10px; padding: 11px 16px 14px; font-size: 0.92rem; font-weight: 600; color: #f87171; cursor: pointer; transition: background 0.15s; }
  .nav-logout:hover { background: rgba(248,113,113,0.07); }
  .nav-logout .nav-icon { font-size: 17px; width: 22px; text-align: center; }
  .nav-overlay { position: fixed; inset: 0; z-index: 198; display: none; }
  .nav-overlay.open { display: block; }

  /* ---- PAGE WRAPPER ---- */
  main {
    max-width: 620px;
    margin: 0 auto;
    padding: 28px 18px 60px;
  }

  /* ---- PAGE HEADING ---- */
  .page-title {
    font-family: 'DM Serif Display', serif;
    font-size: 1.8rem;
    letter-spacing: -0.02em;
    margin-bottom: 4px;
  }
  .page-sub {
    font-size: 0.85rem;
    color: #5a7291;
    margin-bottom: 20px;
  }

  /* ---- CARD ---- */
  .card {
    background: #0d1520;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 14px;
  }

  /* ---- SECTION LABEL ---- */
  .card-label {
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: #5a7291;
    margin-bottom: 14px;
  }
    /* ---- AI INSIGHT CARD ---- */
  .ai-insight-card {
    background: linear-gradient(135deg, #1a1040 0%, #231355 50%, #1a1040 100%);
    border: 1px solid rgba(167,139,250,0.35);
    border-radius: 16px;
    padding: 18px 18px 16px;
    margin-bottom: 14px;
    position: relative;
    overflow: hidden;
  }
  /* subtle glow blob */
  .ai-insight-card::before {
    content: '';
    position: absolute;
    top: -30px; right: -30px;
    width: 120px; height: 120px;
    background: radial-gradient(circle, rgba(167,139,250,0.18) 0%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }
  .ai-insight-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
  }
  .ai-insight-icon {
    width: 34px; height: 34px;
    background: rgba(139,92,246,0.25);
    border: 1px solid rgba(167,139,250,0.4);
    border-radius: 9px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem;
    flex-shrink: 0;
  }
  .ai-insight-title-block {}
  .ai-insight-label {
    font-size: 0.62rem;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: #a78bfa;
  }
  .ai-insight-subtitle {
    font-size: 0.72rem;
    color: rgba(167,139,250,0.6);
    margin-top: 1px;
  }

  /* halfway banner */
  .ai-halfway-banner {
    background: rgba(139,92,246,0.12);
    border: 1px solid rgba(167,139,250,0.2);
    border-radius: 8px;
    padding: 7px 12px;
    font-size: 0.8rem;
    font-weight: 600;
    color: #c4b5fd;
    margin-bottom: 10px;
    display: none;
  }

  .ai-insight-text {
    font-size: 0.87rem;
    line-height: 1.6;
    color: #e2d9f3;
    margin-bottom: 14px;
  }
  .ai-insight-text strong {
    color: #fff;
    font-weight: 700;
  }
  .ai-insight-chips {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }
  .ai-chip {
    padding: 7px 14px;
    background: rgba(109,40,217,0.35);
    border: 1px solid rgba(139,92,246,0.4);
    border-radius: 20px;
    font-size: 0.78rem;
    font-weight: 600;
    color: #ddd6fe;
    cursor: pointer;
    transition: all 0.2s;
    white-space: nowrap;
    display: flex; align-items: center; gap: 5px;
  }
  .ai-chip:hover {
    background: rgba(139,92,246,0.45);
    border-color: rgba(167,139,250,0.7);
    color: #fff;
    transform: translateY(-1px);
  }
  .ai-chip-emoji { font-size: 0.9rem; }

  /* ---- DATE ROW ---- */
  .date-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .date-row span {
    font-size: 0.95rem;
    font-weight: 600;
  }
  .arrow-btn {
    width: 34px;
    height: 34px;
    background: #131f30;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 8px;
    color: #5a7291;
    font-size: 1.1rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: color 0.2s;
  }
  .arrow-btn:hover { color: #f0f4f8; }
  .arrow-btn:disabled { opacity: 0.3; cursor: not-allowed; }

  .wave-bg {
    position: fixed;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    width: 100%; height: 100%;
  }

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

  /* ---- INPUTS ---- */
  .input-row {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-bottom: 10px;
  }
  .input-row input {
    flex: 1;
    min-width: 80px;
    padding: 11px 12px;
    background: #131f30;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 10px;
    color: #f0f4f8;
    font-family: 'DM Sans', Arial, sans-serif;
    font-size: 0.88rem;
    outline: none;
  }
  .input-row input:focus {
    border-color: rgba(74,222,128,0.4);
  }
  .input-row input::placeholder { color: #2e4a66; }

  /* number input labels */
  .input-labels {
    display: flex;
    gap: 8px;
    margin-bottom: 4px;
  }
  .input-labels span {
    flex: 1;
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: #5a7291;
    text-align: center;
  }
  .input-labels .name-lbl { flex: 2; text-align: left; }

  /* ---- ADD BUTTON ---- */
  .btn-add {
    width: 100%;
    padding: 12px;
    background: #22c55e;
    border: none;
    border-radius: 10px;
    color: #060d14;
    font-family: 'DM Sans', Arial, sans-serif;
    font-size: 0.9rem;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s;
  }
  .btn-add:hover { background: #4ade80; }

  /* ---- EXERCISE ITEMS ---- */
  .list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
  }
  .item-count {
    font-size: 0.72rem;
    color: #5a7291;
  }

  .exercise-item {
    display: flex;
    align-items: center;
    background: #111d2e;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 12px;
    padding: 13px 14px;
    margin-bottom: 8px;
    gap: 12px;
    cursor: pointer;
    transition: border-color 0.2s;
  }
  .exercise-item:hover { border-color: rgba(74,222,128,0.3); }
  .exercise-item:last-child { margin-bottom: 0; }

  .ex-dot {
    width: 8px;
    height: 8px;
    background: #4ade80;
    border-radius: 50%;
    flex-shrink: 0;
  }

  .ex-info { flex: 1; }

  .ex-name-row {
    display: flex;
    align-items: center;
    gap: 6px;
    flex-wrap: wrap;
  }

  .ex-name {
    font-size: 0.9rem;
    font-weight: 600;
  }

  .ex-detail {
    font-size: 0.75rem;
    color: #5a7291;
    margin-top: 3px;
  }

  .btn-delete {
    background: none;
    border: none;
    color: #5a7291;
    cursor: pointer;
    font-size: 1rem;
    padding: 4px 7px;
    border-radius: 6px;
    transition: color 0.2s;
  }
  .btn-delete:hover { color: #f87171; }

  .empty {
    text-align: center;
    color: #5a7291;
    font-size: 0.85rem;
    padding: 24px 0;
  }

  /* ---- PR BADGE ---- */
  .pr-badge {
    display: inline-flex;
    align-items: center;
    gap: 3px;
    background: rgba(251,191,36,0.15);
    border: 1px solid rgba(251,191,36,0.45);
    border-radius: 6px;
    padding: 1px 7px;
    font-size: 0.67rem;
    font-weight: 700;
    color: #fbbf24;
    letter-spacing: 0.05em;
  }

  /* ---- e1RM TAG ---- */
  .e1rm-tag {
    font-size: 0.7rem;
    color: #4ade80;
    background: rgba(74,222,128,0.1);
    border-radius: 5px;
    padding: 1px 6px;
  }

  /* ---- MODAL ---- */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.75);
    z-index: 200;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px;
  }
  .modal-box {
    background: #0d1520;
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 20px;
    padding: 22px;
    width: 100%;
    max-width: 540px;
    max-height: 88vh;
    overflow-y: auto;
  }
  .modal-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    margin-bottom: 16px;
  }
  .modal-title { font-family: 'DM Serif Display', serif; font-size: 1.25rem; }
  .modal-close {
    background: none;
    border: none;
    color: #5a7291;
    font-size: 1.2rem;
    cursor: pointer;
    padding: 2px 6px;
    border-radius: 6px;
  }
  .modal-close:hover { color: #f0f4f8; }
  .modal-stats { display: flex; gap: 10px; margin-bottom: 16px; }
  .mstat {
    flex: 1;
    background: #111d2e;
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 12px;
    padding: 12px 14px;
  }
  .mstat-label {
    font-size: 0.63rem;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: #5a7291;
    margin-bottom: 4px;
  }
  .mstat-val { font-size: 1.05rem; font-weight: 700; }
  .mstat-val.green { color: #4ade80; }
  .mstat-val.gold  { color: #fbbf24; }
  .chart-area { position: relative; width: 100%; height: 220px; margin-bottom: 6px; }
  .chart-note { font-size: 0.68rem; color: #5a7291; margin-bottom: 10px; }
  .chart-legend {
    display: flex;
    gap: 14px;
    font-size: 0.7rem;
    color: #5a7291;
    margin-bottom: 6px;
  }
  .chart-legend span { display: flex; align-items: center; gap: 5px; }
  .leg-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
  .history-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    border-bottom: 1px solid rgba(255,255,255,0.05);
    font-size: 0.8rem;
  }
  .history-row:last-child { border-bottom: none; }
  .history-date { color: #5a7291; }
  .history-vals { display: flex; gap: 10px; align-items: center; font-weight: 600; }
  .pr-row-badge {
    font-size: 0.63rem;
    color: #fbbf24;
    background: rgba(251,191,36,0.12);
    border: 1px solid rgba(251,191,36,0.3);
    border-radius: 5px;
    padding: 1px 5px;
  }
  .no-history { text-align: center; color: #5a7291; font-size: 0.83rem; padding: 20px 0; }

</style>
</head>
<body>
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
  <path d="M0 862 C240 840, 480 875, 720 855 C960 835, 1200 868, 1440 850"
        fill="none" stroke="#4ade80" stroke-width="1.2" stroke-opacity="0.18"/>
</svg>
<!-- NAVBAR -->
<nav>
  <a href="<%=request.getContextPath()%>/GoFit?page=dashboard" class="nav-brand">
    <div class="logo-box">💪</div>
    <span class="logo-text">GoFit</span>
  </a>
  <div class="nav-right">
    <button class="ham-btn" id="hamBtn" onclick="toggleNav()" aria-label="Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>

<div class="nav-overlay" id="navOverlay" onclick="closeNav()"></div>

<div class="nav-dropdown" id="navDropdown">
  <div class="nav-brand-row">
    <span class="nav-brand-icon">💪</span> GoFit
  </div>
  <a href="<%=request.getContextPath()%>/GoFit?page=dashboard"><span class="nav-icon">📊</span> Dashboard</a>
  <a href="<%=request.getContextPath()%>/GoFit?page=calorie"><span class="nav-icon">🍎</span> Food Tracking</a>
  <a href="<%=request.getContextPath()%>/GoFit?page=workout" class="active"><span class="nav-icon">🏋️</span> Workout</a>
  <div class="nav-divider"></div>
  <div class="nav-logout" onclick="logout()"><span class="nav-icon">🚪</span> Logout</div>
</div>

<!-- MAIN -->
<main>

  <!-- DATE NAV -->
  <div class="card">
    <div class="date-row">
      <button class="arrow-btn" onclick="changeDay(-1)">&#8249;</button>
      <span id="dateLabel"></span>
      <button class="arrow-btn" id="btnNext" onclick="changeDay(1)">&#8250;</button>
    </div>
    <% if (!isToday) { %>
    <div style="margin-top:10px;background:rgba(74,222,128,0.08);border:1px solid rgba(74,222,128,0.2);border-radius:8px;padding:8px 12px;font-size:0.8rem;color:#4ade80;">
      📅 Viewing past data — logging is disabled for previous days.
    </div>
    <% } %>
  </div>

  <!-- LOG EXERCISE FORM (only shown when viewing today; past days are read-only) -->
  <% if (isToday) { %>
  <div class="card">
    <div class="card-label">Log Exercise</div>
    <form action="<%=request.getContextPath()%>/GoFit" method="post">
      <input type="hidden" name="action" value="addExercise">
      <div class="input-labels">
        <span class="name-lbl">Exercise</span>
        <span>kg</span>
        <span>Reps</span>
      </div>

      <div class="input-row">
        <input name="exerciseName" id="name"   placeholder="e.g. Bench Press" style="flex:2" required list="exerciseSuggestions" autocomplete="off">
        <datalist id="exerciseSuggestions"></datalist>
        <input name="weightKg"     id="weight" type="number" value="0" step="0.5">
        <input name="reps"         id="reps"   type="number" value="10">
      </div>

      <button type="submit" class="btn-add">+ Add Exercise</button>
    </form>
  </div>
  <% } %>

  <!-- LIST -->
  <div class="card">
    <div class="list-header">
      <div class="card-label" style="margin-bottom:0">Exercises</div>
      <span class="item-count" id="itemCount">0 exercises</span>
    </div>
    <div id="list"></div>
  </div>

  <div class="grid-decoration">
    <div class="grid-box lvl-1"></div><div class="grid-box"></div><div class="grid-box lvl-2"></div><div class="grid-box"></div><div class="grid-box lvl-1"></div>
    <div class="grid-box lvl-3"></div><div class="grid-box lvl-1"></div><div class="grid-box"></div><div class="grid-box lvl-4"></div><div class="grid-box lvl-2"></div>
    <div class="grid-box lvl-2"></div><div class="grid-box"></div><div class="grid-box lvl-1"></div><div class="grid-box"></div><div class="grid-box lvl-3"></div>
    <div class="grid-box"></div><div class="grid-box lvl-1"></div><div class="grid-box lvl-2"></div><div class="grid-box"></div><div class="grid-box"></div>
    <div class="grid-box lvl-1"></div><div class="grid-box lvl-3"></div><div class="grid-box lvl-4"></div><div class="grid-box lvl-2"></div><div class="grid-box"></div>
  </div>

</main>

<!-- MODAL -->
<div class="modal-overlay" id="modalOverlay" style="display:none" onclick="handleOverlayClick(event)">
  <div class="modal-box">
    <div class="modal-header">
      <div class="modal-title" id="modalTitle"></div>
      <button class="modal-close" onclick="closeModal()">&#10005;</button>
    </div>
    <div class="modal-stats" id="modalStats"></div>
    <div class="chart-area">
      <canvas id="prChart" role="img" aria-label="PR progress chart"></canvas>
    </div>
    <div class="chart-legend">
      <span><span class="leg-dot" style="background:#4ade80"></span>Weight (kg)</span>
      <span><span class="leg-dot" style="background:#60a5fa"></span>Est. 1RM</span>
    </div>
    <div class="chart-note" id="chartNote"></div>
    <div id="historyList"></div>
  </div>
</div>

<script>

  /* ---------- DATA ---------- */
  var todayExercises = [
<%
    if (exerciseLogs != null) {
        for (int i = 0; i < exerciseLogs.size(); i++) {
            ExerciseLog log = exerciseLogs.get(i);
            String exName = log.getExerciseName() != null ? log.getExerciseName().replace("\"", "\\\"").replace("'", "\\'") : "";
%>
    { id: <%= log.getId() %>, name: "<%= exName %>", weight: <%= log.getWeightKg() %>, reps: <%= log.getReps() %> }<%= (i < exerciseLogs.size() - 1) ? "," : "" %>
<%
        }
    }
%>
  ];
  // ── Server-provided date state (from ?date=yyyy-MM-dd, defaults to today) ──
  var contextPath = '<%=request.getContextPath()%>';
  var SELECTED_DATE = "<%= selectedDateStr %>"; // yyyy-MM-dd
  var IS_TODAY = <%= isToday %>;
  var data      = {};
  var dayOffset = 0;
  var today     = new Date();
  var chartInst = null;

  /* todayExercises is really "exercises for SELECTED_DATE" — server already
     filtered by date, so map it under that key rather than always "today". */
  data[SELECTED_DATE] = todayExercises;

  /* ---------- EXERCISE NAME AUTOCOMPLETE ---------- */
var commonExercises = [

  // ═══════════════════════════════════════════════════════════
  // CHEST
  // ═══════════════════════════════════════════════════════════
  "Barbell Bench Press",
  "Incline Barbell Bench Press",
  "Decline Barbell Bench Press",
  "Dumbbell Bench Press",
  "Incline Dumbbell Bench Press",
  "Decline Dumbbell Bench Press",
  "Close-Grip Bench Press",
  "Wide-Grip Bench Press",
  "Dumbbell Flyes",
  "Incline Dumbbell Flyes",
  "Decline Dumbbell Flyes",
  "Cable Chest Flyes",
  "Low Cable Flyes",
  "High Cable Flyes",
  "Cable Crossover",
  "Pec Deck Machine",
  "Machine Chest Press",
  "Smith Machine Bench Press",
  "Smith Machine Incline Press",
  "Chest Dips",
  "Push-Up",
  "Wide-Grip Push-Up",
  "Diamond Push-Up",
  "Archer Push-Up",
  "Decline Push-Up",
  "Incline Push-Up",
  "Plyometric Push-Up",
  "Landmine Press",
  "Svend Press",
  "Squeeze Press",

  // ═══════════════════════════════════════════════════════════
  // BACK
  // ═══════════════════════════════════════════════════════════
  "Conventional Deadlift",
  "Sumo Deadlift",
  "Romanian Deadlift",
  "Stiff-Leg Deadlift",
  "Deficit Deadlift",
  "Rack Pull",
  "Trap Bar Deadlift",
  "Barbell Row",
  "Pendlay Row",
  "Yates Row",
  "T-Bar Row",
  "Dumbbell Row",
  "Single-Arm Dumbbell Row",
  "Chest-Supported Row",
  "Seal Row",
  "Seated Cable Row",
  "Wide-Grip Seated Cable Row",
  "Single-Arm Cable Row",
  "Low Row",
  "Pull-Up",
  "Wide-Grip Pull-Up",
  "Neutral-Grip Pull-Up",
  "Chin-Up",
  "Archer Pull-Up",
  "Weighted Pull-Up",
  "Assisted Pull-Up",
  "Lat Pulldown",
  "Wide-Grip Lat Pulldown",
  "Close-Grip Lat Pulldown",
  "Reverse-Grip Lat Pulldown",
  "Single-Arm Lat Pulldown",
  "Straight-Arm Pulldown",
  "Kneeling Lat Pulldown",
  "Dumbbell Pullover",
  "Cable Pullover",
  "Back Extension",
  "Hyperextension",
  "Good Morning",
  "Meadows Row",
  "Inverted Row",
  "TRX Row",

  // ═══════════════════════════════════════════════════════════
  // SHOULDERS
  // ═══════════════════════════════════════════════════════════
  "Barbell Overhead Press",
  "Seated Barbell Overhead Press",
  "Dumbbell Shoulder Press",
  "Seated Dumbbell Shoulder Press",
  "Arnold Press",
  "Push Press",
  "Behind-the-Neck Press",
  "Smith Machine Shoulder Press",
  "Machine Shoulder Press",
  "Cable Shoulder Press",
  "Lateral Raise",
  "Dumbbell Lateral Raise",
  "Cable Lateral Raise",
  "Machine Lateral Raise",
  "Leaning Cable Lateral Raise",
  "Front Raise",
  "Dumbbell Front Raise",
  "Barbell Front Raise",
  "Cable Front Raise",
  "Plate Front Raise",
  "Reverse Pec Deck",
  "Bent-Over Lateral Raise",
  "Face Pull",
  "Cable Face Pull",
  "Band Face Pull",
  "Upright Row",
  "Barbell Shrugs",
  "Dumbbell Shrugs",
  "Cable Shrugs",
  "Machine Shrugs",
  "Band Pull-Apart",
  "Cuban Press",
  "Y-T-W Raise",

  // ═══════════════════════════════════════════════════════════
  // BICEPS
  // ═══════════════════════════════════════════════════════════
  "Barbell Bicep Curl",
  "Dumbbell Bicep Curl",
  "Alternating Dumbbell Curl",
  "Hammer Curl",
  "Alternating Hammer Curl",
  "Cross-Body Hammer Curl",
  "EZ-Bar Curl",
  "EZ-Bar Preacher Curl",
  "Barbell Preacher Curl",
  "Dumbbell Preacher Curl",
  "Machine Preacher Curl",
  "Concentration Curl",
  "Spider Curl",
  "Incline Dumbbell Curl",
  "Cable Bicep Curl",
  "Low Cable Curl",
  "High Cable Curl",
  "Rope Hammer Curl",
  "Reverse Barbell Curl",
  "Reverse EZ-Bar Curl",
  "Zottman Curl",
  "21s",
  "Machine Bicep Curl",
  "TRX Bicep Curl",
  "Drag Curl",
  "Cable Concentration Curl",

  // ═══════════════════════════════════════════════════════════
  // TRICEPS
  // ═══════════════════════════════════════════════════════════
  "Tricep Dips",
  "Bench Dips",
  "Close-Grip Bench Press",
  "Skull Crusher",
  "EZ-Bar Skull Crusher",
  "Dumbbell Skull Crusher",
  "Cable Skull Crusher",
  "Overhead Tricep Extension",
  "Dumbbell Overhead Tricep Extension",
  "EZ-Bar Overhead Tricep Extension",
  "Cable Overhead Tricep Extension",
  "Rope Overhead Extension",
  "Cable Tricep Pushdown",
  "Rope Pushdown",
  "Straight Bar Pushdown",
  "Reverse Grip Pushdown",
  "Single-Arm Cable Pushdown",
  "Tricep Kickback",
  "Dumbbell Tricep Kickback",
  "Cable Tricep Kickback",
  "Machine Tricep Press",
  "Tate Press",
  "JM Press",
  "Diamond Push-Up",

  // ═══════════════════════════════════════════════════════════
  // FOREARMS & GRIP
  // ═══════════════════════════════════════════════════════════
  "Wrist Curl",
  "Reverse Wrist Curl",
  "Barbell Wrist Curl",
  "Dumbbell Wrist Curl",
  "Behind-the-Back Wrist Curl",
  "Reverse Curl",
  "Farmer's Carry",
  "Plate Pinch",
  "Dead Hang",
  "Towel Pull-Up",

  // ═══════════════════════════════════════════════════════════
  // QUADS
  // ═══════════════════════════════════════════════════════════
  "Barbell Back Squat",
  "Barbell Front Squat",
  "Low-Bar Squat",
  "High-Bar Squat",
  "Goblet Squat",
  "Hack Squat",
  "Smith Machine Squat",
  "Leg Press",
  "Narrow Stance Leg Press",
  "Wide Stance Leg Press",
  "Leg Extension",
  "Bulgarian Split Squat",
  "Dumbbell Bulgarian Split Squat",
  "Lunges",
  "Barbell Lunges",
  "Dumbbell Lunges",
  "Walking Lunges",
  "Reverse Lunge",
  "Lateral Lunge",
  "Step-Up",
  "Dumbbell Step-Up",
  "Barbell Step-Up",
  "Box Jump",
  "Jump Squat",
  "Sissy Squat",
  "Wall Sit",
  "Sumo Squat",
  "Dumbbell Sumo Squat",
  "Landmine Squat",
  "Zercher Squat",
  "Safety Bar Squat",
  "Pistol Squat",
  "Assisted Pistol Squat",

  // ═══════════════════════════════════════════════════════════
  // HAMSTRINGS
  // ═══════════════════════════════════════════════════════════
  "Lying Leg Curl",
  "Seated Leg Curl",
  "Standing Leg Curl",
  "Nordic Hamstring Curl",
  "Glute-Ham Raise",
  "Good Morning",
  "Dumbbell Romanian Deadlift",
  "Single-Leg Romanian Deadlift",
  "Cable Romanian Deadlift",
  "Snatch-Grip Deadlift",
  "Leg Press (Hamstring Focus)",

  // ═══════════════════════════════════════════════════════════
  // GLUTES
  // ═══════════════════════════════════════════════════════════
  "Barbell Hip Thrust",
  "Dumbbell Hip Thrust",
  "Machine Hip Thrust",
  "Glute Bridge",
  "Single-Leg Glute Bridge",
  "Barbell Glute Bridge",
  "Cable Pull-Through",
  "Kettlebell Swing",
  "Donkey Kick",
  "Cable Donkey Kick",
  "Reverse Hyperextension",
  "Abduction Machine",
  "Cable Hip Abduction",
  "Banded Glute Kickback",
  "Lateral Band Walk",
  "Clamshell",
  "Frog Pump",
  "Sumo Deadlift (Glute Focus)",

  // ═══════════════════════════════════════════════════════════
  // CALVES
  // ═══════════════════════════════════════════════════════════
  "Standing Calf Raise",
  "Seated Calf Raise",
  "Leg Press Calf Raise",
  "Single-Leg Standing Calf Raise",
  "Donkey Calf Raise",
  "Smith Machine Calf Raise",
  "Barbell Calf Raise",
  "Dumbbell Calf Raise",
  "Tibialis Raise",
  "Jump Rope Calf Bounces",

  // ═══════════════════════════════════════════════════════════
  // ABS & CORE
  // ═══════════════════════════════════════════════════════════
  "Plank",
  "Side Plank",
  "Long-Lever Plank",
  "Plank with Hip Dip",
  "Ab Wheel Rollout",
  "Barbell Rollout",
  "Cable Crunch",
  "Rope Cable Crunch",
  "Decline Cable Crunch",
  "Crunch",
  "Decline Crunch",
  "Bicycle Crunch",
  "Reverse Crunch",
  "Sit-Up",
  "Decline Sit-Up",
  "V-Up",
  "Hanging Leg Raise",
  "Hanging Knee Raise",
  "Toes to Bar",
  "Windshield Wiper",
  "Russian Twist",
  "Weighted Russian Twist",
  "Pallof Press",
  "Cable Pallof Press",
  "Woodchop",
  "Cable Woodchop",
  "Landmine Twist",
  "Dragon Flag",
  "L-Sit",
  "Hollow Body Hold",
  "Dead Bug",
  "Mountain Climber",
  "Flutter Kick",
  "Scissor Kick",
  "Leg Raise",
  "Lying Leg Raise",

  // ═══════════════════════════════════════════════════════════
  // OLYMPIC / POWER LIFTS
  // ═══════════════════════════════════════════════════════════
  "Power Clean",
  "Hang Clean",
  "Full Clean",
  "Power Snatch",
  "Hang Snatch",
  "Clean and Jerk",
  "Clean and Press",
  "Push Jerk",
  "Split Jerk",
  "Muscle Snatch",

  // ═══════════════════════════════════════════════════════════
  // FULL BODY / FUNCTIONAL
  // ═══════════════════════════════════════════════════════════
  "Thruster",
  "Barbell Thruster",
  "Dumbbell Thruster",
  "Kettlebell Thruster",
  "Burpee",
  "Burpee Pull-Up",
  "Box Burpee",
  "Dumbbell Snatch",
  "Kettlebell Snatch",
  "Kettlebell Clean",
  "Kettlebell Clean and Press",
  "Kettlebell Turkish Get-Up",
  "Kettlebell Goblet Squat",
  "Barbell Complex",
  "Dumbbell Complex",
  "Devil's Press",
  "Man Maker",
  "Bear Complex",

  // ═══════════════════════════════════════════════════════════
  // CARRIES & LOADED CONDITIONING
  // ═══════════════════════════════════════════════════════════
  "Farmer's Walk",
  "Dumbbell Farmer's Walk",
  "Kettlebell Farmer's Walk",
  "Trap Bar Farmer's Walk",
  "Suitcase Carry",
  "Overhead Carry",
  "Waiter's Walk",
  "Zercher Carry",
  "Sandbag Carry",
  "Yoke Walk",
  "Sled Push",
  "Sled Pull",
  "Sled Row",
  "Battle Ropes",
  "Battle Rope Waves",
  "Battle Rope Slams",
  "Tire Flip",
  "Medicine Ball Slam",
  "Medicine Ball Chest Pass",
  "Medicine Ball Overhead Slam",
  "Sandbag Squat",
  "Sandbag Clean",

  // ═══════════════════════════════════════════════════════════
  // CARDIO / CONDITIONING
  // ═══════════════════════════════════════════════════════════
  "Treadmill Run",
  "Treadmill Incline Walk",
  "Stationary Bike",
  "Assault Bike",
  "Rowing Machine",
  "SkiErg",
  "Stair Climber",
  "Elliptical",
  "Jump Rope",
  "Double-Unders",
  "Box Jump",
  "Broad Jump",
  "Sprint Intervals",
  "Shuttle Run",
  "Swimming Laps",
  "Cycling",
  "Step Mill"

];

// ═══════════════════════════════════════════════════════════
// MUSCLE GROUP MAP
// ═══════════════════════════════════════════════════════════
var exerciseMuscleMap = {
  // Chest
  "Barbell Bench Press":"Chest","Incline Barbell Bench Press":"Chest","Decline Barbell Bench Press":"Chest",
  "Dumbbell Bench Press":"Chest","Incline Dumbbell Bench Press":"Chest","Decline Dumbbell Bench Press":"Chest",
  "Close-Grip Bench Press":"Chest / Triceps","Wide-Grip Bench Press":"Chest",
  "Dumbbell Flyes":"Chest","Incline Dumbbell Flyes":"Chest","Decline Dumbbell Flyes":"Chest",
  "Cable Chest Flyes":"Chest","Low Cable Flyes":"Chest","High Cable Flyes":"Chest",
  "Cable Crossover":"Chest","Pec Deck Machine":"Chest","Machine Chest Press":"Chest",
  "Smith Machine Bench Press":"Chest","Smith Machine Incline Press":"Chest",
  "Chest Dips":"Chest","Push-Up":"Chest","Wide-Grip Push-Up":"Chest",
  "Diamond Push-Up":"Triceps","Archer Push-Up":"Chest","Decline Push-Up":"Chest",
  "Incline Push-Up":"Chest","Plyometric Push-Up":"Chest","Landmine Press":"Chest",
  "Svend Press":"Chest","Squeeze Press":"Chest",
  // Back
  "Conventional Deadlift":"Back","Sumo Deadlift":"Back","Romanian Deadlift":"Hamstrings",
  "Stiff-Leg Deadlift":"Hamstrings","Deficit Deadlift":"Back","Rack Pull":"Back",
  "Trap Bar Deadlift":"Back","Barbell Row":"Back","Pendlay Row":"Back","Yates Row":"Back",
  "T-Bar Row":"Back","Dumbbell Row":"Back","Single-Arm Dumbbell Row":"Back",
  "Chest-Supported Row":"Back","Seal Row":"Back","Seated Cable Row":"Back",
  "Wide-Grip Seated Cable Row":"Back","Single-Arm Cable Row":"Back","Low Row":"Back",
  "Pull-Up":"Back","Wide-Grip Pull-Up":"Back","Neutral-Grip Pull-Up":"Back",
  "Chin-Up":"Back / Biceps","Archer Pull-Up":"Back","Weighted Pull-Up":"Back","Assisted Pull-Up":"Back",
  "Lat Pulldown":"Back","Wide-Grip Lat Pulldown":"Back","Close-Grip Lat Pulldown":"Back",
  "Reverse-Grip Lat Pulldown":"Back","Single-Arm Lat Pulldown":"Back",
  "Straight-Arm Pulldown":"Back","Kneeling Lat Pulldown":"Back",
  "Dumbbell Pullover":"Back / Chest","Cable Pullover":"Back","Back Extension":"Lower Back",
  "Hyperextension":"Lower Back","Good Morning":"Hamstrings",
  "Meadows Row":"Back","Inverted Row":"Back","TRX Row":"Back",
  // Shoulders
  "Barbell Overhead Press":"Shoulders","Seated Barbell Overhead Press":"Shoulders",
  "Dumbbell Shoulder Press":"Shoulders","Seated Dumbbell Shoulder Press":"Shoulders",
  "Arnold Press":"Shoulders","Push Press":"Shoulders","Behind-the-Neck Press":"Shoulders",
  "Smith Machine Shoulder Press":"Shoulders","Machine Shoulder Press":"Shoulders","Cable Shoulder Press":"Shoulders",
  "Lateral Raise":"Shoulders","Dumbbell Lateral Raise":"Shoulders","Cable Lateral Raise":"Shoulders",
  "Machine Lateral Raise":"Shoulders","Leaning Cable Lateral Raise":"Shoulders",
  "Front Raise":"Shoulders","Dumbbell Front Raise":"Shoulders","Barbell Front Raise":"Shoulders",
  "Cable Front Raise":"Shoulders","Plate Front Raise":"Shoulders",
  "Reverse Pec Deck":"Rear Delts","Bent-Over Lateral Raise":"Rear Delts",
  "Face Pull":"Rear Delts","Cable Face Pull":"Rear Delts","Band Face Pull":"Rear Delts",
  "Upright Row":"Shoulders / Traps","Barbell Shrugs":"Traps","Dumbbell Shrugs":"Traps",
  "Cable Shrugs":"Traps","Machine Shrugs":"Traps","Band Pull-Apart":"Rear Delts",
  "Cuban Press":"Shoulders","Y-T-W Raise":"Rear Delts",
  // Biceps
  "Barbell Bicep Curl":"Biceps","Dumbbell Bicep Curl":"Biceps","Alternating Dumbbell Curl":"Biceps",
  "Hammer Curl":"Biceps","Alternating Hammer Curl":"Biceps","Cross-Body Hammer Curl":"Biceps",
  "EZ-Bar Curl":"Biceps","EZ-Bar Preacher Curl":"Biceps","Barbell Preacher Curl":"Biceps",
  "Dumbbell Preacher Curl":"Biceps","Machine Preacher Curl":"Biceps","Concentration Curl":"Biceps",
  "Spider Curl":"Biceps","Incline Dumbbell Curl":"Biceps","Cable Bicep Curl":"Biceps",
  "Low Cable Curl":"Biceps","High Cable Curl":"Biceps","Rope Hammer Curl":"Biceps",
  "Reverse Barbell Curl":"Forearms","Reverse EZ-Bar Curl":"Forearms","Zottman Curl":"Forearms",
  "21s":"Biceps","Machine Bicep Curl":"Biceps","TRX Bicep Curl":"Biceps",
  "Drag Curl":"Biceps","Cable Concentration Curl":"Biceps",
  // Triceps
  "Tricep Dips":"Triceps","Bench Dips":"Triceps","Skull Crusher":"Triceps",
  "EZ-Bar Skull Crusher":"Triceps","Dumbbell Skull Crusher":"Triceps","Cable Skull Crusher":"Triceps",
  "Overhead Tricep Extension":"Triceps","Dumbbell Overhead Tricep Extension":"Triceps",
  "EZ-Bar Overhead Tricep Extension":"Triceps","Cable Overhead Tricep Extension":"Triceps",
  "Rope Overhead Extension":"Triceps","Cable Tricep Pushdown":"Triceps","Rope Pushdown":"Triceps",
  "Straight Bar Pushdown":"Triceps","Reverse Grip Pushdown":"Triceps","Single-Arm Cable Pushdown":"Triceps",
  "Tricep Kickback":"Triceps","Dumbbell Tricep Kickback":"Triceps","Cable Tricep Kickback":"Triceps",
  "Machine Tricep Press":"Triceps","Tate Press":"Triceps","JM Press":"Triceps",
  // Forearms
  "Wrist Curl":"Forearms","Reverse Wrist Curl":"Forearms","Barbell Wrist Curl":"Forearms",
  "Dumbbell Wrist Curl":"Forearms","Behind-the-Back Wrist Curl":"Forearms",
  "Reverse Curl":"Forearms","Farmer's Carry":"Forearms / Grip","Plate Pinch":"Forearms",
  "Dead Hang":"Forearms / Grip","Towel Pull-Up":"Forearms",
  // Quads
  "Barbell Back Squat":"Quads","Barbell Front Squat":"Quads","Low-Bar Squat":"Quads",
  "High-Bar Squat":"Quads","Goblet Squat":"Quads","Hack Squat":"Quads",
  "Smith Machine Squat":"Quads","Leg Press":"Quads","Narrow Stance Leg Press":"Quads",
  "Wide Stance Leg Press":"Quads","Leg Extension":"Quads","Bulgarian Split Squat":"Quads",
  "Dumbbell Bulgarian Split Squat":"Quads","Lunges":"Quads","Barbell Lunges":"Quads",
  "Dumbbell Lunges":"Quads","Walking Lunges":"Quads","Reverse Lunge":"Quads",
  "Lateral Lunge":"Quads","Step-Up":"Quads","Dumbbell Step-Up":"Quads","Barbell Step-Up":"Quads",
  "Box Jump":"Quads","Jump Squat":"Quads","Sissy Squat":"Quads","Wall Sit":"Quads",
  "Sumo Squat":"Quads / Glutes","Dumbbell Sumo Squat":"Quads / Glutes",
  "Landmine Squat":"Quads","Zercher Squat":"Quads","Safety Bar Squat":"Quads",
  "Pistol Squat":"Quads","Assisted Pistol Squat":"Quads",
  // Hamstrings
  "Lying Leg Curl":"Hamstrings","Seated Leg Curl":"Hamstrings","Standing Leg Curl":"Hamstrings",
  "Nordic Hamstring Curl":"Hamstrings","Glute-Ham Raise":"Hamstrings / Glutes",
  "Dumbbell Romanian Deadlift":"Hamstrings","Single-Leg Romanian Deadlift":"Hamstrings",
  "Cable Romanian Deadlift":"Hamstrings","Snatch-Grip Deadlift":"Hamstrings / Back",
  "Leg Press (Hamstring Focus)":"Hamstrings","Stiff-Leg Deadlift":"Hamstrings",
  // Glutes
  "Barbell Hip Thrust":"Glutes","Dumbbell Hip Thrust":"Glutes","Machine Hip Thrust":"Glutes",
  "Glute Bridge":"Glutes","Single-Leg Glute Bridge":"Glutes","Barbell Glute Bridge":"Glutes",
  "Cable Pull-Through":"Glutes","Kettlebell Swing":"Glutes","Donkey Kick":"Glutes",
  "Cable Donkey Kick":"Glutes","Reverse Hyperextension":"Glutes","Abduction Machine":"Glutes",
  "Cable Hip Abduction":"Glutes","Banded Glute Kickback":"Glutes","Lateral Band Walk":"Glutes",
  "Clamshell":"Glutes","Frog Pump":"Glutes","Sumo Deadlift (Glute Focus)":"Glutes",
  // Calves
  "Standing Calf Raise":"Calves","Seated Calf Raise":"Calves","Leg Press Calf Raise":"Calves",
  "Single-Leg Standing Calf Raise":"Calves","Donkey Calf Raise":"Calves",
  "Smith Machine Calf Raise":"Calves","Barbell Calf Raise":"Calves",
  "Dumbbell Calf Raise":"Calves","Tibialis Raise":"Calves","Jump Rope Calf Bounces":"Calves",
  // Core
  "Plank":"Core","Side Plank":"Core","Long-Lever Plank":"Core","Plank with Hip Dip":"Core",
  "Ab Wheel Rollout":"Core","Barbell Rollout":"Core","Cable Crunch":"Abs",
  "Rope Cable Crunch":"Abs","Decline Cable Crunch":"Abs","Crunch":"Abs","Decline Crunch":"Abs",
  "Bicycle Crunch":"Abs","Reverse Crunch":"Abs","Sit-Up":"Abs","Decline Sit-Up":"Abs",
  "V-Up":"Abs","Hanging Leg Raise":"Abs","Hanging Knee Raise":"Abs","Toes to Bar":"Abs",
  "Windshield Wiper":"Abs","Russian Twist":"Abs","Weighted Russian Twist":"Abs",
  "Pallof Press":"Core","Cable Pallof Press":"Core","Woodchop":"Core","Cable Woodchop":"Core",
  "Landmine Twist":"Core","Dragon Flag":"Abs","L-Sit":"Core","Hollow Body Hold":"Core",
  "Dead Bug":"Core","Mountain Climber":"Core","Flutter Kick":"Abs",
  "Scissor Kick":"Abs","Leg Raise":"Abs","Lying Leg Raise":"Abs",
  // Olympic
  "Power Clean":"Full Body","Hang Clean":"Full Body","Full Clean":"Full Body",
  "Power Snatch":"Full Body","Hang Snatch":"Full Body","Clean and Jerk":"Full Body",
  "Clean and Press":"Full Body","Push Jerk":"Full Body","Split Jerk":"Full Body","Muscle Snatch":"Full Body",
  // Full Body
  "Thruster":"Full Body","Barbell Thruster":"Full Body","Dumbbell Thruster":"Full Body",
  "Kettlebell Thruster":"Full Body","Burpee":"Full Body","Burpee Pull-Up":"Full Body",
  "Box Burpee":"Full Body","Dumbbell Snatch":"Full Body","Kettlebell Snatch":"Full Body",
  "Kettlebell Clean":"Full Body","Kettlebell Clean and Press":"Full Body",
  "Kettlebell Turkish Get-Up":"Full Body","Kettlebell Goblet Squat":"Quads",
  "Barbell Complex":"Full Body","Dumbbell Complex":"Full Body","Devil's Press":"Full Body",
  "Man Maker":"Full Body","Bear Complex":"Full Body",
  // Carries
  "Farmer's Walk":"Forearms / Core","Dumbbell Farmer's Walk":"Forearms / Core",
  "Kettlebell Farmer's Walk":"Forearms / Core","Trap Bar Farmer's Walk":"Forearms / Core",
  "Suitcase Carry":"Core","Overhead Carry":"Shoulders","Waiter's Walk":"Shoulders",
  "Zercher Carry":"Core","Sandbag Carry":"Full Body","Yoke Walk":"Full Body",
  "Sled Push":"Full Body","Sled Pull":"Full Body","Sled Row":"Back",
  "Battle Ropes":"Full Body","Battle Rope Waves":"Full Body","Battle Rope Slams":"Full Body",
  "Tire Flip":"Full Body","Medicine Ball Slam":"Full Body","Medicine Ball Chest Pass":"Chest",
  "Medicine Ball Overhead Slam":"Full Body","Sandbag Squat":"Quads","Sandbag Clean":"Full Body",
  // Cardio
  "Treadmill Run":"Cardio","Treadmill Incline Walk":"Cardio","Stationary Bike":"Cardio",
  "Assault Bike":"Cardio","Rowing Machine":"Cardio","SkiErg":"Cardio","Stair Climber":"Cardio",
  "Elliptical":"Cardio","Jump Rope":"Cardio","Double-Unders":"Cardio",
  "Broad Jump":"Legs","Sprint Intervals":"Cardio","Shuttle Run":"Cardio",
  "Swimming Laps":"Cardio","Cycling":"Cardio","Step Mill":"Cardio"
};

// ═══════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════

function getExerciseMuscle(name) {
  return exerciseMuscleMap[(name||'').trim()] || '';
}

function searchExercises(query) {
  if (!query || query.length < 1) return [];
  var q = query.trim().toLowerCase();
  // Prioritise starts-with matches, then contains
  var starts = [], contains = [];
  commonExercises.forEach(function(e) {
    var el = e.toLowerCase();
    if (el.startsWith(q))      starts.push(e);
    else if (el.includes(q))   contains.push(e);
  });
  return starts.concat(contains).slice(0, 10);
}
// ── HELPER: get muscle group for any exercise name ──────────
function getExerciseMuscle(name) {
  if (!name) return '';
  var key = name.trim();
  return exerciseMuscleMap[key] || '';
}

// ── HELPER: fuzzy search / autocomplete ────────────────────
function searchExercises(query) {
  if (!query || query.length < 1) return [];
  var q = query.trim().toLowerCase();
  return commonExercises.filter(function(e) {
    return e.toLowerCase().includes(q);
  }).slice(0, 8); // return top 8 matches
}

  function refreshExerciseSuggestions() {
    var namesSet = {};
    commonExercises.forEach(function(n) { namesSet[n] = true; });
    Object.keys(data).forEach(function(k) {
      (data[k] || []).forEach(function(e) {
        // Title-case whatever the user previously typed, so it shows up nicely too
        var n = e.name.trim();
        if (n) namesSet[n] = true;
      });
    });
    var list = Object.keys(namesSet).sort();
    var dl = document.getElementById('exerciseSuggestions');
    dl.innerHTML = list.map(function(n) {
      return '<option value="' + n.replace(/"/g, '&quot;') + '">';
    }).join('');
  }
  refreshExerciseSuggestions();

  /* ---------- NAV (matches calorie.jsp) ---------- */
  function toggleNav() {
    var open = document.getElementById('navDropdown').classList.toggle('open');
    document.getElementById('hamBtn').classList.toggle('open', open);
    document.getElementById('navOverlay').classList.toggle('open', open);
  }
  function closeNav() {
    document.getElementById('navDropdown').classList.remove('open');
    document.getElementById('hamBtn').classList.remove('open');
    document.getElementById('navOverlay').classList.remove('open');
  }

  /* ---------- LOGOUT ----------
     Must POST (the servlet only handles action=logout in doPost, not doGet) */
  function logout() {
    closeNav();
    if (!confirm('Log out of GoFit?')) return;
    var f = document.createElement('form');
    f.method = 'POST'; f.action = 'GoFit';
    var i = document.createElement('input');
    i.type = 'hidden'; i.name = 'action'; i.value = 'logout';
    f.appendChild(i);
    document.body.appendChild(f);
    f.submit();
  }

  /* ---------- DATE ----------
     Parse/format SELECTED_DATE (yyyy-MM-dd) as a LOCAL date, not UTC, to avoid
     off-by-one near midnight in some timezones. */
  function parseLocalDate(str) {
    var parts = str.split('-');
    return new Date(parseInt(parts[0],10), parseInt(parts[1],10)-1, parseInt(parts[2],10));
  }
  function formatLocalDate(d) {
    return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
  }
  function getDate(offset) {
    var d = parseLocalDate(SELECTED_DATE);
    d.setDate(d.getDate() + offset);
    return d;
  }
  function getKey(d) {
    return formatLocalDate(d);
  }
  function updateDate() {
    var d = parseLocalDate(SELECTED_DATE);
    var yestDate = new Date(); yestDate.setDate(yestDate.getDate()-1);
    var yestStr  = formatLocalDate(yestDate);
    var label = IS_TODAY ? "Today" : (SELECTED_DATE === yestStr ? "Yesterday" : d.toDateString());
    document.getElementById("dateLabel").innerText = label;
    document.getElementById("btnNext").disabled    = IS_TODAY;
  }

  /* ---------- NAV ----------
     Navigating a day now reloads the page from the server with ?date=..., so
     past days show real logged data instead of an always-empty client stand-in. */
  function changeDay(dir) {
    var d = getDate(dir);
    var newDateStr = formatLocalDate(d);
    var todayStr   = formatLocalDate(new Date());
    if (newDateStr > todayStr) return; // block future dates
    window.location.href = 'GoFit?page=workout&date=' + newDateStr;
  }

  /* ---------- e1RM (Epley formula) ---------- */
  function calcE1rm(weight, reps) {
    weight = parseFloat(weight) || 0;
    reps   = parseInt(reps)     || 1;
    if (weight <= 0) return 0;
    if (reps === 1)  return weight;
    return Math.round(weight * (1 + reps / 30) * 10) / 10;
  }

  /* ---------- get ALL history for an exercise ---------- */
  function getHistory(name) {
    var norm = name.trim().toLowerCase();
    var out  = [];
    Object.keys(data).forEach(function(k) {
      (data[k] || []).forEach(function(e) {
        if (e.name.trim().toLowerCase() === norm) {
          var w = parseFloat(e.weight) || 0;
          var r = parseInt(e.reps)     || 1;
          out.push({ date: k, weight: w, reps: r, rm: calcE1rm(w, r) });
        }
      });
    });
    return out.sort(function(a, b) { return a.date.localeCompare(b.date); });
  }

  /* ---------- best e1RM across ALL history ---------- */
  function bestRm(name) {
    var h = getHistory(name);
    if (!h.length) return 0;
    return Math.max.apply(null, h.map(function(x) { return x.rm; }));
  }

  /* ---------- ADD ----------
     Exercise entry is now a real <form> (see Log Exercise card) that POSTs straight
     to GoFit?action=addExercise and reloads with fresh DB data. */

  /* ---------- DELETE ---------- */
  function deleteExercise(id, event) {
    event.stopPropagation();
    if (!id) return; // not-yet-saved items can't be deleted server-side
    fetch(contextPath + '/GoFit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'action=deleteExercise&id=' + encodeURIComponent(id)
    }).then(function(res){
      if (!res.ok) throw new Error('Server returned ' + res.status);
      location.reload();
    }).catch(function(err){ alert('Could not delete: ' + err.message); });
  }

  /* ---------- RENDER ---------- */
  function render() {
    var key  = getKey(getDate(dayOffset));
    var list = data[key] || [];
    var html = "";

    document.getElementById("itemCount").innerText = list.length + " exercises";

    if (list.length === 0) {
      html = "<div class='empty'>No exercises yet — add one above!</div>";
    } else {
      for (var i = 0; i < list.length; i++) {
        var e    = list[i];
        var w    = parseFloat(e.weight) || 0;
        var rm   = calcE1rm(w, e.reps);
        var best = bestRm(e.name);
        var isPR = w > 0 && rm > 0 && rm >= best;
        var safe = e.name.replace(/\\/g, "\\\\").replace(/'/g, "\\'");

        html += "<div class='exercise-item' onclick=\"openModal('" + safe + "')\">";
        html += "  <div class='ex-dot'></div>";
        html += "  <div class='ex-info'>";
        html += "    <div class='ex-name-row'>";
        html += "      <span class='ex-name'>" + e.name + "</span>";
        if (isPR) html += " <span class='pr-badge'>🏆 PR</span>";
        if (w > 0) html += " <span class='e1rm-tag'>e1RM " + rm + "kg</span>";
        html += "    </div>";
        html += "    <div class='ex-detail'>" + e.reps + " reps @ " + w + "kg</div>";
        html += "  </div>";
        if (e.id) html += "  <button class='btn-delete' onclick='deleteExercise(" + e.id + ", event)'>&#10005;</button>";
        html += "</div>";
      }
    }

    document.getElementById("list").innerHTML = html;
  }

  /* ---------- MODAL ---------- */
  function openModal(name) {
    var allHistory = getHistory(name);

    /* stats always use ALL history */
    var allW  = allHistory.map(function(h) { return h.weight; });
    var allRM = allHistory.map(function(h) { return h.rm; });
    var bestW = allW.length  ? Math.max.apply(null, allW)  : 0;
    var bestR = allRM.length ? Math.max.apply(null, allRM) : 0;

    document.getElementById("modalTitle").innerText = name;
    document.getElementById("modalStats").innerHTML =
      "<div class='mstat'><div class='mstat-label'>Best Weight</div><div class='mstat-val green'>" + bestW + " kg</div></div>" +
      "<div class='mstat'><div class='mstat-label'>Best e1RM</div><div class='mstat-val gold'>"   + bestR + " kg</div></div>" +
      "<div class='mstat'><div class='mstat-label'>Sessions</div><div class='mstat-val'>"         + allHistory.length + "</div></div>";

    /* chart = last 10 sessions only */
    var chartHistory = allHistory.slice(-10);
    var total        = allHistory.length;
    var noteEl       = document.getElementById("chartNote");
    noteEl.innerText = total > 10
      ? "Showing last " + chartHistory.length + " of " + total + " sessions"
      : "";

    /* history list = last 10, newest first */
    var hHtml = "";
    if (!allHistory.length) {
      hHtml = "<div class='no-history'>No history yet</div>";
    } else {
      allHistory.slice(-10).reverse().forEach(function(h) {
        var isPR = h.rm > 0 && h.rm === bestR;
        hHtml += "<div class='history-row'>";
        hHtml += "<span class='history-date'>" + h.date + "</span>";
        hHtml += "<div class='history-vals'>";
        hHtml += "<span>" + h.reps + " reps @ " + h.weight + "kg</span>";
        if (h.rm > 0) hHtml += "<span style='color:#60a5fa'>e1RM " + h.rm + "kg</span>";
        if (isPR)     hHtml += "<span class='pr-row-badge'>🏆 PR</span>";
        hHtml += "</div></div>";
      });
    }
    document.getElementById("historyList").innerHTML = hHtml;

    document.getElementById("modalOverlay").style.display = "flex";

    /* draw chart after modal is visible so canvas has dimensions */
    setTimeout(function() {
      if (chartInst) { chartInst.destroy(); chartInst = null; }

      var labels   = chartHistory.map(function(h) {
        var d = new Date(h.date + "T12:00:00");
        return (d.getMonth() + 1) + "/" + d.getDate();
      });
      var wData    = chartHistory.map(function(h) { return h.weight; });
      var rmData   = chartHistory.map(function(h) { return h.rm; });
      var ptColors = wData.map(function(v) { return v === bestW ? "#fbbf24" : "#4ade80"; });
      var ptSizes  = wData.map(function(v) { return v === bestW ? 7 : 4; });

      chartInst = new Chart(document.getElementById("prChart"), {
        type: "line",
        data: {
          labels: labels,
          datasets: [
            {
              label: "Weight (kg)",
              data: wData,
              borderColor: "#4ade80",
              backgroundColor: "rgba(74,222,128,0.12)",
              fill: true,
              tension: 0.35,
              pointBackgroundColor: ptColors,
              pointBorderColor: ptColors,
              pointRadius: ptSizes,
              yAxisID: "y"
            },
            {
              label: "Est. 1RM (kg)",
              data: rmData,
              borderColor: "#60a5fa",
              backgroundColor: "transparent",
              fill: false,
              tension: 0.35,
              borderDash: [5, 4],
              pointBackgroundColor: "#60a5fa",
              pointBorderColor: "#60a5fa",
              pointRadius: 3,
              yAxisID: "y"
            }
          ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              backgroundColor: "#0d1520",
              borderColor: "rgba(255,255,255,0.1)",
              borderWidth: 1,
              titleColor: "#f0f4f8",
              bodyColor: "#5a7291",
              callbacks: {
                label: function(ctx) { return ctx.dataset.label + ": " + ctx.parsed.y + " kg"; }
              }
            }
          },
          scales: {
            x: {
              ticks: { color: "#5a7291", font: { size: 11 } },
              grid:  { color: "rgba(255,255,255,0.04)" },
              border:{ color: "rgba(255,255,255,0.07)" }
            },
            y: {
              min: 0,
              ticks: { color: "#5a7291", font: { size: 11 } },
              grid:  { color: "rgba(255,255,255,0.06)" },
              border:{ color: "rgba(255,255,255,0.07)" }
            }
          }
        }
      });
    }, 60);
  }

  function closeModal() {
    document.getElementById("modalOverlay").style.display = "none";
    if (chartInst) { chartInst.destroy(); chartInst = null; }
  }
  function handleOverlayClick(e) {
    if (e.target === document.getElementById("modalOverlay")) closeModal();
  }

  /* ---------- INIT ---------- */
  updateDate();
  render();

</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>

</body>
</html>
