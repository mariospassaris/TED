<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page import="login_logout_process.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
	int x;
	String name = request.getParameter("uname");
	String pass = request.getParameter("upass");
	LoginSession log = new LoginSession(name,pass);

	x = log.getUser();
	if (x == 1)
	{
		session.setAttribute("log", log);

		out.println("<center><h1>Welcome: " + name + "</h1>");
%>
		<p><b>You are successfully login........</b></p>
<%

		String site = new String("after_login/general_homepage.jsp");
		response.setStatus(response.SC_MOVED_TEMPORARILY);
		response.setHeader("Location", site);

	}
	else
	{
%>
		<p><center><b>Either You Enter Wrong UserName or Password</b></center></p>
<%	}
%>
</body>
</html>

