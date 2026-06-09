package servlet;

import dao.UserDAO;
import dao.ExerciseLogDAO;
import dao.CalorieLogDAO;
import model.User;
import model.ExerciseLog;
import model.CalorieLog;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/GoFit")
public class GoFitServlet extends HttpServlet {

    private UserDAO userDAO             = new UserDAO();
    private ExerciseLogDAO exerciseDAO  = new ExerciseLogDAO();
    private CalorieLogDAO calorieDAO    = new CalorieLogDAO();

    // ── POST — handles every action in the app ────────────────────
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if (action == null) {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
            return;
        }

        // ══════════════════════════════════════════════════════════
        // AUTH ACTIONS
        // ══════════════════════════════════════════════════════════

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
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp");
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            }

        } else if (action.equals("logout")) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");

        // ══════════════════════════════════════════════════════════
        // EXERCISE ACTIONS
        // ══════════════════════════════════════════════════════════

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

            exerciseDAO.insert(log);
            res.sendRedirect(req.getContextPath() + "/workout.jsp");

        } else if (action.equals("deleteExercise")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            try {
                int id = Integer.parseInt(req.getParameter("id"));
                exerciseDAO.delete(id, user.getId());
            } catch (Exception e) { e.printStackTrace(); }

            res.sendRedirect(req.getContextPath() + "/workout.jsp");

        // ══════════════════════════════════════════════════════════
        // CALORIE ACTIONS
        // ══════════════════════════════════════════════════════════

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

            calorieDAO.insert(log);
            res.sendRedirect(req.getContextPath() + "/calorie.jsp");

        } else if (action.equals("deleteCalorie")) {
            if (!isLoggedIn(session)) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            User user = (User) session.getAttribute("user");

            try {
                int id = Integer.parseInt(req.getParameter("id"));
                calorieDAO.delete(id, user.getId());
            } catch (Exception e) { e.printStackTrace(); }

            res.sendRedirect(req.getContextPath() + "/calorie.jsp");

        } else {
            // Unknown action — go home
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
        }
    }

    // ── GET — loads pages with live data from DB ──────────────────
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

        if (page.equals("workout")) {
            List<ExerciseLog> logs = exerciseDAO.findByUserToday(user.getId());
            req.setAttribute("exerciseLogs", logs);
            req.getRequestDispatcher("/workout.jsp").forward(req, res);

        } else if (page.equals("calorie")) {
            List<CalorieLog> logs   = calorieDAO.findByUserToday(user.getId());
            int totalKcal           = calorieDAO.totalKcalToday(user.getId());
            req.setAttribute("calorieLogs", logs);
            req.setAttribute("totalKcal", totalKcal);
            req.getRequestDispatcher("/calorie.jsp").forward(req, res);

        } else if (page.equals("dashboard")) {
            int exerciseCount   = exerciseDAO.countToday(user.getId());
            int totalKcal       = calorieDAO.totalKcalToday(user.getId());
            req.setAttribute("exerciseCount", exerciseCount);
            req.setAttribute("totalKcal", totalKcal);
            req.getRequestDispatcher("/userdashboard.jsp").forward(req, res);

        } else {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
        }
    }

    // ── Helper — check if user is logged in ───────────────────────
    private boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }
}