<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Chapter.aspx.cs" Inherits="FBLA_Conference_System.Maint_Chapter" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Chapter Maintenance</h2></td><td style="padding-left:20px">
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
    <asp:Panel ID="pnlSelChapter" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <asp:UpdatePanel ID="updddChapters" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select a Chapter:</span>
            <asp:DropDownList ID="ddChapters" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewChapterList" DataTextField="ChapterName" DataValueField="ChapterID" 
                ondatabound="ddChapters_DataBound" onselectedindexchanged="ddChapters_SelectedIndexChanged"/>
            &nbsp;<asp:Button ID="btnAddChapter" runat="server" Text=" Add " onclick="btnAddChapter_Click" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />

    <asp:TabContainer ID="tabsChapterMaint" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabChapter" runat="server" HeaderText="Chapter Info"><ContentTemplate>
            <asp:UpdatePanel ID="updfvChapter" runat="server"><ContentTemplate>
                <asp:FormView ID="fvChapter" runat="server" ForeColor="#333333" DataSourceID="sqlChapterMaint" DataKeyNames="ChapterID"
                    oniteminserting="fvChapter_ItemInserting"
                    onitemupdating="fvChapter_ItemUpdating"
                    ondatabound="fvChapter_DataBound">
                    <EmptyDataTemplate>
                        <div style="padding-top:40px;border-top:1px solid black;font-style:italic"><b>There are currently no chapters for this region.</b></div>
                    </EmptyDataTemplate>
                    <EditItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="550px" />
                            <tr><td>Chapter Name:</td><td>
                                <asp:TextBox ID="EditChapterName" runat="server" Text='<%# Bind("ChapterName") %>' /> 
                                <asp:MaskedEditExtender ID="maskEditChapterName" runat="server"
                                    TargetControlID="EditChapterName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChapterName" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChapterName" ControlExtender="maskEditChapterName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a name for the chapter." />
                            </td></tr>
                            <tr class="altrow"><td>Abbreviation:</td><td>
                                <asp:TextBox ID="EditChapterAbbr" runat="server" Text='<%# Bind("ChapterAbbr") %>' />
                                <asp:MaskedEditExtender ID="maskEditChapterAbbr" runat="server"
                                    TargetControlID="EditChapterAbbr" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChapterAbbr" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChapterAbbr" ControlExtender="maskEditChapterAbbr"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an abbreviation for the chapter." />
                            </td></tr>
                            <tr><td>Address:</td><td>
                                <asp:TextBox ID="EditAddress" runat="server" Text='<%# Bind("Address") %>' />
                                <asp:MaskedEditExtender ID="maskEditAddress" runat="server"
                                    TargetControlID="EditAddress" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditAddress" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditAddress" ControlExtender="maskEditAddress"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the street address." />
                            </td></tr>
                            <tr class="altrow"><td>City:</td><td>
                                <asp:TextBox ID="EditCity" runat="server" Text='<%# Bind("City") %>' />
                                <asp:MaskedEditExtender ID="maskEditCity" runat="server"
                                    TargetControlID="EditCity" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditCity" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditCity" ControlExtender="maskEditCity"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the city." />
                            </td></tr>
                            <tr><td>Zip:</td><td>
                                <asp:TextBox ID="EditZip" runat="server" Text='<%# Bind("Zip") %>' />
                                <asp:MaskedEditExtender ID="maskEditZip" runat="server"
                                    TargetControlID="EditZip" Mask="99999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditZip" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditZip" ControlExtender="maskEditZip"
                                    ValidationExpression="[1-9][0-9]{4}" InvalidValueBlurredMessage="Please enter a valid zip code."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the 5-digit zip code." />
                            </td></tr>
                            <tr class="altrow"><td>National Chapter #:</td><td>
                                <asp:TextBox ID="EditNationalChapterID" runat="server" Text='<%# Bind("NationalChapterID") %>' />
                            </td></tr>
                            <tr><td>Adviser Name:</td><td>
                                <asp:TextBox ID="EditChAdviserName" runat="server" Text='<%# Bind("AdviserName") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserName" runat="server"
                                    TargetControlID="EditChAdviserName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserName" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserName" ControlExtender="maskEditChAdviserName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's name." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Email:</td><td>
                                <asp:TextBox ID="EditChAdviserEmail" runat="server" Text='<%# Bind("AdviserEmail") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserEmail" runat="server"
                                    TargetControlID="EditChAdviserEmail" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserEmail" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserEmail" ControlExtender="maskEditChAdviserEmail"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" InvalidValueBlurredMessage="Please enter a valid e-mail address."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's e-mail." />
                            </td></tr>
                            <tr><td>Adviser Cell:</td><td>
                                <asp:TextBox ID="EditChAdviserCell" runat="server" Text='<%# Bind("AdviserCellPhone") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserCell" runat="server"
                                    TargetControlID="EditChAdviserCell" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserCell" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserCell" ControlExtender="maskEditChAdviserCell"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's cell number." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Classroom #:</td><td>
                                <asp:TextBox ID="EditChAdviserClassroom" runat="server" Text='<%# Bind("AdviserClassroom") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserClassroom" runat="server"
                                    TargetControlID="EditChAdviserClassroom" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserClassroom" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserClassroom" ControlExtender="maskEditChAdviserClassroom"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's classroom number." />
                            </td></tr>
                            <tr><td>Adviser Username:</td><td>
                                <asp:TextBox ID="EditChAdviserUsername" runat="server" Text='<%# Bind("AdviserUsername") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserUsername" runat="server"
                                    TargetControlID="EditChAdviserUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserUsername" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserUsername" ControlExtender="maskEditChAdviserUsername"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the Adviser." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Password:</td><td>
                                <asp:TextBox ID="EditChAdviserPassword" runat="server" Text='<%# Bind("AdviserPassword") %>' />
                                <asp:MaskedEditExtender ID="maskEditChAdviserPassword" runat="server"
                                    TargetControlID="EditChAdviserPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChAdviserPassword" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChAdviserPassword" ControlExtender="maskEditChAdviserPassword"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the Adviser." />
                            </td></tr>
                            <tr><td>Adviser T-shirt Size:</td><td>
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
                            <tr class="altrow"><td>Students Username:</td><td>
                                <asp:TextBox ID="EditChStudentsUsername" runat="server" Text='<%# Bind("StudentsUsername") %>' />
                                <asp:MaskedEditExtender ID="maskEditChStudentsUsername" runat="server"
                                    TargetControlID="EditChStudentsUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChStudentsUsername" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChStudentsUsername" ControlExtender="maskEditChStudentsUsername"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the students." />
                            </td></tr>
                            <tr><td>Students Password:</td><td>
                                <asp:TextBox ID="EditChStudentsPassword" runat="server" Text='<%# Bind("StudentsPassword") %>' />
                                <asp:MaskedEditExtender ID="maskEditChStudentsPassword" runat="server"
                                    TargetControlID="EditChStudentsPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditChStudentsPassword" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditChStudentsPassword" ControlExtender="maskEditChStudentsPassword"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the students." />
                            </td></tr>
                            <tr class="altrow"><td>ASB Contact:</td><td>
                                <asp:TextBox ID="EditASBContactName" runat="server" Text='<%# Bind("ASBContactName") %>' />
                                <asp:MaskedEditExtender ID="maskEditASBContactName" runat="server"
                                    TargetControlID="EditASBContactName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditASBContactName" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditASBContactName" ControlExtender="maskEditASBContactName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the ASB contact." />
                            </td></tr>
                            <tr><td>ASB Phone Number:</td><td>
                                <asp:TextBox ID="EditASBContactPhone" runat="server" Text='<%# Bind("ASBContactPhone") %>' />
                                <asp:MaskedEditExtender ID="maskEditASBContactPhone" runat="server"
                                    TargetControlID="EditASBContactPhone" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldEditASBContactPhone" runat="server" ValidationGroup="vgrpEditChapter" ForeColor="Red"
                                    ControlToValidate="EditASBContactPhone" ControlExtender="maskEditASBContactPhone"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the ASB phone." />
                            </td></tr>
                            <tr class="altrow"><td>Outstanding Student:</td><td>
                                <asp:DropDownList ID="ddOutstandingStudent" runat="server" DataSourceID="sqlOutstandingStudentList" DataTextField="Name" DataValueField="MemberID"
                                    OnDataBound="ddOutstandingStudent_DataBound" />
                            </td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" ValidationGroup="vgrpEditChapter" CausesValidation="True" CommandName="Update" Text="Update" />
                            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="550px" />
                            <tr><td>Chapter Name:</td><td>
                                <asp:TextBox ID="InsertChapterName" runat="server" Text='<%# Bind("ChapterName") %>' /> 
                                <asp:MaskedEditExtender ID="maskInsertChapterName" runat="server"
                                    TargetControlID="InsertChapterName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChapterName" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChapterName" ControlExtender="maskInsertChapterName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a name for the chapter." />
                            </td></tr>
                            <tr class="altrow"><td>Abbreviation:</td><td>
                                <asp:TextBox ID="InsertChapterAbbr" runat="server" Text='<%# Bind("ChapterAbbr") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChapterAbbr" runat="server"
                                    TargetControlID="InsertChapterAbbr" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChapterAbbr" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChapterAbbr" ControlExtender="maskInsertChapterAbbr"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter an abbreviation for the chapter." />
                            </td></tr>
                            <tr><td>Address:</td><td>
                                <asp:TextBox ID="InsertAddress" runat="server" Text='<%# Bind("Address") %>' />
                                <asp:MaskedEditExtender ID="maskInsertAddress" runat="server"
                                    TargetControlID="InsertAddress" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertAddress" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertAddress" ControlExtender="maskInsertAddress"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the street address." />
                            </td></tr>
                            <tr class="altrow"><td>City:</td><td>
                                <asp:TextBox ID="InsertCity" runat="server" Text='<%# Bind("City") %>' />
                                <asp:MaskedEditExtender ID="maskInsertCity" runat="server"
                                    TargetControlID="InsertCity" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertCity" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertCity" ControlExtender="maskInsertCity"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the city." />
                            </td></tr>
                            <tr><td>Zip:</td><td>
                                <asp:TextBox ID="InsertZip" runat="server" Text='<%# Bind("Zip") %>' />
                                <asp:MaskedEditExtender ID="maskInsertZip" runat="server"
                                    TargetControlID="InsertZip" Mask="99999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertZip" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertZip" ControlExtender="maskInsertZip"
                                    ValidationExpression="[1-9][0-9]{4}" InvalidValueBlurredMessage="Please enter a valid zip code."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the 5-digit zip code." />
                            </td></tr>
                            <tr class="altrow"><td>National Chapter #:</td><td>
                                <asp:TextBox ID="InsertNationalChapterID" runat="server" Text='<%# Bind("NationalChapterID") %>' />
                            </td></tr>
                            <tr><td>Adviser Name:</td><td>
                                <asp:TextBox ID="InsertChAdviserName" runat="server" Text='<%# Bind("AdviserName") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserName" runat="server"
                                    TargetControlID="InsertChAdviserName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserName" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserName" ControlExtender="maskInsertChAdviserName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's name." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Email:</td><td>
                                <asp:TextBox ID="InsertChAdviserEmail" runat="server" Text='<%# Bind("AdviserEmail") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserEmail" runat="server"
                                    TargetControlID="InsertChAdviserEmail" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserEmail" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserEmail" ControlExtender="maskInsertChAdviserEmail"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" InvalidValueBlurredMessage="Please enter a valid e-mail address."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's e-mail address." />
                            </td></tr>
                            <tr><td>Adviser Cell:</td><td>
                                <asp:TextBox ID="InsertChAdviserCell" runat="server" Text='<%# Bind("AdviserCellPhone") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserCell" runat="server"
                                    TargetControlID="InsertChAdviserCell" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserCell" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserCell" ControlExtender="maskInsertChAdviserCell"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's cell number." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Classroom #:</td><td>
                                <asp:TextBox ID="InsertChAdviserClassroom" runat="server" Text='<%# Bind("AdviserClassroom") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserClassroom" runat="server"
                                    TargetControlID="InsertChAdviserClassroom" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserClassroom" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserClassroom" ControlExtender="maskInsertChAdviserClassroom"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's classroom number." />
                            </td></tr>
                            <tr><td>Adviser Username:</td><td>
                                <asp:TextBox ID="InsertChAdviserUsername" runat="server" Text='<%# Bind("AdviserUsername") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserUsername" runat="server"
                                    TargetControlID="InsertChAdviserUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserUsername" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserUsername" ControlExtender="maskInsertChAdviserUsername"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the Adviser." />
                            </td></tr>
                            <tr class="altrow"><td>Adviser Password:</td><td>
                                <asp:TextBox ID="InsertChAdviserPassword" runat="server" Text='<%# Bind("AdviserPassword") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChAdviserPassword" runat="server"
                                    TargetControlID="InsertChAdviserPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChAdviserPassword" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChAdviserPassword" ControlExtender="maskInsertChAdviserPassword"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the Adviser." />
                            </td></tr>
                            <tr><td>Adviser T-shirt Size:</td><td>
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
                            <tr class="altrow"><td>Students Username:</td><td>
                                <asp:TextBox ID="InsertChStudentsUsername" runat="server" Text='<%# Bind("StudentsUsername") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChStudentsUsername" runat="server"
                                    TargetControlID="InsertChStudentsUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChStudentsUsername" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChStudentsUsername" ControlExtender="maskInsertChStudentsUsername"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the students." />
                            </td></tr>
                            <tr><td>Students Password:</td><td>
                                <asp:TextBox ID="InsertChStudentsPassword" runat="server" Text='<%# Bind("StudentsPassword") %>' />
                                <asp:MaskedEditExtender ID="maskInsertChStudentsPassword" runat="server"
                                    TargetControlID="InsertChStudentsPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertChStudentsPassword" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertChStudentsPassword" ControlExtender="maskInsertChStudentsPassword"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the students." />
                            </td></tr>
                            <tr class="altrow"><td>ASB Contact:</td><td>
                                <asp:TextBox ID="InsertASBContactName" runat="server" Text='<%# Bind("ASBContactName") %>' />
                                <asp:MaskedEditExtender ID="maskInsertASBContactName" runat="server"
                                    TargetControlID="InsertASBContactName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertASBContactName" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertASBContactName" ControlExtender="maskInsertASBContactName"
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the ASB contact." />
                            </td></tr>
                            <tr><td>ASB Phone Number:</td><td>
                                <asp:TextBox ID="InsertASBContactPhone" runat="server" Text='<%# Bind("ASBContactPhone") %>' />
                                <asp:MaskedEditExtender ID="maskInsertASBContactPhone" runat="server"
                                    TargetControlID="InsertASBContactPhone" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                                    OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                <asp:MaskedEditValidator ID="vldInsertASBContactPhone" runat="server" ValidationGroup="vgrpInsertChapter" ForeColor="Red"
                                    ControlToValidate="InsertASBContactPhone" ControlExtender="maskInsertASBContactPhone"
                                    ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="Please enter a valid phone number."
                                    IsValidEmpty="false" EmptyValueBlurredText="Please enter the ASB phone number." />
                            </td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="InsertButton" runat="server" ValidationGroup="vgrpInsertChapter" CausesValidation="True" CommandName="Insert" Text="Insert" />
                            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="350px" />
                            <tr><td>Chapter Name:</td>                      <td class="data"><%# Eval("ChapterName") %></td></tr>
                            <tr class="altrow"><td>Abbreviation:</td>       <td class="data"><%# Eval("ChapterAbbr") %></td></tr>
                            <tr><td>Address:</td>                           <td class="data"><%# Eval("Address")%></td></tr>
                            <tr class="altrow"><td>City:</td>               <td class="data"><%# Eval("City")%></td></tr>
                            <tr><td>Zip:</td>                               <td class="data"><%# Eval("Zip")%></td></tr>
                            <tr class="altrow"><td>National Chapter #:</td> <td class="data"><%# Eval("NationalChapterID") %></td></tr>
                            <tr><td>Adviser Name:</td>                      <td class="data"><%# Eval("AdviserName") %></td></tr>
                            <tr class="altrow"><td>Adviser Email:</td>      <td class="data"><%# Eval("AdviserEmail") %></td></tr>
                            <tr><td>Adviser Cell:</td>                      <td class="data"><%# Eval("AdviserCellPhone") %></td></tr>
                            <tr class="altrow"><td>Adviser Classroom #:</td><td class="data"><%# Eval("AdviserClassroom") %></td></tr>
                            <tr><td>Adviser Username:</td>                  <td class="data"><%# Eval("AdviserUsername") %></td></tr>
                            <tr class="altrow"><td>Adviser Password:</td>   <td class="data"><%# Eval("AdviserPassword") %></td></tr>
                            <tr><td>Adviser T-Shirt Size:</td>              <td class="data"><%# Eval("ShirtSize") %></td></tr>
                            <tr class="altrow"><td>Students Username:</td>  <td class="data"><%# Eval("StudentsUsername") %></td></tr>
                            <tr><td>Students Password:</td>                 <td class="data"><%# Eval("StudentsPassword") %></td></tr>
                            <tr class="altrow"><td>ASB Contact:</td>        <td class="data"><%# Eval("ASBContactName")%></td></tr>
                            <tr><td>ASB Phone Number:</td>                  <td class="data"><%# Eval("ASBContactPhone")%></td></tr>
                            <tr class="altrow"><td>Outstanding Student:</td><td class="data"><%# Eval("OutstandingStudentName")%></td></tr>
                        </table>
                        <span style="display:inline-block;width:186px;padding:5px 0">
                            &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                OnClientClick="javascript:return confirm('Are you sure you want to delete this chapter?')"/>
                        </span>
                        <asp:LinkButton ID="ChangeRegionButton" runat="server" Text="Change Region" onclick="ChangeRegionButton_Click" />
                    </ItemTemplate>
                    <RowStyle BackColor="#BBBBBB" ForeColor="#222222" />
                </asp:FormView>
            </ContentTemplate></asp:UpdatePanel>
            <asp:UpdatePanel ID="updfvChangeRegion" runat="server"><ContentTemplate>
                <asp:FormView ID="fvChangeRegion" runat="server" ForeColor="#333333" DataSourceID="sqlChangeRegion" DataKeyNames="ChapterID" DefaultMode="Edit" Visible="false"
                    OnDataBound="fvChangeRegion_DataBound" OnItemUpdating="fvChangeRegion_ItemUpdating" OnItemUpdated="fvChangeRegion_ItemUpdated">
                    <EditItemTemplate>
                        <table cellpadding="4" cellspacing="0" style="background-color:White">
                            <col width="175px" /><col width="350px" />
                            <tr><td>Change Region:</td><td><asp:DropDownList ID="ddRegionList" runat="server" DataSourceID="sqlRegionList" DataTextField="RegionName" DataValueField="RegionID" /></td></tr>
                        </table>
                        <div style="padding:5px 0">
                            &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" />
                            &nbsp;<asp:LinkButton ID="CancelChangeRegionButton" runat="server" Text="Cancel" onclick="CancelChangeRegionButton_Click" />
                        </div>
                    </EditItemTemplate>
                    <RowStyle BackColor="#BBBBBB" ForeColor="#222222" />
                </asp:FormView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabStudents" runat="server" HeaderText="Chapter Members"><ContentTemplate>
            <asp:UpdatePanel ID="updgvStudents" runat="server"><ContentTemplate>
                <asp:GridView ID="gvStudents" runat="server" DataSourceID="sqlStudents" DataKeyNames="MemberID"
                    ForeColor="#333333" AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" GridLines="None" AllowSorting="True"
                    onrowcommand="gvStudents_RowCommand" OnRowDeleting="gvStudents_RowDeleting" OnRowDataBound="gvStudents_RowDataBound"> 
                    <EmptyDataTemplate>
                        <div style="padding-top:40px;border-top:1px solid black;font-style:italic"><b>There are currently no members for this chapter.</b></div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:TemplateField ShowHeader="False">
                            <EditItemTemplate><div style="width:100px">
                                <asp:LinkButton ID="StudentsUpdateButton" runat="server" ValidationGroup="vgrpEditStudent" CausesValidation="True" CommandName="Update" Text="Update"/>
                                <asp:LinkButton ID="StudentsCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"/>
                            </div></EditItemTemplate>
                            <ItemTemplate><div style="width:100px">
                                <asp:LinkButton ID="StudentsEditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"/>
                                <asp:LinkButton ID="StudentsDeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                                    OnClientClick="javascript:return confirm('Are you sure you want to delete this student?')"/>
                            </div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Paid" ItemStyle-HorizontalAlign="Center" SortExpression="isPaid">
                            <EditItemTemplate>
                                <asp:Label ID="EditPaid" runat="server" Text='<%# (Eval("isPaid").ToString()=="1")? "Y":"" %>'/>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label0" runat="server" Text='<%# (Eval("isPaid").ToString()=="1")? "Y":"" %>'/>
                             </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="First" SortExpression="FirstName">
                            <EditItemTemplate>
                                <asp:TextBox ID="EditFirstName" runat="server" Text='<%# Bind("FirstName") %>' Width="75px"/>
                                <span style="display:none">
                                    <asp:MaskedEditExtender ID="maskEditFirstName" runat="server"
                                        TargetControlID="EditFirstName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                        OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                    <asp:MaskedEditValidator ID="vldEditFirstName" runat="server" ValidationGroup="vgrpEditStudent" ForeColor="Red"
                                        ControlToValidate="EditFirstName" ControlExtender="maskEditFirstName" IsValidEmpty="false"/>
                                </span>
                            </EditItemTemplate>
                            <ItemTemplate><div style="width:90px"><asp:Label ID="Label2" runat="server" Text='<%# Eval("FirstName") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last" SortExpression="LastName">
                            <EditItemTemplate>
                                <asp:TextBox ID="EditLastName" runat="server" Text='<%# Bind("LastName") %>' Width="75px"/>
                                <span style="display:none">
                                    <asp:MaskedEditExtender ID="maskEditLastName" runat="server"
                                        TargetControlID="EditLastName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                                        OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                                    <asp:MaskedEditValidator ID="vldEditLastName" runat="server" ValidationGroup="vgrpEditStudent" ForeColor="Red"
                                        ControlToValidate="EditLastName" ControlExtender="maskEditLastName" IsValidEmpty="false"/>
                                </span>
                            </EditItemTemplate>
                            <ItemTemplate><div style="width:90px"><asp:Label ID="Label1" runat="server" Text='<%# Eval("LastName") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gender" ItemStyle-HorizontalAlign="Center" SortExpression="Gender">
                            <EditItemTemplate><asp:DropDownList ID="ddGender" runat="server"><asp:ListItem Value="M" Text="Male" /><asp:ListItem Value="F" Text="Female" /></asp:DropDownList></EditItemTemplate>
                            <ItemTemplate><div style="width:70px"><asp:Label ID="Label3" runat="server" Text='<%# Eval("Gender") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Class" ItemStyle-Width="55px" ItemStyle-HorizontalAlign="Center" SortExpression="GraduatingClass">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddGraduatingClass" runat="server"/>
                            </EditItemTemplate>
                            <ItemTemplate><asp:Label ID="Label5" runat="server" Text='<%# Eval("GraduatingClass") %>'/></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Shirt Size" ItemStyle-HorizontalAlign="Center" SortExpression="ShirtSize">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddShirtSize" runat="server">
                                    <asp:ListItem Value="" Text="<Blank>" />
                                    <asp:ListItem Value="XS" Text="X-Small" />
                                    <asp:ListItem Value="S" Text="Small" />
                                    <asp:ListItem Value="M" Text="Medium" />
                                    <asp:ListItem Value="L" Text="Large" />
                                    <asp:ListItem Value="XL" Text="X-Large" />
                                    <asp:ListItem Value="2X" Text="XXL" />
                                    <asp:ListItem Value="3X" Text="XXXL" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate><div style="width:75px"><asp:Label ID="Label4" runat="server" Text='<%# Eval("ShirtSize") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Position" SortExpression="ChapterPosition">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddPosition" runat="server">
                                    <asp:ListItem Text="None" Value=""/>
                                    <asp:ListItem Value="President"/>
                                    <asp:ListItem Value="Vice President"/>
                                    <asp:ListItem Value="Treasurer"/>
                                    <asp:ListItem Value="Secretary"/>
                                    <asp:ListItem Value="Parliamentarian"/>
                                    <asp:ListItem Value="Historian"/>
                                    <asp:ListItem Value="Public Relations"/>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate><div style="width:120px"><asp:Label ID="Label6" runat="server" Text='<%# Eval("ChapterPosition") %>'/></div></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Voting Delegate" ItemStyle-HorizontalAlign="Center" SortExpression="isVotingDelegate">
                            <EditItemTemplate><asp:DropDownList ID="ddVotingDelegate" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                            <ItemTemplate><asp:Label ID="Label7" runat="server" Text='<%# ((int)Eval("isVotingDelegate")==0)? "" : "Y" %>'/></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="State Eligible" ItemStyle-HorizontalAlign="Center" SortExpression="isStateEligible">
                            <EditItemTemplate><asp:DropDownList ID="ddStateEligible" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                            <ItemTemplate><asp:Label ID="Label8" runat="server" Text='<%# ((int)Eval("isStateEligible")==0)? "" : "Y" %>'/></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Nationals Eligible" ItemStyle-HorizontalAlign="Center" SortExpression="isNationalEligible">
                            <EditItemTemplate><asp:DropDownList ID="ddNationalEligible" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                            <ItemTemplate><asp:Label ID="Label9" runat="server" Text='<%# ((int)Eval("isNationalEligible")==0)? "" : "Y" %>'/></ItemTemplate>
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
        SelectCommand="SELECT DISTINCT S.[StateID], S.[StateName] FROM [States] S INNER JOIN [Regions] R ON S.[StateID] = R.[StateID] ORDER BY S.[StateName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT [RegionID], [RegionName] FROM [Regions] WHERE ([StateID] = @StateID) ORDER BY [RegionName]">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewChapterList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT [ChapterID], [ChapterName] FROM [Chapters] WHERE ([RegionID] = @RegionID) ORDER BY [ChapterName]">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlChapterMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT C.*, M.FirstName+' '+M.LastName AS OutstandingStudentName FROM Chapters C LEFT JOIN NationalMembers AS M ON C.OutstandingStudent = M.MemberID WHERE C.ChapterID=@ChapterID" 
        DeleteCommand="DELETE FROM Chapters WHERE ChapterID = @ChapterID" 
        InsertCommand="INSERT INTO Chapters (NationalChapterID, StateID, RegionID, ChapterName, ChapterAbbr, AdviserName, AdviserUsername, AdviserPassword, AdviserEmail, AdviserCellPhone, AdviserClassroom, ShirtSize, StudentsUsername, StudentsPassword, ASBContactName, ASBContactPhone, Address, City, Zip) VALUES (@NationalChapterID, @StateID, @RegionID, @ChapterName, @ChapterAbbr, @AdviserName, @AdviserUsername, @AdviserPassword, @AdviserEmail, @AdviserCellPhone, @AdviserClassroom, @ShirtSize, @StudentsUsername, @StudentsPassword, @ASBContactName, @ASBContactPhone, @Address, @City, @Zip); SELECT @ChapterID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE Chapters SET NationalChapterID = @NationalChapterID, ChapterName = @ChapterName, ChapterAbbr = @ChapterAbbr, AdviserUsername = @AdviserUsername, AdviserName = @AdviserName, AdviserPassword = @AdviserPassword, AdviserEmail = @AdviserEmail, AdviserCellPhone = @AdviserCellPhone, AdviserClassroom = @AdviserClassroom, ShirtSize = @ShirtSize, StudentsUsername = @StudentsUsername, StudentsPassword = @StudentsPassword, ASBContactName=@ASBContactName, ASBContactPhone=@ASBContactPhone, Address=@Address, City=@City, Zip=@Zip, OutStandingStudent=@OutStandingStudent WHERE ChapterID = @ChapterID" 
        oninserted="sqlChapterMaint_Inserted" ondeleted="sqlChapterMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ChapterID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="ChapterName" Type="String" />
            <asp:Parameter Name="ChapterAbbr" Type="String" />
            <asp:Parameter Name="NationalChapterID" Type="Int32" />
            <asp:Parameter Name="AdviserName" Type="String" />
            <asp:Parameter Name="AdviserEmail" Type="String" />
            <asp:Parameter Name="AdviserCellPhone" Type="String" />
            <asp:Parameter Name="AdviserClassroom" Type="String" />
            <asp:Parameter Name="AdviserUsername" Type="String" />
            <asp:Parameter Name="AdviserPassword" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="StudentsUsername" Type="String" />
            <asp:Parameter Name="StudentsPassword" Type="String" />
            <asp:Parameter Name="ASBContactName" Type="String" />
            <asp:Parameter Name="ASBContactPhone" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="Zip" Type="Int32" />
            <asp:Parameter Name="ChapterID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="ChapterName" Type="String" />
            <asp:Parameter Name="ChapterAbbr" Type="String" />
            <asp:Parameter Name="NationalChapterID" Type="Int32" />
            <asp:Parameter Name="AdviserName" Type="String" />
            <asp:Parameter Name="AdviserEmail" Type="String" />
            <asp:Parameter Name="AdviserCellPhone" Type="String" />
            <asp:Parameter Name="AdviserClassroom" Type="String" />
            <asp:Parameter Name="AdviserUsername" Type="String" />
            <asp:Parameter Name="AdviserPassword" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="StudentsUsername" Type="String" />
            <asp:Parameter Name="StudentsPassword" Type="String" />
            <asp:Parameter Name="ASBContactName" Type="String" />
            <asp:Parameter Name="ASBContactPhone" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="Zip" Type="Int32" />
            <asp:Parameter Name="OutStandingStudent" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlOutstandingStudentList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT MemberID, LastName+', '+FirstName+' ('+CAST(GraduatingClass AS nvarchar)+')' AS Name FROM NationalMembers WHERE ISNULL(isInactive,0)=0 AND ChapterID=@ChapterID AND isPaid=1 ORDER BY LastName, FirstName">
        <SelectParameters>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlStudents" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
            SelectCommand="SELECT * FROM NationalMembers WHERE ChapterID=@ChapterID AND ISNULL(isInactive,0)=0 ORDER BY LastName, FirstName" 
            DeleteCommand="DELETE FROM NationalMembers WHERE MemberID=@MemberID"
            InsertCommand="INSERT INTO NationalMembers (ChapterID, FirstName, LastName, Gender, ShirtSize, GraduatingClass, ChapterPosition, isVotingDelegate, isStateEligible, isNationalEligible, isPaid) VALUES (@ChapterID, @FirstName, @LastName, @Gender, @ShirtSize, @GraduatingClass, @ChapterPosition, @isVotingDelegate, @isStateEligible, @isNationalEligible, @isPaid)" 
            UpdateCommand="UPDATE NationalMembers SET ChapterID=@ChapterID, FirstName=@FirstName, LastName=@LastName, Gender=@Gender, ShirtSize=@ShirtSize, GraduatingClass=@GraduatingClass, ChapterPosition=@ChapterPosition, isVotingDelegate=@isVotingDelegate, isStateEligible=@isStateEligible, isNationalEligible=@isNationalEligible WHERE MemberID=@MemberID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Gender" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="GraduatingClass" Type="Int32" />
            <asp:Parameter Name="ChapterPosition" Type="String" />
            <asp:Parameter Name="isVotingDelegate" Type="Int32" />
            <asp:Parameter Name="isStateEligible" Type="Int32" />
            <asp:Parameter Name="isNationalEligible" Type="Int32" />
            <asp:Parameter Name="isPaid" Type="Int32" DefaultValue="0" />
        </InsertParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Gender" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="GraduatingClass" Type="Int32" />
            <asp:Parameter Name="ChapterPosition" Type="String" />
            <asp:Parameter Name="isVotingDelegate" Type="Int32" />
            <asp:Parameter Name="isStateEligible" Type="Int32" />
            <asp:Parameter Name="isNationalEligible" Type="Int32" />
            <asp:Parameter Name="MemberID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT [RegionID], [RegionName] FROM [Regions] WHERE ([StateID] = @StateID) ORDER BY [RegionName]">
        <SelectParameters>
            <asp:Parameter Name="StateID" Type="Int32" DefaultValue="0" Direction="Input" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlChangeRegion" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM [Chapters] WHERE ChapterID = @ChapterID" 
        UpdateCommand="UPDATE [Chapters] SET [RegionID] = @RegionID WHERE [ChapterID] = @ChapterID"> 
        <SelectParameters>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
