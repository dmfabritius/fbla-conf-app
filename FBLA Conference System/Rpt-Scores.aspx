<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-Scores.aspx.cs" Inherits="FBLA_Conference_System.Rpt_Scores" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conference Scoring Report</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>

    <asp:Panel ID="pnlSelState" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <asp:UpdatePanel ID="updddStates" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a State:</span>
            <asp:DropDownList ID="ddStates" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID" 
                onselectedindexchanged="ddStates_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelRegion" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <asp:UpdatePanel ID="updddRegions" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a Region:</span>
            <asp:DropDownList ID="ddRegions" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewRegionList" DataTextField="RegionName" DataValueField="RegionID"
                ondatabound="ddRegions_DataBound" onselectedindexchanged="ddRegions_SelectedIndexChanged" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelConference" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddConferences" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a Conference:</span>
            <asp:DropDownList ID="ddConferences" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewConferenceList" DataTextField="ConferenceName" DataValueField="ConferenceID" 
                ondatabound="ddConferences_DataBound" onselectedindexchanged="ddConferences_SelectedIndexChanged" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <br />
    <asp:UpdatePanel ID="updGenerateEventWinners" runat="server"><ContentTemplate>
        <asp:Panel ID="pnlGenerateEventWinners" runat="server">
            <asp:HyperLink ID="lnkGenerateEventWinners" runat="server" Target="_blank" NavigateUrl="~/EventWinners.aspx">Click here</asp:HyperLink>
            to view the list of winners for all events for printing or saving
            <br />
            <asp:HyperLink ID="lnkGenerateWinnersLarge" runat="server" Target="_blank" NavigateUrl="~/EventWinnersLarge.aspx">Click here</asp:HyperLink>
            to view the list of winners in extra large format, one event per page
            <br /><br />
            To create certificates using the mail merge feature in Word, copy the contents of the table<br />
            below and paste it into Excel; then save the file and use it as your data source.
        </asp:Panel>
    </ContentTemplate></asp:UpdatePanel>
    <br />

    <asp:UpdatePanel ID="updEventWinners" runat="server"><ContentTemplate>
        <asp:GridView ID="gvEventWinners" runat="server" DataSourceID="sqlEventWinners"
            CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
            <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
            <EmptyDataTemplate>
                <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no  students attending this conference.</div>
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="EventName" HeaderText="Event" SortExpression="EventName,Place,ChapterName,TeamName,FirstName,LastName"
                    HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                <asp:BoundField DataField="Place" HeaderText="Place" SortExpression="Place,EventName,ChapterName,TeamName,FirstName,LastName"
                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px" />
                <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName,TeamName,FirstName,LastName,EventName,Place"
                    ItemStyle-HorizontalAlign="Left" ItemStyle-Width="200px" />
                <asp:BoundField DataField="TeamName" HeaderText="Team" SortExpression="ChapterName,TeamName,FirstName,LastName,EventName,Place"
                    HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName,LastName"
                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName,FirstName"
                    ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" />
            </Columns>
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#F2F0EA" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>

    <asp:SqlDataSource ID="sqlViewStateList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT DISTINCT S.StateID, S.StateName FROM States S INNER JOIN Regions R ON S.StateID = R.StateID ORDER BY S.StateName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT RegionID, RegionName FROM Regions WHERE StateID = @StateID ORDER BY RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewConferenceList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE ((StateID = @StateID OR StateID = 0) AND (RegionID = @RegionID OR RegionID = 0)) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlEventWinners" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventName,Place,ChapterName,TeamName,FirstName,LastName FROM ConferenceMemberEvents ME INNER JOIN NationalEvents E ON ME.EventID=E.EventID INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID INNER JOIN Chapters C ON M.ChapterID=C.ChapterID WHERE Place IS NOT NULL AND ConferenceID=@ConferenceID ORDER BY EventName,Place,ChapterName,TeamName,LastName,FirstName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>

