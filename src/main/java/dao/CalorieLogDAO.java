package dao;
import model.CalorieLog;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.CalorieLog;
import util.DBConnection;

public class CalorieLogDAO{

    public boolean insert(CalorieLog log) {
    	boolean status = false;
    	String sql = "INSERT INTO calorieLogs (userId, foodName, serving, kcal, carbsG, proteinG, fatG) VALUES (?, ?, ?, ?, ?, ?, ?)";
    	try (Connection con = DBConnection.getconnection();
    			PreparedStatement ps = con.prepareStatement(sql)) {
    				ps.setInt(1, log.getUserId());
    	            ps.setString(2, log.getFoodName());
    	            ps.setString(3, log.getServing());
    	            ps.setInt(4, log.getKcal());
    	            ps.setDouble(5, log.getCarbsG());
    	            ps.setDouble(6, log.getProteinG());
    	            ps.setDouble(7, log.getFatG());
    	             if (ps.executeUpdate() > 0) {
		                status = true;
    	             }
  } catch (Exception e) {
        	
            e.printStackTrace();
            status = false;
        }
return status;

      
    } public boolean delete(int id, int userId) {
        String sql = "DELETE FROM calorieLogs WHERE id = ? AND userId = ?";
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
 
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int totalKcalToday(int userId) {
        String sql = "SELECT SUM(kcal) FROM calorieLogs WHERE userId = ? AND logDate = CURDATE()";
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int totalKcalByDate(int userId, Date date) {
        String sql = "SELECT SUM(kcal) FROM calorieLogs WHERE userId = ? AND logDate = ?";
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<CalorieLog> findByUserToday(int userId) {
        String sql = "SELECT * FROM calorieLogs WHERE userId = ? AND logDate = CURDATE() ORDER BY createdAt DESC";
        List<CalorieLog> list = new ArrayList<>();
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CalorieLog log = new CalorieLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("userId"));
                log.setFoodName(rs.getString("foodName"));
                log.setServing(rs.getString("serving"));
                log.setKcal(rs.getInt("kcal"));
                log.setCarbsG(rs.getDouble("carbsG"));
                log.setProteinG(rs.getDouble("proteinG"));
                log.setFatG(rs.getDouble("fatG"));
                log.setLogDate(rs.getDate("logDate"));
                list.add(log);
            }
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CalorieLog> findByUserAndDate(int userId, Date date) {
        String sql = "SELECT * FROM calorieLogs WHERE userId = ? AND logDate = ? ORDER BY createdAt DESC";
        List<CalorieLog> list = new ArrayList<>();
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setDate(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CalorieLog log = new CalorieLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("userId"));
                log.setFoodName(rs.getString("foodName"));
                log.setServing(rs.getString("serving"));
                log.setKcal(rs.getInt("kcal"));
                log.setCarbsG(rs.getDouble("carbsG"));
                log.setProteinG(rs.getDouble("proteinG"));
                log.setFatG(rs.getDouble("fatG"));
                log.setLogDate(rs.getDate("logDate"));
                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int totalfatToday(int userId) {
        String sql = "SELECT SUM(fatG) FROM calorieLogs WHERE userId = ? AND logDate = CURDATE()";
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int totalproteinToday(int userId) {
        String sql = "SELECT SUM(proteinG) FROM calorieLogs WHERE userId = ? AND logDate = CURDATE()";
        try (Connection conn = DBConnection.getconnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
 
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}