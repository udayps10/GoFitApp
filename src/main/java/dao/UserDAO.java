package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;
import util.DBConnection;

public class UserDAO {

	public boolean registerUser(User user) {
		boolean status = false;

		try (Connection con = DBConnection.getconnection();
				PreparedStatement ps = con.prepareStatement(
						"INSERT INTO users(name, email, password, age, weight, height, goal) VALUES (?, ?, ?, ?, ?, ?, ?)")) {

			ps.setString(1, user.getName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPassword());
			ps.setInt(4, user.getAge());
			ps.setDouble(5, user.getWeight());
			ps.setInt(6, user.getHeight());
			ps.setString(7, user.getGoal());
			ps.setString(8, user.getGender());

			int rows = ps.executeUpdate();
			if (rows > 0 ) {
				status = true;
			}
		}
		 catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}

	public User loginUser(String email, String password) {
       User  user = null;

        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
             )) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

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
                user.setGender(rs.getString{"gender");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
return user ; 
       
    }

	

}