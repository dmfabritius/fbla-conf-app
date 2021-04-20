<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-State.aspx.cs" Inherits="FBLA_Conference_System.Maint_State" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>State Maintenance</h2></td><td style="padding-left:20px">
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
    <br />

    <asp:UpdatePanel ID="updfvState" runat="server"><ContentTemplate>
        <asp:FormView ID="fvState" runat="server" ForeColor="#333333" DataSourceID="sqlStateMaint" DataKeyNames="StateID">
            <EditItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="550px" />
                    <tr><td>State Name:</td><td class="data"><%# Eval("StateName") %></td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td class="data"><%# Eval("StateAbbr") %></td></tr>
                    <tr><td>Address:</td><td>
                        <asp:TextBox ID="EditAddress" runat="server" Text='<%# Bind("Address") %>' />
                        <asp:MaskedEditExtender ID="maskEditAddress" runat="server"
                            TargetControlID="EditAddress" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAddress" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditAddress" ControlExtender="maskEditAddress"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter the street address." />
                    </td></tr>
                    <tr class="altrow"><td>City:</td><td>
                        <asp:TextBox ID="EditCity" runat="server" Text='<%# Bind("City") %>' />
                        <asp:MaskedEditExtender ID="maskEditCity" runat="server"
                            TargetControlID="EditCity" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditCity" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditCity" ControlExtender="maskEditCity"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter the city." />
                    </td></tr>
                    <tr><td>Zip:</td><td>
                        <asp:TextBox ID="EditZip" runat="server" Text='<%# Bind("Zip") %>' />
                        <asp:MaskedEditExtender ID="maskEditZip" runat="server"
                            TargetControlID="EditZip" Mask="99999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditZip" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditZip" ControlExtender="maskEditZip"
                            ValidationExpression="[1-9][0-9]{4}" InvalidValueBlurredMessage="Please enter the 5-digit zip code."
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter the 5-digit zip code." />
                    </td></tr>
                    <tr class="altrow"><td>Adviser Name:</td><td>
                        <asp:TextBox ID="EditAdviserName" runat="server" Text='<%# Bind("AdviserName") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserName" runat="server"
                            TargetControlID="EditAdviserName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserName" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditAdviserName" ControlExtender="maskEditAdviserName"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's name." />
                    </td></tr>
                    <tr><td>Adviser Email:</td><td>
                        <asp:TextBox ID="EditAdviserEmail" runat="server" Text='<%# Bind("AdviserEmail") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserEmail" runat="server"
                            TargetControlID="EditAdviserEmail" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserEmail" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditAdviserEmail" ControlExtender="maskEditAdviserEmail"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" InvalidValueBlurredMessage="Please enter a valid e-mail address."
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter the Adviser's e-mail." />
                    </td></tr>
                    <tr class="altrow"><td>Adviser Username:</td><td>
                        <asp:TextBox ID="EditAdviserUsername" runat="server" Text='<%# Bind("AdviserUsername") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserUsername" runat="server"
                            TargetControlID="EditAdviserUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserUsername" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditAdviserUsername" ControlExtender="maskEditAdviserUsername"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the Adviser." />
                    </td></tr>
                    <tr><td>Adviser Password:</td><td>
                        <asp:TextBox ID="EditAdviserPassword" runat="server" Text='<%# Bind("AdviserPassword") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserPassword" runat="server"
                            TargetControlID="EditAdviserPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserPassword" runat="server" ValidationGroup="vgrpEditState" ForeColor="Red"
                            ControlToValidate="EditAdviserPassword" ControlExtender="maskEditAdviserPassword"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the Adviser." />
                    </td></tr>
                    <tr class="altrow"><td>BEA Dues:</td><td>
                        <asp:TextBox ID="EditBEADues" runat="server" Text='<%# Bind("BEADues") %>'/>
                        <asp:MaskedEditExtender ID="maskEditBEADues" runat="server"
                            TargetControlID="EditBEADues" Mask="999\.00" MaskType="Number" DisplayMoney="Left" AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditBEADues" runat="server" ValidationGroup="vgrpEditConference" ForeColor="Red"
                            ControlToValidate="EditBEADues" ControlExtender="maskEditBEADues"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an amount for BEA dues." />
                    </td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" ValidationGroup="vgrpEditState" CausesValidation="True" CommandName="Update" Text="Update" />
                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </div>
            </EditItemTemplate>
            <ItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="350px" />
                    <tr><td>State Name:</td><td class="data"><%# Eval("StateName") %></td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td class="data"><%# Eval("StateAbbr") %></td></tr>
                    <tr><td>Address:</td><td class="data"><%# Eval("Address")%></td></tr>
                    <tr class="altrow"><td>City:</td><td class="data"><%# Eval("City")%></td></tr>
                    <tr><td>Zip:</td><td class="data"><%# Eval("Zip")%></td></tr>
                    <tr class="altrow"><td>Adviser Name:</td><td class="data"><%# Eval("AdviserName") %></td></tr>
                    <tr><td>Adviser Email:</td><td class="data"><%# Eval("AdviserEmail") %></td></tr>
                    <tr class="altrow"><td>Adviser Username:</td><td class="data"><%# Eval("AdviserUsername") %></td></tr>
                    <tr><td>Adviser Password:</td><td class="data"><%# Eval("AdviserPassword") %></td></tr>
                    <tr class="altrow"><td>State President:</td><td class="data"><%# Eval("StatePresidentName")%></td></tr>
                    <tr><td>State Secretary:</td><td class="data"><%# Eval("StateSecretaryName")%></td></tr>
                    <tr class="altrow"><td>State Public Relations:</td><td class="data"><%# Eval("StatePublicRelationsName")%></td></tr>
                    <tr><td>State Parlimentarian:</td><td class="data"><%# Eval("StateParlimentarianName")%></td></tr>
                    <tr class="altrow"><td>BEA Dues:</td><td class="data"><%# Eval("BEADues", "{0:C}")%></td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                </div>
            </ItemTemplate>
            <RowStyle BackColor="#DDDDDD" ForeColor="#222222" />
        </asp:FormView>
    </ContentTemplate></asp:UpdatePanel>

    <asp:UpdatePanel ID="updOfficers" runat="server"><ContentTemplate>
        <table style="margin-top:20px;border:1px solid #999" cellpadding="6px"><tr><td>
            <br /><span style="display:inline-block;width:120px">Select a Region:</span>
            <asp:DropDownList ID="ddRegions" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewRegionList" DataTextField="RegionName" DataValueField="RegionID"
                ondatabound="ddRegions_DataBound" onselectedindexchanged="ddRegions_SelectedIndexChanged" />
            <br /><span style="display:inline-block;width:120px">Select a Chapter:</span>
            <asp:DropDownList ID="ddChapters" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewChapterList" DataTextField="ChapterName" DataValueField="ChapterID" 
                ondatabound="ddChapters_DataBound" onselectedindexchanged="ddChapters_SelectedIndexChanged"/>
            <br /><span style="display:inline-block;width:120px">Select a Student:</span>
            <asp:DropDownList ID="ddChapterStudents" runat="server" Width="400px"
                DataSourceID="sqlChapterStudents" DataTextField="Name" DataValueField="MemberID"
                OnDataBound="ddChapterStudents_DataBound" />
            <br />
            <br />Click to assign: 
            <asp:Button ID="StatePresident" runat="server" CssClass="AssignButton" Text=" President " onclick="btnAssignOfficer_Click" />
            <asp:Button ID="StateSecretary" runat="server" CssClass="AssignButton" Text=" Secretary " onclick="btnAssignOfficer_Click" />
            <asp:Button ID="StatePublicRelations" runat="server" CssClass="AssignButton" Text=" Public Relations " onclick="btnAssignOfficer_Click" />
            <asp:Button ID="StateParlimentarian" runat="server" CssClass="AssignButton" Text=" Parlimentarian " onclick="btnAssignOfficer_Click" />
        </td></tr></table>
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
        SelectCommand="SELECT StateID, StateName FROM States ORDER BY StateName">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlViewRegionList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionID, RegionName FROM Regions WHERE (StateID=@StateID) ORDER BY RegionName">
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

    <asp:SqlDataSource ID="sqlStateMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT S.*,M1.FirstName+' '+M1.LastName+' ('+C1.ChapterName+')' AS StatePresidentName,M2.FirstName+' '+M2.LastName+' ('+C2.ChapterName+')' AS StateSecretaryName,M3.FirstName+' '+M3.LastName+' ('+C3.ChapterName+')' AS StatePublicRelationsName,M4.FirstName+' '+M4.LastName+' ('+C4.ChapterName+')' AS StateParlimentarianName FROM States AS S LEFT JOIN NationalMembers AS M1 ON S.StatePresident=M1.MemberID LEFT JOIN Chapters AS C1 ON M1.ChapterID=C1.ChapterID LEFT JOIN NationalMembers AS M2 ON S.StateSecretary=M2.MemberID LEFT JOIN Chapters AS C2 ON M2.ChapterID=C2.ChapterID LEFT JOIN NationalMembers AS M3 ON S.StatePublicRelations=M3.MemberID LEFT JOIN Chapters AS C3 ON M3.ChapterID=C3.ChapterID LEFT JOIN NationalMembers AS M4 ON S.StateParlimentarian=M4.MemberID LEFT JOIN Chapters AS C4 ON M4.ChapterID=C4.ChapterID WHERE S.StateID=@StateID"
        UpdateCommand="UPDATE States SET AdviserUsername=@AdviserUsername, AdviserName=@AdviserName, AdviserPassword=@AdviserPassword, AdviserEmail=@AdviserEmail, Address=@Address, City=@City, Zip=@Zip, BEADues=@BEADues WHERE StateID=@StateID">
        <SelectParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="AdviserName" Type="String" />
            <asp:Parameter Name="AdviserEmail" Type="String" />
            <asp:Parameter Name="AdviserUsername" Type="String" />
            <asp:Parameter Name="AdviserPassword" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="City" Type="String" />
            <asp:Parameter Name="Zip" Type="Int32" />
            <asp:Parameter Name="BEADues" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlChapterStudents" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT MemberID, LastName+', '+FirstName+' ('+CAST(GraduatingClass AS nvarchar)+')' AS Name FROM NationalMembers WHERE ISNULL(isInactive,0)=0 AND isPaid=1 AND ChapterID=@ChapterID ORDER BY LastName, FirstName">
        <SelectParameters>
            <asp:ControlParameter Name="ChapterID" ControlID="ddChapters" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
