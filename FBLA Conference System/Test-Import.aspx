<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Test-Import.aspx.cs" Inherits="FBLA_Conference_System.Test_Import" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Import Test Questions</h2></td><td style="padding-left:20px">
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
    <asp:Panel ID="pnlSelRegionalTests" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddRegionalTests" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select Tests:</span>
            <asp:DropDownList ID="ddRegionalTests" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewRegionalTestsList" DataTextField="Description" DataValueField="RegionalTestsID" 
                ondatabound="ddRegionalTests_DataBound" onselectedindexchanged="ddRegionalTests_SelectedIndexChanged" />
            &nbsp;<asp:Button ID="btnAddRegionalTests" runat="server" Text=" Add " onclick="btnAddRegionalTests_Click" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />

    <asp:UpdatePanel ID="updfvRegionalTests" runat="server"><ContentTemplate>
        <asp:FormView ID="fvRegionalTests" runat="server" ForeColor="#333333" DataSourceID="sqlRegionalTestsMaint" DataKeyNames="RegionalTestsID">
            <EmptyDataTemplate>
                <div style="padding-top:20px"><b><i>There are currently no regional tests defined.</i></b></div>
            </EmptyDataTemplate>
            <EditItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <col width="175px" /><col width="550px" />
                    <tr><td>Conference Name:</td><td>
                        <asp:TextBox ID="EditDescription" runat="server" Text='<%# Bind("Description") %>' Width="400px" /> 
                        <asp:MaskedEditExtender ID="maskEditDescription" runat="server"
                            TargetControlID="EditDescription" Mask="?{55}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldEditDescription" runat="server" ValidationGroup="vgrpEditConference" ForeColor="Red"
                            ControlToValidate="EditDescription" ControlExtender="maskEditDescription"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a description." />
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
                    <tr><td>Description:</td><td>
                        <asp:TextBox ID="InsertDescription" runat="server" Text='<%# Bind("Description") %>' Width="400px" /> 
                        <asp:MaskedEditExtender ID="maskInsertDescription" runat="server"
                            TargetControlID="InsertDescription" Mask="?{55}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertDescription" runat="server" ValidationGroup="vgrpInsertConference" ForeColor="Red"
                            ControlToValidate="InsertDescription" ControlExtender="maskInsertDescription"
                            IsValidEmpty="false" EmptyValueBlurredText="Please enter a description." />
                    </td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="InsertButton" runat="server" ValidationGroup="vgrpInsertConference" CausesValidation="True" CommandName="Insert" Text="Insert" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </div>
            </InsertItemTemplate>
            <ItemTemplate>
                <table cellpadding="4" cellspacing="0" style="background-color:White">
                    <tr class="altrow"><td>Description:</td><td class="data"><%# Eval("Description") %></td></tr>
                </table>
                <div style="padding:5px 0">
                    &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"/>
                    &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                        OnClientClick="javascript:return confirm('Are you sure you want to delete these regional tests?')"/>
                </div>
            </ItemTemplate>
            <RowStyle BackColor="#BBBBBB" ForeColor="#222222" />
        </asp:FormView>
    </ContentTemplate></asp:UpdatePanel>


    <asp:Panel ID="pnlWarning" runat="server" Visible="false"><p style="color:red"><b>!!! WARNING !!!</b>
        Performing an import for the selected set of tests<br />
        will <b>delete any existing test questions</b> and their associated images/diagrams<br />
        for <b><u>all tests</u></b> in the set.
    </p></asp:Panel>

    <p><asp:CheckBox ID="ckOverwrite" runat="server" AutoPostBack="true" Checked="false" Text="Overwrite all existing tests in this set?" /></p>

    <p>Test question data saved as a <b>TAB-DELIMITED TEXT FILE</b>: <asp:FileUpload ID="uplFile" runat="server"/>
    <asp:Button ID="btnImport" runat="server" Text="Import" onclick="btnImport_Click"/></p>

    <p>Use the Testing Maintenance page to attach images/diagrams for questions which need them.</p>

    Results/Errors:<br />
    <asp:ListBox ID="lstResults" runat="server" Rows="50" Width="800px" Enabled="false"  />

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
    <asp:SqlDataSource ID="sqlViewRegionalTestsList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionalTestsID, Description FROM RegionalTests WHERE StateID = @StateID OR StateID = 0 ORDER BY Description DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlRegionalTestsMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT RegionalTestsID, Description FROM RegionalTests WHERE RegionalTestsID=@RegionalTestsID" 
        DeleteCommand="DELETE FROM RegionalTests WHERE RegionalTestsID = @RegionalTestsID"
        InsertCommand="INSERT INTO RegionalTests (StateID, Description) VALUES (@StateID, @Description); SELECT @RegionalTestsID = SCOPE_IDENTITY()"
        UpdateCommand="UPDATE RegionalTests SET Description = @Description WHERE RegionalTestsID = @RegionalTestsID"
        OnInserted="sqlRegionalTestsMaint_Inserted" OnDeleted="sqlRegionalTestsMaint_Deleted" OnUpdated="sqlRegionalTestsMaint_Updated">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddRegionalTests" Name="RegionalTestsID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="RegionalTestsID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="RegionalTestsID" Direction="Output" Type="Int32"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Description" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
