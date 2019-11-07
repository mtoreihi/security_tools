<%
Dim file As String = Request.QueryString("file")
System.IO.File.Delete(file)
response.write("Delete completed.")
%>