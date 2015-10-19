/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.itesm.SI;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Diego
 */
public class UploadServlet extends HttpServlet {
    public void init() {
    }
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");
        String fileName = getFileName(filePart);
        OutputStream out = null;
        InputStream filecontent = null;

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            out = new FileOutputStream("C:\\Users\\Diego\\Documents\\seventh-semester\\Seguridad\\Final\\Regional Electricity\\src\\java\\mx\\itesm\\SI\\" + fileName);
            filecontent = filePart.getInputStream();
            int read = 0;
            byte[] bytes = new byte[1024];
            while ((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            out.flush();
            out.close();
            filecontent.close();
            request.setAttribute("success", "Successful upload!");
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("/LoginServlet").forward(request, response);
        } catch (Exception e) {
            out.close();
            filecontent.close();
            e.printStackTrace();
            request.setAttribute("success", "Unsuccessful upload, sorries!");
            request.getRequestDispatcher("/status.jsp").forward(request, response);
        }
    }

    private String getFileName(final Part part) {
        final String partHeader = part.getHeader("content-disposition");
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
