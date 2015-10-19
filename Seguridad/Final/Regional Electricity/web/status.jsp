<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Regional Electricity</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style.css">
    </head>

    <body id="css-zen-garden">
        <div class="page-wrapper">
            <section class="intro" id="zen-intro">
                <header role="banner">
                    <h1>Regional Electricity</h1>
                    <% if (request.getAttribute("success") != null && !request.getAttribute("success").equals("null"))%>
                    <h2><%= request.getAttribute("success") %></h2>
                </header>

                <div class="summary" id="zen-summary" role="article">
                    <p>Website created for the informatic security subject</p>
                    <p> Other Users: </p>
                    <ul>
                        <% ArrayList<String> users = (ArrayList<String>) request.getAttribute("users");
                            for (String user : users) {
                        %>
                        <li><%= user%></li>
                            <% } %>
                    </ul>
                </div>

                <div class="preamble" id="zen-preamble" role="article">
                    <table>
                        <tr>
                            <th>Payment Status</th>
                            <th>Payment Date</th>
                        </tr>
                        <% ArrayList<String[]> stat = (ArrayList<String[]>) request.getAttribute("status");
                            for (String[] row : stat) {
                        %>
                        <tr>
                            <td><%= row[2]%></td> 
                            <td><%= row[3]%></td>
                        </tr>
                        <% }%>
                    </table>
                    <form class="form-container" action="UploadServlet" method="POST" enctype="multipart/form-data">
                        <div class="form-title"><h2>Upload Payment Receipt</h2></div>
                        <div class="form-title">Filename</div>
                        <input class="form-field" type="file" name="file" /><br />
                        <input type="hidden" name="username" value="<%= request.getAttribute("username") %>">
                        <input type="hidden" name="password" value="<%= request.getAttribute("password") %>">
                        <input class="submit-button" type="submit" value="Submit" />
                    </form>
                </div>
            </section>
        </div>
    </body>
</html>
