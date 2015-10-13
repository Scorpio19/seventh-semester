<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                </header>
                
                <div class="summary" id="zen-summary" role="article">
                    <p>Website created for the informatic security subject</p>
                </div>

                <div class="preamble" id="zen-preamble" role="article">
                    <% if(request.getAttribute("error") != null && "true".equalsIgnoreCase(request.getAttribute("error").toString())) { %>
                    <div class="error">Invalid username or password</div>
                    <% } %>
                     <form class="form-container" action="LoginServlet" method="POST">
                        <div class="form-title"><h2>Login</h2></div>
                        <div class="form-title">Username</div>
                        <input class="form-field" type="text" name="username" /><br />
                        <div class="form-title">Password</div>
                        <input class="form-field" type="password" name="password" /><br />
                        <div class="submit-container">
                        <input class="submit-button" type="submit" value="Submit" />
                    </form>
                </div>
            </section>
    </body>
</html>
