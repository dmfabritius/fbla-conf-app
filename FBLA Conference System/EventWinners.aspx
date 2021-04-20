<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventWinners.aspx.cs" Inherits="FBLA_Conference_System.EventWinners" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<style type="text/css">
@page {margin: 0.5in}
p {page-break-after:always}
h2 {font:bold 12pt Arial}
body {font:10pt Arial}
.place {display:inline-block;font:bold 10pt Arial;margin:0 15px 5px 20px}
.winners {display:inline-block;font:10pt Arial;margin:0 15px 5px 40px}
tr {vertical-align:top}
td{border-bottom:1px solid black}
</style>
</head>
<body>
<asp:DataList ID="rptConferenceEventWinners" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" RepeatLayout="Table" ItemStyle-Width="360px"><ItemTemplate>
    <h2><%# DataBinder.Eval(Container.DataItem, "EventName") %></h2>
    <asp:Repeater ID="rpTeams" runat="server" DataSource='<%# GetChildRelation(Container.DataItem, "EventTeams")  %>'>
        <ItemTemplate>
            <span class="place">
            <%# DataBinder.Eval(Container.DataItem, "Place")%> : <%# DataBinder.Eval(Container.DataItem, "TeamName")%>
            </span><br />
            <span class="winners">
                <asp:Repeater ID="rpWinners" runat="server" DataSource='<%#  GetChildRelation(Container.DataItem, "TeamWinners") %>'>
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem, "Name")%><br />
                    </ItemTemplate>
                </asp:Repeater>
            </span><br />
        </ItemTemplate>
    </asp:Repeater>
</ItemTemplate></asp:DataList>
</body>
</html>