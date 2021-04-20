<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rpt-ConfInvoice.aspx.cs" Inherits="FBLA_Conference_System.Rpt_ConfInvoice" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Conference Invoices &amp; Attendance</h2></td><td style="padding-left:20px">
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
    <br />

    <asp:TabContainer ID="tabsConference" runat="server" CssClass="gray">
        <asp:TabPanel ID="tabInvoiceSummary" runat="server" HeaderText="Invoice Summary"><ContentTemplate>
            <asp:UpdatePanel ID="updInvoiceSummary" runat="server"><ContentTemplate>
                <div style="padding-top:15px;border-top:1px solid #808080">
                    <asp:HyperLink ID="lnkGenerateInvoice" runat="server" Target="_blank" NavigateUrl="~/Invoice.aspx">Click here</asp:HyperLink>
                    to view the invoice for the selected chapter for printing or saving
                </div><br />
                <asp:GridView ID="gvConferenceChapters" runat="server" DataKeyNames="ChapterID" ShowFooter="True"
                    CellPadding="5" CellSpacing="1" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" 
                    ondatabinding="gvConferenceChapters_DataBinding"
                    ondatabound="gvConferenceChapters_DataBound"
                    onrowdatabound="gvConferenceChapters_RowDataBound" 
                    onselectedindexchanged="gvConferenceChapters_SelectedIndexChanged">
                    <Columns>
                        <asp:TemplateField ShowHeader="False"><ItemTemplate>
                            <asp:LinkButton ID="SelectButton" runat="server" CausesValidation="False" CommandName="Select" Text="Select"/>
                        </ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" ItemStyle-Width="250px"
                            ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Left" FooterStyle-HorizontalAlign="Left" />
                        <asp:BoundField DataField="NumStudents" HeaderText="Number of Students" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="ConferenceStudentFee" HeaderText="Student Fee" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="StuSubtotal" HeaderText="Student Subtotal" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="NumChaps" HeaderText="Number of Adv/Chaps" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="ConferenceAdviserFee" HeaderText="Adv/Chap Fee" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="AdvSubtotal" HeaderText="Adv/Chap Subtotal" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" ItemStyle-Width="100px" />
                    </Columns>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" HorizontalAlign="Center" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" VerticalAlign="Bottom" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
        <asp:TabPanel ID="tabAttendanceSummary" runat="server" HeaderText="Attendance List"><ContentTemplate>
            <asp:UpdatePanel ID="updAttendanceSummary" runat="server"><ContentTemplate>
                <div style="padding-top:15px;border-top:1px solid #808080">
                    To create name badges using the mail merge feature in Word, copy the contents of the<br />
                    table below and paste it into Excel; then save the file and use it as your data source.
                </div><br />
                <asp:GridView ID="gvAttendanceSummary" runat="server"
                    CellPadding="4" ForeColor="#333333" AutoGenerateColumns="false" AllowSorting="True" GridLines="None"
                    ondatabinding="gvAttendanceSummary_DataBinding"
                    onSorting="gvAttendanceSummary_Sorting">
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"/>
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333"/>
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775"/>
                    <EmptyDataTemplate>
                        <div style="padding-top:15px;border-top:1px solid #808080;font-weight:bold;font-style:italic">There are no  students attending this conference.</div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="RegionName" HeaderText="Region Name" SortExpression="RegionName,ChapterName,Attendee,LastName,FirstName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="200px" />
                        <asp:BoundField DataField="ChapterName" HeaderText="Chapter Name" SortExpression="ChapterName,Attendee,LastName,FirstName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="250px" />
                        <asp:BoundField DataField="Attendee" HeaderText="Attendee Type" SortExpression="Attendee,RegionName,ChapterName,LastName,FirstName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName,LastName,RegionName,ChapterName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName,FirstName,RegionName,ChapterName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="ShirtSize" HeaderText="Shirt Size" SortExpression="ShirtSize,RegionName,ChapterName,Attendee,LastName,FirstName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" />
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#F2F0EA" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </ContentTemplate></asp:UpdatePanel>
        </ContentTemplate></asp:TabPanel>
    </asp:TabContainer>

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
        SelectCommand="SELECT ConferenceID, ConferenceName FROM Conferences WHERE (StateID=@StateID OR StateID=0) AND (RegionID=@RegionID OR RegionID=0) ORDER BY ConferenceDate DESC">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddStates" Name="StateID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddRegions" Name="RegionID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>