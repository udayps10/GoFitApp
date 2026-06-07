package Servlet;

import dao.WorkoutDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Workout;

@WebServlet("/WorkoutServlet")
public class WorkoutServlet extends HttpServlet {
    private WorkoutDAO workoutDao = new WorkoutDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        
        if (action == null) {
            res.sendRedirect(req.getContextPath() + "/userdashboard.jsp");
            return;
        }
        
        if (action.equals("addWorkout")) {
            Workout workout = new Workout();
            workout.setwName(req.getParameter("wname"));
            workout.setwType(req.getParameter("wtype"));
            
            if (req.getParameter("reps") != null && !req.getParameter("reps").isEmpty()) {
                workout.setReps(Integer.parseInt(req.getParameter("reps")));
            }
            if (req.getParameter("sets") != null && !req.getParameter("sets").isEmpty()) {
                workout.setSets(Integer.parseInt(req.getParameter("sets")));
            }
            
            res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?add=success");
        }
        else if (action.equals("deleteWorkout")) {
            int workoutId = Integer.parseInt(req.getParameter("workoutId"));
            if (workoutDao.deleteWorkout(workoutId)) {
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?delete=success");
            } else {
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?delete=error");
            }
        }
        else if (action.equals("updateWorkout")) {
            Workout workout = new Workout();
            if (req.getParameter("workoutId") != null && !req.getParameter("workoutId").isEmpty()) {
                workout.setId(Integer.parseInt(req.getParameter("workoutId")));
            }
            workout.setwName(req.getParameter("wname"));
            
            if (workoutDao.updateWorkout(workout)) {
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?update=success");
            } else {
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?update=error");
            }
        }
    }
}