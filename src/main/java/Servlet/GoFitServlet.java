package Servlet;

import dao.UserDAO;
import dao.ExerciseDao;
import dao.CalorieLogDAO;
import model.User;
import model.ExerciseLog;
import model.CalorieLog;

import java.io.IOException;
import java.io.BufferedReader;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/GoFit")
public class GoFitServlet extends HttpServlet {

    private UserDAO userDAO           = new UserDAO();
    private ExerciseDao exerciseDAO   = new ExerciseDao();
    private CalorieLogDAO calorieDAO  = new CalorieLogDAO();

    String apiKey = System.getenv("GCP_API_KEY");

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if (action == null) {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
            return;
        }

        
        if (action.equals("aiScanFood")) {
            if (!isLoggedIn(session)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"error\":\"Not logged in\"}");
                return;
            }

            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");

            
            Long lastCall = (Long) session.getAttribute("lastAiScanTime");
            long now = System.currentTimeMillis();
            long COOLDOWN_MS = 5000;
            if (lastCall != null && (now - lastCall) < COOLDOWN_MS) {
                long waitSec = (COOLDOWN_MS - (now - lastCall)) / 1000 + 1;
                res.getWriter().write("{\"error\":\"Please wait " + waitSec + "s before scanning again\"}");
                return;
            }

            StringBuilder sb = new StringBuilder();
            BufferedReader reader = req.getReader();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            String body = sb.toString();

            String imageBase64 = extractJsonField(body, "imageBase64");
            String mimeType     = extractJsonField(body, "mimeType");
            if (mimeType == null || mimeType.isEmpty()) mimeType = "image/jpeg";

            if (imageBase64 == null || imageBase64.isEmpty()) {
                res.getWriter().write("{\"error\":\"No image provided\"}");
                return;
            }

            
            String imgHash = String.valueOf(imageBase64.hashCode());
            String cachedHash   = (String) session.getAttribute("lastImgHash");
            String cachedResult = (String) session.getAttribute("lastImgResult");
            if (imgHash.equals(cachedHash) && cachedResult != null) {
                res.getWriter().write(cachedResult);
                return;
            }

            session.setAttribute("lastAiScanTime", now);
            String aiJson = callGeminiVision(imageBase64, mimeType);

           
            if (aiJson != null && !aiJson.contains("\"error\"")) {
                session.setAttribute("lastImgHash", imgHash);
                session.setAttribute("lastImgResult", aiJson);
            }

