/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.itesm.SI;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Diego
 */
public class LoginServlet extends HttpServlet {

    Connection connection = null;

    public void init() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/electricity?allowMultiQueries=true", "root", "password");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String query = "select id from users where username='" + username + "' and password=" + password;
            String query2 = "select username from users";
            Statement dbStatement = connection.createStatement();
            Statement dbStatement2 = connection.createStatement();
            try {
                ResultSet result = dbStatement.executeQuery(query);
                ResultSet users = dbStatement2.executeQuery(query2);
                ArrayList<String> userList = new ArrayList<String>();
                while (users.next()) {
                    userList.add(users.getString(1));                    
                }
                if (!result.next()) {
                    System.out.println("Rejected: "+username);
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                } else {
                    request.setAttribute("user_id", result.getString(1));
                    request.setAttribute("users", userList);
                    request.setAttribute("username", username);
                    request.setAttribute("password", password);
                    request.getRequestDispatcher("/StatusServlet").forward(request, response);
                }
            } catch  (Exception e) {                
                request.setAttribute("error", e.getCause());
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
