<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Uday Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #0b0f14;
    --bg2: #131820;
    --bg3: #1a2030;
    --card: #161c26;
    --border: rgba(255,255,255,0.07);
    --border2: rgba(255,255,255,0.12);
    --green: #22c55e;
    --green-dim: #16a34a;
    --green-bg: rgba(34,197,94,0.08);
    --orange: #f97316;
    --purple: #a855f7;
    --purple-bg: rgba(168,85,247,0.07);
    --purple-border: rgba(168,85,247,0.18);
    --text: #e8edf4;
    --muted: #7a8fa8;
    --hint: #4a5568;
    --r-sm: 8px;
    --r-md: 12px;
    --r-lg: 16px;
    --r-xl: 20px;
  }

  * { margin:0; padding:0; box-sizing:border-box; }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Sans', sans-serif;
    min-height: 100vh;
    padding: 0 0 80px;
  }

  .dash {
    max-width: 900px;
    margin: 0 auto;
    padding: 0 20px;
  }

  /* ---- HEADER ---- */
  .hdr {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24px 0 18px;
    flex-wrap: wrap;
    gap: 12px;
  }
  .hdr-left h1 { font-size: 24px; font-weight: 600; letter-spacing: -0.3px; }
  .hdr-left p { color: var(--muted); font-size: 13px; margin-top: 3px; }

  /* ---- DATE NAV ---- */
  .date-nav {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--r-lg);
    padding: 13px 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16px;
  }
  .dn-center { text-align: center; }
  .dn-label { font-size: 15px; font-weight: 600; }
  .dn-sub { font-size: 12px; color: var(--muted); margin-top: 2px; }
  .dn-btn {
    background: var(--bg3);
    border: 1px solid var(--border);
    color: var(--text);
    width: 34px; height: 34px;
    border-radius: var(--r-sm);
    cursor: pointer;
    font-size: 18px;
    display: flex; align-items: center; justify-content: center;
    transition: background 0.15s;
    font-family: inherit;
  }
  .dn-btn:hover:not(:disabled) { background: var(--border2); }
  .dn-btn:disabled { opacity: 0.25; cursor: not-allowed; }

  /* ---- PAST NOTICE ---- */
  .past-notice {
    background: var(--purple-bg);
    border: 1px solid var(--purple-border);
    border-radius: var(--r-md);
    padding: 10px 14px;
    font-size: 13px;
    color: #c084fc;
    margin-bottom: 16px;
    display: none;
  }

  /* ---- STATS GRID ---- */
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
    margin-bottom: 16px;
  }
  .stat-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--r-lg);
    padding: 14px 12px;
    text-align: center;
  }
  .stat-icon { font-size: 18px; margin-bottom: 6px; display: block; }
  .stat-val { font-size: 20px; font-weight: 700; line-height: 1; }
  .stat-sub { font-size: 11px; color: var(--muted); margin-top: 3px; }
  .stat-bar { height: 4px; background: var(--bg3); border-radius: 99px; margin: 8px 0 4px; overflow: hidden; }
  .stat-bar-fill { height: 100%; background: var(--green); border-radius: 99px; transition: width 0.6s ease; }
  .stat-lbl { font-size: 11px; color: var(--hint); }

  /* ---- GOAL CARD ---- */
  .goal-card {
    background: var(--card);
    border: 1px solid rgba(34,197,94,0.25);
    border-left: 3px solid var(--green);
    border-radius: var(--r-xl);
    padding: 18px 20px;
    margin-bottom: 16px;
  }
  .goal-title { font-size: 11px; font-weight: 600; color: var(--green); text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 8px; }
  .goal-nums { font-size: 28px; font-weight: 700; }
  .goal-nums span { font-size: 14px; color: var(--muted); font-weight: 400; }
  .goal-rem { font-size: 13px; color: var(--muted); margin: 4px 0 10px; }
  .goal-bar { height: 8px; background: var(--bg3); border-radius: 99px; overflow: hidden; margin-bottom: 12px; }
  .goal-bar-fill { height: 100%; background: var(--green); border-radius: 99px; transition: width 0.8s cubic-bezier(.4,0,.2,1); }
  .goal-msg { background: var(--bg3); border-radius: var(--r-sm); padding: 9px 13px; font-size: 13px; color: var(--text); }

  /* ---- AI INSIGHT ---- */
  .ai-card {
    background: var(--purple-bg);
    border: 1px solid var(--purple-border);
    border-radius: var(--r-lg);
    padding: 16px;
  }
  .ai-hdr { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
  .ai-icon {
    background: rgba(168,85,247,0.15);
    border-radius: var(--r-sm);
    width: 34px; height: 34px;
    display: flex; align-items: center; justify-content: center;
    font-size: 16px; flex-shrink: 0;
    border: 1px solid rgba(168,85,247,0.2);
  }
  .ai-lbl { font-size: 11px; font-weight: 600; color: var(--purple); letter-spacing: 0.5px; text-transform: uppercase; }
  .ai-sublbl { font-size: 12px; color: var(--muted); margin-top: 1px; }
  .ai-body { font-size: 13px; color: var(--muted); line-height: 1.65; margin-bottom: 10px; }
  .ai-pills { display: flex; gap: 7px; flex-wrap: wrap; }
  .ai-pill {
    background: rgba(168,85,247,0.1);
    border: 1px solid rgba(168,85,247,0.18);
    border-radius: var(--r-sm);
    padding: 5px 10px;
    font-size: 12px;
    color: #c084fc;
  }

  /* ---- SECTION CARD ---- */
  .section-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--r-xl);
    padding: 18px 20px;
    margin-bottom: 16px;
  }
  .section-title { font-size: 15px; font-weight: 600; margin-bottom: 14px; }

  /* ---- ACTIONS ---- */
  .actions-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px; }
  .action-btn {
    background: var(--bg3);
    border: 1px solid var(--border);
    border-radius: var(--r-lg);
    padding: 14px 8px;
    text-align: center;
    cursor: pointer;
    transition: all 0.15s;
    color: var(--text);
  }
  .action-btn:hover { border-color: rgba(34,197,94,0.4); background: rgba(34,197,94,0.05); }
  .action-btn:disabled, .action-btn.disabled { opacity: 0.35; pointer-events: none; }
  .action-icon { font-size: 18px; display: block; margin-bottom: 5px; }
  .action-lbl { font-size: 12px; color: var(--muted); }

  /* ---- FOOD ITEMS ---- */
  .food-item {
    background: var(--bg3);
    border: 1px solid var(--border);
    border-radius: var(--r-md);
    padding: 11px 13px;
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 6px;
  }
  .fi-name { font-size: 14px; }
  .fi-cal { font-size: 12px; color: var(--green); margin-top: 2px; }
  .rm-btn { background: none; border: none; color: var(--hint); cursor: pointer; font-size: 20px; line-height: 1; transition: color 0.15s; }
  .rm-btn:hover { color: #ef4444; }
  .empty-msg { color: var(--hint); font-size: 13px; font-style: italic; padding: 4px 0; }

  /* ---- WORKOUT ITEMS ---- */
  .ex-item {
    background: var(--bg3);
    border: 1px solid var(--border);
    border-left: 3px solid transparent;
    border-radius: var(--r-md);
    padding: 11px 13px;
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 6px;
    transition: all 0.25s ease;
  }
  .ex-item.done {
    background: linear-gradient(to right, rgba(34,197,94,0.08), var(--bg3) 60%);
    border-color: rgba(34,197,94,0.25);
    border-left-color: var(--green);
  }
  .ex-info { flex: 1; }
  .ex-name { font-size: 14px; font-weight: 500; transition: color 0.2s; }
  .ex-item.done .ex-name { color: var(--green); }
  .ex-det { font-size: 12px; color: var(--muted); margin-top: 2px; }
  .ex-right { display: flex; align-items: center; gap: 8px; }
  .done-btn {
    border: 1px solid var(--border);
    background: var(--bg);
    color: var(--muted);
    border-radius: 20px;
    padding: 6px 14px;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    font-family: inherit;
    white-space: nowrap;
  }
  .done-btn:hover { background: var(--border2); }
  .done-btn.is-done { 
    background: var(--green); 
    border-color: var(--green); 
    color: #060d08; 
    font-weight: 700;
    box-shadow: 0 2px 10px rgba(34,197,94,0.25);
  }
  .done-btn.is-done:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(34,197,94,0.35); }

  /* ---- ADD BTN ---- */
  .add-btn {
    width: 100%;
    background: var(--green);
    border: none;
    border-radius: var(--r-md);
    color: #060d08;
    font-family: inherit;
    font-size: 14px;
    font-weight: 600;
    padding: 12px;
    cursor: pointer;
    transition: all 0.15s;
    margin-top: 8px;
    display: flex; align-items: center; justify-content: center; gap: 6px;
  }
  .add-btn:hover { background: var(--green-dim); }
  .add-btn:disabled { opacity: 0.35; cursor: not-allowed; }

  /* ---- BODY STATS ---- */
  .body-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    margin-bottom: 16px;
  }
  .body-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: var(--r-xl);
    padding: 18px 20px;
  }
  .body-card-title { font-size: 14px; font-weight: 600; margin-bottom: 14px; }
  .body-val-row { display: flex; align-items: center; justify-content: space-between; }
  .body-val { font-size: 32px; font-weight: 700; }
  .body-val small { font-size: 14px; color: var(--muted); font-weight: 400; }
  .upd-btn {
    background: var(--green);
    border: none;
    color: #060d08;
    font-family: inherit;
    font-weight: 600;
    padding: 9px 16px;
    border-radius: var(--r-md);
    cursor: pointer;
    font-size: 13px;
    transition: background 0.15s;
  }
  .upd-btn:hover { background: var(--green-dim); }
  .bmi-section { margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border); }
  .bmi-lbl { font-size: 11px; color: var(--hint); margin-bottom: 4px; }
  .bmi-val { font-size: 20px; font-weight: 700; color: var(--green); }
  .bmi-cat { font-size: 11px; color: var(--muted); margin-top: 2px; }
  .bmi-hint { font-size: 13px; color: var(--muted); line-height: 1.5; margin-top: 4px; }

  /* ---- MODAL ---- */
  .modal-overlay {
    display: none;
    position: fixed; inset: 0;
    background: rgba(0,0,0,0.65);
    z-index: 200;
    align-items: center; justify-content: center;
    padding: 16px;
  }
  .modal-overlay.open { display: flex; }
  .modal {
    background: var(--bg2);
    border: 1px solid var(--border2);
    border-radius: var(--r-xl);
    padding: 22px;
    width: 100%; max-width: 370px;
    max-height: 90vh; overflow-y: auto;
  }
  .modal h3 { font-size: 17px; font-weight: 600; margin-bottom: 16px; }
  .modal input, .modal select {
    width: 100%;
    background: var(--bg3);
    border: 1px solid var(--border2);
    border-radius: var(--r-md);
    color: var(--text);
    padding: 11px 13px;
    font-family: inherit;
    font-size: 14px;
    margin-bottom: 10px;
    outline: none;
  }
  .modal input:focus { border-color: var(--green); }
  .modal-actions { display: flex; gap: 10px; margin-top: 6px; }
  .modal-actions button {
    flex: 1; padding: 11px;
    border-radius: var(--r-md);
    font-family: inherit; font-weight: 600; font-size: 14px;
    cursor: pointer; border: none; transition: opacity 0.15s;
  }
  .modal-actions button:hover { opacity: 0.85; }
  .btn-cancel { background: var(--bg3); color: var(--muted); border: 1px solid var(--border) !important; }
  .btn-save { background: var(--green); color: #060d08; }

  /* ---- SCAN TABS ---- */
  .scan-tab-row { display: flex; gap: 8px; margin-bottom: 14px; }
  .scan-tab {
    flex: 1; padding: 8px;
    background: var(--bg3); border: 1px solid var(--border);
    border-radius: var(--r-md); color: var(--muted);
    font-family: inherit; font-size: 12px; cursor: pointer;
    transition: all 0.15s;
  }
  .scan-tab.active { background: var(--green-bg); border-color: rgba(34,197,94,0.35); color: var(--green); }
  .cam-area {
    background: #070c12;
    border: 1px dashed rgba(34,197,94,0.18);
    border-radius: var(--r-lg); overflow: hidden;
    position: relative;
    min-height: 160px;
    display: flex; align-items: center; justify-content: center;
    margin-bottom: 10px;
  }
  .cam-ph { text-align: center; color: var(--hint); padding: 24px 16px; }
  .cam-ph .cam-icon { font-size: 24px; margin-bottom: 8px; display: block; }
  .cam-ph p { font-size: 12px; line-height: 1.5; }
  .cam-area video { width: 100%; max-height: 200px; object-fit: cover; display: none; }
  .cam-area canvas { display: none; }
  .cam-area img { width: 100%; max-height: 200px; object-fit: cover; display: none; }
  .live-dot { position: absolute; top: 8px; right: 8px; background: rgba(220,38,38,0.85); border-radius: 20px; padding: 2px 8px; font-size: 10px; color: white; display: none; }
  .shutter-wrap { position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); display: none; }
  .shutter-btn { width: 48px; height: 48px; background: white; border: 3px solid rgba(255,255,255,0.4); border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 18px; }
  .cam-btns { display: flex; gap: 8px; margin-bottom: 10px; }
  .cam-btn {
    flex: 1; padding: 9px 6px;
    background: var(--bg3); border: 1px solid var(--border);
    border-radius: var(--r-md); color: var(--text);
    font-family: inherit; font-size: 11px; cursor: pointer;
    display: flex; flex-direction: column; align-items: center; gap: 4px;
    transition: all 0.15s;
  }
  .cam-btn:hover { border-color: rgba(34,197,94,0.4); color: var(--green); }
  .cam-btn span { font-size: 16px; }
  .btn-retake { width: 100%; padding: 8px; background: var(--bg3); border: 1px solid var(--border); border-radius: var(--r-md); color: var(--muted); font-family: inherit; font-size: 12px; cursor: pointer; display: none; margin-bottom: 8px; }
  .btn-scan {
    width: 100%; padding: 10px;
    background: var(--green); border: none;
    border-radius: var(--r-md);
    color: #060d08; font-family: inherit; font-size: 13px; font-weight: 600;
    cursor: pointer; transition: background 0.2s;
    display: flex; align-items: center; justify-content: center; gap: 8px;
    margin-bottom: 10px;
  }
  .btn-scan:disabled { opacity: 0.45; cursor: not-allowed; }
  .spin { width: 14px; height: 14px; border: 2px solid rgba(6,13,8,0.3); border-top-color: #060d08; border-radius: 50%; animation: spin 0.7s linear infinite; display: none; }
  @keyframes spin { to { transform: rotate(360deg); } }
  .scan-result {
    background: var(--green-bg);
    border: 1px solid rgba(34,197,94,0.2);
    border-radius: var(--r-md); padding: 12px;
    display: none; margin-bottom: 10px;
    max-height: 160px; overflow-y: auto;
  }
  .scan-result-lbl { font-size: 10px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--green); margin-bottom: 8px; }
  .scan-item { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; border-bottom: 1px solid rgba(34,197,94,0.08); font-size: 12px; }
  .scan-item:last-child { border-bottom: none; }
  .scan-item-name { font-weight: 500; }
  .scan-item-kcal { color: var(--green); font-weight: 600; }
  .btn-log-scan { width: 100%; padding: 9px; background: transparent; border: 1px solid rgba(34,197,94,0.35); border-radius: var(--r-md); color: var(--green); font-family: inherit; font-size: 12px; font-weight: 600; cursor: pointer; display: none; margin-bottom: 8px; }
  #fileInput { display: none; }

  /* ---- GOAL OPTION BUTTONS ---- */
  .goal-options { display: flex; flex-direction: column; gap: 10px; margin-bottom: 14px; }
  .goal-option {
    display: flex; align-items: center; gap: 12px;
    background: var(--bg3); border: 2px solid var(--border);
    border-radius: var(--r-md); padding: 13px 15px;
    cursor: pointer; transition: all 0.15s; text-align: left;
    font-family: inherit; color: var(--text); width: 100%;
  }
  .goal-option:hover { border-color: var(--green); background: var(--green-bg); }
  .goal-option.selected { border-color: var(--green); background: var(--green-bg); }
  .goal-option .go-icon { font-size: 22px; flex-shrink: 0; }
  .goal-option .go-label { font-size: 14px; font-weight: 600; }
  .goal-option .go-desc { font-size: 11px; color: var(--muted); margin-top: 2px; }
  .goal-option.selected .go-check {
    margin-left: auto; width: 20px; height: 20px;
    background: var(--green); border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 11px; color: #060d08; font-weight: 700; flex-shrink: 0;
  }
  .go-check { display: none; }
  .goal-option.selected .go-check { display: flex; }

  /* ---- RESPONSIVE ---- */
  @media (max-width: 640px) {
    .two-col { grid-template-columns: 1fr; }
    .body-grid { grid-template-columns: 1fr; }
    .dash { padding: 0 14px; }
    .hdr-left h1 { font-size: 20px; }
  }
  @media (max-width: 400px) {
    .stats-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
    .actions-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
  }
  
  /* ---- HAMBURGER DROPDOWN ---- */
  .app-container { display: flex; min-height: 100vh; }
  .main-content { flex: 1; min-width: 0; }
  .menu-btn {
    background: none; border: none; color: var(--text);
    cursor: pointer; margin-right: 12px;
    display: flex; flex-direction: column; justify-content: center; align-items: center;
    gap: 5px; width: 36px; height: 36px; padding: 4px; flex-shrink: 0;
  }
  .menu-btn span {
    display: block; width: 22px; height: 2px;
    background: var(--text); border-radius: 2px;
    transition: all 0.3s ease; transform-origin: center;
  }
  .menu-btn.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
  .menu-btn.open span:nth-child(2) { opacity: 0; transform: scaleX(0); }
  .menu-btn.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

  .nav-dropdown {
    position: absolute; top: 70px; left: 20px;
    background: var(--bg2); border: 1px solid var(--border2);
    border-radius: var(--r-lg); min-width: 210px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.45);
    z-index: 1000; display: none; overflow: hidden;
    animation: dropIn 0.18s ease;
  }
  .nav-dropdown.open { display: block; }
  @keyframes dropIn { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }

  .nav-brand {
    padding: 14px 16px 10px;
    display: flex; align-items: center; gap: 8px;
    border-bottom: 1px solid var(--border);
    font-size: 15px; font-weight: 700; color: var(--text);
  }
  .nav-brand .brand-icon {
    background: var(--green); color: #000;
    padding: 3px 7px; border-radius: 6px; font-size: 14px;
  }

  .nav-item {
    display: flex; align-items: center; gap: 10px;
    padding: 11px 16px; font-size: 14px; font-weight: 500;
    color: var(--muted); text-decoration: none;
    transition: background .15s, color .15s; cursor: pointer;
  }
  .nav-item.active { color: var(--green); background: var(--green-bg); }
  .nav-item:not(.active):not(.nav-logout):hover { background: rgba(255,255,255,0.05); color: var(--text); }
  .nav-icon { font-size: 17px; width: 22px; text-align: center; }

  .nav-divider { height: 1px; background: var(--border); margin: 4px 0; }

  .nav-logout {
    display: flex; align-items: center; gap: 10px;
    padding: 11px 16px 14px; font-size: 14px; font-weight: 500;
    color: #ef4444; text-decoration: none; cursor: pointer;
    transition: background .15s;
  }
  .nav-logout:hover { background: rgba(239,68,68,0.07); }

  .nav-overlay {
    position: fixed; inset: 0; z-index: 999; display: none;
  }
  .nav-overlay.open { display: block; }
