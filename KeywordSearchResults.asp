<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<html>
<head>
<title>Search page for karaoke web application</title>

</head>

<body>

<table style="width:850px;" align="center">
<tr>
<td class="karaokeheader" style="width:500px; background-image:url(Images/klogo.gif);"><a class="greylink" href="Karaoke.aspx">Karaoke</a> > Keyword Search Results</td>
</tr>
</table>

<%	
	strSearch = request("Search")
	
	'Not necessary to check if SearchString is empty because I used JavaScript
	'in the search form to check if empty.
	
	if request("search") = "" then
		response.redirect "Keyword.asp"
	end if
		
	Call goSearch(strSearch)

%>


<%	Sub goSearch(SValue)	%>

<%
	'Display information on screen...
	'response.write "<font face=verdana size=2><br />Your search string: """ & svalue & """"
%>

<%
' Pass in the table to search, and the field to search,
' and, optionally, the column to sort by
strFieldName = "SongTitle"
strTableName = "_viewAll"
strOrderByField = " ORDER BY Artist"

' SValue = This will be the FINAL Seach String From Form / QueryString
SValue = trim(SValue)
SValue = replace(SValue, ",", " ")
SValue = replace(SValue, "-", " ")
SValue = replace(SValue, "'", "''")
SValue = replace(SValue, "+", " ")
SValue = replace(SValue, "  ", " ")	'replace double spaces with a single space
SValue = replace(SValue, "  ", " ")	'make sure again there are no double spaces


' A For-Loop to move through the Search String, counting the spaces.
' We will need to add one in the next step because spaces are in between the words.
For i = 1 to len(SValue)
   If mid(SValue, i, 1) = " " Then 
     WordCounter = WordCounter + 1
   End If
Next

' Now, We Add One To Include The Last Word
WordCounter = WordCounter + 1

'Display Information on screen...
'response.write "<br />Word counter is: " & WordCounter
'response.write "<br />Order by: TrackID [default]"

' Next We Dim Word As An Array, With The Maximum Number Of Words
' To Allow - In This Case, 100
Dim Word(100)

' Now, We Fill The Array With The Words
CurrentWord = 1

For i = 1 to len(SValue)
     If mid(SValue, i, 1) = " " Then
	CurrentWord = CurrentWord + 1
     Else
	Word(CurrentWord) = Word(CurrentWord) + mid(SValue, i, 1)
     End If
Next

' Now Lets Build The SQL Statement Based On What Search Type (SType)
' Was Selected

' SType = Search Type (All Words or Any Word) From Form / QueryString
if request("Opt1") = "ON" then
	SType = "AllWord"
else
	SType = "Anyword"
end if

'Display information on screen...
if request("Opt1") = "ON" then
	matchWhat = "True"
else
	matchWhat = "False"
end if


' Only one word to search
If WordCounter = 1 then
	'Not sure if it ever enters the IF
	If 1 <> WordCounter Then
		SQL1 = SQL1 & "Artist LIKE '%" & Word(1) & "%' OR "
		SQL1 = SQL1 & " CDTitle LIKE '%" & Word(1) & "%' OR "
		SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(1) & "' OR "
		SQL1 = sql1 & strFieldName & " LIKE '%" & Word(1) & "%' OR "
	ElseIf 1 = WordCounter Then
		SQL1 = SQL1 & "Artist LIKE '%" & Word(1) & "%' OR "
		SQL1 = SQL1 & "CDTitle LIKE '%" & Word(1) & "%' OR "
		SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(1) & "' OR "
		SQL1 = SQL1 & strFieldName & " LIKE '%" & Word(1) & "%')"
	End If

Else

' More than one word to search
' For Loop To Concatenate SQL String Together
	For i = 1 to WordCounter
		If SType = "AllWord" Then
			'ALLWORD
			If i <> WordCounter Then
				SQL1 = SQL1 & "Artist LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " CDTitle LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(i) & "' OR "
				SQL1 = sql1 & strFieldName & " LIKE '%" & Word(i) & "%') AND ("
			ElseIf i = WordCounter Then
				SQL1 = SQL1 & "Artist LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " CDTitle LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(i) & "' OR "
				SQL1 = SQL1 & strFieldName & " LIKE '%" & Word(i) & "%')"
			End If				
		Else
			If i <> WordCounter Then
				SQL1 = SQL1 & "Artist LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & "CDTitle LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(i) & "' OR "
				SQL1 = sql1 & strFieldName & " LIKE '%" & Word(i) & "%' OR "
			ElseIf i = WordCounter Then
				SQL1 = SQL1 & "Artist LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & "CDTitle LIKE '%" & Word(i) & "%' OR "
				SQL1 = SQL1 & " HiddenKeyword LIKE '" & Word(i) & "' OR "
				SQL1 = SQL1 & strFieldName & " LIKE '%" & Word(i) & "%')"
			End If
		End If
	Next

End If	

	
' Finishing Part Of SQL Statement.
if Len(strOrderByField) > 0 then
	'We need to perform an ORDER BY!
	'SQL = SQL & SQL1 & " ORDER BY " & strOrderByField
	strWhere = "(" & SQL1 & strOrderByField
Else
	strWhere = "(" & SQL1
End If

%>
	
<%
Const adOpenForwardOnly = 0
Const adLockReadOnly = 1
Const adCmdTableDirect = &H0200
Const adUseClient = 3

