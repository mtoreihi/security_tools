<% @ Page Language="VB" %>
<% Response.Buffer=True %>
<% Response.write("Start"&":")


For Each var as String in Request.ServerVariables
  Response.Write(var & " " & Request(var) & "<br>")
Next


Response.write("End"&".")
%>