</style>
</head>
<body>
<div class="app-container">
  <!-- NAV OVERLAY (closes dropdown on outside click) -->
  <div class="nav-overlay" id="navOverlay" onclick="toggleMenu()"></div>

  <!-- HAMBURGER DROPDOWN -->
  <div class="nav-dropdown" id="navDropdown">
    <div class="nav-brand">
      <span class="brand-icon">💪</span> GoFit
    </div>
    <a href="userdashboard.jsp" class="nav-item active">
      <span class="nav-icon">📊</span>
      <div><div>Dashboard</div></div>
    </a>
    <a href="calorie.jsp" class="nav-item">
      <span class="nav-icon">🍎</span>
      <div><div>Food Tracking</div></div>
    </a>
    <a href="workout.jsp" class="nav-item">
      <span class="nav-icon">🏋️</span>
      <div><div>Workout</div></div>
    </a>
    <div class="nav-divider"></div>
    <a href="logout.jsp" class="nav-logout">
      <span class="nav-icon">🚪</span>
      <div>Logout</div>
    </a>
  </div>

  <div class="main-content">
<div class="dash">

  <!-- HEADER -->
  <div class="hdr">
    <div class="hdr-left" style="display: flex; align-items: center;">
      <button class="menu-btn" id="menuBtn" onclick="toggleMenu()">
        <span></span><span></span><span></span>
      </button>
      <div>
        <h1>Hi Uday 👋</h1>
        <p id="hdr-sub">Let's crush your goals today!</p>
      </div>
    </div>
  </div>

  <!-- DATE NAV -->
  <div class="date-nav">
    <button class="dn-btn" id="btn-prev" onclick="changeDay(-1)">‹</button>
    <div class="dn-center">
      <div class="dn-label" id="date-label">Today</div>
      <div class="dn-sub" id="date-sub"></div>
    </div>
    <button class="dn-btn" id="btn-next" onclick="changeDay(1)" disabled>›</button>
  </div>

  <!-- PAST NOTICE -->
  <div class="past-notice" id="past-notice">
    📅 Viewing past data — logging is disabled for previous days.
  </div>

  <!-- STATS -->
  <div class="stats-grid">
    <div class="stat-card">
      <span class="stat-icon">🔥</span>
      <div class="stat-val">1500</div>
      <div class="stat-sub">/ 2000 kcal</div>
      <div class="stat-bar"><div class="stat-bar-fill" style="width:75%"></div></div>
      <div class="stat-lbl">Calories</div>
    </div>
    <div class="stat-card">
      <span class="stat-icon">💪</span>
      <div class="stat-val">2</div>
      <div class="stat-sub">exercises done</div>
      <div class="stat-bar"><div class="stat-bar-fill" style="width:40%"></div></div>
      <div class="stat-lbl">Workouts</div>
    </div>
    <div class="stat-card">
      <span class="stat-icon">👟</span>
      <div class="stat-val">6k</div>
      <div class="stat-sub">/ 10k steps</div>
      <div class="stat-bar"><div class="stat-bar-fill" style="width:60%"></div></div>
      <div class="stat-lbl">Steps</div>
    </div>
  </div>

  <!-- GOAL CARD -->
  <div class="goal-card">
    <div class="goal-title">🎯 Daily Goal</div>
    <div class="goal-nums">1500 <span>/ 2000 kcal</span></div>
    <div class="goal-rem">500 kcal remaining</div>
    <div class="goal-bar"><div class="goal-bar-fill" style="width:75%"></div></div>
    <div class="goal-msg">💪 Halfway there! You got this!</div>
  </div>

  <!-- AI INSIGHT (full width) -->
  <div class="ai-card" style="margin-bottom:16px;">
      <div class="ai-hdr">
        <div class="ai-icon">🤖</div>
        <div>
          <div class="ai-lbl">AI Insight</div>
          <div class="ai-sublbl">Personalised for today</div>
        </div>
      </div>
      <div class="ai-body">
        You've consumed <strong style="color:#c084fc">1500 kcal</strong> with <strong style="color:#c084fc">500 kcal</strong> remaining. Based on your workout, try a protein-rich meal for recovery. You can still eat:
      </div>
      <div class="ai-pills">
        <span class="ai-pill">🥚 2 eggs + toast ~280 kcal</span>
        <span class="ai-pill">🍛 Rice + dal ~420 kcal</span>
        <span class="ai-pill">🥜 Peanut butter + banana</span>
      </div>
  </div>

  <!-- QUICK ACTIONS -->
  <div class="section-card">
    <div class="section-title">⚡ Quick Actions</div>
    <div class="actions-grid">
      <div class="action-btn" id="qa-food" onclick="openModal('food')">
        <span class="action-icon">🍽️</span><div class="action-lbl">Add Food</div>
      </div>
      <div class="action-btn" id="qa-workout" onclick="openModal('workout')">
        <span class="action-icon">💪</span><div class="action-lbl">Log Workout</div>
      </div>
      <div class="action-btn" onclick="openModal('weight')">
        <span class="action-icon">⚖️</span><div class="action-lbl">Update Weight</div>
      </div>
    </div>
  </div>

  <!-- FOOD LOG -->
  <div class="section-card">
    <div class="section-title">🥗 Food Log</div>
    <div id="food-list">
      <div class="food-item">
        <div><div class="fi-name">Oatmeal with Berries</div><div class="fi-cal">320 kcal</div></div>
        <button class="rm-btn" onclick="removeItem(this)">×</button>
      </div>
      <div class="food-item">
        <div><div class="fi-name">Grilled Chicken Salad</div><div class="fi-cal">450 kcal</div></div>
        <button class="rm-btn" onclick="removeItem(this)">×</button>
      </div>
      <div class="food-item">
        <div><div class="fi-name">Protein Bar</div><div class="fi-cal">200 kcal</div></div>
        <button class="rm-btn" onclick="removeItem(this)">×</button>
      </div>
    </div>
    <button class="add-btn" id="add-food-btn" onclick="openModal('food')">+ Add Food</button>
  </div>

  <!-- WORKOUT LOG -->
  <div class="section-card">
    <div class="section-title">🏋️ Workout Log</div>
    <div id="workout-list">
      <div class="ex-item done">
        <div class="ex-info">
          <div class="ex-name">Bench Press</div>
          <div class="ex-det">3 sets × 10 reps × 135 lbs</div>
        </div>
        <div class="ex-right">
          <button class="done-btn is-done" onclick="toggleDone(this)">✓ Done</button>
          <button class="rm-btn" onclick="removeItem(this)">×</button>
        </div>
      </div>
      <div class="ex-item">
        <div class="ex-info">
          <div class="ex-name">Squats</div>
          <div class="ex-det">4 sets × 8 reps × 185 lbs</div>
        </div>
        <div class="ex-right">
          <button class="done-btn" onclick="toggleDone(this)">Pending</button>
          <button class="rm-btn" onclick="removeItem(this)">×</button>
        </div>
      </div>
    </div>
    <button class="add-btn" id="add-workout-btn" onclick="openModal('workout')">+ Add Exercise</button>
  </div>

  <!-- BODY STATS -->
  <div class="body-grid">
    <div class="body-card">
      <div class="body-card-title">⚖️ Weight</div>
      <div class="body-val-row">
        <div class="body-val" id="weight-val">89 <small>kg</small></div>
        <button class="upd-btn" onclick="openModal('weight')">Update</button>
      </div>
      <div class="bmi-section">
        <div class="bmi-lbl">BMI</div>
        <div class="bmi-val" id="bmi-val">—</div>
        <div class="bmi-cat" id="bmi-cat">Add height to calculate</div>
      </div>
    </div>
    <div class="body-card">
      <div class="body-card-title">🎯 Goal</div>
      <div class="body-val-row">
        <div>
          <div class="body-val" style="font-size:20px; line-height:1.2;" id="goal-display">Maintain Weight</div>
          <div style="font-size:12px; color:var(--muted); margin-top:4px;" id="goal-desc">Stay at current calorie balance</div>
        </div>
        <button class="upd-btn" onclick="openModal('goal')">Change</button>
      </div>
      <div class="bmi-section">
        <div class="bmi-lbl">Current target</div>
        <div class="bmi-hint" id="goal-hint">2000 kcal / day</div>
      </div>
    </div>
  </div>

