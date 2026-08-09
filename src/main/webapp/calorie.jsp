<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.CalorieLog, model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int calorieGoal = (currentUser.getCalorieGoal() > 0) ? currentUser.getCalorieGoal() : 2200;
    List<CalorieLog> calorieLogs = (List<CalorieLog>) request.getAttribute("calorieLogs");

    String selectedDateStr = (String) request.getAttribute("selectedDate");
    if (selectedDateStr == null) selectedDateStr = java.time.LocalDate.now().toString();
    Boolean isTodayAttr = (Boolean) request.getAttribute("isToday");
    boolean isToday = (isTodayAttr != null) ? isTodayAttr : true;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GoFit Calories</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@400;600;700&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'DM Sans', Arial, sans-serif; background: #080d14; color: #f0f4f8; min-height: 100vh; position: relative; overflow-x: hidden; }
  .corner-deco { position: fixed; bottom: 0; right: 0; width: 180px; height: 180px; pointer-events: none; z-index: 0; opacity: 0.55; }
  .corner-deco svg { width: 100%; height: 100%; }
  nav { background: #0b1220; border-bottom: 1px solid rgba(255,255,255,0.07); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 58px; position: sticky; top: 0; z-index: 200; }
  .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
  .logo-box { width: 32px; height: 32px; background: #4ade80; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
  .logo-text { font-family: 'DM Serif Display', serif; font-size: 1.2rem; color: #f0f4f8; }
  .nav-right { display: flex; align-items: center; gap: 10px; }
  .over-alert { display: none; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: #fff; background: #dc2626; border: 1px solid #f87171; padding: 4px 12px; border-radius: 20px; animation: alertpulse 1.5s infinite; }
  @keyframes alertpulse { 0%,100%{opacity:1} 50%{opacity:0.6} }
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
  main { max-width: 620px; margin: 0 auto; padding: 28px 18px 100px; position: relative; z-index: 1; }
  .card { background: #0d1520; border: 1px solid rgba(255,255,255,0.07); border-radius: 16px; padding: 20px; margin-bottom: 14px; }
  .date-row { display: flex; align-items: center; justify-content: space-between; }
  .date-row span { font-size: 0.95rem; font-weight: 600; }
  .arrow-btn { width: 34px; height: 34px; background: #131f30; border: 1px solid rgba(255,255,255,0.07); border-radius: 8px; color: #5a7291; font-size: 1.1rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: color 0.2s; }
  .arrow-btn:hover { color: #f0f4f8; }
  .arrow-btn:disabled { opacity: 0.3; cursor: not-allowed; }
  .card-label { font-size: 0.68rem; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: #5a7291; margin-bottom: 14px; }
  .stat-row { display: flex; gap: 10px; margin-bottom: 16px; }
  .stat-box { flex: 1; background: #111d2e; border: 1px solid rgba(255,255,255,0.07); border-radius: 12px; padding: 12px 10px; text-align: center; }
  .stat-val { font-size: 1.25rem; font-weight: 700; display: block; }
  .stat-lbl { font-size: 0.68rem; color: #5a7291; margin-top: 3px; display: block; }
  .prog-track { height: 7px; background: #131f30; border-radius: 99px; overflow: hidden; margin-top: 6px; }
  .prog-fill { height: 100%; border-radius: 99px; background: linear-gradient(90deg,#22c55e,#4ade80); transition: width 0.4s ease; }
  .prog-fill.over { background: linear-gradient(90deg,#f87171,#fca5a5); }
  .prog-meta { display: flex; justify-content: space-between; font-size: 0.72rem; color: #5a7291; margin-bottom: 6px; }
  .macro-title { font-size: 0.68rem; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: #5a7291; margin: 16px 0 10px; }
  .macro-row { display: flex; gap: 8px; }
  .macro-box { flex: 1; border-radius: 12px; padding: 11px 10px; text-align: center; position: relative; overflow: hidden; }
  .macro-box.carbs  { background: #131e35; border: 1px solid rgba(96,165,250,0.2); }
  .macro-box.protein{ background: #1e1328; border: 1px solid rgba(192,132,252,0.2); }
  .macro-box.fat    { background: #1e1a0f; border: 1px solid rgba(251,191,36,0.2); }
  .macro-val { font-size: 1.1rem; font-weight: 700; display: block; }
  .macro-box.carbs   .macro-val { color: #60a5fa; }
  .macro-box.protein .macro-val { color: #c084fc; }
  .macro-box.fat     .macro-val { color: #fbbf24; }
  .macro-lbl { font-size: 0.65rem; color: #5a7291; margin-top: 2px; display: block; }
  .macro-pct { font-size: 0.6rem; font-weight: 700; margin-top: 4px; display: block; opacity: 0.7; }
  .macro-box.carbs   .macro-pct { color: #60a5fa; }
  .macro-box.protein .macro-pct { color: #c084fc; }
  .macro-box.fat     .macro-pct { color: #fbbf24; }
  .macro-bar-wrap { height: 3px; background: rgba(255,255,255,0.06); border-radius: 99px; overflow: hidden; margin-top: 6px; }
  .macro-bar-fill { height: 100%; border-radius: 99px; transition: width 0.5s ease; }
  .macro-box.carbs   .macro-bar-fill { background: #60a5fa; }
  .macro-box.protein .macro-bar-fill { background: #c084fc; }
  .macro-box.fat     .macro-bar-fill { background: #fbbf24; }
  .macro-stack { height: 6px; background: #131f30; border-radius: 99px; overflow: hidden; margin-top: 12px; display: flex; }
  .macro-stack-seg { height: 100%; transition: width 0.5s ease; }
  .macro-stack-seg.c { background: #60a5fa; }
  .macro-stack-seg.p { background: #c084fc; }
  .macro-stack-seg.f { background: #fbbf24; }
  .macro-stack-legend { display: flex; gap: 12px; margin-top: 6px; justify-content: center; }
  .msl { font-size: 0.62rem; color: #5a7291; display: flex; align-items: center; gap: 4px; }
  .msl-dot { width: 7px; height: 7px; border-radius: 2px; flex-shrink: 0; }
  .ai-insight-card { background: linear-gradient(135deg, #1a1040 0%, #231355 50%, #1a1040 100%); border: 1px solid rgba(167,139,250,0.35); border-radius: 16px; padding: 18px 18px 16px; margin-bottom: 14px; position: relative; overflow: hidden; }
  .ai-insight-card::before { content: ''; position: absolute; top: -30px; right: -30px; width: 120px; height: 120px; background: radial-gradient(circle, rgba(167,139,250,0.18) 0%, transparent 70%); border-radius: 50%; pointer-events: none; }
  .ai-insight-header { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
  .ai-insight-icon { width: 34px; height: 34px; background: rgba(139,92,246,0.25); border: 1px solid rgba(167,139,250,0.4); border-radius: 9px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
  .ai-insight-label { font-size: 0.62rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: #a78bfa; }
  .ai-insight-subtitle { font-size: 0.72rem; color: rgba(167,139,250,0.6); margin-top: 1px; }
  .ai-halfway-banner { background: rgba(139,92,246,0.12); border: 1px solid rgba(167,139,250,0.2); border-radius: 8px; padding: 7px 12px; font-size: 0.8rem; font-weight: 600; color: #c4b5fd; margin-bottom: 10px; display: none; }
  .ai-insight-text { font-size: 0.87rem; line-height: 1.6; color: #e2d9f3; margin-bottom: 14px; }
  .ai-insight-text strong { color: #fff; font-weight: 700; }
  .ai-insight-chips { display: flex; gap: 8px; flex-wrap: wrap; }
  .ai-chip { padding: 7px 14px; background: rgba(109,40,217,0.35); border: 1px solid rgba(139,92,246,0.4); border-radius: 20px; font-size: 0.78rem; font-weight: 600; color: #ddd6fe; cursor: pointer; transition: all 0.2s; white-space: nowrap; display: flex; align-items: center; gap: 5px; }
  .ai-chip:hover { background: rgba(139,92,246,0.45); border-color: rgba(167,139,250,0.7); color: #fff; transform: translateY(-1px); }
  .ai-chip-emoji { font-size: 0.9rem; }
  .tabs { display: flex; gap: 8px; margin-bottom: 14px; }
  .tab-btn { flex: 1; padding: 10px 8px; background: #111d2e; border: 1px solid rgba(255,255,255,0.07); border-radius: 10px; color: #5a7291; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.82rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 6px; transition: all 0.2s; }
  .tab-btn.active { background: #0f2a1a; border-color: rgba(74,222,128,0.35); color: #4ade80; }
  .tab-btn:hover:not(.active) { color: #f0f4f8; border-color: rgba(255,255,255,0.15); }
  .tab-panel { display: none; }
  .tab-panel.active { display: block; }
  .input-row { display: flex; gap: 8px; margin-bottom: 8px; flex-wrap: wrap; }
  .input-row input { flex: 1; min-width: 80px; padding: 11px 12px; background: #131f30; border: 1px solid rgba(255,255,255,0.07); border-radius: 10px; color: #f0f4f8; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.85rem; outline: none; }
  .input-row input:focus { border-color: rgba(74,222,128,0.4); }
  .input-row input::placeholder { color: #2e4a66; }
  .input-row input#qtyInput { max-width: 78px; flex: 0 0 78px; }
  .macro-input-row { display: flex; gap: 8px; margin-bottom: 10px; }
  .macro-input-row input { flex: 1; padding: 10px 10px; background: #131f30; border: 1px solid rgba(255,255,255,0.07); border-radius: 10px; color: #f0f4f8; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.8rem; outline: none; min-width: 0; }
  .macro-input-row input:focus { border-color: rgba(74,222,128,0.4); }
  .macro-input-row input::placeholder { color: #2e4a66; font-size: 0.75rem; }
  .macro-input-label { font-size: 0.65rem; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase; color: #5a7291; margin-bottom: 5px; }
  .live-preview { font-size: 0.74rem; color: #4ade80; margin: -2px 0 10px; min-height: 16px; }
  .btn-add { width: 100%; padding: 12px; background: #22c55e; border: none; border-radius: 10px; color: #060d14; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.9rem; font-weight: 700; cursor: pointer; transition: background 0.2s; }
  .btn-add:hover { background: #4ade80; }
  .cam-action-btns { display: flex; gap: 10px; margin-bottom: 12px; }
  .cam-action-btn { flex: 1; padding: 16px 10px; background: #111d2e; border: 1px solid rgba(255,255,255,0.07); border-radius: 12px; color: #f0f4f8; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.88rem; font-weight: 600; cursor: pointer; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 7px; transition: all 0.2s; }
  .cam-action-btn .cab-icon { font-size: 1.7rem; }
  .cam-action-btn:hover { border-color: rgba(74,222,128,0.4); color: #4ade80; background: #0d1c2b; }
  .camera-area { background: #0a1422; border: 1.5px dashed rgba(74,222,128,0.2); border-radius: 14px; overflow: hidden; position: relative; min-height: 210px; display: flex; flex-direction: column; align-items: center; justify-content: center; margin-bottom: 12px; }
  .camera-area video { width: 100%; max-height: 280px; object-fit: cover; display: none; }
  .camera-area canvas { display: none; }
  .camera-area img#previewImg { width: 100%; max-height: 280px; object-fit: cover; display: none; }
  .cam-placeholder { text-align: center; color: #2e4a66; padding: 40px 20px; }
  .cam-placeholder .cam-icon { font-size: 2.8rem; margin-bottom: 10px; }
  .cam-placeholder p { font-size: 0.82rem; line-height: 1.6; }
  .cam-live-badge { position: absolute; top: 10px; right: 10px; background: rgba(220,38,38,0.85); border-radius: 20px; padding: 3px 10px; font-size: 0.68rem; font-weight: 700; letter-spacing: 0.06em; color: #fff; display: none; }
  .shutter-wrap { position: absolute; bottom: 16px; left: 50%; transform: translateX(-50%); display: none; }
  .shutter-btn { width: 62px; height: 62px; background: white; border: 4px solid rgba(255,255,255,0.35); border-radius: 50%; cursor: pointer; box-shadow: 0 0 0 4px rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; transition: transform 0.1s; }
  .shutter-btn:active { transform: scale(0.92); }
  .btn-retake { width: 100%; padding: 11px; background: #131f30; border: 1px solid rgba(255,255,255,0.07); border-radius: 10px; color: #5a7291; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: all 0.2s; display: none; margin-bottom: 10px; }
  .btn-retake:hover { color: #f0f4f8; border-color: rgba(255,255,255,0.18); }
  .btn-scan { width: 100%; padding: 13px; background: #22c55e; border: none; border-radius: 10px; color: #060d14; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.9rem; font-weight: 700; cursor: pointer; transition: background 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 10px; }
  .btn-scan:hover { background: #4ade80; }
  .btn-scan:disabled { opacity: 0.45; cursor: not-allowed; background: #22c55e; }
  .spinner { width: 16px; height: 16px; border: 2px solid rgba(6,13,20,0.3); border-top-color: #060d14; border-radius: 50%; animation: spin 0.7s linear infinite; display: none; }
  @keyframes spin { to { transform: rotate(360deg); } }
  .ai-result { background: #0f2a1a; border: 1px solid rgba(74,222,128,0.3); border-radius: 12px; padding: 14px; display: none; margin-bottom: 10px; }
  .ai-result-label { font-size: 0.65rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: #4ade80; margin-bottom: 10px; }
  .ai-food-item { display: flex; justify-content: space-between; align-items: flex-start; padding: 8px 0; border-bottom: 1px solid rgba(74,222,128,0.1); }
  .ai-food-item:last-child { border-bottom: none; }
  .ai-food-name { font-size: 0.88rem; font-weight: 600; }
  .ai-food-meta { font-size: 0.72rem; color: #5a7291; margin-top: 2px; }
  .ai-food-macros { font-size: 0.68rem; color: #5a7291; margin-top: 3px; display: flex; gap: 8px; }
  .ai-food-macros span { padding: 1px 6px; border-radius: 4px; font-weight: 600; }
  .ai-food-macros .mc { background: rgba(96,165,250,0.12); color: #60a5fa; }
  .ai-food-macros .mp { background: rgba(192,132,252,0.12); color: #c084fc; }
  .ai-food-macros .mf { background: rgba(251,191,36,0.12); color: #fbbf24; }
  .ai-food-kcal { font-size: 0.88rem; font-weight: 700; color: #4ade80; white-space: nowrap; margin-left: 8px; }
  .ai-result-note { font-size: 0.72rem; color: #5a7291; margin-top: 10px; line-height: 1.5; }
  .btn-log-all { width: 100%; padding: 12px; background: transparent; border: 1px solid rgba(74,222,128,0.4); border-radius: 10px; color: #4ade80; font-family: 'DM Sans', Arial, sans-serif; font-size: 0.88rem; font-weight: 700; cursor: pointer; transition: all 0.2s; display: none; }
  .btn-log-all:hover { background: #0f2a1a; }
  .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
  .food-item { display: flex; align-items: flex-start; background: #111d2e; border: 1px solid rgba(255,255,255,0.07); border-radius: 12px; padding: 12px 14px; margin-bottom: 8px; gap: 12px; }
  .food-dot { width: 8px; height: 8px; background: #4ade80; border-radius: 50%; flex-shrink: 0; margin-top: 5px; }
  .food-info { flex: 1; }
  .food-name { font-size: 0.9rem; font-weight: 600; }
  .food-serving { font-size: 0.75rem; color: #5a7291; margin-top: 2px; }
  .food-macros-row { display: flex; gap: 6px; margin-top: 5px; }
  .fm-pill { font-size: 0.62rem; font-weight: 700; padding: 2px 7px; border-radius: 5px; }
  .fm-pill.c { background: rgba(96,165,250,0.12); color: #60a5fa; }
  .fm-pill.p { background: rgba(192,132,252,0.12); color: #c084fc; }
  .fm-pill.f { background: rgba(251,191,36,0.12); color: #fbbf24; }
  .food-right { display: flex; flex-direction: column; align-items: flex-end; gap: 6px; }
  .food-kcal { font-size: 0.88rem; font-weight: 700; color: #4ade80; white-space: nowrap; }
  .btn-delete { background: none; border: none; color: #5a7291; cursor: pointer; font-size: 1rem; padding: 2px 4px; border-radius: 6px; transition: color 0.2s; }
  .btn-delete:hover { color: #f87171; }
  .empty { text-align: center; color: #5a7291; font-size: 0.85rem; padding: 24px 0; }
  .toast { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); padding: 12px 20px; border-radius: 12px; font-size: 0.82rem; font-weight: 600; z-index: 999; display: none; text-align: center; max-width: 90vw; }
  .toast.show { display: block; animation: fadeUp 0.2s ease; }
  @keyframes fadeUp { from{opacity:0;transform:translateX(-50%) translateY(8px)} to{opacity:1;transform:translateX(-50%) translateY(0)} }
  #fileInput { display: none; }
</style>
</head>
<body>

<div class="corner-deco">
  <svg viewBox="0 0 180 180" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="0" y="140" width="30" height="30" rx="6" fill="#22c55e"/>
    <rect x="36" y="140" width="30" height="30" rx="6" fill="#16a34a" opacity=".7"/>
    <rect x="72" y="140" width="30" height="30" rx="6" fill="#22c55e"/>
    <rect x="108" y="140" width="30" height="30" rx="6" fill="#14532d" opacity=".5"/>
    <rect x="144" y="140" width="30" height="30" rx="6" fill="#22c55e"/>
    <rect x="0" y="104" width="30" height="30" rx="6" fill="#16a34a" opacity=".6"/>
    <rect x="36" y="104" width="30" height="30" rx="6" fill="#22c55e"/>
    <rect x="72" y="104" width="30" height="30" rx="6" fill="#14532d" opacity=".4"/>
    <rect x="108" y="104" width="30" height="30" rx="6" fill="#4ade80" opacity=".5"/>
    <rect x="144" y="104" width="30" height="30" rx="6" fill="#16a34a" opacity=".7"/>
  </svg>
</div>

<nav>
  <a href="userdashboard.jsp" class="nav-brand">
    <div class="logo-box">💪</div>
    <span class="logo-text">GoFit</span>
  </a>
  <div class="nav-right">
    <span class="over-alert" id="overAlert">⚠ Over Goal!</span>
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
  <a href="userdashboard.jsp"><span class="nav-icon">📊</span> Dashboard</a>
  <a href="<%=request.getContextPath()%>/GoFit?page=calorie" class="active"><span class="nav-icon">🍎</span> Food Tracking</a>
  <a href="<%=request.getContextPath()%>/GoFit?page=workout"><span class="nav-icon">🏋️</span> Workout</a>
  <div class="nav-divider"></div>
  <div class="nav-logout" onclick="logout()"><span class="nav-icon">🚪</span> Logout</div>
</div>

<main>

  <div class="card">
    <div class="date-row">
      <button class="arrow-btn" onclick="changeDay(-1)">&#8249;</button>
      <span id="dateLabel">Today</span>
      <button class="arrow-btn" id="btnNext" onclick="changeDay(1)">&#8250;</button>
    </div>
    <% if (!isToday) { %>
    <div style="margin-top:10px;background:rgba(167,139,250,0.1);border:1px solid rgba(167,139,250,0.25);border-radius:8px;padding:8px 12px;font-size:0.8rem;color:#c4b5fd;">
      📅 Viewing past data — logging is disabled for previous days.
    </div>
    <% } %>
  </div>

  <div class="card">
    <div class="card-label">Calorie Summary</div>
    <div class="stat-row">
      <div class="stat-box">
        <span class="stat-val" id="statConsumed" style="color:#4ade80">0</span>
        <span class="stat-lbl">Consumed</span>
        <span id="statOver" style="display:none;font-size:0.7rem;font-weight:700;color:#f87171;margin-top:4px;"></span>
      </div>
      <div class="stat-box">
        <span class="stat-val" id="statRemaining" style="color:#5a7291"><%= calorieGoal %></span>
        <span class="stat-lbl">Remaining</span>
      </div>
      <div class="stat-box">
        <span class="stat-val" style="color:#5a7291"><%= calorieGoal %></span>
        <span class="stat-lbl">Goal</span>
      </div>
    </div>
    <div class="prog-meta"><span id="progPct">0%</span><span id="progStatus">No food yet</span></div>
    <div class="prog-track"><div class="prog-fill" id="progFill" style="width:0%"></div></div>
    <div class="macro-title">Macros</div>
    <div class="macro-row">
      <div class="macro-box carbs">
        <span class="macro-val" id="macroCarbs">0g</span>
        <span class="macro-lbl">Carbs</span>
        <span class="macro-pct" id="macroCarbsPct">0%</span>
        <div class="macro-bar-wrap"><div class="macro-bar-fill" id="macroCarbsBar" style="width:0%"></div></div>
      </div>
      <div class="macro-box protein">
        <span class="macro-val" id="macroProtein">0g</span>
        <span class="macro-lbl">Protein</span>
        <span class="macro-pct" id="macroProteinPct">0%</span>
        <div class="macro-bar-wrap"><div class="macro-bar-fill" id="macroProteinBar" style="width:0%"></div></div>
      </div>
      <div class="macro-box fat">
        <span class="macro-val" id="macroFat">0g</span>
        <span class="macro-lbl">Fat</span>
        <span class="macro-pct" id="macroFatPct">0%</span>
        <div class="macro-bar-wrap"><div class="macro-bar-fill" id="macroFatBar" style="width:0%"></div></div>
      </div>
    </div>
    <div class="macro-stack" id="macroStack">
      <div class="macro-stack-seg c" id="stackC" style="width:0%"></div>
      <div class="macro-stack-seg p" id="stackP" style="width:0%"></div>
      <div class="macro-stack-seg f" id="stackF" style="width:0%"></div>
    </div>
    <div class="macro-stack-legend">
      <div class="msl"><div class="msl-dot" style="background:#60a5fa"></div>Carbs</div>
      <div class="msl"><div class="msl-dot" style="background:#c084fc"></div>Protein</div>
      <div class="msl"><div class="msl-dot" style="background:#fbbf24"></div>Fat</div>
    </div>
  </div>

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
        <span class="ai-chip-emoji">🥗</span> Rice + dal ~420 kcal
      </div>
      <div class="ai-chip" onclick="quickLog('Peanut butter + banana','1 serving',310,38,10,13)">
        <span class="ai-chip-emoji">🥜</span> Peanut butter + banana
      </div>
    </div>
  </div>

  <div class="card" id="addCard">
    <div class="card-label">Log Food</div>
    <div class="tabs">
      <button class="tab-btn active" onclick="switchTab('manual')" id="tab-manual">✏️ Manual</button>
      <button class="tab-btn" onclick="switchTab('camera')" id="tab-camera">📷 Scan Food</button>
    </div>

    <div class="tab-panel active" id="panel-manual">
      <form action="<%=request.getContextPath()%>/GoFit" method="post" id="manualForm">
        <input type="hidden" name="action" value="addCalorie">
        <div class="input-row">
          <input type="text"   name="foodName" id="foodNameInput" placeholder="Food name (e.g. Roti, Dal, Chicken curry)" list="foodDatalist" autocomplete="off" required />
          <input type="number" id="qtyInput" value="1" min="0.25" step="0.25" title="Quantity" placeholder="Qty" />
          <input type="text"   name="serving" id="servingInput" placeholder="Serving" />
        </div>
        <datalist id="foodDatalist"></datalist>
        <div class="macro-input-label">Calories &amp; Macros (auto-filled, editable)</div>
        <div class="input-row">
          <input type="number" name="kcal" id="kcalInput" placeholder="Calories" required />
        </div>
        <div class="macro-input-row">
          <input type="number" step="0.1" name="carbsG"   id="carbsInput"   placeholder="Carbs g" />
          <input type="number" step="0.1" name="proteinG" id="proteinInput" placeholder="Protein g" />
          <input type="number" step="0.1" name="fatG"     id="fatInput"     placeholder="Fat g" />
        </div>
        <div class="live-preview" id="livePreview"></div>
        <button type="submit" class="btn-add">+ Add Food</button>
      </form>
    </div>

    <div class="tab-panel" id="panel-camera">
      <div class="cam-action-btns">
        <button class="cam-action-btn" onclick="startCamera()">
          <span class="cab-icon">📷</span>Open Camera
        </button>
        <button class="cam-action-btn" onclick="document.getElementById('fileInput').click()">
          <span class="cab-icon">🖼️</span>Upload from Gallery
        </button>
      </div>
      <input type="file" id="fileInput" accept="image/*" onchange="handleUpload(event)" />
      <div class="camera-area">
        <div class="cam-placeholder" id="camPlaceholder">
          <div class="cam-icon">🍱</div>
          <p>Take a photo or pick from gallery<br>AI detects food + estimates macros</p>
        </div>
        <video id="videoEl" autoplay playsinline muted></video>
        <canvas id="canvasEl"></canvas>
        <img id="previewImg" alt="Food" />
        <span class="cam-live-badge" id="liveBadge">● LIVE</span>
        <div class="shutter-wrap" id="shutterWrap">
          <button class="shutter-btn" onclick="capturePhoto()">📸</button>
        </div>
      </div>
      <button class="btn-retake" id="btnRetake" onclick="resetCamera()">↩ Retake / Change Photo</button>
      <button class="btn-scan" id="btnScan" onclick="scanWithGemini()" disabled>
        <span class="spinner" id="scanSpinner"></span>
        <span id="scanLabel">🔍 Analyse with AI</span>
      </button>
      <div class="ai-result" id="aiResult">
        <div class="ai-result-label">🤖 AI Food Detection</div>
        <div id="aiItems"></div>
        <div class="ai-result-note" id="aiNote"></div>
      </div>
      <button class="btn-log-all" id="btnLogAll" onclick="logAllAiItems()">✅ Log All Items</button>
    </div>
  </div>

  <div class="card">
    <div class="list-header">
      <div class="card-label" style="margin-bottom:0">Food List</div>
      <span style="font-size:0.72rem;color:#5a7291" id="itemCount">0 items</span>
    </div>
    <div id="list"></div>
  </div>

</main>

<div class="toast" id="toast"></div>

<script>
  // ── Server-provided date state (from ?date=yyyy-MM-dd, defaults to today) ──
  var contextPath = '<%=request.getContextPath()%>';
  var SELECTED_DATE = "<%= selectedDateStr %>"; // yyyy-MM-dd
  var IS_TODAY = <%= isToday %>;
  var dayOffset = 0;
  var GOAL = <%= calorieGoal %>;
  var capturedB64 = null, capturedMime = 'image/jpeg';
  var stream = null, aiDetectedItems = [];

  // name (lowercase) : [serving, kcal, carbs, protein, fat] per 1 serving
  var INDIAN_FOODS = {
    "roti":["1 medium",71,15,3,0.4], "chapati":["1 medium",71,15,3,0.4],
    "paratha":["1 plain",126,18,3,5], "aloo paratha":["1 piece",220,30,4,9],
    "puri":["1 piece",100,12,2,5], "rice":["1 cup cooked",205,45,4.3,0.4],
    "white rice":["1 cup",205,45,4.3,0.4], "brown rice":["1 cup",216,45,5,1.8],
    "jeera rice":["1 cup",250,40,5,8], "veg biryani":["1 plate",350,50,8,12],
    "chicken biryani":["1 plate",450,45,25,18], "mutton biryani":["1 plate",500,45,28,22],
    "dal tadka":["1 bowl",180,25,9,5], "dal fry":["1 bowl",200,25,9,7],
    "rajma":["1 bowl",220,30,10,6], "chole":["1 bowl",270,35,10,10],
    "chana masala":["1 bowl",270,35,10,10], "palak paneer":["1 bowl",280,10,14,20],
    "paneer butter masala":["1 bowl",350,12,14,26], "shahi paneer":["1 bowl",380,12,15,28],
    "butter chicken":["1 bowl",490,12,30,35], "chicken curry":["1 bowl",300,8,28,18],
    "chicken tikka masala":["1 bowl",350,10,30,20], "egg curry":["1 bowl",220,6,14,15],
    "boiled egg":["1 large",78,0.6,6,5], "omelette":["1 egg",90,1,6,7],
    "2 egg omelette":["2 eggs",180,2,12,14], "scrambled eggs":["2 eggs",190,2,13,14],
    "egg bhurji":["2 eggs",220,4,13,16], "fish curry":["1 bowl",250,6,25,14],
    "fried fish":["100g",200,5,20,12], "mutton curry":["1 bowl",350,8,25,22],
    "idli":["2 pieces",78,16,2,0.3], "dosa":["1 plain",133,20,3,4],
    "masala dosa":["1 piece",250,35,5,10], "uttapam":["1 piece",180,25,5,6],
    "medu vada":["2 pieces",200,15,6,12], "sambar":["1 bowl",150,20,6,4],
    "coconut chutney":["2 tbsp",60,3,1,5], "upma":["1 bowl",200,30,5,7],
    "poha":["1 bowl",250,40,5,7], "pav bhaji":["1 plate",400,50,8,18],
    "vada pav":["1 piece",290,40,6,12], "samosa":["1 piece",260,25,4,17],
    "kachori":["1 piece",200,20,4,12], "pakora":["100g",250,20,6,16],
    "bhel puri":["1 plate",200,35,5,5], "sev puri":["1 plate",250,35,5,10],
    "pani puri":["6 pieces",150,25,3,4], "dhokla":["2 pieces",160,25,6,4],
    "curd":["1 cup",150,11,8,8], "yogurt":["1 cup",150,11,8,8],
    "buttermilk":["1 glass",40,4,2,1], "lassi":["1 glass",220,35,6,6],
    "paneer":["100g raw",265,3,18,20], "curd rice":["1 bowl",200,30,6,5],
    "tandoori chicken":["1 leg piece",200,2,25,10], "chicken 65":["100g",280,10,20,18],
    "fish fry":["100g",220,8,20,12], "prawns curry":["1 bowl",220,8,22,10],
    "kadhi":["1 bowl",150,15,5,8], "bhindi masala":["1 bowl",150,12,3,10],
    "aloo gobi":["1 bowl",180,20,4,9], "baingan bharta":["1 bowl",160,15,3,10],
    "mixed veg curry":["1 bowl",150,15,4,8], "rajma chawal":["1 plate",450,65,15,10],
    "dal chawal":["1 plate",400,60,14,8], "khichdi":["1 bowl",250,40,8,6],
    "curd vada":["2 pieces",250,20,8,15], "gulab jamun":["1 piece",150,20,2,7],
    "rasgulla":["1 piece",106,22,2,0.5], "jalebi":["2 pieces",150,25,1,6],
    "barfi":["1 piece",100,12,2,5], "besan ladoo":["1 piece",180,20,4,9],
    "gajar halwa":["1 bowl",250,30,4,12], "kheer":["1 bowl",200,35,5,5],
    "payasam":["1 bowl",200,30,4,6], "naan":["1 piece",260,45,8,5],
    "butter naan":["1 piece",310,45,8,10], "garlic naan":["1 piece",300,45,8,9],
    "missi roti":["1 piece",120,20,4,3], "thepla":["1 piece",110,15,3,4],
    "dal makhani":["1 bowl",300,25,10,18], "malai kofta":["1 bowl",350,20,8,26],
    "veg pulao":["1 plate",300,45,6,10], "egg fried rice":["1 plate",350,50,12,12],
    "chicken fried rice":["1 plate",400,50,20,12], "chicken noodles":["1 plate",380,45,18,14],
    "veg noodles":["1 plate",300,45,8,10], "veg manchurian":["1 bowl",250,20,6,16],
    "chicken manchurian":["1 bowl",300,15,20,18], "spring roll":["2 pieces",180,20,4,9],
    "veg momos":["6 pieces",180,25,5,6], "chicken momos":["6 pieces",220,20,12,8],
    "green chutney":["2 tbsp",25,3,1,1], "papad":["1 roasted",40,6,2,1],
    "pickle":["1 tbsp",35,3,0.3,3], "banana":["1 medium",105,27,1,0.3],
    "apple":["1 medium",95,25,0.5,0.3], "mango":["1 cup sliced",100,25,1,0.5],
    "papaya":["1 cup",55,14,0.9,0.2], "watermelon":["1 cup",46,11,1,0.2],
    "almonds":["10 pieces",70,2,3,6], "peanuts":["30g",170,5,7,14],
    "chai":["1 cup",80,12,2,3], "tea":["1 cup",80,12,2,3],
    "black coffee":["1 cup",5,1,0.3,0], "filter coffee":["1 cup",60,8,2,2]
  };

  var currentFood = null; // { serving, kcal, carbs, protein, fat } base values per 1 serving

  var todayItems = [
<%
    if (calorieLogs != null) {
        for (int i = 0; i < calorieLogs.size(); i++) {
            CalorieLog log = calorieLogs.get(i);
            String foodName = log.getFoodName() != null ? log.getFoodName().replace("\"", "\\\"").replace("'", "\\'") : "";
            String serving = log.getServing() != null ? log.getServing().replace("\"", "\\\"") : "1 serving";
%>
    { id: <%= log.getId() %>, name: "<%= foodName %>", serving: "<%= serving %>",
      kcal: <%= log.getKcal() %>, carbs: <%= log.getCarbsG() %>, protein: <%= log.getProteinG() %>, fat: <%= log.getFatG() %>, src: 'manual' }<%= (i < calorieLogs.size() - 1) ? "," : "" %>
<%
        }
    }
%>
  ];

  var data = {};
  data[SELECTED_DATE] = todayItems; // todayItems is really "items for SELECTED_DATE" — server already filtered by date

  function saveFoodToServer(name, serving, kcal, carbs, protein, fat) {
    return fetch(contextPath + '/GoFit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'action=addCalorie'
          + '&foodName=' + encodeURIComponent(name)
          + '&serving=' + encodeURIComponent(serving || '1 serving')
          + '&kcal=' + encodeURIComponent(kcal)
          + '&carbsG=' + encodeURIComponent(carbs || 0)
          + '&proteinG=' + encodeURIComponent(protein || 0)
          + '&fatG=' + encodeURIComponent(fat || 0)
    }).then(function(res){
      if (!res.ok) throw new Error('Server returned ' + res.status);
      return res;
    });
  }

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

  function quickLog(name, serving, kcal, carbs, protein, fat) {
    saveFoodToServer(name, serving, kcal, carbs, protein, fat)
      .then(function(){ showToast('✅ ' + name + ' logged!', true); setTimeout(function(){ location.reload(); }, 500); })
      .catch(function(err){ showToast('Could not save: ' + err.message); });
  }

  function updateInsight(totalKcal, remaining, over) {
    var banner = document.getElementById('halfwayBanner');
    var text = document.getElementById('aiInsightText');
    var chips = document.getElementById('aiInsightChips');
    var pct = totalKcal / GOAL;
    banner.style.display = (pct >= 0.45 && pct < 0.65) ? 'block' : 'none';
    if (totalKcal === 0) {
      text.innerHTML = 'Start logging your meals to get personalised AI recommendations for the day.';
      chips.innerHTML =
        chip('🥚','2 eggs + toast ~280 kcal','2 eggs + toast','1 plate',280,30,16,10) +
        chip('🥗','Rice + dal ~420 kcal','Rice + dal','1 bowl',420,60,18,8) +
        chip('🥜','Peanut butter + banana','Peanut butter + banana','1 serving',310,38,10,13);
    } else if (over) {
      text.innerHTML = "You've consumed <strong>" + totalKcal + " kcal</strong> — you're <strong style='color:#f87171'>" + (totalKcal - GOAL) + " kcal over</strong> your goal.";
      chips.innerHTML =
        chip('💧','Drink water','Water','500ml',0,0,0,0) +
        chip('🥗','Light salad ~80 kcal','Green salad','1 bowl',80,10,4,2);
    } else if (remaining < 300) {
      text.innerHTML = "Almost at your goal! Only <strong>" + remaining + " kcal</strong> remaining.";
      chips.innerHTML =
        chip('🍵','Green tea + almonds ~90 kcal','Green tea + almonds','1 cup + 5 nuts',90,4,3,7) +
        chip('🍌','Banana ~90 kcal','Banana','1 medium',90,23,1,0);
    } else {
      text.innerHTML = "You've consumed <strong>" + totalKcal + " kcal</strong> with <strong>" + remaining + " kcal</strong> remaining.";
      chips.innerHTML =
        chip('🥚','2 eggs + toast ~280 kcal','2 eggs + toast','1 plate',280,30,16,10) +
        chip('🥗','Rice + dal ~420 kcal','Rice + dal','1 bowl',420,60,18,8) +
        chip('🥜','Peanut butter + banana','Peanut butter + banana','1 serving',310,38,10,13);
    }
  }

  function chip(emoji, label, name, serving, kcal, carbs, protein, fat) {
    return "<div class='ai-chip' onclick=\"quickLog('" + name.replace(/'/g,"\\'") + "','" + serving + "'," + kcal + "," + carbs + "," + protein + "," + fat + ")\">"
         + "<span class='ai-chip-emoji'>" + emoji + "</span> " + label + "</div>";
  }

  function switchTab(t) {
    ['manual','camera'].forEach(function(x){
      document.getElementById('tab-'+x).classList.toggle('active',x===t);
      document.getElementById('panel-'+x).classList.toggle('active',x===t);
    });
    if (t!=='camera') stopCamera();
  }

  // Parse SELECTED_DATE (yyyy-MM-dd) as a local date, not UTC, to avoid off-by-one
  // near midnight in some timezones.
  function parseLocalDate(str) {
    var parts = str.split('-');
    return new Date(parseInt(parts[0],10), parseInt(parts[1],10)-1, parseInt(parts[2],10));
  }
  function formatLocalDate(d) {
    return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
  }
  function getDate(o){ var d=parseLocalDate(SELECTED_DATE); d.setDate(d.getDate()+o); return d; }
  function getKey(d) { return formatLocalDate(d); }
  function updateDate(){
    var d = parseLocalDate(SELECTED_DATE);
    var todayStr = formatLocalDate(new Date());
    var yestDate = new Date(); yestDate.setDate(yestDate.getDate()-1);
    var yestStr = formatLocalDate(yestDate);
    var label = IS_TODAY ? 'Today' : (SELECTED_DATE === yestStr ? 'Yesterday' : d.toDateString());
    document.getElementById('dateLabel').innerText = label;
    document.getElementById('btnNext').disabled = IS_TODAY;
    document.getElementById('addCard').style.display = IS_TODAY ? 'block' : 'none';
    document.getElementById('aiInsightCard').style.display = IS_TODAY ? 'block' : 'none';
  }
  
  function changeDay(dir){
    var d = getDate(dir);
    var newDateStr = formatLocalDate(d);
    var todayStr = formatLocalDate(new Date());
    if (newDateStr > todayStr) return; 
    window.location.href = 'GoFit?page=calorie&date=' + newDateStr;
  }
  function getItems(){ return data[SELECTED_DATE] || []; }

  function deleteFood(id){
    if (!id) return;
    fetch(contextPath + '/GoFit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'action=deleteCalorie&id=' + encodeURIComponent(id)
    }).then(function(){ location.reload(); })
      .catch(function(err){ showToast('Could not delete: ' + err.message); });
  }


  (function initFoodAutocomplete(){
    var dl = document.getElementById('foodDatalist');
    dl.innerHTML = Object.keys(INDIAN_FOODS).map(function(k){
      var label = k.charAt(0).toUpperCase() + k.slice(1);
      return '<option value="' + label + '">';
    }).join('');

    var nameInput   = document.getElementById('foodNameInput');
    var qtyInput    = document.getElementById('qtyInput');
    var servingInput= document.getElementById('servingInput');
    var kcalInput   = document.getElementById('kcalInput');
    var carbsInput  = document.getElementById('carbsInput');
    var proteinInput= document.getElementById('proteinInput');
    var fatInput    = document.getElementById('fatInput');
    var preview     = document.getElementById('livePreview');

    nameInput.addEventListener('input', function(){
      var key = nameInput.value.trim().toLowerCase();
      var match = INDIAN_FOODS[key];
      if (match) {
        currentFood = { serving: match[0], kcal: match[1], carbs: match[2], protein: match[3], fat: match[4] };
        qtyInput.value = 1;
        applyQty();
      } else {
        currentFood = null;
        preview.innerText = '';
      }
    });

    qtyInput.addEventListener('input', applyQty);

    function applyQty(){
      if (!currentFood) return;
      var qty = parseFloat(qtyInput.value) || 1;
      var k = Math.round(currentFood.kcal * qty);
      var c = +(currentFood.carbs * qty).toFixed(1);
      var p = +(currentFood.protein * qty).toFixed(1);
      var f = +(currentFood.fat * qty).toFixed(1);

      servingInput.value = qty + ' x ' + currentFood.serving;
      kcalInput.value = k;
      carbsInput.value = c;
      proteinInput.value = p;
      fatInput.value = f;
      preview.innerText = '≈ ' + k + ' kcal · ' + c + 'g carbs · ' + p + 'g protein · ' + f + 'g fat';
    }
  })();

  function startCamera(){
    if(!navigator.mediaDevices||!navigator.mediaDevices.getUserMedia){showToast('Camera not supported');return;}
    navigator.mediaDevices.getUserMedia({video:{facingMode:'environment'},audio:false})
      .then(function(s){
        stream=s;
        var v=document.getElementById('videoEl');
        v.srcObject=s; v.style.display='block';
        document.getElementById('previewImg').style.display='none';
        document.getElementById('camPlaceholder').style.display='none';
        document.getElementById('liveBadge').style.display='block';
        document.getElementById('shutterWrap').style.display='block';
        document.getElementById('btnRetake').style.display='none';
        document.getElementById('btnScan').disabled=true;
        capturedB64=null; hideAiResult();
      })
      .catch(function(err){showToast('Camera error: '+err.message);});
  }

  function capturePhoto(){
    var v=document.getElementById('videoEl'),c=document.getElementById('canvasEl');
    c.width=v.videoWidth; c.height=v.videoHeight;
    c.getContext('2d').drawImage(v,0,0);
    var dataUrl=c.toDataURL('image/jpeg',0.88);
    capturedB64=dataUrl.split(',')[1]; capturedMime='image/jpeg';
    var img=document.getElementById('previewImg');
    img.src=dataUrl; img.style.display='block'; v.style.display='none';
    document.getElementById('liveBadge').style.display='none';
    document.getElementById('shutterWrap').style.display='none';
    document.getElementById('btnRetake').style.display='block';
    document.getElementById('btnScan').disabled=false;
    stopCamera();
  }

  function handleUpload(e){
    var file=e.target.files[0]; if(!file)return;
    capturedMime=file.type||'image/jpeg';
    var r=new FileReader();
    r.onload=function(ev){
      var dataUrl=ev.target.result; capturedB64=dataUrl.split(',')[1];
      var img=document.getElementById('previewImg');
      img.src=dataUrl; img.style.display='block';
      document.getElementById('videoEl').style.display='none';
      document.getElementById('camPlaceholder').style.display='none';
      document.getElementById('liveBadge').style.display='none';
      document.getElementById('shutterWrap').style.display='none';
      document.getElementById('btnRetake').style.display='block';
      document.getElementById('btnScan').disabled=false;
      hideAiResult();
    };
    r.readAsDataURL(file); stopCamera(); e.target.value='';
  }

  function resetCamera(){
    stopCamera(); capturedB64=null;
    document.getElementById('previewImg').style.display='none';
    document.getElementById('previewImg').src='';
    document.getElementById('videoEl').style.display='none';
    document.getElementById('camPlaceholder').style.display='block';
    document.getElementById('liveBadge').style.display='none';
    document.getElementById('shutterWrap').style.display='none';
    document.getElementById('btnRetake').style.display='none';
    document.getElementById('btnScan').disabled=true;
    hideAiResult();
  }

  function stopCamera(){
    if(stream){stream.getTracks().forEach(function(t){t.stop();});stream=null;}
  }

  // ── AI SCAN: now calls our own servlet proxy — no API key in the browser ──
  function scanWithGemini(){
    if(!capturedB64){showToast('Take or upload a photo first');return;}
    setScanLoading(true); hideAiResult();
    fetch(contextPath + '/GoFit?action=aiScanFood', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ imageBase64: capturedB64, mimeType: capturedMime })
    })
    .then(function(res){ return res.json(); })
    .then(function(d){
      setScanLoading(false);
      if (d.error) { showToast('AI error: ' + d.error); return; }
      showAiItems(d.items || []);
    })
    .catch(function(err){ setScanLoading(false); showToast('AI error: '+err.message); });
  }

  function showAiItems(items){
    aiDetectedItems = Array.isArray(items) ? items : [];
    if(!aiDetectedItems.length){showToast('No food detected — try a clearer photo');return;}
    var html='',totalK=0,totalC=0,totalP=0,totalF=0;
    aiDetectedItems.forEach(function(item){
      var k=parseInt(item.kcal)||0, c=parseFloat(item.carbs)||0, p=parseFloat(item.protein)||0, f=parseFloat(item.fat)||0;
      totalK+=k; totalC+=c; totalP+=p; totalF+=f;
      html+="<div class='ai-food-item'><div><div class='ai-food-name'>"+esc(item.name)+"</div>"
          +"<div class='ai-food-meta'>"+esc(item.serving||'1 serving')+"</div>"
          +"<div class='ai-food-macros'><span class='mc'>C "+c+"g</span><span class='mp'>P "+p+"g</span><span class='mf'>F "+f+"g</span></div></div>"
          +"<div class='ai-food-kcal'>"+k+" kcal</div></div>";
    });
    document.getElementById('aiItems').innerHTML=html;
    document.getElementById('aiNote').innerText='⚡ Estimates are approximate. Total: ~'+totalK+' kcal · '+totalC+'g carbs · '+totalP+'g protein · '+totalF+'g fat';
    document.getElementById('aiResult').style.display='block';
    document.getElementById('btnLogAll').style.display='block';
  }

  function logAllAiItems(){
    var count=aiDetectedItems.length;
    var saves=aiDetectedItems.map(function(item){
      return saveFoodToServer(item.name,item.serving||'1 serving',parseInt(item.kcal)||0,parseFloat(item.carbs)||0,parseFloat(item.protein)||0,parseFloat(item.fat)||0);
    });
    Promise.all(saves).then(function(){
      aiDetectedItems=[]; document.getElementById('btnLogAll').style.display='none'; document.getElementById('aiResult').style.display='none';
      resetCamera(); showToast('✅ '+count+' item'+(count!==1?'s':'')+' logged!',true);
      setTimeout(function(){ location.reload(); },500);
    }).catch(function(err){ showToast('Some items failed to save: '+err.message); });
  }

  function hideAiResult(){ document.getElementById('aiResult').style.display='none'; document.getElementById('btnLogAll').style.display='none'; aiDetectedItems=[]; }
  function setScanLoading(on){ document.getElementById('btnScan').disabled=on; document.getElementById('scanSpinner').style.display=on?'inline-block':'none'; document.getElementById('scanLabel').textContent=on?'Analysing…':'🔍 Analyse with AI'; }

  var toastT;
  function showToast(msg,ok){
    var el=document.getElementById('toast');
    el.textContent=msg;
    el.style.background=ok?'#0f2a1a':'#1a0a0a';
    el.style.border=ok?'1px solid rgba(74,222,128,0.4)':'1px solid rgba(248,113,113,0.4)';
    el.style.color=ok?'#4ade80':'#f87171';
    el.classList.add('show'); clearTimeout(toastT);
    toastT=setTimeout(function(){el.classList.remove('show');},3200);
  }
  function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
  function logout(){
    closeNav();
    if(!confirm('Log out of GoFit?')) return;
    var f = document.createElement('form');
    f.method = 'POST'; f.action = 'GoFit';
    var i = document.createElement('input');
    i.type = 'hidden'; i.name = 'action'; i.value = 'logout';
    f.appendChild(i);
    document.body.appendChild(f);
    f.submit();
  }

  function render(){
    var items=getItems();
    var totalKcal=0,totalC=0,totalP=0,totalF=0;
    items.forEach(function(i){totalKcal+=i.kcal;totalC+=i.carbs;totalP+=i.protein;totalF+=i.fat;});
    var remaining=GOAL-totalKcal, pct=Math.round(totalKcal/GOAL*100), over=totalKcal>GOAL, dp=Math.min(pct,100);
    document.getElementById('overAlert').style.display=over?'inline-block':'none';
    document.getElementById('statConsumed').innerText=totalKcal;
    document.getElementById('statOver').innerText=over?'+'+(totalKcal-GOAL)+' over':'';
    document.getElementById('statOver').style.display=over?'block':'none';
    document.getElementById('statRemaining').innerText=over?'Over!':remaining;
    document.getElementById('statRemaining').style.color=over?'#f87171':'#5a7291';
    document.getElementById('progPct').innerText=pct+'%';
    document.getElementById('progStatus').innerText=over?'Over goal 🔴':pct>80?'Almost there 🟡':pct>0?'On track 🟢':'No food yet';
    var fill=document.getElementById('progFill'); fill.style.width=dp+'%'; fill.className=over?'prog-fill over':'prog-fill';
    var totalMacroG=totalC+totalP+totalF;
    var cPct=totalMacroG>0?Math.round(totalC/totalMacroG*100):0;
    var pPct=totalMacroG>0?Math.round(totalP/totalMacroG*100):0;
    var fPct=totalMacroG>0?Math.round(totalF/totalMacroG*100):0;
    document.getElementById('macroCarbs').innerText=totalC.toFixed(0)+'g';
    document.getElementById('macroProtein').innerText=totalP.toFixed(0)+'g';
    document.getElementById('macroFat').innerText=totalF.toFixed(0)+'g';
    document.getElementById('macroCarbsPct').innerText=cPct+'% of macros';
    document.getElementById('macroProteinPct').innerText=pPct+'% of macros';
    document.getElementById('macroFatPct').innerText=fPct+'% of macros';
    document.getElementById('macroCarbsBar').style.width=Math.min(totalC/275*100,100)+'%';
    document.getElementById('macroProteinBar').style.width=Math.min(totalP/110*100,100)+'%';
    document.getElementById('macroFatBar').style.width=Math.min(totalF/73*100,100)+'%';
    document.getElementById('stackC').style.width=cPct+'%';
    document.getElementById('stackP').style.width=pPct+'%';
    document.getElementById('stackF').style.width=fPct+'%';
    document.getElementById('itemCount').innerText=items.length+' items';
    updateInsight(totalKcal,remaining,over);
    var html='';
    if(!items.length){html="<div class='empty'>No food added yet</div>";}
    else{items.forEach(function(item){
      var hasM=item.carbs||item.protein||item.fat;
      html+="<div class='food-item'><div class='food-dot'></div><div class='food-info'>"
           +"<div class='food-name'>"+esc(item.name)+"</div>"
           +"<div class='food-serving'>"+esc(item.serving)+"</div>"
           +(hasM?"<div class='food-macros-row'>"
             +"<span class='fm-pill c'>C "+item.carbs.toFixed(0)+"g</span>"
             +"<span class='fm-pill p'>P "+item.protein.toFixed(0)+"g</span>"
             +"<span class='fm-pill f'>F "+item.fat.toFixed(0)+"g</span>"
             +"</div>":"")
           +"</div><div class='food-right'>"
           +"<span class='food-kcal'>"+item.kcal+" kcal</span>"
           +(item.id?"<button class='btn-delete' onclick='deleteFood("+item.id+")'>✕</button>":"")
           +"</div></div>";
    });}
    document.getElementById('list').innerHTML=html;
  }

  updateDate(); render();
</script>
</body>
</html>
