<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OnlineTestingStatus.aspx.cs" Inherits="FBLA_Conference_System.OnlineTestingStatus" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>FCS Online Testing Status</title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
</head>
<body style="font:12pt Calibri"><form id="form1" runat="server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" CellPadding="4" ForeColor="#333333" GridLines="None"
        ShowFooter="true" OnRowDataBound="GridView1_RowDataBound">
        <Columns>
            <asp:BoundField DataField="ConferenceName" HeaderText="Conference" InsertVisible="False" ReadOnly="True" FooterStyle-HorizontalAlign="Right" />
            <asp:BoundField DataField="Num" HeaderText="Responses" DataFormatString="{0:#,##0}" ItemStyle-HorizontalAlign="Right" FooterStyle-HorizontalAlign="Right" />
        </Columns>
        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <FooterStyle BackColor="#7D9BBD" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="select c.ConferenceName, num from (select ConferenceID,Num=COUNT(*) from TestResponses group by ConferenceID) r inner join Conferences c on r.ConferenceID=c.ConferenceID"/>

</form></body></html>