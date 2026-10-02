# 💪 GoFit — Your Fitness, Simplified

A Java-based fitness tracking web application built with JSP, Servlets, and MySQL. GoFit lets users log daily exercises and calories, track their body stats, and get AI-powered nutrition insights — all in a clean, dark-themed dashboard.

---

## 📸 Preview

| Page | Description |
|---|---|
| `homepage.jsp` | Landing page with features, how-it-works, and call to action |
| `userdashboard.jsp` | Daily summary — calories, workouts, BMI, AI insight, streak |
| `workout.jsp` | Log exercises — name, weight (kg), reps |
| `calorie.jsp` | Log food — name, serving, kcal, protein, carbs, fat |
| `login.jsp` | User login |
| `register.jsp` | Two-step registration — account + body stats |

---

## 🗂️ Project Structure

```
GoFit/
│
├── src/
│   ├── model/
│   │   ├── User.java               # id, name, email, password, age, weightKg, heightCm, goal
│   │   ├── ExerciseLog.java        # id, userId, exerciseName, weightKg, reps, logDate
│   │   └── CalorieLog.java         # id, userId, foodName, serving, kcal, carbsG, proteinG, fatG, logDate
│   │
│   ├── dao/
│   │   ├── UserDAO.java            # register(), login()
│   │   ├── ExerciseLogDAO.java     # insert(), findByUserToday(), delete(), countToday()
│   │   └── CalorieLogDAO.java      # insert(), findByUserToday(), delete(), totalKcalToday()
│   │
│   ├── servlet/
│   │   ├── RegisterServlet.java    # POST → saves new user → redirect login.jsp
│   │   ├── LoginServlet.java       # POST → checks credentials → sets session → redirect dashboard
│   │   ├── ExerciseLogServlet.java # GET → load exercises | POST → add or delete exercise
│   │   └── CalorieLogServlet.java  # GET → load food logs  | POST → add or delete food
│   │
│   └── util/
│       └── DBConnection.java       # JDBC connection to gofit MySQL database
│
└── WebContent/
    ├── homepage.jsp
    ├── login.jsp
    ├── register.jsp
    ├── userdashboard.jsp
    ├── workout.jsp
    └── calorie.jsp
```

---

## 🗃️ Database Schema

Database name: `gofit`

### `users`
| Column | Type | Description |
|---|---|---|
| id | INT PK | Auto increment |
| name | VARCHAR(100) | Full name |
| email | VARCHAR(100) UNIQUE | Login email |
| password | VARCHAR(255) | Plain text (hash in production) |
| age | INT | Optional |
| weightKg | DECIMAL(5,2) | Body weight in kg |
| heightCm | DECIMAL(5,2) | Height in cm (used for BMI) |
| goal | VARCHAR(50) | e.g. Lose weight, Build muscle |

### `exercise_logs`
| Column | Type | Description |
|---|---|---|
| id | INT PK | Auto increment |
| userId | INT FK | References users(id) |
| exerciseName | VARCHAR(100) | e.g. Bench Press |
| weightKg | DECIMAL(5,2) | Dumbbell/barbell weight |
| reps | INT | Number of reps |
| logged_date | DATE | Defaults to today |
| created_at | TIMESTAMP | Auto |

### `calorie_logs`
| Column | Type | Description |
|---|---|---|
| id | INT PK | Auto increment |
| userId | INT FK | References users(id) |
| foodName | VARCHAR(100) | e.g. Rice + Dal |
| serving | VARCHAR(100) | e.g. 1 cup |
| kcal | INT | Calories |
| carbsG | DECIMAL(6,2) | Carbohydrates in grams |
| proteinG | DECIMAL(6,2) | Protein in grams |
| fatG | DECIMAL(6,2) | Fat in grams |
| logged_date | DATE | Defaults to today |
| created_at | TIMESTAMP | Auto |

---

## ⚙️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | JSP, HTML, CSS, JavaScript |
| Backend | Java Servlets |
| Database | MySQL |
| Pattern | MVC + DAO |
| Server | Apache Tomcat |
| AI Feature | Google Gemini 1.5 Flash API (food scanning) |

