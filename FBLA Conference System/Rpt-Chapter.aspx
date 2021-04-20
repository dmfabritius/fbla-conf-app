<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-Chapter.aspx.cs" Inherits="FBLA_Conference_System.Rpt_Chapter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Chapter Summary Reports</h2></td><td style="padding-left:20px">
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
    <asp:Panel ID="pnlSelChapter" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <asp:UpdatePanel ID="updddChapters" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a Chapter:</span>
            <asp:DropDownList ID="ddChapters" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewChapterList" DataTextField="ChapterName" DataValueField="ChapterID" 
                ondatabound="ddChapters_DataBound" onselectedindexchanged="ddChapters_SelectedIndexChanged"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />
    <asp:UpdatePanel ID="updNumberOfStudents" runat="server"><ContentTemplate>
        Number of students from the selected chapter signed up for one or more events for the<br />selected conference:
        <asp:Label ID="lblNumberOfStudents" runat="server" Font-Bold="true" />
    </ContentTemplate></asp:UpdatePanel>
    <br />
    <asp:TabContainer ID="tabsReports" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabAttendance" runat="server" HeaderText="Attendance"><ContentTemplate>
            <asp:UpdatePanel ID="updAttendance" runat="server"><ContentTemplate>
                <asp:GridView ID="gvAttendance" runat="server" DataSourceID="sqlAttendance"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no  students attending this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" SortExpression="StudentName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="NumEvents" HeaderText="Number of Events" SortExpression="NumEvents"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabStudentsByEvent" runat="server" HeaderText="Students by Events"><ContentTemplate>
            <asp:UpdatePanel ID="updConfStudentsByEvent" runat="server"><ContentTemplate>
                <asp:GridView ID="gvStudentsByEvent" runat="server" DataSourceID="sqlStudentsByEvent"
                    CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true"
                    OnRowDataBound="gvStudentsByEvent_RowDataBound">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <Columns>
                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Left" />
                            <HeaderTemplate>
                                <asp:Label ID="Label1" runat="server" Text="Event Name"/>
                                <asp:Label ID="Label2" runat="server" Text=" | Filter by:" Font-Bold="false"/>
                                <asp:DropDownList ID="ddEventType" runat="server" CausesValidation="false" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddEventType_SelectedIndexChanged">
                                    <asp:ListItem Value=" " Text="Indiv & Team" Selected="true" />
                                    <asp:ListItem Value="EventType='I'" Text="Indiv Only" />
                                    <asp:ListItem Value="EventType='T'" Text="Team Only" />
                                </asp:DropDownList>
                            </HeaderTemplate>
                            <ItemStyle Width="300px" />
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server"><%# Eval("EventName") %></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="TestTaken" HeaderText="Online Test Taken" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="200px" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabEventsByStudent" runat="server" HeaderText="Events by Student"><ContentTemplate>
            <asp:UpdatePanel ID="updConfEventsByStudent" runat="server"><ContentTemplate>
                <asp:GridView ID="gvEventsByStudent" runat="server" DataSourceID="sqlEventsByStudent"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no eligible students for this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="EventName" HeaderText="Event Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="TestTaken" HeaderText="Online Test Taken" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="200px" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabChapterEvents" runat="server" HeaderText="Chapter Events"><ContentTemplate>
            <asp:UpdatePanel ID="updChapterEvents" runat="server"><ContentTemplate>
                <asp:GridView ID="gvChapterEvents" runat="server" DataSourceID="sqlChapterEvents"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no chapter events for this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="EventName" HeaderText="Event Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="StudentName" HeaderText="Chapter Representative" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabJudgeComments" runat="server" HeaderText="Judges' Comments"><ContentTemplate>
            <asp:UpdatePanel ID="updJudgeComments" runat="server"><ContentTemplate>
                <asp:GridView ID="gvJudgeComments" runat="server" DataSourceID="sqlJudgeComments"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no judges' comments for this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="EventName" HeaderText="Event Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="Name" HeaderText="Student/Team" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="PerfComments" HeaderText="Judges' Comments" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="375px" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
    </asp:TabContainer>

    <asp:Panel ID="pnlPopup" runat="server" CssClass="ModalWindow">
        <asp:UpdatePanel ID="updPopup" runat="server"><ContentTemplate>
            <div style="width:100%;text-align:center">
                <asp:Label ID="lblPopup" runat="server"/>
                <br /><br />
                <asp:Button ID="btnClosePopup" runat="server" Text="OK" />
            </div>
            <asp:Button ID="btnShowPopup" runat="server" style="display:none" />
            <asp:ModalPopupExtender ID="popupErrorMsg" runat="server" BackgroundCssClass="ModalBackground"
                PopupControlID="pnlPopup" TargetControlID="btnShowPopup" CancelControlID="btnClosePopup" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
        
    <asp:SqlDataSource ID="sqlViewStateList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT DISTINCT S.StateID, S.StateName FROM States S INNER JOIN Regions R ON S.StateID=R.StateID ORDER BY S.StateName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT RegionID, RegionName FROM Regions WHERE StateID=@StateID ORDER BY RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewChapterList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ChapterID, ChapterName FROM Chapters WHERE (RegionID=@RegionID) ORDER BY ChapterName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewConferenceList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE (StateID=@StateID OR StateID=0) AND (RegionID=@RegionID OR RegionID=0) AND ConferenceDate >= CONVERT(date, GETDATE()-180) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sqlAttendance" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT (LastName+', '+FirstName) AS StudentName, CAST(COUNT(ME.EventID) AS nvarchar)+' event'+CASE WHEN COUNT(ME.EventID)=1 THEN '' ELSE 's' END AS NumEvents FROM NationalMembers M INNER JOIN ConferenceMemberEvents ME ON ME.ConferenceID=@ConferenceID AND M.MemberID=ME.MemberID WHERE ChapterID=@ChapterID GROUP BY LastName, FirstName ORDER BY LastName, FirstName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStudentsByEvent" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT CASE WHEN E.EventType='N' THEN 'I' ELSE E.EventType END AS EventType,CASE WHEN ISNULL(SE.TeamName,'')='' THEN E.EventName ELSE E.EventName+' ('+SE.TeamName+')' END AS EventName,ISNULL(StudentName,'-') AS StudentName,ISNULL(TestTaken,'') AS TestTaken FROM NationalEvents E LEFT JOIN (SELECT C.EventID, (LastName+', '+FirstName) AS StudentName,TeamName,TestTaken=CASE WHEN ObjectiveElapsedTime IS NOT NULL THEN 'Y' ELSE '' END FROM ConferenceMemberEvents C INNER JOIN NationalMembers M ON C.MemberID=M.MemberID WHERE C.ConferenceID=@ConferenceID AND M.ChapterID=@ChapterID) AS SE ON E.EventID=SE.EventID WHERE isInactive=0 AND (CASE EventType WHEN 'T' THEN 'I' ELSE EventType END=CASE (SELECT isMembersOnly FROM Conferences WHERE ConferenceID=@ConferenceID) WHEN 0 THEN 'N' ELSE 'I' END) AND E.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID) ORDER BY EventName,StudentName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlEventsByStudent" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT (LastName+', '+FirstName) StudentName, ISNULL(EventName,'-') EventName, ISNULL(TestTaken,'') TestTaken FROM NationalMembers M LEFT JOIN (SELECT CME.MemberID, CASE WHEN E.EventType='T' THEN E.EventName+' ('+CME.TeamName+')' ELSE E.EventName END AS EventName, TestTaken=CASE WHEN ObjectiveElapsedTime IS NOT NULL THEN 'Y' ELSE '' END FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID=E.EventID WHERE CME.ConferenceID=@ConferenceID) AS SE ON M.MemberID=SE.MemberID WHERE ISNULL(isInactive,0)=0 AND CASE WHEN (SELECT isMembersOnly FROM Conferences WHERE ConferenceID=@ConferenceID)=1 THEN M.isPaid ELSE 1 END=1 AND CASE WHEN (SELECT StateID FROM Conferences WHERE ConferenceID=@ConferenceID)=0 THEN M.isNationalEligible ELSE 1 END=1 AND CASE WHEN (SELECT RegionID FROM Conferences WHERE ConferenceID=@ConferenceID)=0 THEN M.isStateEligible ELSE 1 END=1 AND M.ChapterID=@ChapterID ORDER BY LastName, FirstName, EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChapterEvents" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventName, ISNULL(StudentName,'-') AS StudentName FROM NationalEvents E LEFT JOIN (SELECT C.EventID, (LastName+', '+FirstName) StudentName FROM ConferenceMemberEvents C INNER JOIN NationalMembers M ON C.MemberID=M.MemberID WHERE C.ConferenceID=@ConferenceID AND M.ChapterID=@ChapterID) AS SE ON E.EventID=SE.EventID WHERE isInactive=0 AND (EventType=CASE (SELECT isMembersOnly FROM Conferences WHERE ConferenceID=@ConferenceID) WHEN 1 THEN 'C' ELSE 'X' END) AND E.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID) ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlJudgeComments" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventName, Name=CASE WHEN ISNULL(CME.TeamName,'')='' THEN M.LastName+', '+M.FirstName ELSE TeamName END, CO.PerfComments FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID=E.EventID INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID INNER JOIN JudgeComments CO ON CME.MemberID=CO.MemberID AND CME.ConferenceID=CO.ConferenceID AND CME.EventID=CO.EventID WHERE CME.ConferenceID=@ConferenceID AND M.ChapterID=@ChapterID ORDER BY EventName, LastName, FirstName, TeamName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
