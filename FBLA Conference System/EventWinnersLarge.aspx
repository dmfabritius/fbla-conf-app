<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventWinnersLarge.aspx.cs" Inherits="FBLA_Conference_System.EventWinnersLarge" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<style type="text/css">
@page {margin: 0.25in}
p {page-break-after:always}
.event {font:bold 32pt Arial;margin:0}
.place {display:block;font:28pt Arial;margin-top:34px}
.winners {display:inline-block;font:bold 26pt Arial;margin:0}
table{border-top:1px solid black;margin:0}
td{padding-left:10px}
</style>
</head>
<body>
<asp:DataList ID="rptConferenceEventWinners" runat="server" RepeatColumns="1" RepeatDirection="Horizontal" RepeatLayout="Flow" ItemStyle-Width="1008px"><ItemTemplate>
    <div class="event"><%# DataBinder.Eval(Container.DataItem, "EventName") %></div>
    <asp:Repeater ID="rpTeams" runat="server" DataSource='<%# GetChildRelation(Container.DataItem, "EventTeams")  %>'>
        <ItemTemplate>
            <div class="place">
            <%# DataBinder.Eval(Container.DataItem, "Place")%> : <%# DataBinder.Eval(Container.DataItem, "TeamName")%>
            </div>
            <span class="winners">
                <asp:DataList ID="rpWinners" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" RepeatLayout="Table" ItemStyle-Width="1008px"
                    DataSource='<%#  GetChildRelation(Container.DataItem, "TeamWinners") %>'><ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem, "Name")%><br />
                </ItemTemplate></asp:DataList>
            </span>
        </ItemTemplate>
    </asp:Repeater>
    <p/><!-- Page Break -->
</ItemTemplate></asp:DataList>
</body>
</html>