---

## 🚀 Setup Instructions

### 1. Clone / Download the project
```
Place the project inside your Tomcat webapps folder
```

### 2. Set up the database
```sql
-- Open MySQL and run:
CREATE DATABASE gofit;
USE gofit;
-- Then paste and run the contents of gofit_final.sql
```

### 3. Configure environment variables

Connection settings are read from the environment — nothing secret lives in the source.

| Variable | Default | Purpose |
|---|---|---|
| `DB_URL` | `jdbc:mysql://localhost:3306/gofit?allowPublicKeyRetrieval=true&useSSL=false` | JDBC connection string |
| `DB_USER` | `root` | Database user |
| `DB_PASSWORD` | *(empty)* | Database password — **set this, never commit it** |
| `GEMINI_API_KEY` | *(none)* | Google Gemini key for AI food scanning. Without it the app falls back to the Mifflin-St Jeor formula for calorie goals |

PowerShell (persists for your user):
```powershell
[Environment]::SetEnvironmentVariable("DB_PASSWORD", "<your_mysql_password>", "User")
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "<your_key>", "User")
```

Docker / PaaS: pass them as container or service environment variables.

### 4. MySQL JDBC Driver
Already bundled at `src/main/webapp/WEB-INF/lib/mysql-connector-j-9.5.0.jar` (plus `jbcrypt-0.4.jar` for password hashing).

### 5. Run on Tomcat
- Right-click project → Run on Server → Apache Tomcat
- Open browser: `http://localhost:8080/GOFIT/homepage.jsp`

### 6. Build the WAR manually
```powershell
javac -encoding UTF-8 -cp "<tomcat>/lib/servlet-api.jar;src/main/webapp/WEB-INF/lib/*" -d build/classes (Get-ChildItem src/main/java -Recurse -Filter *.java).FullName
# then package build/classes into GOFIT.war under WEB-INF/classes, or use the Dockerfile
```

---

## 🔗 URL Routing

| URL | What it does |
|---|---|
| `/homepage.jsp` | Landing page |
| `/register.jsp` | Registration form |
| `/RegisterServlet` | Saves new user |
| `/login.jsp` | Login form |
| `/LoginServlet` | Authenticates user, sets session |
| `/userdashboard.jsp` | Main dashboard |
| `/ExerciseLogServlet` | GET: load exercises · POST: add/delete |
| `/CalorieLogServlet` | GET: load food · POST: add/delete |
| `/LogoutServlet` | Clears session, redirects to login |

---

## ✨ Features

- **Exercise Logger** — Log any exercise with weight and reps. Delete with one click.
- **Calorie Tracker** — Log food with full macros (kcal, protein, carbs, fat).
- **Dashboard Summary** — See today's total calories, exercise count, and body stats at a glance.
- **BMI Calculator** — Auto-calculates from stored weight and height.
- **AI Food Scanning** — Take a photo of your meal and Gemini AI detects the food and estimates calories.
- **AI Insights** — Personalised daily recommendations based on your remaining calories and workouts.
- **Streak Tracker** — Visual calendar showing your active logging days.
- **Date Navigation** — Browse and view past days' logs (logging disabled for past days).

---

## 🔒 Session Management

Every protected page checks for a valid session:
```java
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
}
```

The `user` object (type `User`) is stored in session on login and removed on logout.

---

## 📌 Notes

- Passwords are hashed with BCrypt (`util.PasswordUtil`); existing plain-text rows are re-hashed on first successful login.
- The Gemini AI key is read from the `GEMINI_API_KEY` environment variable — get one from [Google AI Studio](https://aistudio.google.com). Registration still works without it; the calorie goal falls back to the Mifflin-St Jeor equation.
- The app is designed as an MVP — future features like workout planning, sets tracking, and personal records can be added using the existing database architecture.


## 🤝 Contributions
Contributions, issues, and feature requests are welcome.

Feel free to fork this repository and submit a pull request.

---

## 👨‍💻 Built By

**Udaypratap Singh ** — GoFit v1.0 · 2026 

Thankyou !

