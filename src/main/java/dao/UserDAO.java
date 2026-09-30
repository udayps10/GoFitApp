package dao;
import model.User;
import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.PasswordUtil;
public class UserDAO {
    public boolean register(User user) {
        String sql = "INSERT INTO users (name, email, password, age, weightKg, heightCm, goal, calorieGoal) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, normalizeEmail(user.getEmail()));
            ps.setString(3, PasswordUtil.hashPassword(user.getPassword())); 
            ps.setInt(4, user.getAge());
            ps.setDouble(5, user.getWeightKg());
            ps.setDouble(6, user.getHeightCm());
            ps.setString(7, user.getGoal());
            ps.setInt(8, user.getCalorieGoal());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizeEmail(email));
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String email, String enteredpassword) {
        String sql = "SELECT * FROM users WHERE email = ?"; 
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, normalizeEmail(email));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                boolean validPassword = PasswordUtil.checkPassword(enteredpassword, hashedPassword);
                if (!validPassword && enteredpassword != null
                        && enteredpassword.equals(hashedPassword)) {
                    validPassword = true;
                    updatePassword(rs.getInt("id"), enteredpassword);
                }
                if (!validPassword) {
                    return null;
                }

                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setAge(rs.getInt("age"));
                user.setWeightKg(rs.getDouble("weightKg"));
                user.setHeightCm(rs.getDouble("heightCm"));
                user.setGoal(rs.getString("goal"));
                user.setCalorieGoal(rs.getInt("calorieGoal"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }

    private void updatePassword(int userId, String plainPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hashPassword(plainPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateWeight(int userId, double weightKg) {
        String sql = "UPDATE users SET weightKg = ? WHERE id = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, weightKg);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateGoal(int userId, String goal, int calorieGoal) {
        String sql = "UPDATE users SET goal = ?, calorieGoal = ? WHERE id = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, goal);
            ps.setInt(2, calorieGoal);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCalorieGoal(int userId, int calorieGoal) {
        String sql = "UPDATE users SET calorieGoal = ? WHERE id = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, calorieGoal);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}