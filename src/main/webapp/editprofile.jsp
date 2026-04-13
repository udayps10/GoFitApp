<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Profile — GoFit</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg: #0a0f0a;
    --card: #0e1510;
    --surface: #121a13;
    --border: rgba(74,222,128,0.10);
    --text: #f0f5f0;
    --muted: #4a6650;
    --green: #4ade80;
    --green-dark: #16a34a;
    --green-mid: #22c55e;
    --red: #f87171;
    --red-bg: rgba(248,113,113,0.07);
    --red-border: rgba(248,113,113,0.35);
  }

  body {
    font-family: 'DM Sans', sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
  }

  body::before {
    content: '';
    position: fixed; top: -25%; left: -10%;
    width: 60vw; height: 60vw;
    background: radial-gradient(circle, rgba(74,222,128,0.07) 0%, transparent 65%);
    pointer-events: none; z-index: 0;
  }
  body::after {
    content: '';
    position: fixed; bottom: -20%; right: -10%;
    width: 50vw; height: 50vw;
    background: radial-gradient(circle, rgba(34,197,94,0.05) 0%, transparent 65%);
    pointer-events: none; z-index: 0;
  }

  .wave-bg {
    position: fixed; inset: 0; z-index: 0;
    pointer-events: none; width: 100%; height: 100%;
  }

  .card {
    position: relative; z-index: 1;
    background: rgba(14,21,16,0.85);
    border: 1px solid var(--border);
    border-radius: 20px;
    width: 420px;
    padding: 42px 40px;
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
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 30px;
  }
  .logo-icon {
    width: 36px; height: 36px;
    background: var(--green);
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    box-shadow: 0 0 16px rgba(74,222,128,0.35);
  }
  .logo-icon svg { width: 20px; height: 20px; }
  .logo-name {
    font-family: 'DM Serif Display', serif;
    font-size: 1.4rem;
    letter-spacing: -0.02em;
    color: var(--text);
  }

  .progress-wrap { display: flex; gap: 6px; margin-bottom: 26px; }
  .progress-bar {
    height: 2px; flex: 1; border-radius: 99px;
    background: rgba(74,222,128,0.12);
    transition: background 0.4s;
  }
  .progress-bar.active {
    background: var(--green);
    box-shadow: 0 0 8px rgba(74,222,128,0.5);
  }

  .step-label {
    font-size: 0.7rem; font-weight: 600;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--green-dark); margin-bottom: 6px;
  }

  h2 {
    font-family: 'DM Serif Display', serif;
    font-size: 2rem; font-weight: 400;
    letter-spacing: -0.03em; line-height: 1.15;
    margin-bottom: 4px;
  }
  .subtitle {
    font-size: 0.85rem; color: var(--muted);
    margin-bottom: 26px; font-weight: 300;
  }

  .slides-outer { overflow: hidden; }
  .slides {
    display: flex; width: 200%;
    transition: transform 0.45s cubic-bezier(0.65,0,0.35,1);
  }
  .slide { width: 50%; display: flex; flex-direction: column; gap: 11px; }

  .field { display: flex; flex-direction: column; gap: 5px; }

  label {
    font-size: 0.7rem; font-weight: 600;
    letter-spacing: 0.09em; text-transform: uppercase;
    color: var(--muted);
  }
  .label-note {
    font-weight: 300; text-transform: none; letter-spacing: 0;
    font-size: 0.68rem;
  }

  .input-wrap { position: relative; display: flex; align-items: center; }
  .input-wrap input { padding-right: 42px !important; }

  input, select {
    width: 100%;
    padding: 12px 14px;
    background: rgba(10,15,10,0.6);
    border: 1px solid rgba(74,222,128,0.10);
    border-radius: 10px;
    color: var(--text);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.9rem;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
    -webkit-appearance: none;
  }
  input::placeholder { color: #1e2e1e; }
  input:focus, select:focus {
    border-color: rgba(74,222,128,0.35);
    box-shadow: 0 0 0 3px rgba(74,222,128,0.08);
  }
  input.error, select.error {
    border-color: var(--red-border) !important;
    background: var(--red-bg) !important;
    box-shadow: 0 0 0 3px rgba(248,113,113,0.08) !important;
  }

  .err-msg {
    font-size: 0.72rem; color: var(--red);
    margin-top: 2px; display: none; font-weight: 500;
  }
  .err-msg.show { display: block; }

  select option { background: #0e1510; }

  .eye-btn {
    position: absolute; right: 13px;
    background: none; border: none; cursor: pointer;
    color: var(--muted); padding: 0;
    display: flex; align-items: center; justify-content: center;
    width: 20px; height: 20px; transition: color 0.2s;
  }
  .eye-btn:hover { color: var(--green); }
  .eye-btn svg { width: 17px; height: 17px; }

  .row { display: flex; gap: 10px; }
  .row .field { flex: 1; }

  .btn-primary {
    width: 100%; padding: 13px;
    background: var(--green); color: #071a0a;
    border: none; border-radius: 50px;
    font-family: 'DM Sans', sans-serif;
    font-size: 0.9rem; font-weight: 700;
    cursor: pointer; letter-spacing: 0.01em; margin-top: 6px;
    transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
    box-shadow: 0 4px 20px rgba(74,222,128,0.25);
  }
  .btn-primary:hover { background: var(--green-mid); box-shadow: 0 6px 28px rgba(74,222,128,0.40); transform: scale(1.02); }
  .btn-primary:active { transform: scale(0.98); }
  .btn-primary:disabled { opacity: 0.6; pointer-events: none; }

  .btn-secondary {
    width: 100%; padding: 13px;
    background: transparent; color: var(--muted);
    border: 1px solid rgba(74,222,128,0.12); border-radius: 50px;
    font-family: 'DM Sans', sans-serif; font-size: 0.9rem;
    font-weight: 500; cursor: pointer;
    transition: color 0.2s, border-color 0.2s;
  }
  .btn-secondary:hover { color: var(--green); border-color: rgba(74,222,128,0.3); }

  .btn-row { display: flex; gap: 10px; margin-top: 6px; }
  .btn-row .btn-primary,
  .btn-row .btn-secondary { margin-top: 0; }

  .footer {
    text-align: center; margin-top: 22px;
    font-size: 0.82rem; color: var(--muted);
  }
  .footer a { color: var(--green); text-decoration: none; font-weight: 600; }
  .footer a:hover { text-decoration: underline; }

  .strength-wrap { display: flex; gap: 4px; margin-top: 6px; }
  .strength-seg {
    height: 3px; flex: 1; border-radius: 99px;
    background: rgba(74,222,128,0.10); transition: background 0.3s;
  }
  .strength-label { font-size: 0.68rem; margin-top: 3px; color: var(--muted); font-weight: 500; min-height: 14px; }

  .toast {
    position: fixed; bottom: 32px; left: 50%;
    transform: translateX(-50%) translateY(16px);
    background: rgba(14,21,16,0.97);
    border: 1px solid rgba(74,222,128,0.28);
    border-radius: 12px; padding: 11px 20px;
    display: flex; align-items: center; gap: 9px;
    font-size: 0.84rem; font-weight: 500;
    box-shadow: 0 16px 40px rgba(0,0,0,0.5);
    opacity: 0; pointer-events: none;
    transition: opacity 0.3s, transform 0.3s;
    z-index: 200; white-space: nowrap;
  }
  .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
  .toast-icon { color: var(--green); }
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
  <path d="M0 820 C180 780, 360 840, 540 810 C720 780, 900 830, 1080 800 C1260 770, 1350 820, 1440 800 L1440 900 L0 900 Z" fill="#0d1a0e" fill-opacity="0.9"/>
  <path d="M0 850 C200 820, 400 870, 600 845 C800 820, 1000 860, 1200 838 C1350 820, 1400 845, 1440 835 L1440 900 L0 900 Z" fill="#0a150b" fill-opacity="0.7"/>
  <path d="M0 862 C240 840, 480 875, 720 855 C960 835, 1200 868, 1440 850" fill="none" stroke="#4ade80" stroke-width="1.2" stroke-opacity="0.18"/>
  <line x1="0" y1="300" x2="1440" y2="300" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
  <line x1="0" y1="500" x2="1440" y2="500" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
  <line x1="0" y1="700" x2="1440" y2="700" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.04"/>
  <line x1="300" y1="0" x2="300" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
  <line x1="720" y1="0" x2="720" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
  <line x1="1140" y1="0" x2="1140" y2="900" stroke="#4ade80" stroke-width="0.4" stroke-opacity="0.03"/>
</svg>

<div class="card">
  <div class="logo">
    <div class="logo-icon">
      <svg viewBox="0 0 24 24" fill="none">
        <path d="M6 12h2M16 12h2M8 12V9a1 1 0 011-1h6a1 1 0 011 1v3M8 12v3a1 1 0 001 1h6a1 1 0 001-1v-3" stroke="#071a0a" stroke-width="2" stroke-linecap="round"/>
        <circle cx="4" cy="12" r="2" fill="#071a0a"/>
        <circle cx="20" cy="12" r="2" fill="#071a0a"/>
      </svg>
    </div>
    <span class="logo-name">GoFit</span>
  </div>

  <div class="progress-wrap">
    <div class="progress-bar active" id="p1"></div>
    <div class="progress-bar" id="p2"></div>
  </div>

  <div class="step-label" id="step-label">Step 1 of 2</div>
  <h2 id="slide-title">Edit profile</h2>
  <p class="subtitle" id="slide-sub">Update your account details.</p>

  <form onsubmit="return false;">
    <div class="slides-outer">
      <div class="slides" id="slides">

        <!-- Slide 1 -->
        <div class="slide">

          <div class="field">
            <label for="fullname">Full Name</label>
            <input type="text" id="fullname" value="Alex Johnson" autocomplete="name">
            <span class="err-msg" id="err-fullname">Full name is required.</span>
          </div>

          <div class="field">
            <label for="email">Email</label>
            <input type="email" id="email" value="alex@example.com" autocomplete="email">
            <span class="err-msg" id="err-email">Enter a valid email address.</span>
          </div>

          <div class="field">
            <label for="pw-new">New Password <span class="label-note">(leave blank to keep current)</span></label>
            <div class="input-wrap">
              <input type="password" id="pw-new" placeholder="Min. 8 characters" autocomplete="new-password">
              <button type="button" class="eye-btn" onclick="togglePw('pw-new','eye1','eyeoff1')" tabindex="-1">
                <svg id="eye1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                <svg id="eyeoff1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
              </button>
            </div>
            <div class="strength-wrap">
              <div class="strength-seg" id="s1"></div>
              <div class="strength-seg" id="s2"></div>
              <div class="strength-seg" id="s3"></div>
              <div class="strength-seg" id="s4"></div>
            </div>
            <div class="strength-label" id="strength-label"></div>
            <span class="err-msg" id="err-pw-new">Password must be at least 8 characters.</span>
          </div>

          <div class="field">
            <label for="pw-confirm">Confirm New Password</label>
            <div class="input-wrap">
              <input type="password" id="pw-confirm" placeholder="Repeat new password" autocomplete="new-password">
              <button type="button" class="eye-btn" onclick="togglePw('pw-confirm','eye2','eyeoff2')" tabindex="-1">
                <svg id="eye2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                <svg id="eyeoff2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
              </button>
            </div>
            <span class="err-msg" id="err-pw-confirm">Passwords do not match.</span>
          </div>

          <button type="button" class="btn-primary" onclick="nextSlide()">Continue →</button>
        </div>

        <!-- Slide 2 -->
        <div class="slide">

          <div class="row">
            <div class="field">
              <label for="age">Age</label>
              <input type="number" id="age" value="25" min="10" max="100">
              <span class="err-msg" id="err-age">Enter a valid age (10–100).</span>
            </div>
            <div class="field">
              <label for="weight">Weight (kg)</label>
              <input type="number" id="weight" value="70" min="20" max="300">
              <span class="err-msg" id="err-weight">Enter a valid weight.</span>
            </div>
          </div>

          <div class="field">
            <label for="height">Height (cm)</label>
            <input type="number" id="height" value="175" min="50" max="250">
            <span class="err-msg" id="err-height">Enter a valid height.</span>
          </div>

          <div class="field">
            <label for="goal">Fitness Goal</label>
            <select id="goal">
              <option value="Lose Fat">Lose Fat</option>
              <option value="Build Muscle" selected>Build Muscle</option>
              <option value="Maintain Weight">Maintain Weight</option>
              <option value="Improve Endurance">Improve Endurance</option>
            </select>
          </div>

          <div class="btn-row">
            <button type="button" class="btn-secondary" onclick="prevSlide()">← Back</button>
            <button type="button" class="btn-primary" id="btn-save" onclick="handleSave()">Save Changes</button>
          </div>
        </div>

      </div>
    </div>
  </form>

  <div class="footer">
    <a href="#" onclick="history.back(); return false;">← Back to app</a>
  </div>
</div>

<div class="toast" id="toast">
  <span class="toast-icon">✓</span>
  <span id="toast-msg">Profile updated successfully!</span>
</div>

<script>
  function setError(el, errEl, show) {
    if (show) { el.classList.add('error'); errEl.classList.add('show'); }
    else       { el.classList.remove('error'); errEl.classList.remove('show'); }
  }

  ['fullname','email','pw-new','pw-confirm'].forEach(function(id) {
    var el = document.getElementById(id);
    var err = document.getElementById('err-' + id);
    if (el && err) el.addEventListener('input', function(){ setError(el, err, false); });
  });

  document.getElementById('pw-new').addEventListener('input', function() {
    var val = this.value;
    var score = 0;
    if (val.length >= 8) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    var colors = ['#f87171','#fb923c','#facc15','#4ade80'];
    var labels = ['Weak','Fair','Good','Strong'];
    ['s1','s2','s3','s4'].forEach(function(id, i) {
      document.getElementById(id).style.background =
        val.length === 0 ? 'rgba(74,222,128,0.10)' :
        i < score ? colors[score-1] : 'rgba(74,222,128,0.10)';
    });
    document.getElementById('strength-label').textContent = val.length ? (labels[score-1]||'Weak') : '';
  });

  function validateSlide1() {
    var ok = true;
    var name = document.getElementById('fullname');
    if (!name.value.trim()) { setError(name, document.getElementById('err-fullname'), true); ok = false; }

    var email = document.getElementById('email');
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) { setError(email, document.getElementById('err-email'), true); ok = false; }

    var pwNew = document.getElementById('pw-new');
    var pwConfirm = document.getElementById('pw-confirm');
    if (pwNew.value.length > 0 && pwNew.value.length < 8) {
      setError(pwNew, document.getElementById('err-pw-new'), true); ok = false;
    }
    if (pwNew.value && pwConfirm.value !== pwNew.value) {
      setError(pwConfirm, document.getElementById('err-pw-confirm'), true); ok = false;
    }
    return ok;
  }

  function validateSlide2() {
    var ok = true;
    [
      ['age',    document.getElementById('err-age'),    function(v){ return !isNaN(v) && v >= 10 && v <= 100; }],
      ['weight', document.getElementById('err-weight'), function(v){ return !isNaN(v) && v >= 20 && v <= 300; }],
      ['height', document.getElementById('err-height'), function(v){ return !isNaN(v) && v >= 50 && v <= 250; }]
    ].forEach(function(row) {
      var el = document.getElementById(row[0]);
      var val = parseFloat(el.value);
      if (!el.value || !row[2](val)) { setError(el, row[1], true); ok = false; }
      else { setError(el, row[1], false); }
    });
    return ok;
  }

  function nextSlide() {
    if (!validateSlide1()) return;
    document.getElementById('slides').style.transform = 'translateX(-50%)';
    document.getElementById('p2').classList.add('active');
    document.getElementById('step-label').textContent = 'Step 2 of 2';
    document.getElementById('slide-title').textContent = 'Fitness profile';
    document.getElementById('slide-sub').textContent = 'Update your fitness details.';
  }

  function prevSlide() {
    document.getElementById('slides').style.transform = 'translateX(0%)';
    document.getElementById('p2').classList.remove('active');
    document.getElementById('step-label').textContent = 'Step 1 of 2';
    document.getElementById('slide-title').textContent = 'Edit profile';
    document.getElementById('slide-sub').textContent = 'Update your account details.';
  }

  function togglePw(inputId, eyeId, eyeOffId) {
    var input = document.getElementById(inputId);
    var isHidden = input.type === 'password';
    input.type = isHidden ? 'text' : 'password';
    document.getElementById(eyeId).style.display    = isHidden ? 'none'  : 'block';
    document.getElementById(eyeOffId).style.display = isHidden ? 'block' : 'none';
  }

  function handleSave() {
    if (!validateSlide2()) return;
    var btn = document.getElementById('btn-save');
    btn.textContent = 'Saving…'; btn.disabled = true;
    setTimeout(function() {
      btn.textContent = 'Save Changes'; btn.disabled = false;
      var toast = document.getElementById('toast');
      toast.classList.add('show');
      setTimeout(function(){ toast.classList.remove('show'); }, 3000);
    }, 800);
  }
</script>
</body>
</html>