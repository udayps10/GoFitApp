<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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

  /* ---- NAVBAR ---- */
  nav {
    background: #0b1220;
    border-bottom: 1px solid rgba(255,255,255,0.07);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 24px;
    height: 58px;
  }
  .logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-family: 'DM Serif Display', serif;
    font-size: 1.2rem;
  }
  .logo-box {
    width: 32px;
    height: 32px;
    background: #4ade80;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
  }
  .nav-badge {
    font-size: 0.72rem;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: #4ade80;
    background: rgba(74,222,128,0.1);
    border: 1px solid rgba(74,222,128,0.25);
    padding: 4px 12px;
    border-radius: 20px;
  }

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

<!-- NAVBAR -->
<nav>
  <div class="logo">
    <div class="logo-box">💪</div>
    GoFit
  </div>
  <div class="nav-badge">Workouts</div>
</nav>

<!-- MAIN -->
<main>

  <h1 class="page-title">GoFit 🏋️</h1>
  <p class="page-sub">Track your workouts</p>

  <!-- DATE NAV -->
  <div class="card">
    <div class="date-row">
      <button class="arrow-btn" onclick="changeDay(-1)">&#8249;</button>
      <span id="dateLabel"></span>
      <button class="arrow-btn" id="btnNext" onclick="changeDay(1)">&#8250;</button>
    </div>
  </div>

  <!-- AI INSIGHT CARD -->
  <div class="ai-insight-card" id="aiInsightCard">
    <div class="ai-halfway-banner" id="halfwayBanner">💪 Halfway there! You got this!</div>
    <div class="ai-insight-header">
      <div class="ai-insight-icon">🤖</div>
      <div class="ai-insight-title-block">
        <div class="ai-insight-label">AI Insight</div>
        <div class="ai-insight-subtitle">Personalised for today</div>
      </div>
    </div>
    <div class="ai-insight-text" id="aiInsightText">
      Start logging your meals to get personalised AI recommendations for the day.
    </div>
    <div class="ai-insight-chips" id="aiInsightChips">
      <div class="ai-chip" onclick="quickLog('2 eggs + toast','1 plate',280,30,16,10)">
        <span class="ai-chip-emoji">🥚</span> 2 eggs + toast ~280 kcal
      </div>
      <div class="ai-chip" onclick="quickLog('Rice + dal','1 bowl',420,60,18,8)">
        <span class="ai-chip-emoji">🍛</span> Rice + dal ~420 kcal
      </div>
      <div class="ai-chip" onclick="quickLog('Peanut butter + banana','1 serving',310,38,10,13)">
        <span class="ai-chip-emoji">🥜</span> Peanut butter + banana
      </div>
    </div>
  </div>

  <!-- ADD -->
  <div class="card">
    <div class="card-label">Log Exercise</div>

    <div class="input-labels">
      <span class="name-lbl">Exercise</span>
      <span>kg</span>
      <span>Reps</span>
    </div>

    <div class="input-row">
      <input id="name"   placeholder="e.g. Bench Press" style="flex:2">
      <input id="weight" type="number" value="0">
      <input id="reps"   type="number" value="10">
    </div>

    <button class="btn-add" onclick="addExercise()">+ Add Exercise</button>
  </div>

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
  var data      = {};
  var dayOffset = 0;
  var today     = new Date();
  var chartInst = null;

  /* ---------- DATE ---------- */
  function getDate(offset) {
    var d = new Date();
    d.setDate(d.getDate() + offset);
    return d;
  }
  function getKey(d) {
    return d.toISOString().split("T")[0];
  }
  function updateDate() {
    var d     = getDate(dayOffset);
    var label = dayOffset === 0  ? "Today"
              : dayOffset === -1 ? "Yesterday"
              : d.toDateString();
    document.getElementById("dateLabel").innerText = label;
    document.getElementById("btnNext").disabled    = (dayOffset === 0);
  }

  /* ---------- NAV ---------- */
  function changeDay(dir) {
    if (dayOffset + dir > 0) return;
    dayOffset += dir;
    updateDate();
    render();
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

  /* ---------- ADD ---------- */
  function addExercise() {
    var name = document.getElementById("name").value.trim();
    if (!name) { document.getElementById("name").focus(); return; }

    var reps   = document.getElementById("reps").value;
    var weight = document.getElementById("weight").value;

    var key = getKey(getDate(dayOffset));
    if (!data[key]) { data[key] = []; }
    data[key].push({ name: name, reps: reps, weight: weight });

    document.getElementById("name").value = "";
    render();
  }

  /* ---------- DELETE ---------- */
  function deleteExercise(index, event) {
    event.stopPropagation();
    var key = getKey(getDate(dayOffset));
    if (!data[key]) return;
    data[key].splice(index, 1);
    render();
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
        html += "  <button class='btn-delete' onclick='deleteExercise(" + i + ", event)'>&#10005;</button>";
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