<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Conference.aspx.cs" Inherits="FBLA_Conference_System.Maint_Conference" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conferences</h2></td><td style="padding-left:20px">
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
            &nbsp;<asp:Button ID="btnAddConference" runat="server" Text=" Add " onclick="btnAddConference_Click" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <br />
    <asp:TabContainer ID="tabsConference" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabDetails" runat="server" HeaderText="Conference Details"><ContentTemplate>
            <asp:UpdatePanel ID="updfvConference" runat="server"><ContentTemplate>
                <asp:FormView ID="fvConference" runat="server" ForeColor="#333333" DataSourceID="sqlConferenceMaint" DataKeyNames="ConferenceID"
                    OnItemInserting="fvConference_ItemInserting" OnItemUpdating="fvConference_ItemUpdating" OnDataBound="fvConference_DataBound">
                    <EmptyDataTemplate>
                        <div style="padding-top:20px"><b><i>There are currently no conferences defined.</i></b></div>
                    </EmptyDataTemplate>
                    <EditItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="550px" />
                            <tr><td>Conference Name:</td><td>
                                <asp:TextBox ID="EditConferenceName" runat="server" Text='<%# Bind("ConferenceName") %>' Width="400px" /> 
                                <asp:MaskedEditExtender ID="maskEditConferenceName" runat="server"
                                    TargetControlID="EditConferenceName" Mask="?{55}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditConferenceName" runat="server" ValidationGroup="vgrpEditConference" ForeColor="Red"
                                    ControlToValidate="EditConferenceName" ControlExtender="maskEditConferenceName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a name." />
                            </td></tr>
                            <tr class="altrow"><td>Conference Date:</td><td>
                                <asp:TextBox ID="EditConferenceDate" runat="server" Text='<%# Bind("ConferenceDate","{0:MM/dd/yyyy}") %>' />
                                <img id="imgEditConferenceDate" src="img/cal_icon.png" alt="Select conference date" />
                                <asp:CalendarExtender ID="calEditConferenceDate" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="EditConferenceDate" PopupButtonID="imgEditConferenceDate">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskEditConferenceDate" runat="server"
                                    TargetControlID="EditConferenceDate" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr><td>Registration Starts:</td><td>
                                <asp:TextBox ID="EditRegistrationStart" runat="server" Text='<%# Bind("RegistrationStart","{0:MM/dd/yyyy}") %>' />
                                <img id="imgEditRegistrationStart" src="img/cal_icon.png" alt="Select conference registration start date" />
                                <asp:CalendarExtender ID="calEditRegistrationStart" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="EditRegistrationStart" PopupButtonID="imgEditRegistrationStart">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskEditRegistrationStart" runat="server"
                                    TargetControlID="EditRegistrationStart" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr class="altrow"><td>Registration Ends:</td><td>
                                <asp:TextBox ID="EditRegistrationEnd" runat="server" Text='<%# Bind("RegistrationEnd","{0:MM/dd/yyyy}") %>' />
                                <img id="imgEditRegistrationEnd" src="img/cal_icon.png" alt="Select conference registration end date" />
                                <asp:CalendarExtender ID="calEditRegistrationEnd" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="EditRegistrationEnd" PopupButtonID="imgEditRegistrationEnd">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskEditRegistrationEnd" runat="server"
                                    TargetControlID="EditRegistrationEnd" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr><td>Adviser Fee:</td><td>
                                <asp:TextBox ID="EditAdviserFee" runat="server" Text='<%# Bind("ConferenceAdviserFee") %>'/>
                                <asp:MaskedEditExtender ID="maskEditAdviserFee" runat="server"
                                    TargetControlID="EditAdviserFee" Mask="999\.00" MaskType="Number" DisplayMoney="Left" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditAdviserFee" runat="server" ValidationGroup="vgrpEditConference" ForeColor="Red"
                                    ControlToValidate="EditAdviserFee" ControlExtender="maskEditAdviserFee"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an amount for students' conference fee." />
                            </td></tr>
                            <tr class="altrow"><td>Student Fee:</td><td>
                                <asp:TextBox ID="EditStudentFee" runat="server" Text='<%# Bind("ConferenceStudentFee") %>'/> 
                                <asp:MaskedEditExtender ID="maskEditStudentFee" runat="server"
                                    TargetControlID="EditStudentFee" Mask="999\.00" MaskType="Number" DisplayMoney="Left" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditStudentFee" runat="server" ValidationGroup="vgrpEditConference" ForeColor="Red"
                                    ControlToValidate="EditStudentFee" ControlExtender="maskEditStudentFee"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an amount for students' conference fee." />
                            </td></tr>
                            <tr><td>Closed to non-members:</td><td>
                                <asp:DropDownList ID="ddMembersOnly" runat="server">
                                    <asp:ListItem Value="1" Text="Yes" />
                                    <asp:ListItem Value="0" Text="No" />
                                </asp:DropDownList>
                            </td></tr>
                            <tr class="altrow"><td>Online Tests:</td><td>
                                <asp:DropDownList ID="ddTests" runat="server" DataSourceID="sqlViewRegionalTestsList" DataTextField="Description" DataValueField="RegionalTestsID"
                                    OnDataBound="ddTests_DataBound" />
                            </td></tr>
                            <tr><td>Online Testing Ends:</td><td>
                                <asp:TextBox ID="EditOnlineTestingEnd" runat="server" Text='<%# Bind("OnlineTestingEnd","{0:MM/dd/yyyy}") %>' />
                                <img id="imgEditOnlineTestingEnd" src="img/cal_icon.png" alt="Select online testing end date" />
                                <asp:CalendarExtender ID="calEditOnlineTestingEnd" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="EditOnlineTestingEnd" PopupButtonID="imgEditOnlineTestingEnd">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskEditOnlineTestingEnd" runat="server"
                                    TargetControlID="EditOnlineTestingEnd" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr class="altrow"><td>Perf Testing Start:</td><td>
                                <asp:TextBox ID="EditPerfTestingStart" runat="server" Text='<%# Bind("PerfTestingStart","{0:h:mm tt}") %>'/> (hh:mm AM/PM)
                            </td></tr>
                            <tr><td>Perf Testing End:</td><td>
                                <asp:TextBox ID="EditPerfTestingEnd" runat="server" Text='<%# Bind("PerfTestingEnd","{0:h:mm tt}") %>'/> (hh:mm AM/PM)
                            </td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" ValidationGroup="vgrpEditConference" CausesValidation="True" CommandName="Update" Text="Update" />
                            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="550px" />
                            <tr class="altrow"><td>Conference Level:</td><td>
                                <asp:DropDownList ID="ddConferenceLevel" runat="server">
                                    <asp:ListItem Value="Regional"/>
                                </asp:DropDownList>
                            </td></tr>
                            <tr><td>Conference Name:</td><td>
                                <asp:TextBox ID="InsertConferenceName" runat="server" Text='<%# Bind("ConferenceName") %>' Width="400px" /> 
                                <asp:MaskedEditExtender ID="maskInsertConferenceName" runat="server"
                                    TargetControlID="InsertConferenceName" Mask="?{55}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertConferenceName" runat="server" ValidationGroup="vgrpInsertConference" ForeColor="Red"
                                    ControlToValidate="InsertConferenceName" ControlExtender="maskInsertConferenceName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a name." />
                            </td></tr>
                            <tr class="altrow"><td>Conference Date:</td><td>
                                <asp:TextBox ID="InsertConferenceDate" runat="server" Text='<%# Bind("ConferenceDate","{0:MM/dd/yyyy}") %>' />
                                <img id="imgInsertConferenceDate" src="img/cal_icon.png" alt="Select conference date" />
                                <asp:CalendarExtender ID="calInsertConferenceDate" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="InsertConferenceDate" PopupButtonID="imgInsertConferenceDate">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskInsertConferenceDate" runat="server"
                                    TargetControlID="InsertConferenceDate" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr><td>Registration Starts:</td><td>
                                <asp:TextBox ID="InsertRegistrationStart" runat="server" Text='<%# Bind("RegistrationStart","{0:MM/dd/yyyy}") %>' />
                                <img id="imgInsertRegistrationStart" src="img/cal_icon.png" alt="Select conference registration start date" />
                                <asp:CalendarExtender ID="calInsertRegistrationStart" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="InsertRegistrationStart" PopupButtonID="imgInsertRegistrationStart">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskInsertRegistrationStart" runat="server"
                                    TargetControlID="InsertRegistrationStart" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr class="altrow"><td>Registration Ends:</td><td>
                                <asp:TextBox ID="InsertRegistrationEnd" runat="server" Text='<%# Bind("RegistrationEnd","{0:MM/dd/yyyy}") %>' />
                                <img id="imgInsertRegistrationEnd" src="img/cal_icon.png" alt="Select conference registration end date" />
                                <asp:CalendarExtender ID="calInsertRegistrationEnd" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="InsertRegistrationEnd" PopupButtonID="imgInsertRegistrationEnd">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskInsertRegistrationEnd" runat="server"
                                    TargetControlID="InsertRegistrationEnd" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr><td>Adviser Fee:</td><td>
                                <asp:TextBox ID="InsertAdviserFee" runat="server" Text='<%# Bind("ConferenceAdviserFee") %>'/> 
                                <asp:MaskedEditExtender ID="maskInsertAdviserFee" runat="server"
                                    TargetControlID="InsertAdviserFee" Mask="999\.00" MaskType="Number" DisplayMoney="Left" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertAdviserFee" runat="server" ValidationGroup="vgrpInsertConference" ForeColor="Red"
                                    ControlToValidate="InsertAdviserFee" ControlExtender="maskInsertAdviserFee"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an amount for students' conference fee." />
                            </td></tr>
                            <tr class="altrow"><td>Student Fee:</td><td>
                                <asp:TextBox ID="InsertStudentFee" runat="server" Text='<%# Bind("ConferenceStudentFee") %>'/> 
                                <asp:MaskedEditExtender ID="maskInsertStudentFee" runat="server"
                                    TargetControlID="InsertStudentFee" Mask="999\.00" MaskType="Number" DisplayMoney="Left" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertStudentFee" runat="server" ValidationGroup="vgrpInsertConference" ForeColor="Red"
                                    ControlToValidate="InsertStudentFee" ControlExtender="maskInsertStudentFee"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an amount for students' conference fee." />
                            </td></tr>
                            <tr><td>Closed to non-members:</td><td>
                                <asp:DropDownList ID="ddMembersOnly" runat="server">
                                    <asp:ListItem Value="1" Text="Yes" />
                                    <asp:ListItem Value="0" Text="No" />
                                </asp:DropDownList>
                            </td></tr>
                            <tr class="altrow"><td>Online Tests:</td><td>
                                <asp:DropDownList ID="ddTests" runat="server" DataSourceID="sqlViewRegionalTestsList" DataTextField="Description" DataValueField="RegionalTestsID"
                                    OnDataBound="ddTests_DataBound" />
                            </td></tr>
                            <tr><td>Online Testing Ends:</td><td>
                                <asp:TextBox ID="InsertOnlineTestingEnd" runat="server" Text='<%# Bind("OnlineTestingEnd","{0:MM/dd/yyyy}") %>' />
                                <img id="imgInsertOnlineTestingEnd" src="img/cal_icon.png" alt="Select online testing end date" />
                                <asp:CalendarExtender ID="calInsertOnlineTestingEnd" runat="server" CssClass="GrayCalendar" PopupPosition="BottomLeft"
                                    TargetControlID="InsertOnlineTestingEnd" PopupButtonID="imgInsertOnlineTestingEnd">
                                </asp:CalendarExtender>
                                <asp:MaskedEditExtender ID="maskInsertOnlineTestingEnd" runat="server"
                                    TargetControlID="InsertOnlineTestingEnd" Mask="99/99/9999" MaskType="Date" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                            </td></tr>
                            <tr class="altrow"><td>Perf Testing Start:</td><td>
                                <asp:TextBox ID="InsertPerfTestingStart" runat="server" Text='<%# Bind("PerfTestingStart") %>'/> (hh:mm AM/PM)
                            </td></tr>
                            <tr><td>Perf Testing End:</td><td>
                                <asp:TextBox ID="InsertPerfTestingEnd" runat="server" Text='<%# Bind("PerfTestingEnd") %>'/> (hh:mm AM/PM)
                            </td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="InsertButton" runat="server" ValidationGroup="vgrpInsertConference" CausesValidation="True" CommandName="Insert" Text="Insert" />
                            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <tr><td style="width:175px">Conference Level:</td><td class="data" style="width:550px"><%# Eval("ConferenceLevel") %></td></tr>
                            <tr class="altrow"><td>Conference Name:</td><td class="data"><%# Eval("ConferenceName") %></td></tr>
                            <tr><td>Conference Date:</td><td class="data"><%# Eval("ConferenceDate", "{0:M/d/yyyy}")%></td></tr>
                            <tr class="altrow"><td>Registration Starts:</td><td class="data"><%# Eval("RegistrationStart", "{0:M/d/yyyy}")%></td></tr>
                            <tr><td>Registration Ends:</td><td class="data"><%# Eval("RegistrationEnd","{0:M/d/yyyy}")%></td></tr>
                            <tr class="altrow"><td>Adviser Fee:</td><td class="data"><%# Eval("ConferenceAdviserFee", "{0:C}")%></td></tr>
                            <tr><td>Student Fee:</td><td class="data"><%# Eval("ConferenceStudentFee", "{0:C}")%></td></tr>
                            <tr class="altrow"><td>Closed to non-members:</td><td class="data"><%# ((int)Eval("isMembersOnly")==1)? "Yes" : "No" %></td></tr>
                            <tr><td>Online Tests:</td><td class="data"><%# Eval("Description", "{0:C}")%></td></tr>
                            <tr class="altrow"><td>Online Testing Ends:</td><td class="data"><%# Eval("OnlineTestingEnd", "{0:M/d/yyyy}")%></td></tr>
                            <tr>
                                <td>Perf Testing Start:</td>
                                <td class="data">
                                    <%# Eval("PerfTestingStart", "{0:h:mm tt}")%>
                                    <div style="float:right;font-weight:normal">
                                        <asp:HyperLink ID="lnkSchedMatrix" runat="server" Target="_blank" NavigateUrl="~/PerfSched-Events.aspx?layout=m" Visible="false">Scheduling Matrix</asp:HyperLink>
                                        <asp:HyperLink ID="lnkStationSched" runat="server" Target="_blank" NavigateUrl="~/PerfSched-Events.aspx?layout=s" Visible="false">Station Schedules</asp:HyperLink>
                                        <asp:Label ID="lblSchedNote" runat="server" Text="Enter start and end times to see schedules" ForeColor="blue" />
                                    </div>
                                </td>

                            </tr>
                            <tr class="altrow"><td>Perf Testing End:</td><td class="data"><%# Eval("PerfTestingEnd", "{0:h:mm tt}")%></td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"/>
                            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                OnClientClick="javascript:return confirm('Are you sure you want to delete this conference?')"/>
                        </div>
                    </ItemTemplate>
                    <RowStyle BackColor="#BBBBBB" ForeColor="#222222" />
                </asp:FormView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabPackages" runat="server" HeaderText="Hotel Packages"><ContentTemplate>
            <asp:UpdatePanel ID="updPackages" runat="server"><ContentTemplate>
                <asp:GridView ID="gvHotelPackageMaint" runat="server" DataSourceID="sqlHotelPackageMaint" DataKeyNames="HotelPackageID"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="True"
                    onrowcommand="gvHotelPackageMaint_RowCommand"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;width:100%"><b><i>This conference currently has no hotel packages defined.</i></b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField ShowHeader="False" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <br />&nbsp;<asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Add" Font-Bold="false"
                                    CausesValidation="True" ValidationGroup="vgrpInsertHotelPackage"/>
                            </HeaderTemplate>
                            <ItemTemplate>
                                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Remove"
                                    OnClientClick="javascript:return confirm('Are you sure you want to remove this package?')"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div>Package Description</div><asp:TextBox ID="InsertHotelPackageDesc" runat="server" Width="450px"/>
                                <asp:MaskedEditExtender ID="maskInsertHotelPackageDesc" runat="server"
                                    TargetControlID="InsertHotelPackageDesc" Mask="?{75}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertHotelPackageDesc" runat="server" ValidationGroup="vgrpInsertHotelPackage" ForeColor="Red" Font-Bold="false"
                                    ControlToValidate="InsertHotelPackageDesc" ControlExtender="maskInsertHotelPackageDesc"
                                    IsValidEmpty="false" EmptyValueBlurredText="<br>Please enter a description for the hotel package." />
                            </HeaderTemplate>
                            <ItemTemplate>
                                &nbsp;<asp:Label ID="HotelPackageDesc" runat="server" Text='<%# Eval("PackageDesc") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div>Price</div><asp:TextBox ID="InsertHotelPackagePrice" runat="server" Width="100px"/>
                                <asp:MaskedEditExtender ID="maskInsertHotelPackagePrice" runat="server"
                                    TargetControlID="InsertHotelPackagePrice" Mask="9,999.99" MaskType="Number" InputDirection="RightToLeft"
                                    DisplayMoney="Left" AcceptNegative="None" ClearMaskOnLostFocus="true" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertHotelPackageCell" runat="server" ValidationGroup="vgrpInsertHotelPackage" ForeColor="Red" Font-Bold="false"
                                    ControlToValidate="InsertHotelPackagePrice" ControlExtender="maskInsertHotelPackagePrice"
                                    MinimumValue="1" MaximumValue="9999" InvalidValueBlurredMessage="<br>Please enter a valid price."
                                    IsValidEmpty="false" EmptyValueBlurredText="<br>Please enter a valid price." />
                            </HeaderTemplate>
                            <ItemTemplate>
                                &nbsp;<asp:Label ID="HotelPackagePrice" runat="server" Text='<%# Eval("PackagePrice", "{0:C}") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#BBBBBB" VerticalAlign="Top" />
                    <RowStyle BackColor="White" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#284775" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
    </asp:TabContainer>

    <br /><br />
    <asp:UpdatePanel ID="updExcluded" runat="server"><ContentTemplate>
        <asp:TabContainer ID="tabsExcluded" runat="server" CssClass="gray">
            <asp:TabPanel ID="tabExcludedEvents" runat="server" HeaderText="Excluded Events"><ContentTemplate>
                <asp:GridView ID="gvExcludedEventsMaint" runat="server" DataSourceID="sqlExcludedEventsMaint" DataKeyNames="ConferenceID,EventID"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="true" Width="742px"
                    onrowcommand="gvExcludedEventsMaint_RowCommand"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;width:100%"><b><i>There are currently no excluded events for this conference.</i></b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField ShowHeader="False" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div style="height:52px">
                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="False" CommandName="Insert" Text="Exclude Event:" Font-Bold="false"/>
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Don't Exclude"
                                    OnClientClick="javascript:return confirm('Are you sure you want to stop excluding this event from the conference?')"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div style="height:54px">
                                    <asp:DropDownList ID="ddEventList" runat="server" DataSourceID="sqlEventList" DataTextField="EventName" DataValueField="EventID" />
                                    <br /><br />
                                    Currently Excluded Events
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div style="width:100%"><asp:Label ID="ViewEventName" runat="server" Text='<%# Eval("EventName") %>'/></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#BBBBBB" />
                    <RowStyle BackColor="White" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#284775" />
                </asp:GridView>
                <asp:GridView ID="gvExcludedEventsDisplay" runat="server" DataSourceID="sqlExcludedEventsMaint" Visible="false"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="true"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;width:100%"><b><i>There are currently no excluded events for this conference.</i></b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField HeaderText="Excluded Events for this Conference" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <div style="width:100%"><asp:Label ID="ViewEventName" runat="server" Text='<%# Eval("EventName") %>'/></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#BBBBBB" ForeColor="#284775" />
                    <RowStyle BackColor="White" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#333333" />
                </asp:GridView>
            </ContentTemplate></asp:TabPanel>
            <asp:TabPanel ID="tabExcludedPerfs" runat="server" HeaderText="Excluded Performances"><ContentTemplate>
                <asp:GridView ID="gvExcludedPerfsMaint" runat="server" DataSourceID="sqlExcludedPerfsMaint" DataKeyNames="ConferenceID,EventID"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="true" Width="742px"
                    onrowcommand="gvExcludedPerfsMaint_RowCommand"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;width:100%"><b><i>There are currently no excluded performances for this conference.</i></b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField ShowHeader="False" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div style="height:52px">
                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="False" CommandName="Insert" Text="Exclude Performance:" Font-Bold="false"/>
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Don't Exclude"
                                    OnClientClick="javascript:return confirm('Are you sure you want to stop excluding this performance from the conference?')"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <HeaderTemplate>
                                <div style="height:54px">
                                    <asp:DropDownList ID="ddPerfEventList" runat="server" DataSourceID="sqlPerfEventList" DataTextField="EventName" DataValueField="EventID" />
                                    <br /><br />
                                    Currently Excluded Performances
                                </div>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div style="width:100%"><asp:Label ID="ViewEventName" runat="server" Text='<%# Eval("EventName") %>'/></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#BBBBBB" />
                    <RowStyle BackColor="White" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#284775" />
                </asp:GridView>
                <asp:GridView ID="gvExcludedPerfsDisplay" runat="server" DataSourceID="sqlExcludedPerfsMaint" Visible="false"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="true"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;width:100%"><b><i>There are currently no excluded performances for this conference.</i></b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField HeaderText="Excluded Events for this Conference" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <div style="width:100%"><asp:Label ID="ViewEventName" runat="server" Text='<%# Eval("EventName") %>'/></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#BBBBBB" ForeColor="#284775" />
                    <RowStyle BackColor="White" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#333333" />
                </asp:GridView>
            </ContentTemplate></asp:TabPanel>
        </asp:TabContainer>
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
        SelectCommand="SELECT ConferenceID, ConferenceName, isMembersOnly FROM Conferences WHERE ((StateID = @StateID OR StateID = 0) AND (RegionID = @RegionID OR RegionID = 0)) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlConferenceMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT C.*, ISNULL(T.Description,'n/a') AS Description, CASE WHEN C.StateID = 0 THEN 'Nationals' ELSE CASE WHEN RegionID = 0 THEN 'State' ELSE 'Regionals' END END AS ConferenceLevel FROM Conferences C LEFT JOIN RegionalTests T ON C.RegionalTestsID=T.RegionalTestsID WHERE ConferenceID = @ConferenceID" 
        DeleteCommand="DELETE FROM Conferences WHERE ConferenceID = @ConferenceID" 
        InsertCommand="INSERT INTO Conferences (StateID, RegionID, ConferenceName, ConferenceDate, RegistrationStart, RegistrationEnd, ConferenceAdviserFee, ConferenceStudentFee, isMembersOnly, RegionalTestsID, PerfTestingStart, PerfTestingEnd, OnlineTestingEnd) VALUES (@StateID, @RegionID, @ConferenceName, @ConferenceDate, @RegistrationStart, @RegistrationEnd, @ConferenceAdviserFee, @ConferenceStudentFee, @isMembersOnly, @RegionalTestsID, @PerfTestingStart, @PerfTestingEnd, @OnlineTestingEnd); SELECT @ConferenceID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE Conferences SET ConferenceName = @ConferenceName, ConferenceDate = @ConferenceDate, RegistrationStart = @RegistrationStart, RegistrationEnd = @RegistrationEnd, ConferenceAdviserFee = @ConferenceAdviserFee, ConferenceStudentFee = @ConferenceStudentFee, isMembersOnly = @isMembersOnly, RegionalTestsID = @RegionalTestsID, PerfTestingStart=@PerfTestingStart, PerfTestingEnd=@PerfTestingEnd, OnlineTestingEnd=@OnlineTestingEnd WHERE ConferenceID = @ConferenceID"
        oninserted="sqlConferenceMaint_Inserted" ondeleted="sqlConferenceMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="StateID" Type="Int32" />
            <asp:Parameter Name="RegionID" Type="Int32" />
            <asp:Parameter Name="ConferenceName" Type="String" />
            <asp:Parameter Name="ConferenceDate" Type="DateTime" />
            <asp:Parameter Name="RegistrationStart" Type="DateTime" />
            <asp:Parameter Name="RegistrationEnd" Type="DateTime" />
            <asp:Parameter Name="ConferenceAdviserFee" Type="Int32" />
            <asp:Parameter Name="ConferenceStudentFee" Type="Int32" />
            <asp:Parameter Name="isMembersOnly" Type="Int32" />
            <asp:Parameter Name="RegionalTestsID" Type="Int32" />
            <asp:Parameter Name="PerfTestingStart" Type="DateTime" />
            <asp:Parameter Name="PerfTestingEnd" Type="DateTime" />
            <asp:Parameter Name="OnlineTestingEnd" Type="DateTime" />
            <asp:Parameter Name="ConferenceID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="ConferenceName" Type="String" />
            <asp:Parameter Name="ConferenceDate" Type="DateTime" />
            <asp:Parameter Name="RegistrationStart" Type="DateTime" />
            <asp:Parameter Name="RegistrationEnd" Type="DateTime" />
            <asp:Parameter Name="ConferenceAdviserFee" Type="Int32" />
            <asp:Parameter Name="ConferenceStudentFee" Type="Int32" />
            <asp:Parameter Name="isMembersOnly" Type="Int32" />
            <asp:Parameter Name="RegionalTestsID" Type="Int32" />
            <asp:Parameter Name="PerfTestingStart" Type="DateTime" />
            <asp:Parameter Name="PerfTestingEnd" Type="DateTime" />
            <asp:Parameter Name="OnlineTestingEnd" Type="DateTime" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionalTestsList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM (SELECT RegionalTestsID=NULL, Description='n/a' UNION SELECT RegionalTestsID, Description FROM RegionalTests WHERE StateID = @StateID OR StateID = 0) U ORDER BY Description DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID, EventName FROM NationalEvents WHERE isInactive=0 AND EventType <> 'N' AND EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID = @ConferenceID) ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlExcludedEventsMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT NE.EventName, EE.ConferenceID, EE.EventID FROM ExcludedEvents AS EE INNER JOIN NationalEvents AS NE ON EE.EventID = NE.EventID WHERE (EE.ConferenceID = @ConferenceID) ORDER BY NE.EventName"
        DeleteCommand="DELETE FROM ExcludedEvents WHERE ConferenceID = @ConferenceID AND EventID = @EventID" 
        InsertCommand="INSERT INTO ExcludedEvents (ConferenceID, EventID) VALUES (@ConferenceID, @EventID)"
        OnInserted="sqlExcluded_Inserted">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPerfEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID, EventName FROM NationalEvents WHERE isInactive=0 AND (ISNULL(PerformanceWeight,0)<>0 AND (ISNULL(ObjectiveWeight,0)<>0 OR ISNULL(HomesiteWeight,0)<>0)) AND EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=@ConferenceID) AND EventID NOT IN (SELECT EventID FROM ExcludedPerformances WHERE ConferenceID=@ConferenceID) ORDER BY EventName">
        <SelectParameters>
            <asp:ControlParameter Name="ConferenceID" ControlID="ddConferences" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlExcludedPerfsMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT NE.EventName, EE.ConferenceID, EE.EventID FROM ExcludedPerformances AS EE INNER JOIN NationalEvents AS NE ON EE.EventID=NE.EventID WHERE EE.ConferenceID=@ConferenceID ORDER BY NE.EventName"
        DeleteCommand="DELETE FROM ExcludedPerformances WHERE ConferenceID=@ConferenceID AND EventID=@EventID" 
        InsertCommand="INSERT INTO ExcludedPerformances (ConferenceID, EventID) VALUES (@ConferenceID, @EventID)"
        OnInserted="sqlExcluded_Inserted">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlHotelPackageMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM ConferenceHotelPackages WHERE ConferenceID=@ConferenceID ORDER BY PackageDesc"
        InsertCommand="INSERT INTO ConferenceHotelPackages (ConferenceID, PackageDesc, PackagePrice) VALUES (@ConferenceID, @PackageDesc, @PackagePrice)"
        DeleteCommand="DELETE FROM ConferenceHotelPackages WHERE HotelPackageID=@HotelPackageID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="HotelPackageID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="PackageDesc" Type="String" />
            <asp:Parameter Name="PackagePrice" Type="Double" />
        </InsertParameters>
    </asp:SqlDataSource>

</asp:Content>
