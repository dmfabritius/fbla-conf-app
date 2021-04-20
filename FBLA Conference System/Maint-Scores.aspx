<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Scores.aspx.cs" Inherits="FBLA_Conference_System.Maint_Scores" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conference Scoring</h2></td><td style="padding-left:20px">
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
            &nbsp;<asp:Button ID="btnCalcScores" runat="server" Text="Calculate scores for all events" onclick="btnCalcScores_Click" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelEvent" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddEvents" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select an Event:</span>
            <asp:DropDownList ID="ddEvents" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewEventList" DataTextField="EventName" DataValueField="EventID" 
                onselectedindexchanged="ddEvents_SelectedIndexChanged" />
            &nbsp;<asp:Button ID="btnUpdate" runat="server" Text="Submit scores for this event" onclick="btnUpdate_Click" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <br />
    <asp:UpdatePanel ID="updEventScores" runat="server"><ContentTemplate>
        <asp:GridView ID="gvEventScores" runat="server" DataSourceID="sqlEventScoresMaint" DataKeyNames="MemberID"
            AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" ForeColor="#333333" AllowSorting="true"
            GridLines="None" onrowdatabound="gvEventScores_RowDataBound">
            <Columns>
                <asp:BoundField DataField="Place" HeaderText="Place" ReadOnly="true" ItemStyle-HorizontalAlign="Center" SortExpression="Score,ObjectiveElapsedTime" />
                <asp:BoundField DataField="ChapterName" HeaderText="Chapter" ReadOnly="true" ItemStyle-Width="250px" />
                <asp:BoundField DataField="TeamName" HeaderText="Team" ReadOnly="true" ItemStyle-Width="90px" SortExpression="ChapterName,TeamName,Name" />
                <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="true" ItemStyle-Width="200px" SortExpression="Name" />
                <asp:TemplateField HeaderText="Objective" ItemStyle-HorizontalAlign="Center" SortExpression="ObjectiveScore desc,ChapterName,TeamName,Name"><ItemTemplate>
                    <asp:TextBox ID="EditObj" runat="server" Text='<%# Bind("ObjectiveScore") %>' Width="50px"
                        onchange="this.style.backgroundColor='#d9e9ff'" />
                </ItemTemplate></asp:TemplateField>
                <asp:TemplateField HeaderText="Performance" ItemStyle-HorizontalAlign="Center" SortExpression="PerformanceScore desc,ChapterName,TeamName,Name"><ItemTemplate>
                    <asp:TextBox ID="EditPerf" runat="server" Text='<%# Bind("PerformanceScore") %>' Width="50px"
                        onchange="this.style.backgroundColor='#d9e9ff'" />
                </ItemTemplate></asp:TemplateField>
                <asp:TemplateField HeaderText="Homesite" ItemStyle-HorizontalAlign="Center" SortExpression="HomesiteScore desc,ChapterName,TeamName,Name"><ItemTemplate>
                    <asp:TextBox ID="EditHome" runat="server" Text='<%# Bind("HomesiteScore") %>' Width="50px"
                       onchange="this.style.backgroundColor='#d9e9ff'" />
                </ItemTemplate></asp:TemplateField>
                <asp:BoundField DataField="OnlineTestScore" HeaderText="Obj Online" ReadOnly="true"
                    ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Center" SortExpression="OnlineTestScore desc,ChapterName,TeamName,Name" />
                <asp:TemplateField HeaderText="Perf Online" ItemStyle-Width="50px" ItemStyle-HorizontalAlign="Center" SortExpression="OnlineJudgeScore desc,ChapterName,TeamName,Name"><ItemTemplate>
                    <asp:Label ID="lblOnlineJudge" runat="server" Text='<%# Eval("OnlineJudgeScore","{0:N2}") %>' Width="50px" />
                </ItemTemplate></asp:TemplateField>
            </Columns>
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <EditRowStyle BackColor="#999999" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>

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
        SelectCommand="SELECT DISTINCT S.StateID, S.StateName FROM States S INNER JOIN Regions R ON S.StateID = R.StateID ORDER BY S.StateName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT RegionID, RegionName FROM Regions WHERE StateID = @StateID ORDER BY RegionName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewConferenceList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE isMembersOnly = 1 AND ((StateID = @StateID OR StateID = 0) AND (RegionID = @RegionID OR RegionID = 0)) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT E.EventID,EventName+' ('+CAST(SUM(CASE WHEN ISNULL(ME.HomesiteScore,0)+ISNULL(ME.ObjectiveScore,0)+ISNULL(ME.PerformanceScore,0) = 0 THEN 0 ELSE 1 END) AS nvarchar)+' of '+CAST(COUNT(ME.MemberID) AS nvarchar)+' scores)' AS EventName FROM NationalEvents E LEFT JOIN ConferenceMemberEvents ME ON ME.ConferenceID=@ConferenceID AND E.EventID=ME.EventID WHERE isInactive=0 AND EventType <> 'N' AND E.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID) GROUP BY E.EventID,EventName ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sqlEventScoresMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT M.MemberID,Name=M.LastName + ', ' + M.FirstName,TeamName=ISNULL(ME.TeamName, '(Individual)'),C.ChapterName,Place,ObjectiveScore,ObjectiveWeight=ISNULL(ObjectiveWeight,0),OnlineTestScore=ISNULL(OnlineTestScore,0),ObjectiveElapsedTime,PerformanceScore,PerformanceWeight=ISNULL(PerformanceWeight,0),NoPerformance=ISNULL(EE.EventID,0),OnlineJudgeScore=ISNULL(OnlineJudgeScore,0)/100.0,HomesiteScore,HomesiteWeight=ISNULL(HomesiteWeight,0),Score=-1*(ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+ISNULL(PerformanceScore,0)*ISNULL(PerformanceWeight,0)+ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0)) FROM ConferenceMemberEvents ME INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID INNER JOIN Chapters C ON M.ChapterID=C.ChapterID INNER JOIN NationalEvents E ON ME.EventID=E.EventID LEFT JOIN ExcludedPerformances EE ON ME.ConferenceID=EE.ConferenceID AND ME.EventID=EE.EventID WHERE ME.ConferenceID=@ConferenceID AND ME.EventID=@EventID ORDER BY C.ChapterName,ISNULL(ME.TeamName, ''),M.LastName,M.FirstName"
        UpdateCommand="UPDATE ConferenceMemberEvents SET ObjectiveScore=@ObjectiveScore,PerformanceScore=@PerformanceScore,HomesiteScore=@HomesiteScore WHERE ConferenceID=@ConferenceID AND EventID=@EventID AND MemberID=@MemberID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:Parameter Name="ObjectiveScore" Type="Int32" />
            <asp:Parameter Name="PerformanceScore" Type="Int32" />
            <asp:Parameter Name="HomesiteScore" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>