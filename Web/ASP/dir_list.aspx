<%
dim path As String = Request.QueryString("path")

response.write(path)
response.write("<br>----------------------------------<br>")
Dim files As String() = System.IO.Directory.GetFiles(path)
Dim dirs AS String() = System.IO.Directory.GetDirectories(path)

Dim dirName As String
For Each dirName In dirs
	response.write(dirName)
	response.write("<br>")
Next dirName

Dim fileName As String
For Each fileName In files
	response.write(fileName)
	response.write("<br>")
Next fileName

%>