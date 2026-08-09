package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://host.docker.internal:3306/gofit?allowPublicKeyRetrieval=true&useSSL=false";

    private static final String USER = "root";
    private static final String PASSWORD = "Uday@2006";

    public static Connection getconnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("✅ DB Connected");
            return con;

        } catch (Exception e) {
            System.out.println("❌ DB Connection Failed");
            e.printStackTrace();
            return null;
        }
    }
}