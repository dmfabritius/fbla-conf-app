<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-ConfHotels.aspx.cs" Inherits="FBLA_Conference_System.Rpt_ConfHotels" %>

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
                &nbsp;<asp:Button ID="btnUpdate" runat="server" Text="Submit Packages" onclick="btnUpdate_Click" />
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
    <div><asp:HyperLink ID="lnkGenerateHotelInvoice" runat="server" Target="_blank" NavigateUrl="~/HotelInvoice.aspx">Click here</asp:HyperLink>
    to view the hotel packages invoice for this chapter for printing or saving.</div>
    <div style="color:red">The total number of packages should equal the total number of people attending<br/>the conference (including students, advisers, and chaperones).</div>
    <br />

    <asp:UpdatePanel ID="updHotelPackages" runat="server"><ContentTemplate>
        <asp:GridView ID="gvHotelPackages" runat="server" DataSourceID="sqlConfChapHotels" DataKeyNames="HotelPackageID"
            AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" ForeColor="#333333" AllowSorting="false" GridLines="None">
            <Columns>
                <asp:BoundField DataField="HotelPackageID" ReadOnly="true" Visible="false" />
                <asp:BoundField DataField="PackageDesc" HeaderText="Package Description" ReadOnly="true" ItemStyle-Width="350px" />
                <asp:BoundField DataField="PackagePrice" HeaderText="Package Price" ItemStyle-HorizontalAlign="Center" ReadOnly="true" DataFormatString="{0:C}" />
                <asp:TemplateField HeaderText="# Packages" ItemStyle-HorizontalAlign="Center"><ItemTemplate>
                    <asp:TextBox ID="EditObj" runat="server" Text='<%# Bind("Amount") %>' Width="50px"
                        onchange="this.style.backgroundColor='#d9e9ff'" />
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

    <asp:SqlDataSource ID="sqlConfChapHotels" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT CHP.HotelPackageID, CHP.PackageDesc, CHP.PackagePrice, ISNULL(CCH.Amount,0) Amount FROM ConferenceHotelPackages CHP LEFT JOIN ConferenceChapterHotels CCH ON CHP.HotelPackageID=CCH.HotelPackageID AND CCH.ChapterID=@ChapterID WHERE CHP.ConferenceID=@ConferenceID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddConferences" Name="ConferenceID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddChapters" Name="ChapterID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
