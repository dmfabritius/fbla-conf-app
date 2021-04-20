<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-Region.aspx.cs" Inherits="FBLA_Conference_System.Rpt_Region" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Regional Summary Reports</h2></td><td style="padding-left:20px">
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
    <br />

    <asp:TabContainer ID="tabsReports" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabRegionConfSummary" runat="server" HeaderText="Conference Summary"><ContentTemplate>
            <asp:UpdatePanel ID="updRegionConfSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvRegionConfSummary" runat="server" DataSourceID="sqlRegionConfSummary" ShowFooter="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None"
                    onrowdatabound="gvRegionConfSummary_RowDataBound">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no students attending conferences in this region.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" SortExpression="ChapterName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="NumLeadership" HeaderText="Leadership" SortExpression="NumLeadership"
                            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="125px" />
                        <asp:BoundField DataField="NumRegional" HeaderText="Regionals" SortExpression="NumRegional"
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
        <asp:TabPanel ID="tabRegionStudentSummary" runat="server" HeaderText="Membership"><ContentTemplate>
            <asp:UpdatePanel ID="updRegionStudentSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvRegionStudentSummary" runat="server" DataSourceID="sqlRegionStudentSummary" ShowFooter="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None"
                    onrowdatabound="gvRegionStudentSummary_RowDataBound">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Center" Width="100px"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" HorizontalAlign="Center" Width="100px"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no Nationally dues paid students in this region.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" SortExpression="ChapterName"
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
        <asp:TabPanel ID="tabRegionOfficers" runat="server" HeaderText="Officers"><ContentTemplate>
            <asp:UpdatePanel ID="updRegionOfficers" runat="server"><ContentTemplate>
                <asp:GridView ID="gvRegionOfficers" runat="server" DataSourceID="sqlRegionOfficers"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no chapter officers in this region.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" SortExpression="ChapterName" ItemStyle-Width="300px" />
                        <asp:BoundField DataField="ChapterPosition" HeaderText="Position" SortExpression="ChapterPosition" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" ItemStyle-Width="175px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName" ItemStyle-Width="175px" />
                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
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
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionID, RegionName FROM Regions WHERE StateID=@StateID ORDER BY RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRegionConfSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT CH.ChapterName,SUM(CASE WHEN CF.isMembersOnly=0 THEN 1 ELSE 0 END) AS NumLeadership,SUM(CASE WHEN CF.isMembersOnly=1 AND CF.RegionID <> 0 THEN 1 ELSE 0 END)AS NumRegional FROM (SELECT DISTINCT ConferenceID, MemberID FROM ConferenceMemberEvents) ME INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID INNER JOIN Chapters CH ON M.ChapterID=CH.ChapterID INNER JOIN Conferences CF ON ME.ConferenceID=CF.ConferenceID WHERE CF.RegionID=@RegionID AND CASE WHEN (MONTH(GETDATE()) > 7 AND ((MONTH(ConferenceDate) > 7 AND YEAR(ConferenceDate) = YEAR(GETDATE())) OR (MONTH(ConferenceDate) < 8 AND YEAR(ConferenceDate) = YEAR(GETDATE())+1))) OR (MONTH(GETDATE()) < 8 AND ((MONTH(ConferenceDate) > 7 AND YEAR(ConferenceDate) = YEAR(GETDATE())-1) OR (MONTH(ConferenceDate) < 8 AND YEAR(ConferenceDate) = YEAR(GETDATE())))) THEN 'Y' ELSE 'N' END = 'Y' GROUP BY CH.ChapterName ORDER BY CH.ChapterName">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRegionStudentSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ChapterName,COUNT(M.MemberID) AS NumMembers,SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8 THEN 1 ELSE 0 END) AS NumSeniors,SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+1 THEN 1 ELSE 0 END) AS NumJuniors,SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+2 THEN 1 ELSE 0 END) AS NumSophomores,SUM(CASE WHEN M.GraduatingClass=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+3 THEN 1 ELSE 0 END) AS NumFreshmen,SUM(CASE WHEN M.GraduatingClass > DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+3 THEN 1 ELSE 0 END) AS NumMiddle,SUM(CASE WHEN M.Gender='M' THEN 1 ELSE 0 END) AS NumMales,SUM(CASE WHEN M.Gender='F' THEN 1 ELSE 0 END) AS NumFemales FROM NationalMembers M INNER JOIN Chapters C ON M.ChapterID=C.ChapterID WHERE ISNULL(isInactive,0)=0 AND isPaid=1 AND M.GraduatingClass>=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8 AND C.RegionID=@RegionID GROUP BY ChapterName ORDER BY ChapterName">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRegionOfficers" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ChapterName,ChapterPosition,FirstName,LastName FROM NationalMembers M INNER JOIN Chapters C ON M.ChapterID=C.ChapterID WHERE RegionID=@RegionID AND ISNULL(ChapterPosition,'None') <> 'None' ORDER BY ChapterName,ChapterPosition">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    

</asp:Content>
