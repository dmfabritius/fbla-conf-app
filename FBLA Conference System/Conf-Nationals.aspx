<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Conf-Nationals.aspx.cs" Inherits="FBLA_Conference_System.Conf_Nationals" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Nationals Event Participation</h2></td><td style="padding-left:20px">
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

    <asp:TabContainer ID="tabsNationals" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabNationalsSelections" runat="server" HeaderText="Participation Selections"><ContentTemplate>
            <asp:UpdatePanel ID="updgvNationalsSelections" runat="server"><ContentTemplate>
                <asp:GridView ID="gvNationalsSelections" runat="server" DataSourceID="sqlNationalsSelections" DataKeyNames="MemberID,ConferenceID,EventID"
                    ForeColor="#333333" AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" GridLines="None" AllowSorting="True"
                    onrowcommand="gvNationalsSelections_RowCommand" OnRowUpdated="gvNationalsSelections_RowUpdated" OnRowDataBound="gvNationalsSelections_RowDataBound"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:40px;border-top:1px solid black;font-style:italic"><b>This chapter currently currently has no members who have placed at this conference.</b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField ShowHeader="False">
                            <EditItemTemplate><div style="width:100px">
                                <asp:LinkButton ID="NationalsSelectionsUpdateButton" runat="server" ValidationGroup="vgrpEditSelection" CausesValidation="True" CommandName="Update" Text="Update"/>
                                <asp:LinkButton ID="NationalsSelectionsCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"/>
                            </div></EditItemTemplate>
                            <ItemTemplate><div style="width:100px">
                                <asp:LinkButton ID="NationalsSelectionsEditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"/>
                            </div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="First Name" SortExpression="FirstName,LastName,EventName">
                            <EditItemTemplate>
                                <asp:Label ID="EditFirstName" runat="server" Text='<%# Eval("FirstName") %>'/>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="FirstName" runat="server" Text='<%# Eval("FirstName") %>'/>
                             </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Name" SortExpression="LastName,FirstName,EventName">
                            <EditItemTemplate>
                                <asp:Label ID="EditLastName" runat="server" Text='<%# Eval("LastName") %>'/>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LastName" runat="server" Text='<%# Eval("LastName") %>'/>
                             </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Event" SortExpression="EventName,Place">
                            <EditItemTemplate>
                                <asp:Label ID="EditEventName" runat="server" Text='<%# Eval("EventName") %>'/>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="EventName" runat="server" Text='<%# Eval("EventName") %>'/>
                             </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Place" SortExpression="Place,EventName">
                            <EditItemTemplate>
                                <asp:Label ID="EditPlace" runat="server" Text='<%# Eval("Place") %>'/>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Place" runat="server" Text='<%# Eval("Place") %>'/>
                             </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Attending" ItemStyle-HorizontalAlign="Center" SortExpression="isAttendingNationals,FirstName,LastName">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddAttendingNationals" runat="server">
                                    <asp:ListItem Value="1" Text="Yes" />
                                    <asp:ListItem Value="0" Text="No" />
                                    <asp:ListItem Value="-1" Text="-Blank-" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate><asp:Label ID="AttendingNationals" runat="server"
                                Text='<%# ((int)Eval("isAttendingNationals")==-1)? "" : ((int)Eval("isAttendingNationals")==0)? "N" : "Y" %>'/></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Priority" ItemStyle-HorizontalAlign="Center" SortExpression="EventPriority">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddEventPriority" runat="server">
                                    <asp:ListItem Value="0" Text="-Blank-" />
                                    <asp:ListItem Value="1" />
                                    <asp:ListItem Value="2" />
                                    <asp:ListItem Value="3" />
                                    <asp:ListItem Value="4" />
                                    <asp:ListItem Value="5" />
                                    <asp:ListItem Value="6" />
                                    <asp:ListItem Value="7" />
                                    <asp:ListItem Value="8" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate><div style="width:75px"><asp:Label ID="EventPriority" runat="server" Text='<%# ((int)Eval("EventPriority")==0)? "" : Eval("EventPriority") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle BackColor="White"/>
                    <EditRowStyle BackColor="#999999" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#FFFDF8" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabResponseSummary" runat="server" HeaderText="Response Summary"><ContentTemplate>
            <asp:UpdatePanel ID="updResponseSummary" runat="server"><ContentTemplate>
                <asp:GridView ID="gvResponseSummary" runat="server" DataSourceID="SqlResponseSummary" AllowSorting="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" ItemStyle-Width="250px" SortExpression="RegionName,ChapterName" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" ItemStyle-Width="250px" SortExpression="ChapterName" />
                        <asp:BoundField DataField="NumEligible" HeaderText="Total" ItemStyle-Width="75px" SortExpression="NumEligible,RegionName,ChapterName" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="NumNR" HeaderText="No Response" ItemStyle-Width="75px" SortExpression="NumNR,RegionName,ChapterName" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="NumNo" HeaderText="No" ItemStyle-Width="75px" SortExpression="NumNo,RegionName,ChapterName" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="NumYes" HeaderText="Yes" ItemStyle-Width="75px" SortExpression="NumYes,RegionName,ChapterName" ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" VerticalAlign="Bottom" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Left" />
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabSelectionsList" runat="server" HeaderText="Selections List"><ContentTemplate>
            <asp:UpdatePanel ID="updgvSelectionsList" runat="server"><ContentTemplate>
                <asp:GridView ID="gvSelectionsList" runat="server" DataSourceID="sqlSelectionsList" AllowSorting="True"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region" ItemStyle-Width="250px" SortExpression="RegionName,ChapterName,EventName,Place" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter" ItemStyle-Width="250px" SortExpression="ChapterName,EventName,Place" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" ItemStyle-Width="100px" SortExpression="FirstName,LastName,ChapterName" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" ItemStyle-Width="100px" SortExpression="LastName,FirstName,ChapterName" />
                        <asp:BoundField DataField="EventName" HeaderText="Event" ItemStyle-Width="250px" SortExpression="EventName,Place,FirstName,LastName" />
                        <asp:BoundField DataField="Place" HeaderText="Place" ItemStyle-Width="50px"
                            ItemStyle-HorizontalAlign="Center" SortExpression="Place,EventName,FirstName,LastName" />
                        <asp:BoundField DataField="EventPriority" HeaderText="Priority" ItemStyle-Width="50px"
                            ItemStyle-HorizontalAlign="Center" SortExpression="EventPriority,EventName,Place" />
                    </Columns>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" VerticalAlign="Bottom" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Left" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabNationalsAssignments" runat="server" HeaderText="Event Assignments"><ContentTemplate>
            <asp:UpdatePanel ID="updgvNationalsAssignments" runat="server"><ContentTemplate>
                <asp:GridView ID="gvNationalsAssignments" runat="server"
                    CellPadding="4" CellSpacing="1" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" 
                    ondatabinding="gvNationalsAssignments_DataBinding">
                    <Columns>
                        <asp:BoundField DataField="EventName" HeaderText="Event" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="AdviserName" HeaderText="Adviser" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="AdviserEmail" HeaderText="Email" ItemStyle-Width="150px" />
                    </Columns>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" VerticalAlign="Bottom" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
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
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE (StateID=@StateID OR StateID=0) AND RegionID=0 AND ConferenceDate < CONVERT(date, GETDATE()) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlNationalsSelections" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT CME.MemberID, CME.ConferenceID, CME.EventID, M.FirstName, M.LastName, E.EventName, CME.Place, ISNULL(CME.isAttendingNationals,-1) isAttendingNationals, ISNULL(CME.EventPriority,0) EventPriority FROM ConferenceMemberEvents CME INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID INNER JOIN NationalEvents E ON CME.EventID=E.EventID WHERE ISNULL(M.isInactive,0)=0 AND ConferenceID=@ConferenceID AND ChapterID=@ChapterID AND CME.Place IS NOT NULL ORDER BY FirstName, LastName, EventName"
        UpdateCommand="UPDATE ConferenceMemberEvents SET isAttendingNationals=@isAttendingNationals, EventPriority=@EventPriority WHERE MemberID=@MemberID AND ConferenceID=@ConferenceID AND EventID=@EventID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
            <asp:Parameter Name="isAttendingNationals" Type="Int32" />
            <asp:Parameter Name="EventPriority" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlResponseSummary" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT R.RegionName, C.ChapterName, NumEligible=COUNT(*), NumNR=SUM(CASE WHEN ISNULL(CME.isAttendingNationals,-1)=-1 THEN 1 ELSE 0 END), NumNo=SUM(CASE WHEN ISNULL(CME.isAttendingNationals,-1)=0 THEN 1 ELSE 0 END), NumYes=SUM(CASE WHEN ISNULL(CME.isAttendingNationals,-1)=1 THEN 1 ELSE 0 END) FROM ConferenceMemberEvents CME INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID INNER JOIN Chapters C ON M.ChapterID=C.ChapterID INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE ISNULL(M.isInactive,0)=0 AND CME.ConferenceID=@ConferenceID AND CME.Place IS NOT NULL GROUP BY R.RegionName, C.ChapterName ORDER BY R.RegionName, C.ChapterName">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlSelectionsList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionName, ChapterName, FirstName, LastName, EventName, Place, EventPriority FROM ConferenceMemberEvents CME INNER JOIN NationalEvents E ON CME.EventID=E.EventID INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID INNER JOIN Chapters C ON M.ChapterID=C.ChapterID INNER JOIN Regions R ON C.RegionID=R.RegionID WHERE ISNULL(M.isInactive,0)=0 AND CME.ConferenceID=@ConferenceID AND CME.isAttendingNationals=1 AND Place IS NOT NULL AND ISNULL(EventPriority,0)<>0 ORDER BY EventName,Place">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