'Create an explicit recordset object...
Set rs = Server.CreateObject("ADODB.Recordset")
rs.ActiveConnection = objConnection
'response.write SQL
'on error resume next

rs.PageSize = 100					'Display no more than this # on screen
rs.CacheSize = 10
rs.CursorLocation = adUseClient		'Allows use of recordcount

intFilter = request("Filter")

if intFilter = "" then
	intFilter= 0
end if


sql1 = "SELECT * FROM _viewAll WHERE " & strWhere


'Display information on screen...
'response.write "<p>SQL statement generated: <font color=red>" & sql1 & "</font><p>"

rs.Open sql1
%>

<table align="center" width="850" cellpadding="1">
<tr>
<td colspan="2"><div class="content"><b>Search Parameters</b></div></td>
</tr>
<tr>
<td width="150"><div class="content">Keywords: </div></td>
<td valign="bottom"><div class="content"><%= sValue %></div></td>
</tr>

<!--
<tr>
<td width="150"><div class="content">Number of keywords: </div></td>
<td><div class="content"><%= wordCounter %></div></td>
</tr>
-->

<tr>
<td width="150"><div class="content">Search in columns: </div></td>
<td><div class="content">Artist, Song Title, CD Title</div></td>
</tr>

<!--
<tr>
<td width="150"><div class="content">Match ALL keyword(s) ? </div></td>
<td><div class="content"><%= matchWhat %></div></td>
</tr>
-->

<tr>
<td width="150"><div class="content"># of matches found: </div></td>
<td><div class="content"><%= rs.recordcount %></div></td>
</tr>
</table>


<table align="center" cellpadding="2" style="width:850px;border-collapse: collapse">
<!--
<tr>
<td><div class="content"><b>SQL statement generated: </b></div></td>
</tr>
<tr>
<td><div class="content"><%= sql1 %></div></td>
</tr>
-->

<tr>
<td>
<%
	If rs.recordcount > 100 then
		response.write "<div class=content><br /><b>Showing only the Top 100</b>.  Enter more keywords to improve search.</div>"
	End If
%>
</td>
</tr>
</table>


<% 

if not rs.eof then
If Len(Request("pagenum")) = 0  Then
  rs.AbsolutePage = 1
 Else
  If CInt(Request("pagenum")) <= rs.PageCount Then
   rs.AbsolutePage = Request("pagenum")
  Else
   rs.AbsolutePage = 1
  End If
 End If

 Dim abspage, pagecnt
  abspage = rs.AbsolutePage
  pagecnt = rs.PageCount

End if
%>


<%
	Dim counter
	counter=0
%>

<br />
<table align="center" width="850" cellpadding="1" style="border-collapse: collapse">
<tr>
<th class="viewsongs" width="4%">&nbsp;</th> 
<th class="viewsongs" width="7%">TrackID:</th>
<th class="viewsongs" width="19%">Artist: (sort by)</th>
<th class="viewsongs" width="23%">Song Title:</th>
<th class="viewsongs" width="8%">Genre:</th>
<th class="viewsongs" width="27%">CD Title:</th>
<th class="viewsongs" width="6%">CD # :</th>
<th class="viewsongs" width="6%">Playlist:</th>
</tr>

<%	
	'If the search returned 0 songs, let user know, and not just display a blank row
	If rs.recordcount = 0 then
%>
	<tr>
	<td colspan="8" align="center"><font color="#ff0000">
	<% 	response.write "We didn't find any songs containing "%>
	<%	if request("Opt1")="ON" then 
			response.write "<u>ALL</u> of the words "
		else
			response.write "<u>ANY</u> of the words "
		end if
	%>
	<%	response.write """<b>" & request("search") & "</b>."" " & "Please modify your search."%></font></td>
	</tr>

<%	
	Else

  	If Not rs.EOF Then
 
		For intRec = 1 to rs.pageSize
			if not rs.EOF then
%>

<%
	if counter MOD 2 = 0 then
%>
  	<tr bgcolor="#ececec" onMouseOver="Line_Over(this)" onMouseOut="Line_Out(this,'#ececec')"> 
<%
	else
%>
  	<tr onMouseOver="Line_Over(this)" onMouseOut="Line_Out(this,'#ffffff')"> 
<%
	end if
%>

<td class="viewsongs"><%=Counter + 1%></td>
<td class="viewsongs"><%=rs("TrackID")%></td>
<td class="viewsongs"><a href = "FindByArtist.asp?Artist=<%=rs("Artist")%>"><%=rtrim(rs("Artist"))%></a></td>
<td class="viewsongs"><%=rs("SongTitle")%>
<% 
	If datediff("d", rs("DateAdded"), now()) < 90 then
		'response.write "<font color=#aaaaaa>" & " **"
		response.Write " <img src=Images/new.gif>"
	else
		response.write ""
	end if
%></td>
<td class="viewsongs"><%=rs("Genre")%></td>
<td class="viewsongs"><%=rs("CDTitle")%></td>
<td class="viewsongs"><a href = "viewCDandTracks.asp?specificCD=<%=rs("CDNum")%>"><%=rs("CDNum")%></a></td>
<td class="viewsongs" align="center"><a href="PlaylistAdd.asp?HotID=<%=rs("TrackID") %>"><img src="Images/plus.gif" border="0" alt="Add to playlist"></a></td>
</tr>

<%
				Counter = Counter + 1
				rs.Movenext
			End if
	 	Next
	End IF
END if
%>

</table>

<%
'End If
%>
<% End Sub %>


</body>

</html>
