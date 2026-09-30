package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = env("DB_URL",
        "jdbc:mysql://localhost:3306/gofit?allowPublicKeyRetrieval=true&useSSL=false");

    private static final String USER = env("DB_USER", "root");

    private static final String PASSWORD = env("DB_PASSWORD", "");

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return (value == null || value.trim().isEmpty()) ? fallback : value.trim();
    }

    public static Connection getconnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("DB Connected");
            return con;

        } catch (Exception e) {
            System.out.println("DB Connection Failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
