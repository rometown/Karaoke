<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Karaoke.aspx.cs" Inherits="Bubbarome.Karaoke" %>

<!DOCTYPE html>

<html>
<head>
    <title>Karaoke application home page</title>
    
    <link href="CSS/karaoke.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        ul.jobd
        {
            list-style-image:url(Images/arrow_right.jpg);
            margin-top:0;
        }
    </style>

</head>
<body>
    <!--#include file="Kheader.html"-->
    <form id="form1" runat="server">
    <div>
        <table align="center" style="width:800px">
            <tr>
            <td colspan="2" style="width:500px; background-image:url(Images/klogo.gif);" class="karaokeheader"><a class="greylink" href="Karaoke.aspx">Karaoke</a></td>
            </tr>

            <tr>
            <td colspan="2" style="padding-bottom:15px;">
            <div class="content">
            Thank you for checking out my karaoke application. I built this website to manage my karaoke collection of 9,000 songs at home.  My friends and I use this website to quickly find songs and add it to our playlists (must be signed in). Try it out! Start typing an artist's name in the keyword search above (e.g. type <i>Celine Dion</i>) and watch the Google-style autosuggest start recommending songs. Or click on any of the artist name below to view all of their songs. For other search methods, click on the drop-down menu above. <a class="bluelink" href="AboutKaraoke.asp">Want to learn more about my Karaoke website</a>?
            </div>
            </td>
            </tr>
            <tr>
            <td style="padding-bottom: 15px;width: 400px">
            <!-- Customized asp.net gridview control. Contains onmouseover, onmouseout and onclick events using the OnRowDataBound attribute. -->
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="1" CellSpacing="1" CssClass="viewsongs" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None" PageSize="200" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound">
            <AlternatingRowStyle BackColor="White" ForeColor="#808080" />
            <Columns>
                <asp:BoundField DataField="Artist" HeaderStyle-Width="250" HeaderText="Artist" SortExpression="Artist" >
<HeaderStyle Width="250px"></HeaderStyle>
                </asp:BoundField>
                <asp:BoundField DataField="SongCount" HeaderStyle-Width="100" HeaderText="SongCount" SortExpression="SongCount" >
<HeaderStyle Width="100px"></HeaderStyle>
                </asp:BoundField>
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="White" Font-Bold="False" ForeColor="#808080" />
            <HeaderStyle BackColor="White" Font-Bold="False" ForeColor="#808080" />
                <PagerSettings FirstPageText="First&amp;nbsp;" LastPageText="Last" Mode="NextPreviousFirstLast" NextPageText="Next&amp;nbsp;" Position="TopAndBottom" PreviousPageText="Prev&amp;nbsp;" />
            <PagerStyle BackColor="White" ForeColor="#808080" HorizontalAlign="Center" />
            <RowStyle BackColor="#f5f5f5" ForeColor="#808080" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:romeom_karaokeConnectionString %>" SelectCommand="SELECT * FROM [_viewArtists] ORDER BY Artist"></asp:SqlDataSource>
            </td>

            <td style="vertical-align:top; padding-top:20px;"><div class="content">Built using the following Web 2.0 technologies:
                    <ul class="jobd" style="margin-left:0; padding-left:30px;">
                        <li>Microsoft: ASP.NET Web Forms, C#, SQL</li>
                        <li>JavaScript, jQuery, AJAX (use Search above to invoke jQuery).</li>
                        <li>HTML5, CSS</li>
                        <li>Bootstrap (CSS) including Mobile Device</li>
                        <li>Back-end: Microsoft SQL Server, Stored Procedures</li>
                    </ul>
                </div>
            </td>

            </tr>
        </table>
       
    </div>
    </form>
    

    <!--#include file="Footer.html"-->


</body>
</html>
