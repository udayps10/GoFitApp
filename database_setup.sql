-- Create GoFit Database
CREATE DATABASE IF NOT EXISTS gofit;
USE gofit;

-- Create users table
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

-- Create exercise_logs table
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

-- Create calorie_logs table
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

-- Sample user for testing (password: Test@123)
-- The actual password stored will be hashed
INSERT INTO users (name, email, password, age, weightKg, heightCm, goal, calorieGoal) 
VALUES ('Test User', 'test@example.com', 'hashed_password_here', 25, 75, 175, 'Maintain Weight', 2000);
