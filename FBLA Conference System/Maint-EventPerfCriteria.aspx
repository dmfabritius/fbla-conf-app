<%@ Page EnableEventValidation="false" Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Maint-EventPerfCriteria.aspx.cs" Inherits="FBLA_Conference_System.Maint_EventPerfCriteria" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Performance Event Judging Criteria</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>

    <asp:Panel ID="pnlSelEvent" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddEvents" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select an Event:</span>
            <asp:DropDownList ID="ddEvents" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewEventList" DataTextField="EventName" DataValueField="EventID" 
                onselectedindexchanged="ddEvents_SelectedIndexChanged" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <br />
    <asp:Button ID="btnAddCriteria" runat="server" Text=" Add Criteria " onclick="btnAddCriteria_Click" />
    <asp:UpdatePanel ID="updPerfCriteria" runat="server"><ContentTemplate><asp:Panel ID="pnlPerfCriteria" runat="server">
        <asp:GridView ID="gvPerfCriteriaMaint" runat="server" DataSourceID="sqlPerfCriteriaMaint" DataKeyNames="PerfCriteriaID"
            CellPadding="4" CellSpacing="1" ForeColor="#333333" AutoGenerateColumns="False" GridLines="None">
            <Columns>
                <asp:TemplateField ShowHeader="False" ItemStyle-Width="80px">
                    <EditItemTemplate>
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" />
                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                            OnClientClick="javascript:return confirm('Are you sure you want to delete this criteria?')"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sort Order" ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center" SortExpression="SortOrder">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditSortOrder" runat="server" Width="50px" Text='<%# Bind("SortOrder") %>'/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("SortOrder") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Weight" ItemStyle-Width="75px" ItemStyle-HorizontalAlign="Center" SortExpression="Weight">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditWeight" runat="server" Width="50px" Text='<%# Bind("Weight") %>'/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("Weight") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Criteria" SortExpression="Criteria">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditCriteria" runat="server" TextMode="MultiLine" Rows="2" Width="590px" Text='<%# Bind("Criteria") %>'/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Width="600px" Text='<%# Eval("Criteria") %>'></asp:Label>
                    </ItemTemplate>
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
        
    <asp:SqlDataSource ID="sqlViewEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID, EventName FROM NationalEvents WHERE isInactive=0 AND ISNULL(PerformanceWeight,0) <> 0 ORDER BY EventName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPerfCriteriaMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM JudgeCriteria WHERE EventID=@EventID ORDER BY SortOrder"
        InsertCommand="INSERT INTO JudgeCriteria (EventID, Criteria) VALUES (@EventID, @Criteria)" 
        UpdateCommand="UPDATE JudgeCriteria SET SortOrder=@SortOrder, Weight=@Weight, Criteria=@Criteria WHERE PerfCriteriaID=@PerfCriteriaID"
        DeleteCommand="DELETE FROM JudgeCriteria WHERE PerfCriteriaID=@PerfCriteriaID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="Criteria" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="SortOrder" Type="Int32" />
            <asp:Parameter Name="Weight" Type="Int32" />
            <asp:Parameter Name="Criteria" Type="String" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="PerfCriteriaID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
