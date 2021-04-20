<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Conf-Chaperones.aspx.cs" Inherits="FBLA_Conference_System.Conf_Chaperones" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conference Advisers/Chaperones</h2></td><td style="padding-left:20px">
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
    As a general guideline, there should be a chaperone for every<br />
    15 students at a regional conference, 10 at state, and 7 at nationals.<br />
    <br />
    <asp:UpdatePanel ID="updChaperones" runat="server"><ContentTemplate><asp:Panel ID="pnlChaperones" runat="server">
        <table id="AttendanceCount">
            <tr><th colspan="2" style="border-bottom:1px solid #808080">Selected chapter's attendance for this conference</th></tr>
            <tr>
                <td style="width:100px">Students:</td>
                <td><asp:Label ID="lblNumberOfStudents" runat="server"/></td>
            </tr>
            <tr>
                <td>Chaperones:</td>
                <td><asp:Label ID="lblNumberOfChaperones" runat="server"/></td>
            </tr>
        </table>
        <br />
        <asp:GridView ID="gvChaperoneMaint" runat="server" DataSourceID="sqlChaperoneMaint" DataKeyNames="ChaperoneID"
            CellPadding="4" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None" ShowHeaderWhenEmpty="True"
            ondatabound="gvChaperoneMaint_DataBound" onrowcommand="gvChaperoneMaint_RowCommand"> 
            <EmptyDataTemplate>
                <div style="padding-top:15px;width:100%"><b><i>This chapter currently has no chaperones. Please note that advisers must be added as conference chaperones.</i></b></div>
            </EmptyDataTemplate>
            <Columns>
                <asp:TemplateField ShowHeader="False" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <br />&nbsp;<asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Add" Font-Bold="false"
                            CausesValidation="True" ValidationGroup="vgrpInsertChaperone"/>
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Remove"
                            OnClientClick="javascript:return confirm('Are you sure you want to remove this chaperone?')"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div>Type</div>
                        <asp:DropDownList ID="ddType" runat="server">
                            <asp:ListItem Value="A" Text="Adviser" />
                            <asp:ListItem Value="C" Text="Chaperone" />
                        </asp:DropDownList>
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:Label ID="ChaperoneType" runat="server" Text='<%# Eval("ChaperoneType") %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div>Name</div><asp:TextBox ID="InsertChaperoneName" runat="server"/>
                        <asp:MaskedEditExtender ID="maskInsertChaperoneName" runat="server"
                            TargetControlID="InsertChaperoneName" Mask="?{50}" MaskType="None" PromptCharacter=" " AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertChaperoneName" runat="server" ValidationGroup="vgrpInsertChaperone" ForeColor="Red" Font-Bold="false"
                            ControlToValidate="InsertChaperoneName" ControlExtender="maskInsertChaperoneName"
                            IsValidEmpty="false" EmptyValueBlurredText="<br>Please enter a name(first and last)<br>for the adviser/chaperone." />
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:Label ID="ChaperoneName" runat="server" Text='<%# Eval("ChaperoneName") %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div>Cell Phone</div><asp:TextBox ID="InsertChaperoneCell" runat="server" Width="100px"/>
                        <asp:MaskedEditExtender ID="maskInsertChaperoneCell" runat="server"
                            TargetControlID="InsertChaperoneCell" Mask="(999) 999-9999" MaskType="None" ClearMaskOnLostFocus="false" AutoComplete="false"
                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditInvalid" />
                        <asp:MaskedEditValidator ID="vldInsertChaperoneCell" runat="server" ValidationGroup="vgrpInsertChaperone" ForeColor="Red" Font-Bold="false"
                            ControlToValidate="InsertChaperoneCell" ControlExtender="maskInsertChaperoneCell"
                            ValidationExpression="\([2-9][0-9]{2}\) [0-9]{3}-[0-9]{4}" InvalidValueBlurredMessage="<br>Please enter a valid<br>phone number."
                            IsValidEmpty="false" EmptyValueBlurredText="<br>Please enter a valid<br>phone number." />
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:Label ID="ChaperoneCell" runat="server" Text='<%# Eval("ChaperoneCell") %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div>Shirt Size</div>
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
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:Label ID="ShirtSize" runat="server" Text='<%# Eval("ShirtSize") %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                    <HeaderTemplate>
                        <div>Join BEA?</div>
                        <asp:DropDownList ID="ddJoinBEA" runat="server">
                            <asp:ListItem Value="0" Text="No" />
                            <asp:ListItem Value="1" Text="Yes" />
                        </asp:DropDownList>
                    </HeaderTemplate>
                    <ItemTemplate>
                        &nbsp;<asp:Label ID="JoinBEA" runat="server" Text='<%# ((int)Eval("JoinBEA") == 0)? "No" : "Yes" %>'/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#BBBBBB" VerticalAlign="Top" />
            <RowStyle BackColor="White" ForeColor="#333333" />
            <AlternatingRowStyle BackColor="#E8F0F0" ForeColor="#284775" />
        </asp:GridView>
    </asp:Panel></ContentTemplate></asp:UpdatePanel>

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
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE (StateID = @StateID OR StateID = 0) AND (RegionID = @RegionID OR RegionID = 0) AND ConferenceDate >= CONVERT(date, GETDATE()) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlChaperoneMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM ConferenceChapterChaperones WHERE ConferenceID = @ConferenceID AND ChapterID = @ChapterID"
        InsertCommand="INSERT INTO ConferenceChapterChaperones (ChapterID, ConferenceID, ChaperoneType, ChaperoneName, ChaperoneCell, ShirtSize, JoinBEA) VALUES (@ChapterID, @ConferenceID, @ChaperoneType, @ChaperoneName, @ChaperoneCell, @ShirtSize, @JoinBEA)" 
        UpdateCommand="--not yet implemented--UPDATE ConferenceChapterChaperones SET ChaperoneType=@ChaperoneType, ChaperoneName=@ChaperoneName, ChaperoneCell=@ChaperoneCell, ShirtSize=@ShirtSize WHERE ChaperoneID=@ChaperoneID"
        DeleteCommand="DELETE FROM ConferenceChapterChaperones WHERE ChaperoneID=@ChaperoneID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="ChaperoneType" Type="String" />
            <asp:Parameter Name="ChaperoneName" Type="String" />
            <asp:Parameter Name="ChaperoneCell" Type="String" />
            <asp:Parameter Name="ShirtSize" Type="String" />
            <asp:Parameter Name="JoinBEA" Type="Int32" />
        </InsertParameters>
        <DeleteParameters>
            <asp:Parameter Name="ChaperoneID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