</div><!-- /dash -->

<!-- =================== MODALS =================== -->

<!-- FOOD MODAL -->
<div class="modal-overlay" id="modal-food">
  <div class="modal">
    <h3>🍽️ Add Food</h3>
    <div class="scan-tab-row">
      <button class="scan-tab active" onclick="switchTab('manual')" id="ftab-manual">✏️ Manual</button>
      <button class="scan-tab" onclick="switchTab('scan')" id="ftab-scan">📷 Scan with AI</button>
    </div>
    <div id="fpanel-manual">
      <input type="text" id="food-name" placeholder="Food name (e.g. Rice + Dal)" />
      <input type="number" id="food-cal" placeholder="Calories (kcal)" />
      <div class="modal-actions">
        <button class="btn-cancel" onclick="closeModal('food')">Cancel</button>
        <button class="btn-save" onclick="saveFood()">Add</button>
      </div>
    </div>
    <div id="fpanel-scan" style="display:none">
      <div class="cam-area" id="camArea">
        <div class="cam-ph" id="camPh">
          <span class="cam-icon">🍱</span>
          <p>Take a photo or upload<br>AI will detect your food</p>
        </div>
        <video id="vidEl" autoplay playsinline muted></video>
        <canvas id="cvEl"></canvas>
        <img id="scanPreview" alt="food" />
        <span class="live-dot" id="liveDot">● LIVE</span>
        <div class="shutter-wrap" id="shutterEl">
          <button class="shutter-btn" onclick="capture()">📸</button>
        </div>
      </div>
      <div class="cam-btns">
        <button class="cam-btn" onclick="startCam()"><span>📷</span>Camera</button>
        <button class="cam-btn" onclick="document.getElementById('fileInput').click()"><span>🖼️</span>Gallery</button>
      </div>
      <input type="file" id="fileInput" accept="image/*" onchange="uploadFile(event)" />
      <button class="btn-retake" id="retakeBtn" onclick="resetCam()">↩ Retake</button>
      <button class="btn-scan" id="btnScan" onclick="doScan()" disabled>
        <span class="spin" id="scanSpin"></span>
        <span id="scanLbl">🔍 Analyse with AI</span>
      </button>
      <div class="scan-result" id="scanResult">
        <div class="scan-result-lbl">🤖 Detected Items</div>
        <div id="scanItems"></div>
        <div id="scanNote" style="font-size:11px;color:var(--muted);margin-top:8px;"></div>
      </div>
      <button class="btn-log-scan" id="btnLogScan" onclick="logScanned()">✅ Log All Items</button>
      <button class="btn-cancel" style="width:100%;padding:10px;border-radius:12px;font-size:13px;margin-top:4px;cursor:pointer;" onclick="closeModal('food')">Close</button>
    </div>
  </div>
