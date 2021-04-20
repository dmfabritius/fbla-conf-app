<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-ConfReports.aspx.cs" Inherits="FBLA_Conference_System.Rpt_ConfReports" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conference Reports</h2></td><td style="padding-left:20px">
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

    <asp:TabContainer ID="tabsConference" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabEventsSummary" runat="server" HeaderText="Events Summary"><ContentTemplate>
            <asp:UpdatePanel ID="updEventsSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvEventsSummary" runat="server" DataSourceID="sqlEventsSummary"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no students attending this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="EventName" HeaderText="Event Name" SortExpression="EventName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="350px" />
                        <asp:BoundField DataField="NumTeams" HeaderText="Participating Teams" SortExpression="NumTeams"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="NumStudents" HeaderText="Participating Students" SortExpression="NumStudents"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="150px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabEventsDetail" runat="server" HeaderText="Events Detail"><ContentTemplate>
            <asp:UpdatePanel ID="updEventsDetail" runat="server"><ContentTemplate>
                <asp:GridView ID="gvEventsDetail" runat="server" DataSourceID="sqlEventsDetail"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no students attending this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="EventName" HeaderText="Event" SortExpression="EventName,RegionName,ChapterName,TeamName,LastName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName,EventName,ChapterName,TeamName,LastName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName,EventName,TeamName,LastName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="TeamName" HeaderText="Team" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName,LastName,RegionName,ChapterName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName,FirstName,RegionName,ChapterName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabAdvisers" runat="server" HeaderText="Advisers/Chaperones"><ContentTemplate>
            <asp:UpdatePanel ID="updAdvisers" runat="server"><ContentTemplate>
                <asp:GridView ID="gvAdvisers" runat="server" DataSourceID="sqlAdvisers"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName, ChapterName" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="ChaperoneName" HeaderText="Adviser/Chaperone" SortExpression="ChaperoneName" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="ChaperoneCell" HeaderText="Cell" SortExpression="ChaperoneCell" ItemStyle-Width="175px" />
                        <asp:BoundField DataField="AdviserEmail" HeaderText="Email" SortExpression="AdviserEmail" ItemStyle-Width="150px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
    </asp:TabContainer>

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

    <asp:SqlDataSource ID="sqlEventsSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventName,CASE WHEN E.EventType='T' THEN T.NumTeams ELSE NULL END AS NumTeams,NumStudents FROM NationalEvents E INNER JOIN Conferences C ON CASE WHEN E.EventType <> 'N' THEN 'I' ELSE 'N' END = CASE  WHEN C.isMembersOnly = 1 THEN 'I' ELSE 'N' END LEFT JOIN (SELECT EventID,COUNT(Teams) AS NumTeams FROM (SELECT DISTINCT EventID,CAST(ChapterID AS nvarchar)+CASE WHEN TeamName IS NULL THEN CAST(CME.MemberID AS nvarchar) ELSE TeamName END AS Teams FROM ConferenceMemberEvents CME INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID WHERE ConferenceID=@ConferenceID) AS NT GROUP BY EventID) AS T ON E.EventID=T.EventID LEFT JOIN (SELECT EventID,COUNT(*) AS NumStudents FROM ConferenceMemberEvents WHERE ConferenceID=@ConferenceID GROUP BY EventID) AS S ON E.EventID=S.EventID WHERE ConferenceID=@ConferenceID ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlEventsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventName,RegionName,ChapterName,TeamName,ISNULL(LastName,'-') AS LastName,ISNULL(FirstName,'-') AS FirstName FROM NationalEvents E LEFT JOIN (SELECT CME.EventID,RegionName,ChapterName,TeamName,LastName,FirstName FROM ConferenceMemberEvents CME INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID INNER JOIN Chapters C ON M.ChapterID=C.ChapterID INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE CME.ConferenceID=@ConferenceID) AS SE ON E.EventID=SE.EventID WHERE (CASE WHEN EventType = 'T' OR EventType = 'C' THEN 'I' ELSE EventType END = CASE (SELECT isMembersOnly FROM Conferences WHERE ConferenceID=@ConferenceID) WHEN 0 THEN 'N' ELSE 'I' END) AND E.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID) ORDER BY EventName,RegionName,ChapterName,TeamName,LastName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAdvisers" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT DISTINCT R.RegionName, C.ChapterName, CC.ChaperoneName, CC.ChaperoneCell, C.AdviserEmail FROM ConferenceChapterChaperones CC INNER JOIN Chapters C ON CC.ChapterID=C.ChapterID INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE ConferenceID=@ConferenceID ORDER BY R.RegionName, C.ChapterName, CC.ChaperoneName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>


</asp:Content>