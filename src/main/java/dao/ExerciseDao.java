package dao;

import model.ExerciseLog;
import util.DBConnection;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class ExerciseDao {

    public boolean insert(ExerciseLog log) {
        String sql = "INSERT INTO exerciseLogs (userId, exerciseName, weightKg, reps) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, log.getUserId());           
            ps.setString(2, log.getExerciseName());  
            ps.setDouble(3, log.getWeightKg());      
            ps.setInt(4, log.getReps());             

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ExerciseLog> findByUserToday(int userId) {
        String sql = "SELECT * FROM exerciseLogs WHERE userId = ? AND logDate = CURDATE() ORDER BY createdAt DESC";
        List<ExerciseLog> list = new ArrayList<>();
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ExerciseLog log = new ExerciseLog();
                log.setId(rs.getInt("id"));                        
                log.setUserId(rs.getInt("userId"));                
                log.setExerciseName(rs.getString("exerciseName")); 
                log.setWeightKg(rs.getDouble("weightKg"));         
                log.setReps(rs.getInt("reps"));                    
                log.setLogDate(rs.getDate("logDate"));             
                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── NEW: same as findByUserToday but for any given date (used for date-nav / "past days") ──
    public List<ExerciseLog> findByUserAndDate(int userId, Date date) {
        String sql = "SELECT * FROM exerciseLogs WHERE userId = ? AND logDate = ? ORDER BY createdAt DESC";
        List<ExerciseLog> list = new ArrayList<>();
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ExerciseLog log = new ExerciseLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("userId"));
                log.setExerciseName(rs.getString("exerciseName"));
                log.setWeightKg(rs.getDouble("weightKg"));
                log.setReps(rs.getInt("reps"));
                log.setLogDate(rs.getDate("logDate"));
                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM exerciseLogs WHERE id = ? AND userId = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countToday(int userId) {
        String sql = "SELECT COUNT(*) FROM exerciseLogs WHERE userId = ? AND logDate = CURDATE()";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── NEW: same as countToday but for any given date (used for dashboard-by-date, if ever needed) ──
    public int countByDate(int userId, Date date) {
        String sql = "SELECT COUNT(*) FROM exerciseLogs WHERE userId = ? AND logDate = ?";
        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}