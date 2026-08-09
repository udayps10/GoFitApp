# GoFit Login Troubleshooting Guide

## 🔍 What I Fixed

1. **Database Connection**: Changed from Docker hostname `host.docker.internal` to `localhost:3306`
2. **URL Routing**: Fixed all form actions and links to use proper context paths
3. **Session Handling**: Added debugging to help identify where the issue is
4. **Error Display**: Added login error messages to inform users of invalid credentials

## ✅ Steps to Get Login Working

### Step 1: Verify Database Setup
1. Open your MySQL client (MySQLWorkbench, phpMyAdmin, or command line)
2. Visit the test page to check database status: `http://localhost:8080/GOFIT/dbtest.jsp`
3. If tables don't exist, run the SQL script:
   - File: `/GOFIT/database_setup.sql`
   - Or execute these commands in your MySQL client:

```sql
CREATE DATABASE IF NOT EXISTS gofit;
USE gofit;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    age INT DEFAULT 0,
    weightKg DOUBLE DEFAULT 0,
    heightCm DOUBLE DEFAULT 0,
    goal VARCHAR(100) DEFAULT 'Maintain Weight',
    calorieGoal INT DEFAULT 2000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS exercise_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    exerciseName VARCHAR(255) NOT NULL,
    weightKg DOUBLE DEFAULT 0,
    reps INT DEFAULT 0,
    logged_date DATE DEFAULT CURDATE(),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS calorie_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    foodName VARCHAR(255) NOT NULL,
    serving VARCHAR(100) DEFAULT '1 serving',
    kcal INT DEFAULT 0,
    carbsG DOUBLE DEFAULT 0,
    proteinG DOUBLE DEFAULT 0,
    fatG DOUBLE DEFAULT 0,
    logged_date DATE DEFAULT CURDATE(),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);
```

### Step 2: Register a New User
1. Go to: `http://localhost:8080/GOFIT/register.jsp`
2. Fill in the registration form with:
   - Name: Your name
   - Email: Your email address
   - Password: A secure password
   - Age, Weight, Height: Your details
   - Goal: Choose your fitness goal
3. Click "Register"

### Step 3: Test Login
1. Go to: `http://localhost:8080/GOFIT/login.jsp`
2. Enter the email and password you just registered
3. Click "Continue"
4. You should now see the user dashboard

## 🐛 Troubleshooting

### Issue: "Database connection FAILED" on dbtest.jsp
**Solution:**
- Ensure MySQL is running
- Check DBConnection.java has correct credentials:
  - URL: `jdbc:mysql://localhost:3306/gofit`
  - USER: `root`
  - PASSWORD: `Uday@2006`

### Issue: "No users found" on dbtest.jsp
**Solution:**
- Register a new user via `http://localhost:8080/GOFIT/register.jsp`

### Issue: "Invalid email or password" error after login
**Solution:**
- Check that you're using the correct email and password
- Password must match what you registered with
- Try registering a new account

### Issue: Console shows "❌ Login failed for: ..."
**Solution:**
- Check that the user exists in the database
- Use dbtest.jsp to verify users in the database
- Check the console for error messages

## 📋 Key Files Modified

1. **DBConnection.java** - Fixed database URL from Docker to localhost
2. **GoFitServlet.java** - Added debugging/logging for login flow
3. **login.jsp** - Added error message display
4. **All JSP files** - Fixed URL routing with context paths
5. **database_setup.sql** - Created database setup script
6. **dbtest.jsp** - Created for troubleshooting

## 🔄 Testing Workflow

```
1. Visit: http://localhost:8080/GOFIT/dbtest.jsp
   ↓ (Check database connection and tables)
2. Visit: http://localhost:8080/GOFIT/register.jsp
   ↓ (Create a test account)
3. Visit: http://localhost:8080/GOFIT/login.jsp
   ↓ (Login with your account)
4. Should see: Dashboard with user data
```

## 🚀 Next Steps

1. **Rebuild and redeploy** the GOFIT application in Eclipse
2. **Run the database setup** if tables don't exist
3. **Register a new account** or verify existing ones
4. **Test the login flow** step by step

Good luck! The application should now work correctly. 💪
