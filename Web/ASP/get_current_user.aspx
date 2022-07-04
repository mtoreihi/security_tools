<% @ Page Language="VB" %>
<% Response.Buffer=True %>
<%
Dim logon As String
  logon = System.Security.Principal.WindowsIdentity.GetCurrent().Name
response.write(logon)
%>