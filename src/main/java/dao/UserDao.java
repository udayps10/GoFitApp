package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.User;
import util.DBConnection;

public class UserDao {

    public boolean registerUser(User user) {
        boolean status = false;
        String query = "INSERT INTO users(name, email, password, age, weight, height, goal) VALUES (?, ?, ?, ?, ?, ?, ?)";

        // Fixed typo: getconnection() with a lowercase 'c'
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            // SECURITY WARNING: In a real app, hash this password before saving!
            ps.setString(3, user.getPassword()); 
            ps.setInt(4, user.getAge());
            ps.setDouble(5, user.getWeight());
            ps.setDouble(6, user.getHeight());
            ps.setString(7, user.getGoal());

            int rows = ps.executeUpdate();
            status = rows > 0;

        } catch (SQLException e) {
            // Catching SQLException specifically is better practice
            System.err.println("Database error during user registration: " + e.getMessage());
            e.printStackTrace();
        }

        return status;
    }

    public User loginUser(String email, String password) {
        User user = null;
        String query = "SELECT * FROM users WHERE email=? AND password=?";

        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, email);
            ps.setString(2, password);

            // FIX: Wrapped ResultSet in its own try-with-resources block to prevent memory leaks
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setAge(rs.getInt("age"));
                    user.setWeight(rs.getDouble("weight"));
                    user.setHeight(rs.getDouble("height"));
                    user.setGoal(rs.getString("goal"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Database error during user login: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
}