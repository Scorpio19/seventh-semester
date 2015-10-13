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
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/electricity", "root", "password");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String query = "select id from users where username='" + username + "' and password='" + password + "'";
            Statement dbStatement = connection.createStatement();
            ResultSet result = dbStatement.executeQuery(query);
            if (!result.next()) {
                request.setAttribute("error", "true");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                System.out.println(result.getString(1));
                request.setAttribute("user_id", result.getString(1));
                request.getRequestDispatcher("/StatusServlet").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