</div>

<!-- WORKOUT MODAL -->
<div class="modal-overlay" id="modal-workout">
  <div class="modal">
    <h3>💪 Log Exercise</h3>
    <input type="text" id="ex-name" placeholder="Exercise name" />
    <input type="number" id="ex-sets" placeholder="Sets" />
    <input type="number" id="ex-reps" placeholder="Reps" />
    <input type="number" id="ex-weight" placeholder="Weight (kg/lbs)" />
    <div class="modal-actions">
      <button class="btn-cancel" onclick="closeModal('workout')">Cancel</button>
      <button class="btn-save" onclick="saveWorkout()">Add</button>
    </div>
  </div>
</div>

<!-- WEIGHT MODAL -->
<div class="modal-overlay" id="modal-weight">
  <div class="modal">
    <h3>⚖️ Update Weight</h3>
    <input type="number" id="new-weight" placeholder="Weight (kg)" />
    <div class="modal-actions">
      <button class="btn-cancel" onclick="closeModal('weight')">Cancel</button>
      <button class="btn-save" onclick="saveWeight()">Update</button>
    </div>
  </div>
</div>

<!-- GOAL MODAL -->
<div class="modal-overlay" id="modal-goal">
  <div class="modal">
    <h3>🎯 Change Goal</h3>
    <div class="goal-options">
      <button class="goal-option" id="goal-lose" onclick="selectGoal('lose')">
        <span class="go-icon">🔥</span>
        <div>
          <div class="go-label">Lose Fat</div>
          <div class="go-desc">Calorie deficit · burn more than you eat</div>
        </div>
        <span class="go-check">✓</span>
      </button>
      <button class="goal-option" id="goal-build" onclick="selectGoal('build')">
        <span class="go-icon">💪</span>
        <div>
          <div class="go-label">Build Muscle</div>
          <div class="go-desc">Calorie surplus · fuel your gains</div>
        </div>
        <span class="go-check">✓</span>
      </button>
      <button class="goal-option selected" id="goal-maintain" onclick="selectGoal('maintain')">
        <span class="go-icon">⚖️</span>
        <div>
          <div class="go-label">Maintain Weight</div>
          <div class="go-desc">Stay at current calorie balance</div>
        </div>
        <span class="go-check">✓</span>
      </button>
    </div>
    <div class="modal-actions">
      <button class="btn-cancel" onclick="closeModal('goal')">Cancel</button>
      <button class="btn-save" onclick="saveGoal()">Save Goal</button>
    </div>
  </div>
