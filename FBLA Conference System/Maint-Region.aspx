<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Region.aspx.cs" Inherits="FBLA_Conference_System.Maint_Region" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Regional Maintenance</h2></td><td style="padding-left:20px">
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
            &nbsp;<asp:Button ID="btnAddRegion" runat="server" Text=" Add " onclick="btnAddRegion_Click"/>
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />

    <asp:UpdatePanel ID="updfvRegion" runat="server"><ContentTemplate>
        <asp:FormView ID="fvRegion" runat="server" ForeColor="#333333" DataSourceID="sqlRegionMaint" DataKeyNames="RegionID"
                onitemupdating="fvRegion_ItemUpdating" ondatabound="fvRegion_DataBound">
            <EmptyDataTemplate>
                <div style="padding-top:40px;border-top:1px solid black;font-style:italic"><b>There are currently no regions for this state.</b></div>
            </EmptyDataTemplate>
            <EditItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="550px" />
                    <tr><td>Region Name:</td><td>
                        <asp:TextBox ID="EditRegionName" runat="server" Text='<%# Bind("RegionName") %>' /> 
                        <asp:MaskedEditExtender ID="maskEditRegionName" runat="server"
                            TargetControlID="EditRegionName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditRegionName" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditRegionName" ControlExtender="maskEditRegionName"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a name for the region." />
                    </td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td>
                        <asp:TextBox ID="EditRegionAbbr" runat="server" Text='<%# Bind("RegionAbbr") %>' />
                        <asp:MaskedEditExtender ID="maskEditRegionAbbr" runat="server"
                            TargetControlID="EditRegionAbbr" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditRegionAbbr" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditRegionAbbr" ControlExtender="maskEditRegionAbbr"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an abbreviation for the region." />
                    </td></tr>
                    <tr><td>Regional Adviser:</td><td>
                        <asp:DropDownList ID="ddRegionalAdviser" runat="server" DataSourceID="sqlRegionalAdviserList" DataTextField="Name" DataValueField="ChapterID"
                            OnDataBound="ddRegionalAdviser_DataBound" />
                    </td></tr>
                    <tr class="altrow"><td>Regional VP:</td><td>
                        <asp:DropDownList ID="ddRegionalVP" runat="server" DataSourceID="sqlRegionalVPList" DataTextField="Name" DataValueField="MemberID"
                            OnDataBound="ddRegionalVP_DataBound" />
                    </td></tr>
                    <tr><td>Region Username:</td><td>
                        <asp:TextBox ID="EditAdviserUsername" runat="server" Text='<%# Bind("AdviserUsername") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserUsername" runat="server"
                            TargetControlID="EditAdviserUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserUsername" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditAdviserUsername" ControlExtender="maskEditAdviserUsername"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a  username for the Adviser." />
                    </td></tr>
                    <tr class="altrow"><td>Region Password:</td><td>
                        <asp:TextBox ID="EditAdviserPassword" runat="server" Text='<%# Bind("AdviserPassword") %>' />
                        <asp:MaskedEditExtender ID="maskEditAdviserPassword" runat="server"
                            TargetControlID="EditAdviserPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditAdviserPassword" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditAdviserPassword" ControlExtender="maskEditAdviserPassword"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a  password for the Adviser." />
                    </td></tr>
                    <tr><td>Invoice Address:</td><td>
                        <asp:TextBox ID="EditInvoiceAddress" runat="server" Text='<%# Bind("InvoiceAddress") %>' />
                        <asp:MaskedEditExtender ID="maskEditInvoiceAddress" runat="server"
                            TargetControlID="EditInvoiceAddress" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditInvoiceAddress" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditInvoiceAddress" ControlExtender="maskEditInvoiceAddress"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice address." />
                    </td></tr>
                    <tr class="altrow"><td>Invoice City:</td><td>
                        <asp:TextBox ID="EditInvoiceCity" runat="server" Text='<%# Bind("InvoiceCity") %>' />
                        <asp:MaskedEditExtender ID="maskEditInvoiceCity" runat="server"
                            TargetControlID="EditInvoiceCity" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditInvoiceCity" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditInvoiceCity" ControlExtender="maskEditInvoiceCity"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice city." />
                    </td></tr>
                    <tr><td>Invoice Zip:</td><td>
                        <asp:TextBox ID="EditInvoiceZip" runat="server" Text='<%# Bind("InvoiceZip") %>' />
                        <asp:MaskedEditExtender ID="maskEditInvoiceZip" runat="server"
                            TargetControlID="EditInvoiceZip" Mask="99999" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditInvoiceZip" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditInvoiceZip" ControlExtender="maskEditInvoiceZip"
                            ValidationExpression="[1-9][0-9]{4}" InvalidValueBlurredMessage="Please enter a 5-digit zip code."
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice zip code." />
                    </td></tr>
                    <tr class="altrow"><td>Invoice Contact:</td><td>
                        <asp:TextBox ID="EditInvoiceContact" runat="server" Text='<%# Bind("InvoiceContact") %>' />
                        <asp:MaskedEditExtender ID="maskEditInvoiceContact" runat="server"
                            TargetControlID="EditInvoiceContact" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditInvoiceContact" runat="server" ValidationGroup="vgrpEditRegion" ForeColor="Red"
                            ControlToValidate="EditInvoiceContact" ControlExtender="maskEditInvoiceContact"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice contact." />
                    </td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" ValidationGroup="vgrpEditRegion" CausesValidation="True" CommandName="Update" Text="Update" />
                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </div>
            </EditItemTemplate>
            <InsertItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="550px" />
                    <tr><td>Region Name:</td><td>
                        <asp:TextBox ID="InsertRegionName" runat="server" Text='<%# Bind("RegionName") %>' /> 
                        <asp:MaskedEditExtender ID="maskInsertRegionName" runat="server"
                            TargetControlID="InsertRegionName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertRegionName" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertRegionName" ControlExtender="maskInsertRegionName"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a name for the region." />
                    </td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td>
                        <asp:TextBox ID="InsertRegionAbbr" runat="server" Text='<%# Bind("RegionAbbr") %>' />
                        <asp:MaskedEditExtender ID="maskInsertRegionAbbr" runat="server"
                            TargetControlID="InsertRegionAbbr" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertRegionAbbr" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertRegionAbbr" ControlExtender="maskInsertRegionAbbr"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an abbreviation for the region." />
                    </td></tr>
                    <tr><td>Regional Adviser:</td><td>
                        <asp:Label ID="InsertRegionalAdviser" runat="server" Text="Update after adding chapters for the region." Font-Italic="true"/>
                    </td></tr>
                    <tr class="altrow"><td>Regional VP:</td><td>
                        <asp:Label ID="InsertRegionalVP" runat="server" Text="Update after adding chapters and students for the region." Font-Italic="true"/>
                    </td></tr>
                    <tr><td>Region Username:</td><td>
                        <asp:TextBox ID="InsertAdviserUsername" runat="server" Text='<%# Bind("AdviserUsername") %>' />
                        <asp:MaskedEditExtender ID="maskInsertAdviserUsername" runat="server"
                            TargetControlID="InsertAdviserUsername" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertAdviserUsername" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertAdviserUsername" ControlExtender="maskInsertAdviserUsername"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a username for the Adviser." />
                    </td></tr>
                    <tr class="altrow"><td>Region Password:</td><td>
                        <asp:TextBox ID="InsertAdviserPassword" runat="server" Text='<%# Bind("AdviserPassword") %>' />
                        <asp:MaskedEditExtender ID="maskInsertAdviserPassword" runat="server"
                            TargetControlID="InsertAdviserPassword" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertAdviserPassword" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertAdviserPassword" ControlExtender="maskInsertAdviserPassword"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a password for the Adviser." />
                    </td></tr>
                    <tr><td>Invoice Address:</td><td>
                        <asp:TextBox ID="InsertInvoiceAddress" runat="server" Text='<%# Bind("InvoiceAddress") %>' />
                        <asp:MaskedEditExtender ID="maskInsertInvoiceAddress" runat="server"
                            TargetControlID="InsertInvoiceAddress" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertInvoiceAddress" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertInvoiceAddress" ControlExtender="maskInsertInvoiceAddress"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice address." />
                    </td></tr>
                    <tr class="altrow"><td>Invoice City:</td><td>
                        <asp:TextBox ID="InsertInvoiceCity" runat="server" Text='<%# Bind("InvoiceCity") %>' />
                        <asp:MaskedEditExtender ID="maskInsertInvoiceCity" runat="server"
                            TargetControlID="InsertInvoiceCity" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertInvoiceCity" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertInvoiceCity" ControlExtender="maskInsertInvoiceCity"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice city." />
                    </td></tr>
                    <tr><td>Invoice Zip:</td><td>
                        <asp:TextBox ID="InsertInvoiceZip" runat="server" Text='<%# Bind("InvoiceZip") %>' />
                        <asp:MaskedEditExtender ID="maskInsertInvoiceZip" runat="server"
                            TargetControlID="InsertInvoiceZip" Mask="99999" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertInvoiceZip" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertInvoiceZip" ControlExtender="maskInsertInvoiceZip"
                            ValidationExpression="[1-9][0-9]{4}" InvalidValueBlurredMessage="Please enter a 5-digit zip code."
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice zip code." />
                    </td></tr>
                    <tr class="altrow"><td>Invoice Contact:</td><td>
                        <asp:TextBox ID="InsertInvoiceContact" runat="server" Text='<%# Bind("InvoiceContact") %>' />
                        <asp:MaskedEditExtender ID="maskInsertInvoiceContact" runat="server"
                            TargetControlID="InsertInvoiceContact" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertInvoiceContact" runat="server" ValidationGroup="vgrpInsertRegion" ForeColor="Red"
                            ControlToValidate="InsertInvoiceContact" ControlExtender="maskInsertInvoiceContact"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter an invoice contact." />
                    </td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="InsertButton" runat="server" ValidationGroup="vgrpInsertRegion" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </div>
            </InsertItemTemplate>
            <ItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="350px" />
                    <tr><td>Region Name:</td><td class="data"><%# Eval("RegionName") %></td></tr>
                    <tr class="altrow"><td>Abbreviation:</td><td class="data"><%# Eval("RegionAbbr") %></td></tr>
                    <tr valign="top"><td>Regional Adviser:</td><td class="data"><%# Eval("AdviserName") %><br /><%# Eval("ChapterName") %></td></tr>
                    <tr valign="top" class="altrow"><td>Regional VP:</td><td class="data"><%# Eval("RegionalVPName")%><br /><%# Eval("RegionalVPChapter")%></td></tr>
                    <tr><td>Region Username:</td><td class="data"><%# Eval("AdviserUsername") %></td></tr>
                    <tr class="altrow"><td>Region Password:</td><td class="data"><%# Eval("AdviserPassword") %></td></tr>
                    <tr><td>Invoice Address:</td><td class="data"><%# Eval("InvoiceAddress")%></td></tr>
                    <tr class="altrow"><td>Invoice City:</td><td class="data"><%# Eval("InvoiceCity")%></td></tr>
                    <tr><td>Invoice Zip:</td><td class="data"><%# Eval("InvoiceZip")%></td></tr>
                    <tr class="altrow"><td>Invoice Contact:</td><td class="data"><%# Eval("InvoiceContact")%></td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                    &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                        OnClientClick="javascript:return confirm('Are you sure you want to delete this region?')"/>
                </div>
            </ItemTemplate>
            <RowStyle BackColor="#CCCCCC" ForeColor="#222222" />
        </asp:FormView>
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
        SelectCommand="SELECT [RegionID], [RegionName] FROM [Regions] WHERE ([StateID] = @StateID) ORDER BY [RegionName]">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRegionMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT R.*, CA.AdviserName, CA.ChapterName, M.FirstName+' '+M.LastName AS RegionalVPName, CVP.ChapterName AS RegionalVPChapter FROM Regions AS R LEFT JOIN NationalMembers AS M ON R.RegionalVP = M.MemberID LEFT JOIN Chapters AS CVP ON M.ChapterID = CVP.ChapterID LEFT JOIN Chapters AS CA ON R.AdviserChapterID = CA.ChapterID WHERE R.RegionID = @RegionID"
        DeleteCommand="DELETE FROM Regions WHERE RegionID = @RegionID" 
        InsertCommand="INSERT INTO Regions (StateID,RegionName,RegionAbbr,AdviserUsername,AdviserPassword,InvoiceAddress,InvoiceCity,InvoiceZip,InvoiceContact) VALUES (@StateID,@RegionName,@RegionAbbr,@AdviserUsername,@AdviserPassword,@InvoiceAddress,@InvoiceCity,@InvoiceZip,@InvoiceContact); SELECT @RegionID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE Regions SET RegionName=@RegionName,RegionAbbr=@RegionAbbr,AdviserChapterID=@AdviserChapterID,AdviserUsername=@AdviserUsername,AdviserPassword=@AdviserPassword,RegionalVP=@RegionalVP,InvoiceAddress=@InvoiceAddress,InvoiceCity=@InvoiceCity,InvoiceZip=@InvoiceZip,InvoiceContact=@InvoiceContact WHERE RegionID = @RegionID" 
        oninserted="sqlRegionMaint_Inserted" ondeleted="sqlRegionMaint_Deleted">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="RegionID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter Name="StateID" ControlID="ddStates" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="RegionName" Type="String" />
            <asp:Parameter Name="RegionAbbr" Type="String" />
            <asp:Parameter Name="AdviserUsername" Type="String" />
            <asp:Parameter Name="AdviserPassword" Type="String" />
            <asp:Parameter Name="InvoiceAddress" Type="String" />
            <asp:Parameter Name="InvoiceCity" Type="String" />
            <asp:Parameter Name="InvoiceZip" Type="String" />
            <asp:Parameter Name="InvoiceContact" Type="String" />
            <asp:Parameter Name="RegionID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="RegionName" Type="String" />
            <asp:Parameter Name="RegionAbbr" Type="String" />
            <asp:Parameter Name="AdviserChapterID" Type="Int32" />
            <asp:Parameter Name="RegionalVP" Type="Int32" />
            <asp:Parameter Name="AdviserUsername" Type="String" />
            <asp:Parameter Name="AdviserPassword" Type="String" />
            <asp:Parameter Name="InvoiceAddress" Type="String" />
            <asp:Parameter Name="InvoiceCity" Type="String" />
            <asp:Parameter Name="InvoiceZip" Type="String" />
            <asp:Parameter Name="InvoiceContact" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRegionalAdviserList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT ChapterID, AdviserName+' ('+ChapterName+')' AS Name FROM Chapters WHERE ChapterID IN (SELECT ChapterID FROM Chapters WHERE RegionID = @RegionID) ORDER BY AdviserName">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlRegionalVPList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT MemberID, LastName+', '+FirstName+' ('+ChapterName+')' AS Name FROM NationalMembers M INNER JOIN Chapters C ON M.ChapterID=C.ChapterID WHERE ISNULL(isInactive,0)=0 AND M.ChapterID IN (SELECT ChapterID FROM Chapters WHERE RegionID = @RegionID) AND isPaid = 1 ORDER BY LastName, FirstName">
        <SelectParameters>
            <asp:ControlParameter Name="RegionID" ControlID="ddRegions" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
