/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.itesm.SI;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
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
public class StatusServlet extends HttpServlet {

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
            String userId = (String)request.getAttribute("user_id");
            ArrayList<String> users = (ArrayList<String>)request.getAttribute("users");
            String query = "select * from status where user_id='" + userId + "'";
            Statement dbStatement = connection.createStatement();
            ResultSet result = dbStatement.executeQuery(query);
            ArrayList<String[]> status = new ArrayList<String[]>();
            
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            while (result.next()) {
                String[] row = new String[4];
                for (int i = 0; i < 4; i++) {
                    row[i] = result.getString(i+1);
                }
                status.add(row);
            }
            request.setAttribute("status", status);
            request.setAttribute("users", users);
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("/status.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
