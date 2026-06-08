package dao;
import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class UserDAO{
	public boolean  register(User user) {
		 boolean status = false;
		 String sql = "INSERT INTO users (name, email, password, age, weightKg, heightCm, goal) VALUES (?, ?, ?, ?, ?, ?, ?)";
		try (Connection con = DBConnection.getconnection();
				PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, user.getName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPassword());
				ps.setInt(4, user.getAge());
				ps.setDouble(5, user.getWeightKg());
					
				ps.setDouble(6, user.getHeightCm());
				ps.setString(7, user.getGoal());
				
				int rows = ps.executeUpdate();
				if (rows>0){
					return true;
					
				}
				
		} catch (Exception e) {
			e.printStackTrace();
			return false;
			
		}
						 return status;
			
		}
	
		 public User login(String email, String password) {
			 String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
			 try (Connection con = DBConnection.getconnection();
					 PreparedStatement ps = con.prepareStatement(sql)){
				 ps.setString(1, email);
				 ps.setString(2, password);
				 ResultSet rs = ps.executeQuery();
				 if(rs.next()) {
					 User user = new User();
					 user.setId(rs.getInt("id"));
					 user.setName(rs.getString("name"));	
					 user.setEmail(rs.getString("email"));
					 user.setAge(rs.getInt("age"));
					 user.setWeightKg(rs.getDouble("weightKg"));
					 user.setHeightCm(rs.getDouble("heightCm"));
					 user.setGoal(rs.getString("goal"));
					 return user;
				 } 
					 
					
				 
			 } catch (Exception e) {
				 e.printStackTrace();
				
			 } return null;	
		 }}