</div>
		
			<script>
  /* ===== YOUR API KEY ===== */
  var GEMINI_KEY = 'YOUR_GEMINI_API_KEY_HERE';

  /* ===== HAMBURGER MENU ===== */
  function toggleMenu() {
    var btn = document.getElementById('menuBtn');
    var dd = document.getElementById('navDropdown');
    var ov = document.getElementById('navOverlay');
    btn.classList.toggle('open');
    dd.classList.toggle('open');
    ov.classList.toggle('open');
  }

  /* ===== STATE ===== */
  var weightKg = 89, heightCm = 0;
  var camStream = null, capturedB64 = null, capturedMime = 'image/jpeg';
  var scannedItems = [];

  /* ===== DATE LOGIC =====
     offset = days from today (0 = today, -1 = yesterday, never > 0)
     Midnight crossing: check every minute; if local date has changed, refresh display
  */
  var offset = 0;

  function getLocalDateStr(d) {
    return d.getFullYear() + '-' +
      String(d.getMonth()+1).padStart(2,'0') + '-' +
      String(d.getDate()).padStart(2,'0');
  }

  var todayStr = getLocalDateStr(new Date());

  function checkMidnight() {
    var nowStr = getLocalDateStr(new Date());
    if (nowStr !== todayStr) {
      todayStr = nowStr;
      // If user was viewing "today" (offset 0), they stay on today (new date)
      updateDateDisplay();
    }
  }
  setInterval(checkMidnight, 60000); // check every minute

  function changeDay(dir) {
    var newOffset = offset + dir;
    if (newOffset > 0) return; // block future dates
    offset = newOffset;
    updateDateDisplay();
  }

  function updateDateDisplay() {
    var d = new Date();
    d.setDate(d.getDate() + offset);
    var isPast = offset < 0;

    // Label
    var label;
    if (offset === 0) label = 'Today';
    else if (offset === -1) label = 'Yesterday';
    else label = d.toLocaleDateString('en-US', {weekday: 'long'});

    document.getElementById('date-label').textContent = label;
    document.getElementById('date-sub').textContent = d.toLocaleDateString('en-US', {
      month: 'short', day: 'numeric', year: 'numeric'
    });

    // Next button — always disabled when on today or future
    document.getElementById('btn-next').disabled = (offset >= 0);

    // Past notice banner
    document.getElementById('past-notice').style.display = isPast ? 'block' : 'none';

    // Disable food/workout actions for past days
    var foodBtn = document.getElementById('qa-food');
    var workoutBtn = document.getElementById('qa-workout');
    var addFood = document.getElementById('add-food-btn');
    var addWorkout = document.getElementById('add-workout-btn');

    [foodBtn, workoutBtn].forEach(function(el) {
      if (isPast) { el.classList.add('disabled'); el.style.pointerEvents = 'none'; }
      else { el.classList.remove('disabled'); el.style.pointerEvents = ''; }
    });
    addFood.disabled = isPast;
    addWorkout.disabled = isPast;

    // Header subtext
    document.getElementById('hdr-sub').textContent = isPast
      ? 'Viewing ' + d.toLocaleDateString('en-US', {month: 'short', day: 'numeric'})
      : "Let's crush your goals today!";
  }
  updateDateDisplay();

  /* ===== MODALS ===== */
  function openModal(t) {
    if ((t === 'food' || t === 'workout') && offset < 0) return; // block past day logging
    document.getElementById('modal-' + t).classList.add('open');
  }
  function closeModal(t) {
    document.getElementById('modal-' + t).classList.remove('open');
    if (t === 'food') resetCam();
  }
  document.querySelectorAll('.modal-overlay').forEach(function(m) {
    m.addEventListener('click', function(e) {
      if (e.target === m) {
        var id = m.id.replace('modal-', '');
        closeModal(id);
      }
    });
  });

  /* ===== FOOD TAB SWITCH ===== */
  function switchTab(tab) {
    ['manual', 'scan'].forEach(function(t) {
      document.getElementById('ftab-' + t).classList.toggle('active', t === tab);
      document.getElementById('fpanel-' + t).style.display = t === tab ? 'block' : 'none';
    });
    if (tab !== 'scan') resetCam();
  }

  /* ===== REMOVE ITEMS ===== */
  function removeItem(btn) {
    btn.closest('.food-item, .ex-item').remove();
  }

  /* ===== SAVE FOOD ===== */
  function saveFood() {
    var name = document.getElementById('food-name').value.trim();
    var cal = document.getElementById('food-cal').value.trim();
    if (!name) return;
    var item = document.createElement('div');
    item.className = 'food-item';
    item.innerHTML = '<div><div class="fi-name">' + esc(name) + '</div><div class="fi-cal">' + (cal ? cal + ' kcal' : '') + '</div></div><button class="rm-btn" onclick="removeItem(this)">×</button>';
    document.getElementById('food-list').appendChild(item);
    document.getElementById('food-name').value = '';
    document.getElementById('food-cal').value = '';
    closeModal('food');
  }

  /* ===== WORKOUT ===== */
  function toggleDone(btn) {
    var item = btn.closest('.ex-item');
    var isDone = item.classList.contains('done');
    item.classList.toggle('done', !isDone);
    btn.classList.toggle('is-done', !isDone);
    btn.textContent = isDone ? 'Pending' : '✓ Done';
  }

  function saveWorkout() {
    var name = document.getElementById('ex-name').value.trim();
    var sets = document.getElementById('ex-sets').value;
    var reps = document.getElementById('ex-reps').value;
    var wt = document.getElementById('ex-weight').value;
    if (!name) return;
    var item = document.createElement('div');
    item.className = 'ex-item';
    item.innerHTML = '<div class="ex-info"><div class="ex-name">' + esc(name) + '</div><div class="ex-det">' + sets + ' sets × ' + reps + ' reps × ' + wt + ' lbs</div></div><div class="ex-right"><button class="done-btn" onclick="toggleDone(this)">Pending</button><button class="rm-btn" onclick="removeItem(this)">×</button></div>';
    document.getElementById('workout-list').appendChild(item);
    ['ex-name','ex-sets','ex-reps','ex-weight'].forEach(function(id) { document.getElementById(id).value = ''; });
    closeModal('workout');
  }

  /* ===== WEIGHT + HEIGHT + BMI ===== */
  function saveWeight() {
    var val = parseFloat(document.getElementById('new-weight').value);
    if (!val) return;
    weightKg = val;
    document.getElementById('weight-val').innerHTML = val + ' <small>kg</small>';
    document.getElementById('new-weight').value = '';
    closeModal('weight');
  }

  /* ===== GOAL ===== */
  var currentGoal = 'maintain';
  var pendingGoal = 'maintain';
  var goalData = {
    lose:     { label: 'Lose Fat',        desc: 'Calorie deficit · burn more',   hint: '1600 kcal / day', icon: '🔥' },
    build:    { label: 'Build Muscle',    desc: 'Calorie surplus · fuel gains',  hint: '2400 kcal / day', icon: '💪' },
    maintain: { label: 'Maintain Weight', desc: 'Stay at current calorie balance', hint: '2000 kcal / day', icon: '⚖️' }
  };

  function selectGoal(key) {
    pendingGoal = key;
    ['lose','build','maintain'].forEach(function(k) {
      document.getElementById('goal-' + k).classList.toggle('selected', k === key);
    });
  }

  function saveGoal() {
    currentGoal = pendingGoal;
    var d = goalData[currentGoal];
    document.getElementById('goal-display').textContent = d.label;
    document.getElementById('goal-desc').textContent = d.desc;
    document.getElementById('goal-hint').textContent = d.hint;
    closeModal('goal');
  }

  function updateBMI() {
    if (!heightCm || !weightKg) {
      document.getElementById('bmi-val').textContent = '—';
      document.getElementById('bmi-cat').textContent = 'Add height to calculate';
      return;
    }
    var h = heightCm / 100;
    var bmi = (weightKg / (h * h)).toFixed(1);
    var cat = bmi < 18.5 ? 'Underweight' : bmi < 25 ? 'Normal weight' : bmi < 30 ? 'Overweight' : 'Obese';
    var col = bmi < 18.5 ? '#60a5fa' : bmi < 25 ? '#22c55e' : bmi < 30 ? '#f97316' : '#ef4444';
    document.getElementById('bmi-val').textContent = bmi;
    document.getElementById('bmi-val').style.color = col;
    document.getElementById('bmi-cat').textContent = cat;
  }

  /* ===== CAMERA ===== */
  function startCam() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert('Camera not supported on this device/browser');
      return;
    }
    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' }, audio: false })
      .then(function(s) {
        camStream = s;
        var v = document.getElementById('vidEl');
        v.srcObject = s;
        v.style.display = 'block';
        document.getElementById('scanPreview').style.display = 'none';
        document.getElementById('camPh').style.display = 'none';
        document.getElementById('liveDot').style.display = 'block';
        document.getElementById('shutterEl').style.display = 'block';
        document.getElementById('retakeBtn').style.display = 'none';
        document.getElementById('btnScan').disabled = true;
        capturedB64 = null;
        hideScanResult();
      })
      .catch(function(err) { alert('Camera error: ' + err.message); });
  }

  function capture() {
    var v = document.getElementById('vidEl');
    var c = document.getElementById('cvEl');
    c.width = v.videoWidth;
    c.height = v.videoHeight;
    c.getContext('2d').drawImage(v, 0, 0);
    var dataUrl = c.toDataURL('image/jpeg', 0.88);
    capturedB64 = dataUrl.split(',')[1];
    capturedMime = 'image/jpeg';
    var img = document.getElementById('scanPreview');
    img.src = dataUrl;
    img.style.display = 'block';
    v.style.display = 'none';
    document.getElementById('liveDot').style.display = 'none';
    document.getElementById('shutterEl').style.display = 'none';
    document.getElementById('retakeBtn').style.display = 'block';
    document.getElementById('btnScan').disabled = false;
    stopCam();
  }

  function uploadFile(e) {
    var file = e.target.files[0];
    if (!file) return;
    capturedMime = file.type || 'image/jpeg';
    var r = new FileReader();
    r.onload = function(ev) {
      var dataUrl = ev.target.result;
      capturedB64 = dataUrl.split(',')[1];
      var img = document.getElementById('scanPreview');
      img.src = dataUrl;
      img.style.display = 'block';
      document.getElementById('vidEl').style.display = 'none';
      document.getElementById('camPh').style.display = 'none';
      document.getElementById('liveDot').style.display = 'none';
      document.getElementById('shutterEl').style.display = 'none';
      document.getElementById('retakeBtn').style.display = 'block';
      document.getElementById('btnScan').disabled = false;
      hideScanResult();
    };
    r.readAsDataURL(file);
    stopCam();
    e.target.value = '';
  }

  function resetCam() {
    stopCam();
    capturedB64 = null;
    var img = document.getElementById('scanPreview');
    img.style.display = 'none';
    img.src = '';
    document.getElementById('vidEl').style.display = 'none';
    document.getElementById('camPh').style.display = 'block';
    document.getElementById('liveDot').style.display = 'none';
    document.getElementById('shutterEl').style.display = 'none';
    document.getElementById('retakeBtn').style.display = 'none';
    document.getElementById('btnScan').disabled = true;
    hideScanResult();
  }

  function stopCam() {
    if (camStream) {
      camStream.getTracks().forEach(function(t) { t.stop(); });
      camStream = null;
    }
  }

  /* ===== GEMINI AI SCAN ===== */
  function doScan() {
    if (!capturedB64) return;
    setScanLoad(true);
    hideScanResult();
    var prompt = 'You are a nutrition expert. Identify ALL food items in this image.\nReturn ONLY a JSON array:\n[{"name":"Food","serving":"1 cup","kcal":250},...]\nIf no food: []\nBe realistic with Indian home-cooked portions.';
    fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=' + GEMINI_KEY, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }, { inline_data: { mime_type: capturedMime, data: capturedB64 } }] }]
      })
    })
    .then(function(r) {
      if (!r.ok) return r.json().then(function(e) { throw new Error(e.error && e.error.message || 'API error'); });
      return r.json();
    })
    .then(function(d) {
      setScanLoad(false);
      var text = d.candidates && d.candidates[0] && d.candidates[0].content && d.candidates[0].content.parts && d.candidates[0].content.parts[0] && d.candidates[0].content.parts[0].text;
      if (!text) throw new Error('Empty response from AI');
      showScanResult(text);
    })
    .catch(function(err) { setScanLoad(false); alert('AI error: ' + err.message); });
  }

  function showScanResult(text) {
    var clean = text.replace(/```json/gi, '').replace(/```/g, '').trim();
    var items;
    try { items = JSON.parse(clean); }
    catch(e) {
      var m = clean.match(/\[[\s\S]*\]/);
      try { items = m ? JSON.parse(m[0]) : []; }
      catch(e2) { items = []; }
    }
    scannedItems = Array.isArray(items) ? items : [];
    if (!scannedItems.length) { alert('No food detected — try a clearer photo'); return; }
    var html = '', total = 0;
    scannedItems.forEach(function(item) {
      var k = parseInt(item.kcal) || 0;
      total += k;
      html += '<div class="scan-item"><div><div class="scan-item-name">' + esc(item.name) + '</div><div style="font-size:11px;color:var(--muted)">' + esc(item.serving || '1 serving') + '</div></div><div class="scan-item-kcal">' + k + ' kcal</div></div>';
    });
    document.getElementById('scanItems').innerHTML = html;
    document.getElementById('scanNote').textContent = 'Total: ~' + total + ' kcal (estimates)';
    document.getElementById('scanResult').style.display = 'block';
    document.getElementById('btnLogScan').style.display = 'block';
  }

  function logScanned() {
    scannedItems.forEach(function(item) {
      var el = document.createElement('div');
      el.className = 'food-item';
      el.innerHTML = '<div><div class="fi-name">' + esc(item.name) + '</div><div class="fi-cal">' + (item.kcal || 0) + ' kcal</div></div><button class="rm-btn" onclick="removeItem(this)">×</button>';
      document.getElementById('food-list').appendChild(el);
    });
    scannedItems = [];
    hideScanResult();
    resetCam();
    closeModal('food');
  }

  function hideScanResult() {
    document.getElementById('scanResult').style.display = 'none';
    document.getElementById('btnLogScan').style.display = 'none';
    scannedItems = [];
  }

  function setScanLoad(on) {
    document.getElementById('btnScan').disabled = on;
    document.getElementById('scanSpin').style.display = on ? 'inline-block' : 'none';
    document.getElementById('scanLbl').textContent = on ? 'Analysing…' : '🔍 Analyse with AI';
  }

  function esc(s) {
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }
</script>
</body>
</html>