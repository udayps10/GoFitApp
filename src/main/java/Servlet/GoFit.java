package Servlet;
import dao.UserDAO;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import model.User;

@WebServlet("/GoFit")
public class GoFit extends HttpServlet {

    private UserDAO userDao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if (action == null) {
            res.sendRedirect(req.getContextPath() + "/homepage.jsp");
            return;
        }

        if (action.equals("login")) {

            String email = req.getParameter("email");
            String password = req.getParameter("password");

            User user = userDao.loginUser(email, password);

            if (user != null) {
                session.setAttribute("user", user);
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp");
            } else {
                res.sendRedirect(req.getContextPath() + "/homepage.jsp");
            } 
        } else if (action.equals("register")) { 
            User user = new User();
            user.setName(req.getParameter("name"));
            user.setAge(Integer.parseInt(req.getParameter("age")));
            user.setWeight(Double.parseDouble(req.getParameter("weight")));
            user.setHeight(Double.parseDouble(req.getParameter("height")));
            user.setEmail(req.getParameter("email"));
            user.setPassword(req.getParameter("password"));
            user.setGoal(req.getParameter("goal"));
            
            if (userDao.registerUser(user)) {
                res.sendRedirect(req.getContextPath()+ "/userdashboard.jsp?register=success");
            } else {
                res.sendRedirect(req.getContextPath() + "/userdashboard.jsp?register=error");
            }
        } else if (action.equals("logout")) {
            session.invalidate();
            res.sendRedirect(req.getContextPath()+ "/homepage.jsp");
        } 
    }
}