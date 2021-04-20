<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Event-SignUp.aspx.cs" Inherits="FBLA_Conference_System.Event_SignUp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Event Sign-Up</h2></td><td style="padding-left:20px">
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

    <asp:UpdatePanel ID="updStudentEvents" runat="server"><ContentTemplate>
        <asp:Panel ID="pnlAssignStudentEvents" runat="server">
            <h3>Student Event Assignments</h3>
            <table style="border:1px solid #999" cellpadding="6px">
                <col width="115px" /><col width="415px" /><col width="100px" />
                <tr valign="top"><td align="right">Student Name:<br />Sign-Ups:</td><td colspan="2">
                    <asp:DropDownList ID="ddStudents" runat="server" AutoPostBack="true" 
                        DataSourceID="sqlStudentList" DataTextField="Name" DataValueField="MemberID" 
                        OnDataBound="ddStudents_DataBound" Width="400px" />
                    <br /># of events total (max
                      <asp:Literal runat="server" Text="<%$ AppSettings:MaxEventsPerStudent %>" />):
                      <asp:Label ID="lblNumTotalEvents" runat="server" Text="-0-" Font-Bold="true" />
                    <br /># of performance events (max
                      <asp:Literal runat="server" Text="<%$ AppSettings:MaxPerfEventsPerStudent %>" />): 
                      <asp:Label ID="lblNumPerfEvents" runat="server" Text="-0-" Font-Bold="true" />
                </td></tr>
                <tr><td align="right">Event:<br />Team:</td><td>
                    <asp:DropDownList ID="ddEvents" runat="server" AutoPostBack="true" Width="400px"
                        DataSourceID="sqlStudentEventList" DataTextField="EventName" DataValueField="EventID"
                        ondatabound="ddEvents_DataBound" onselectedindexchanged="ddEvents_SelectedIndexChanged" />
                    <br />
                    <asp:DropDownList ID="ddTeamNames" runat="server" Width="400px" />
                </td><td valign="top">
                    <asp:Button ID="btnAddStudentEvent" runat="server" 
                        onclick="btnAddStudentEvent_Click" Text=" Add " />
                </td></tr>
                <tr valign="top"><td align="right">Selected Events:</td><td>
                    <asp:ListBox ID="lstSelectedStudentEvents" runat="server" Rows="10" Width="400px"
                        DataSourceID="sqlStudentEventMaint" DataTextField="Name" DataValueField="EventID"
                        OnDataBound="lstSelectedStudentEvents_DataBound" />
                </td><td>
                    <asp:Button ID="btnRemoveStudentEvent" runat="server" Text=" Remove " onclick="btnRemoveStudentEvent_Click" 
                        OnClientClick="javascript:return confirm('Are you sure you don\'t want to sign-up for this event?')" />
                </td></tr>
            </table>
        </asp:Panel>
    </ContentTemplate></asp:UpdatePanel>

    <asp:UpdatePanel ID="updChapterEvents" runat="server"><ContentTemplate>
        <asp:Panel ID="pnlAssignChapterEvents" runat="server">
            <h3>Chapter Event Assignments</h3>
            <table style="border:1px solid #999" cellpadding="6px">
                <col width="115px" /><col width="415px" /><col width="100px" />
                <tr><td align="right">Chapter Representative:</td><td colspan="2">
                    <asp:DropDownList ID="ddChapterStudents" runat="server" AutoPostBack="true" Width="400px"
                        DataSourceID="sqlStudentList" DataValueField="MemberID"  DataTextField="Name" OnDataBound="ddChapterStudents_DataBound"/>
                </td></tr>
                <tr><td align="right">Event:</td><td>
                    <asp:DropDownList ID="ddChapterEvents" runat="server" Width="400px" DataSourceID="sqlChapterEventList" DataValueField="EventID"  DataTextField="EventName"/>
                </td><td valign="top">
                    <asp:Button ID="btnAddChapterEvent" runat="server" Text=" Add " onclick="btnAddChapterEvent_Click" />
                </td></tr>
                <tr valign="top"><td align="right">Selected Events:</td><td>
                    <asp:ListBox ID="lstSelectedChapterEvents" runat="server" Width="400px" Rows="5"
                        DataSourceID="sqlChapterEventMaint" DataTextField="EventName" DataValueField="EventID" OnDataBound="lstSelectedChapterEvents_DataBound" />
                </td><td>
                    <asp:Button ID="btnRemoveChapterEvent" runat="server" Text=" Remove " onclick="btnRemoveChapterEvent_Click"
                        OnClientClick="javascript:return confirm('Are you sure you don\'t want to sign-up for this event?')"/>
                </td></tr>
            </table>
        </asp:Panel>
    </ContentTemplate></asp:UpdatePanel>

    <asp:UpdatePanel ID="updfvStudent" runat="server"><ContentTemplate>
        <asp:Panel ID="pnlAddStudent" runat="server" Visible="false">
            <h3>Add a Student</h3>
            <asp:FormView ID="fvStudent" runat="server" ForeColor="#333333" 
                DataSourceID="sqlStudentList" DataKeyNames="MemberID" DefaultMode="Insert" 
                oniteminserting="fvStudent_ItemInserting" 
                ondatabound="fvStudent_DataBound">
                <InsertItemTemplate>
                    <table cellpadding="4" cellspacing="0" style="background-color:White">
                        <col width="175px" /><col width="480px" />
                        <tr><td>First Name:</td><td>
                            <asp:TextBox ID="InsertFirstName" runat="server" Text='<%# Bind("FirstName") %>' Width="300px"/>
                            <asp:MaskedEditExtender ID="maskInsertFirstName" runat="server"
                                TargetControlID="InsertFirstName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            <asp:MaskedEditValidator ID="vldInsertFirstName" runat="server" ValidationGroup="vgrpInsertStudent" ForeColor="Red"
                                ControlToValidate="InsertFirstName" ControlExtender="maskInsertFirstName"
                                IsValidEmpty="false" EmptyValueBlurredText="Please enter a first name."/>
                        </td></tr>
                        <tr class="altrow"><td>Last Name:</td><td>
                            <asp:TextBox ID="InsertLastName" runat="server" Text='<%# Bind("LastName") %>' Width="300px"/>
                            <asp:MaskedEditExtender ID="maskInsertLastName" runat="server"
                                TargetControlID="InsertLastName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            <asp:MaskedEditValidator ID="vldInsertLastName" runat="server" ValidationGroup="vgrpInsertStudent" ForeColor="Red"
                                ControlToValidate="InsertLastName" ControlExtender="maskInsertLastName"
                                IsValidEmpty="false" EmptyValueBlurredText="Please enter a last name."/>
                        </td></tr>
                        <tr><td>Graduating Class:</td><td>
                            <asp:DropDownList ID="ddGraduatingClass" runat="server"  Width="150px"/>
                        </td></tr>
                        <tr class="altrow"><td>Gender:</td><td>
                            <asp:DropDownList ID="ddGender" runat="server" Width="150px">
                                <asp:ListItem Value="M" Text="Male" />
                                <asp:ListItem Value="F" Text="Female" />
                            </asp:DropDownList>
                        </td></tr>
                        <tr><td>T-shirt Size:</td><td>
                            <asp:DropDownList ID="ddShirtSize" runat="server" Width="150px">
                                <asp:ListItem Value="" Text="<Blank>" />
                                <asp:ListItem Value="XS" Text="X-Small" />
                                <asp:ListItem Value="S" Text="Small" />
                                <asp:ListItem Value="M" Text="Medium" />
                                <asp:ListItem Value="L" Text="Large" />
                                <asp:ListItem Value="XL" Text="X-Large" />
                                <asp:ListItem Value="2X" Text="XXL" />
                                <asp:ListItem Value="3X" Text="XXXL" />
                            </asp:DropDownList>
                        </td></tr>
                        <tr class="altrow"><td>Position:</td><td>
                            <asp:DropDownList ID="ddPosition" runat="server" Width="150px">
                                <asp:ListItem Value="None"/>
                                <asp:ListItem Value="President"/>
                                <asp:ListItem Value="Vice President"/>
                                <asp:ListItem Value="Treasurer"/>
                                <asp:ListItem Value="Secretary"/>
                                <asp:ListItem Value="Parliamentarian"/>
                                <asp:ListItem Value="Historian"/>
                                <asp:ListItem Value="Public Relations"/>
                            </asp:DropDownList>
                        </td></tr>
                    </table>
                    <div style="padding:5px 0">
                        &nbsp;<asp:LinkButton ID="InsertButton" runat="server" ValidationGroup="vgrpInsertStudent" CausesValidation="True" CommandName="Insert" Text="Add" />
                    </div>
                </InsertItemTemplate>
                <RowStyle BackColor="#BBBBBB" ForeColor="#222222" />
            </asp:FormView>
        </asp:Panel>
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
    <asp:SqlDataSource ID="sqlViewChapterList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ChapterID, ChapterName FROM Chapters WHERE (RegionID = @RegionID) ORDER BY ChapterName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewConferenceList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE (StateID = @StateID OR StateID = 0) AND (RegionID = @RegionID OR RegionID = 0) AND RegistrationStart <= CONVERT(date, GETDATE()+(@TZO/1440.0)) AND RegistrationEnd >= CONVERT(date, GETDATE()+(@TZO/1440.0)) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="TZO" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlStudentList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="-- Property set in code behind"
        InsertCommand="INSERT INTO NationalMembers (ChapterID, FirstName, LastName, Gender, ShirtSize, GraduatingClass, ChapterPosition, isPaid) VALUES (@ChapterID, LTRIM(RTRIM(@FirstName)), LTRIM(RTRIM(@LastName)), @Gender, @ShirtSize, @GraduatingClass, @ChapterPosition, @isPaid); SELECT @MemberID = SCOPE_IDENTITY()" 
        DeleteCommand="DELETE FROM NationalMembers WHERE MemberID=@MemberID"
        oninserted="sqlStudentList_Inserted">
        <InsertParameters>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Gender" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="GraduatingClass" Type="Int32" />
            <asp:Parameter Name="ChapterPosition" Type="String" />
            <asp:Parameter Name="isPaid" Type="Int32" DefaultValue="0" />
            <asp:Parameter Name="MemberID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <DeleteParameters>
            <asp:ControlParameter Name="MemberID" ControlID="ddStudents" PropertyName="SelectedValue" Type="Int32"/>
        </DeleteParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStudentEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID,EventName FROM NationalEvents WHERE isInactive=0 AND (SELECT NumEventsTotal=COUNT(*) FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID=E.EventID WHERE ConferenceID=@ConferenceID AND MemberID=@MemberID)<@MaxEventsPerStudent AND (EventID NOT IN (SELECT EventID FROM NationalEvents WHERE ISNULL(PerformanceWeight,0)<>0 AND (SELECT NumPerfEvents=SUM(CASE WHEN ISNULL(E.PerformanceWeight,0)<>0 THEN 1 ELSE 0 END) FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID=E.EventID WHERE ConferenceID=@ConferenceID AND MemberID=@MemberID)>=@MaxPerfEventsPerStudent)) AND (isLowerclassmen=0 OR isLowerclassmen=(SELECT CASE WHEN GraduatingClass>=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+2 THEN 1 ELSE 0 END FROM NationalMembers WHERE MemberID=@MemberID)) AND (isUpperclassmen=0 OR isUpperclassmen=(SELECT CASE WHEN GraduatingClass<=DATEPART(yyyy,GETDATE())+DATEPART(m,GETDATE())/8+1 THEN 1 ELSE 0 END FROM NationalMembers WHERE MemberID=@MemberID)) AND (CASE EventType WHEN 'T' THEN 'I' ELSE EventType END=CASE (SELECT isMembersOnly FROM Conferences WHERE ConferenceID=@ConferenceID) WHEN 0 THEN 'N' ELSE 'I' END) AND (EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID)) AND (EventID NOT IN (SELECT EventID FROM ConferenceMemberEvents WHERE ConferenceID=@ConferenceID AND MemberID=@MemberID)) ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="MemberID" ControlID="ddStudents" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="MaxEventsPerStudent" DefaultValue='<%$ AppSettings:MaxEventsPerStudent %>' />
            <asp:Parameter Name="MaxPerfEventsPerStudent" DefaultValue='<%$ AppSettings:MaxPerfEventsPerStudent %>' />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStudentEventMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT EventID,Name FROM (SELECT SortKey=10,CME.EventID,CASE WHEN E.EventType = 'T' THEN E.EventName+' ('+CME.TeamName+': Min. '+CAST(E.MinTeamSize AS nvarchar)+' members req''d)' ELSE E.EventName END AS Name FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID = E.EventID WHERE E.EventType<>'C' AND CME.ConferenceID=@ConferenceID AND CME.MemberID=@MemberID UNION SELECT DISTINCT SortKey=20,CME.EventID, Name='&nbsp;&nbsp;&nbsp;'+FirstName+' '+LastName FROM ConferenceMemberEvents CME INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName INNER JOIN NationalMembers M ON TEAM.MemberID=M.MemberID WHERE CME.ConferenceID=@ConferenceID AND M.ChapterID=@ChapterID AND CME.MemberID=@MemberID AND CME.TeamName IS NOT NULL) U ORDER BY EventID, SortKey, Name"
        DeleteCommand="DELETE FROM ConferenceMemberEvents WHERE ((ConferenceID = @ConferenceID) AND (MemberID = @MemberID) AND (EventID = @EventID))"
        InsertCommand="INSERT INTO ConferenceMemberEvents (ConferenceID, MemberID, EventID, TeamName) VALUES (@ConferenceID, @MemberID, @EventID, @TeamName)">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="MemberID" ControlID="ddStudents" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="MemberID" ControlID="ddStudents" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="EventID" ControlID="lstSelectedStudentEvents" PropertyName="SelectedValue" Type="Int32" />
        </DeleteParameters>
         <InsertParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="MemberID" ControlID="ddStudents" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="EventID" ControlID="ddEvents" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="TeamName" ControlID="ddTeamNames" PropertyName="SelectedValue" Type="String" />
         </InsertParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlChapterEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID, EventName FROM NationalEvents WHERE isInactive=0 AND EventType='C' AND EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID = @ConferenceID) AND EventID NOT IN (SELECT EventID FROM ConferenceMemberEvents WHERE ConferenceID = @ConferenceID AND EventType = 'C' AND MemberID IN (SELECT MemberID FROM NationalMembers WHERE ChapterID = @ChapterID)) ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChapterEventMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT M.EventID, E.EventName + ' (' + M.TeamName + ')' AS EventName FROM ConferenceMemberEvents M INNER JOIN NationalEvents E ON M.EventID = E.EventID WHERE ((M.ConferenceID = @ConferenceID) AND (E.EventType = 'C') AND (M.MemberID IN (SELECT MemberID FROM NationalMembers WHERE ChapterID = @ChapterID))) ORDER BY E.EventName"
        DeleteCommand="DELETE FROM ConferenceMemberEvents WHERE ((ConferenceID = @ConferenceID) AND (MemberID IN (SELECT MemberID FROM NationalMembers WHERE ChapterID = @ChapterID)) AND (EventID = @EventID))"
        InsertCommand="INSERT INTO ConferenceMemberEvents (ConferenceID, MemberID, EventID, TeamName) VALUES (@ConferenceID, @MemberID, @EventID, @TeamName)">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32"/>
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="EventID" ControlID="lstSelectedChapterEvents" PropertyName="SelectedValue" Type="Int32" />
        </DeleteParameters>
         <InsertParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32"/>
            <asp:ControlParameter Name="MemberID" ControlID="ddChapterStudents" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="EventID" ControlID="ddChapterEvents" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="TeamName" ControlID="ddChapters" PropertyName="SelectedItem.Text" Type="String" />
         </InsertParameters>
    </asp:SqlDataSource>

</asp:Content>
