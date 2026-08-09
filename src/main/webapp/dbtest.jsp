<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.DBConnection, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>GoFit Database Test</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        .status { margin: 20px 0; padding: 15px; border-radius: 5px; font-weight: bold; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        pre { background: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #23A55A; color: white; }
    </style>
</head>
<body>
<div class="container">
    <h1>🏥 GoFit Database Test</h1>
    
    <%
        try {
            // Test database connection
            Connection con = DBConnection.getconnection();
            
            if (con == null) {
    %>
                <div class="status error">❌ Database connection FAILED</div>
                <p>The application cannot connect to the MySQL database.</p>
                <p><strong>Check:</strong></p>
                <ul>
                    <li>MySQL server is running</li>
                    <li>Database credentials in DBConnection.java are correct</li>
                    <li>Database 'gofit' exists</li>
                    <li>Connection string: localhost:3306</li>
                </ul>
    <%
            } else {
    %>
                <div class="status success">✅ Database connection SUCCESS</div>
                
    <%
                // Check if tables exist
                DatabaseMetaData dbMeta = con.getMetaData();
                ResultSet tables = dbMeta.getTables(null, null, "users", new String[]{"TABLE"});
                
                if (tables.next()) {
    %>
                    <div class="status success">✅ Users table EXISTS</div>
                    
                    <h3>📊 Users in Database:</h3>
    <%
                    // Get user count
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id, email, name FROM users LIMIT 10");
                    
                    if (rs.next()) {
    %>
                        <table>
                            <tr><th>ID</th><th>Email</th><th>Name</th></tr>
    <%
                        do {
    %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td><%= rs.getString("name") %></td>
                            </tr>
    <%
                        } while (rs.next());
    %>
                        </table>
    <%
                    } else {
    %>
                        <div class="status error">❌ No users found in database</div>
                        <p>You need to create a user account. Use the <a href="register.jsp">Register</a> page to create an account.</p>
    <%
                    }
                    rs.close();
                    stmt.close();
                } else {
    %>
                    <div class="status error">❌ Users table NOT FOUND</div>
                    <p>The 'users' table doesn't exist. Run the database_setup.sql script to create the tables.</p>
                    <p><strong>Location:</strong> /GOFIT/database_setup.sql</p>
    <%
                }
                
                con.close();
            }
        } catch (Exception e) {
    %>
            <div class="status error">❌ ERROR: <%= e.getMessage() %></div>
            <pre><%= e.toString() %></pre>
    <%
        }
    %>
    
    <hr style="margin-top: 30px; margin-bottom: 30px;">
    <p style="color: #666; font-size: 12px;">
        <strong>Next Steps:</strong><br>
        1. Check the database connection status above<br>
        2. Ensure the 'gofit' database exists<br>
        3. Run database_setup.sql if tables are missing<br>
        4. Create a user account via <a href="register.jsp">Register</a><br>
        5. Try logging in with your credentials<br>
        <a href="login.jsp">Back to Login</a>
    </p>
</div>
</body>
</html>