            res.getWriter().write(aiJson);
            return;
        }

      
        if (action.equals("register")) {
            User user = new User();
            user.setName(req.getParameter("name"));
            user.setEmail(req.getParameter("email"));
            user.setPassword(req.getParameter("password"));
            user.setGoal(req.getParameter("goal"));

            try { user.setAge(Integer.parseInt(req.getParameter("age"))); }
            catch (Exception e) { user.setAge(0); }
            try { user.setWeightKg(Double.parseDouble(req.getParameter("weightKg"))); }
            catch (Exception e) { user.setWeightKg(0); }
            try { user.setHeightCm(Double.parseDouble(req.getParameter("heightCm"))); }
            catch (Exception e) { user.setHeightCm(0); }

            int aiCalories = fetchCalorieGoalFromAI(
                user.getAge(), user.getWeightKg(), user.getHeightCm(), user.getGoal()
            );
            user.setCalorieGoal(aiCalories);

            if (userDAO.register(user)) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?success=registered");
            } else {
                res.sendRedirect(req.getContextPath() + "/register.jsp?error=exists");
            }

    
        } else if (action.equals("login")) {
            String email    = req.getParameter("email");
            String password = req.getParameter("password");
            User user = userDAO.login(email, password);

            if (user != null) {
                session.setAttribute("user", user);
                
                res.sendRedirect(req.getContextPath() + "/GoFit?page=dashboard");
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            }

       
        } else if (action.equals("logout")) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");

        } else if (action.equals("addExercise")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            ExerciseLog log = new ExerciseLog();
            log.setUserId(user.getId());
            log.setExerciseName(req.getParameter("exerciseName"));

            try { log.setWeightKg(Double.parseDouble(req.getParameter("weightKg"))); }
            catch (Exception e) { log.setWeightKg(0); }
            try { log.setReps(Integer.parseInt(req.getParameter("reps"))); }
            catch (Exception e) { log.setReps(0); }

            try {
                exerciseDAO.insert(log);
                res.sendRedirect(req.getContextPath() + "/GoFit?page=workout");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendError(500, "Insert failed: " + e.getMessage());
            }

        } else if (action.equals("deleteExercise")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            try {
                int id = Integer.parseInt(req.getParameter("id"));
                exerciseDAO.delete(id, user.getId());
            } catch (Exception e) { e.printStackTrace(); }
            res.sendRedirect(req.getContextPath() + "/GoFit?page=workout");

        } else if (action.equals("addCalorie")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            CalorieLog log = new CalorieLog();
            log.setUserId(user.getId());
            log.setFoodName(req.getParameter("foodName"));
            log.setServing(req.getParameter("serving") != null ? req.getParameter("serving") : "1 serving");

            try { log.setKcal(Integer.parseInt(req.getParameter("kcal"))); }
            catch (Exception e) { log.setKcal(0); }
            try { log.setCarbsG(Double.parseDouble(req.getParameter("carbsG"))); }
            catch (Exception e) { log.setCarbsG(0); }
            try { log.setProteinG(Double.parseDouble(req.getParameter("proteinG"))); }
            catch (Exception e) { log.setProteinG(0); }
            try { log.setFatG(Double.parseDouble(req.getParameter("fatG"))); }
            catch (Exception e) { log.setFatG(0); }

            try {
                calorieDAO.insert(log);
                res.sendRedirect(req.getContextPath() + "/GoFit?page=calorie");
            } catch (Exception e) {
                e.printStackTrace();
                res.sendError(500, "Insert failed: " + e.getMessage());
            }

        } else if (action.equals("deleteCalorie")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            try {
                int id = Integer.parseInt(req.getParameter("id"));
                calorieDAO.delete(id, user.getId());
            } catch (Exception e) { e.printStackTrace(); }

            res.sendRedirect(req.getContextPath() + "/GoFit?page=calorie");

        
        } else if (action.equals("updateWeight")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            try {
                double newWeight = Double.parseDouble(req.getParameter("weightKg"));
                boolean ok = userDAO.updateWeight(user.getId(), newWeight);
                if (ok) {
                    user.setWeightKg(newWeight);
                    session.setAttribute("user", user);
                    res.sendRedirect(req.getContextPath() + "/GoFit?page=dashboard");
                } else {
                    res.sendError(500, "Weight update failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                res.sendError(500, "Invalid weight value: " + e.getMessage());
            }

        } else {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String page = req.getParameter("page");
        HttpSession session = req.getSession(false);

        if (page == null) {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
            return;
        }

        if (!isLoggedIn(session)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        java.sql.Date selectedDate;
        String dateParam = req.getParameter("date");
        boolean isToday;
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            java.sql.Date parsed;
            try {
                parsed = java.sql.Date.valueOf(dateParam.trim());
            } catch (IllegalArgumentException e) {
                parsed = new java.sql.Date(System.currentTimeMillis());
            }
            java.sql.Date todayDate = new java.sql.Date(System.currentTimeMillis());
            selectedDate = parsed.after(todayDate) ? todayDate : parsed;
        } else {
            selectedDate = new java.sql.Date(System.currentTimeMillis());
        }
        isToday = selectedDate.toString().equals(new java.sql.Date(System.currentTimeMillis()).toString());

        if (page.equals("workout")) {
            List<ExerciseLog> logs = isToday
                ? exerciseDAO.findByUserToday(user.getId())
                : exerciseDAO.findByUserAndDate(user.getId(), selectedDate);
            req.setAttribute("exerciseLogs", logs);
            req.setAttribute("selectedDate", selectedDate.toString());
            req.setAttribute("isToday", isToday);
            req.getRequestDispatcher("/workout.jsp").forward(req, res);

        } else if (page.equals("calorie")) {
            List<CalorieLog> logs = isToday
                ? calorieDAO.findByUserToday(user.getId())
                : calorieDAO.findByUserAndDate(user.getId(), selectedDate);
            int totalKcal = isToday
                ? calorieDAO.totalKcalToday(user.getId())
                : calorieDAO.totalKcalByDate(user.getId(), selectedDate);
            req.setAttribute("calorieLogs", logs);
            req.setAttribute("totalKcal", totalKcal);
            req.setAttribute("selectedDate", selectedDate.toString());
            req.setAttribute("isToday", isToday);
            req.getRequestDispatcher("/calorie.jsp").forward(req, res);

        } else if (page.equals("dashboard")) {
            int exerciseCount = isToday
                ? exerciseDAO.countToday(user.getId())
                : exerciseDAO.countByDate(user.getId(), selectedDate);
            int totalKcal = isToday
                ? calorieDAO.totalKcalToday(user.getId())
                : calorieDAO.totalKcalByDate(user.getId(), selectedDate);
            List<ExerciseLog> exerciseLogs = isToday
                ? exerciseDAO.findByUserToday(user.getId())
                : exerciseDAO.findByUserAndDate(user.getId(), selectedDate);
            List<CalorieLog> calorieLogs = isToday
                ? calorieDAO.findByUserToday(user.getId())
                : calorieDAO.findByUserAndDate(user.getId(), selectedDate);
            req.setAttribute("exerciseCount", exerciseCount);
            req.setAttribute("totalKcal", totalKcal);
            req.setAttribute("exerciseLogs", exerciseLogs);
            req.setAttribute("calorieLogs", calorieLogs);
            req.setAttribute("selectedDate", selectedDate.toString());
            req.setAttribute("isToday", isToday);
            req.getRequestDispatcher("/userdashboard.jsp").forward(req, res);

        } else {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
        }
    }

    private int fetchCalorieGoalFromAI(int age, double weightKg, double heightCm, String goal) {
        try {
            String prompt = "A user wants to " + goal + ". They are " + age +
                " years old, weigh " + weightKg + "kg, and are " + heightCm +
                "cm tall. Calculate their daily calorie target using the Mifflin-St Jeor " +
                "equation with a moderate activity factor of 1.55. " +
                "Adjust: subtract 300 for Lose Fat, add 300 for Build Muscle, " +
                "no change for Maintain Weight. Reply with ONLY the integer number, nothing else.";

            String jsonBody = "{\"contents\":[{\"parts\":[{\"text\":\"" + prompt + "\"}]}]}";

            java.net.URL url = new java.net.URL(
                    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY
            );
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(15000);
            conn.setDoOutput(true);
            conn.getOutputStream().write(jsonBody.getBytes("UTF-8"));

            int status = conn.getResponseCode();
            java.io.InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            java.util.Scanner sc = new java.util.Scanner(is, "UTF-8");
            sc.useDelimiter("\\A");
            String response = sc.hasNext() ? sc.next() : "";
            sc.close();

            if (status < 200 || status >= 300) {
                throw new RuntimeException("Gemini API error (" + status + "): " + response);
            }

            int textIdx = response.indexOf("\"text\": \"") + 9;
            String numStr = response.substring(textIdx, response.indexOf("\"", textIdx)).trim();
            return Integer.parseInt(numStr);

        } catch (Exception e) {
            e.printStackTrace();
            double bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
            int base = (int)(bmr * 1.55);
            if ("Lose Fat".equals(goal))         return base - 300;
            if ("Build Muscle".equals(goal))     return base + 300;
            return base;
        }
    }

    private String callGeminiVision(String imageBase64, String mimeType) {
        try {
            String prompt = "You are a nutrition expert AI. Analyse this food image and identify ALL visible food items. "
                + "For EACH item return: name, estimated serving size, estimated calories (kcal), carbohydrates (g), protein (g), fat (g). "
                + "Return ONLY a valid JSON array with no markdown: "
                + "[{\\\"name\\\":\\\"Food Name\\\",\\\"serving\\\":\\\"serving size\\\",\\\"kcal\\\":250,\\\"carbs\\\":30,\\\"protein\\\":15,\\\"fat\\\":8}] "
                + "If no food visible return: [] . Be realistic with Indian home-cooked portion sizes.";

            String jsonBody = "{\"contents\":[{\"parts\":[{\"text\":\"" + prompt + "\"},"
                + "{\"inline_data\":{\"mime_type\":\"" + mimeType + "\",\"data\":\"" + imageBase64 + "\"}}]}]}";

            java.net.URL url = new java.net.URL(
                    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY
            );
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(20000);
            conn.setReadTimeout(20000);
            conn.setDoOutput(true);
            conn.getOutputStream().write(jsonBody.getBytes("UTF-8"));

            int status = conn.getResponseCode();
            java.io.InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            java.util.Scanner sc = new java.util.Scanner(is, "UTF-8");
            sc.useDelimiter("\\A");
            String response = sc.hasNext() ? sc.next() : "";
            sc.close();

            if (status < 200 || status >= 300) {
                return "{\"error\":\"Gemini API error (" + status + "): " + response.replace("\"", "'").replace("\n", " ") + "\"}";
            }

            int textIdx = response.indexOf("\"text\": \"");
            if (textIdx == -1) return "{\"error\":\"Empty AI response\"}";
            textIdx += 9;
            int endIdx = response.indexOf("\"\n", textIdx);
            if (endIdx == -1) endIdx = response.indexOf("\"}", textIdx);
            String rawText = response.substring(textIdx, endIdx)
                .replace("\\n", "").replace("\\\"", "\"");
            String cleaned = rawText.replaceAll("```json", "").replaceAll("```", "").trim();

            return "{\"items\":" + (cleaned.isEmpty() ? "[]" : cleaned) + "}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}";
        }
    }

    private String extractJsonField(String json, String field) {
        String key = "\"" + field + "\":\"";
        int start = json.indexOf(key);
        if (start == -1) return null;
        start += key.length();
        int end = json.indexOf("\"", start);
        while (end > 0 && json.charAt(end - 1) == '\\') {
            end = json.indexOf("\"", end + 1);
        }
        if (end == -1) return null;
        return json.substring(start, end);
    }

    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }
}