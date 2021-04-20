<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-State.aspx.cs" Inherits="FBLA_Conference_System.Rpt_State" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>State Summary Reports</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>

    <asp:Panel ID="pnlSelState" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <asp:UpdatePanel ID="updddStates" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a State:</span>
            <asp:DropDownList ID="ddStates" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />

    <asp:TabContainer ID="tabsReports" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabStateConfSummary" runat="server" HeaderText="Conferences"><ContentTemplate>
            <asp:UpdatePanel ID="updStateConfSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvStateConfSummary" runat="server" DataSourceID="sqlStateConfSummary" ShowFooter="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None"
                    onrowdatabound="gvStateConfSummary_RowDataBound">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no students attending conferences in this state.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region Name" SortExpression="RegionName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="325px" />
                        <asp:BoundField DataField="NumLeadership" HeaderText="Leadership" SortExpression="NumLeadership"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="125px" />
                        <asp:BoundField DataField="NumRegional" HeaderText="Regionals" SortExpression="NumRegional"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="125px" />
                        <asp:BoundField DataField="NumState" HeaderText="State" SortExpression="NumState"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="125px" />
                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabStateStudentSummary" runat="server" HeaderText="Membership"><ContentTemplate>
            <asp:UpdatePanel ID="updStateStudentSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvStateStudentSummary" runat="server" DataSourceID="sqlStateStudentSummary" ShowFooter="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None"
                    onrowdatabound="gvStateStudentSummary_RowDataBound">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Center" Width="100px"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" HorizontalAlign="Center" Width="100px"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no Nationally dues paid students in this state.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region Name" SortExpression="RegionName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="NumMembers" HeaderText="Members" SortExpression="NumMembers"/>
                        <asp:BoundField DataField="NumSeniors" HeaderText="Seniors" SortExpression="NumSeniors"/>
                        <asp:BoundField DataField="NumJuniors" HeaderText="Juniors" SortExpression="NumJuniors"/>
                        <asp:BoundField DataField="NumSophomores" HeaderText="Soph's" SortExpression="NumSophomores"/>
                        <asp:BoundField DataField="NumFreshmen" HeaderText="Freshmen" SortExpression="NumFreshmen"/>
                        <asp:BoundField DataField="NumMiddle" HeaderText="7th/8th" SortExpression="NumMiddle"/>
                        <asp:BoundField DataField="NumMales" HeaderText="Males" SortExpression="NumMales"/>
                        <asp:BoundField DataField="NumFemales" HeaderText="Females" SortExpression="NumFemales"/>
                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabPresidentsList" runat="server" HeaderText="Presidents List"><ContentTemplate>
            <asp:UpdatePanel ID="updPresidentsList" runat="server"><ContentTemplate>
                <asp:GridView ID="gvPresidentsList" runat="server" DataSourceID="sqlPresidentsList"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no chapter presidents in this state.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName, ChapterName, LastName, FirstName" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName, LastName, FirstName" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName, ChapterName" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="AdviserName" HeaderText="Adviser" SortExpression="AdviserName, LastName, FirstName" ItemStyle-Width="200px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabOutstanding" runat="server" HeaderText="Outstanding Students"><ContentTemplate>
            <asp:UpdatePanel ID="updOutstanding" runat="server"><ContentTemplate>
                <asp:GridView ID="gvOutstanding" runat="server" DataSourceID="sqlOutstanding"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no students marked as outstanding in this state.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName,ChapterName,LastName,FirstName" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName,LastName,FirstName" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName,ChapterName" ItemStyle-Width="150px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabVotingDelegates" runat="server" HeaderText="Voting Delegates"><ContentTemplate>
            <asp:UpdatePanel ID="updVotingDelegates" runat="server"><ContentTemplate>
                <asp:GridView ID="gvVotingDelegatesSummary" runat="server" DataSourceID="sqlVotingDelegatesSummary"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no voting delegates in this state.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName, ChapterName" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="ChapterSize" HeaderText="Number of Members" SortExpression="ChapterSize"
                            ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="MaxDelegates" HeaderText="Maximum Delegates" SortExpression="MaxDelegates"
                            ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabAdvisers" runat="server" HeaderText="Advisers"><ContentTemplate>
            <asp:UpdatePanel ID="updAdvisers" runat="server"><ContentTemplate>
                <asp:GridView ID="gvAdvisers" runat="server" DataSourceID="sqlAdvisers"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" SortExpression="RegionName, ChapterName" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" SortExpression="ChapterName" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="AdviserName" HeaderText="Adviser/Chaperone" SortExpression="AdviserName" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="AdviserCellPhone" HeaderText="Cell" SortExpression="AdviserCellPhone" ItemStyle-Width="175px" />
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
        SelectCommand="SELECT StateID, StateName FROM States ORDER BY StateName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlStateConfSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT R.RegionName,SUM(CASE WHEN CF.isMembersOnly=0 THEN 1 ELSE 0 END) AS NumLeadership,SUM(CASE WHEN CF.isMembersOnly=1 AND CF.RegionID <> 0 THEN 1 ELSE 0 END) AS NumRegional,SUM(CASE WHEN CF.isMembersOnly=1 AND CF.RegionID = 0 THEN 1 ELSE 0 END) AS NumState FROM (SELECT DISTINCT ConferenceID, MemberID FROM ConferenceMemberEvents) ME INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID INNER JOIN Chapters CH ON M.ChapterID=CH.ChapterID INNER JOIN Regions R ON CH.RegionID=R.RegionID INNER JOIN Conferences CF ON ME.ConferenceID=CF.ConferenceID WHERE CF.StateID=@StateID AND CASE WHEN (MONTH(GETDATE()) > 7 AND ((MONTH(ConferenceDate) > 7 AND YEAR(ConferenceDate) = YEAR(GETDATE())) OR (MONTH(ConferenceDate) < 8 AND YEAR(ConferenceDate) = YEAR(GETDATE())+1))) OR (MONTH(GETDATE()) < 8 AND ((MONTH(ConferenceDate) > 7 AND YEAR(ConferenceDate) = YEAR(GETDATE())-1) OR (MONTH(ConferenceDate) < 8 AND YEAR(ConferenceDate) = YEAR(GETDATE())))) THEN 'Y' ELSE 'N' END = 'Y' GROUP BY R.RegionName ORDER BY R.RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStateStudentSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT R.RegionName,COUNT(M.MemberID) AS NumMembers, NumSeniors=SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8 THEN 1 ELSE 0 END), NumJuniors=SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+1 THEN 1 ELSE 0 END), NumSophomores=SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+2 THEN 1 ELSE 0 END), NumFreshmen=SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+3 THEN 1 ELSE 0 END), NumMiddle=SUM(CASE WHEN M.GraduatingClass > DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+3 THEN 1 ELSE 0 END), NumMales=SUM(CASE WHEN M.Gender='M' THEN 1 ELSE 0 END), NumFemales=SUM(CASE WHEN M.Gender='F' THEN 1 ELSE 0 END) FROM NationalMembers M INNER JOIN Chapters CH ON M.ChapterID=CH.ChapterID AND CH.StateID=@StateID INNER JOIN Regions R ON CH.RegionID=R.RegionID WHERE ISNULL(isInactive,0)=0 AND M.isPaid=1 AND M.GraduatingClass>=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8 GROUP BY R.RegionName ORDER BY R.RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlPresidentsList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionName,ChapterName,FirstName,LastName,AdviserName FROM NationalMembers M INNER JOIN Chapters C ON M.ChapterID=C.ChapterID INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE ISNULL(isInactive,0)=0 AND M.ChapterPosition='President' AND C.StateID=@StateID ORDER BY RegionName,ChapterName,LastName,FirstName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOutstanding" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionName,ChapterName,FirstName,LastName FROM Chapters C INNER JOIN Regions R ON C.RegionID=R.RegionID INNER JOIN NationalMembers M ON C.OutstandingStudent=M.MemberID WHERE ISNULL(isInactive,0)=0 AND C.StateID=@StateID ORDER BY RegionName,ChapterName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVotingDelegatesSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionName,ChapterName,ChapterSize=(SELECT COUNT(MemberID) FROM NationalMembers M WHERE ISNULL(isPaid,0)=1 AND C.ChapterID=M.ChapterID),MaxDelegates=(SELECT MaxDelegates=CASE WHEN COUNT(MemberID) <= 50 THEN 2 ELSE (CASE WHEN COUNT(MemberID) <= 100 THEN 3 ELSE 4 END) END FROM NationalMembers M WHERE ISNULL(isPaid,0)=1 AND C.ChapterID=M.ChapterID) FROM Chapters C INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE C.StateID=@StateID AND (SELECT COUNT(MemberID) FROM NationalMembers M WHERE ISNULL(isPaid,0)=1 AND C.ChapterID=M.ChapterID AND M.isStateEligible=1) <> 0 ORDER BY RegionName,ChapterName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlAdvisers" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT R.RegionName, C.ChapterName, C.AdviserName, C.AdviserCellPhone, C.AdviserEmail FROM Chapters C INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE C.StateID=@StateID ORDER BY R.RegionName, C.ChapterName">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
