<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Event.aspx.cs" Inherits="FBLA_Conference_System.Maint_Event" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Event Maintenance</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>

    <asp:UpdatePanel ID="updgvEventMaint" runat="server"><ContentTemplate>
        <asp:Button ID="btnAddEvent" runat="server" Text=" Add Event " onclick="btnAddEvent_Click" />
        <asp:GridView ID="gvEventMaint" runat="server" DataSourceID="sqlEventMaint" DataKeyNames="EventID"
            AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" ForeColor="#333333" GridLines="None" AllowSorting="True" 
            onrowdatabound="gvEventMaint_RowDataBound" onrowcommand="gvEventMaint_RowCommand">
            <Columns>
                <asp:TemplateField ShowHeader="False" ItemStyle-Width="35px">
                    <EditItemTemplate>
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" />
                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                        <!--
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                            OnClientClick="javascript:return confirm('Are you sure you want to delete this event?')"/>
                        -->
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Event Name" ItemStyle-Width="250px" SortExpression="EventName">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditEventName" runat="server" Width="95%" Text='<%# Bind("EventName") %>'/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("EventName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Active" ItemStyle-HorizontalAlign="Center" SortExpression="isInactive">
                    <EditItemTemplate><asp:DropDownList ID="ddInactive" runat="server"><asp:ListItem Value="0" Text="Yes" /><asp:ListItem Value="1" Text="No" /></asp:DropDownList></EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# ((int)Eval("isInactive")==0)? "Y" : "-" %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Type" ItemStyle-HorizontalAlign="Center" SortExpression="EventType"
                    ItemStyle-Width="75px">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddTeamEvent" runat="server">
                            <asp:ListItem Value="I" Text="Indv" />
                            <asp:ListItem Value="T" Text="Team" />
                            <asp:ListItem Value="C" Text="Chp" />
                            <asp:ListItem Value="N" Text="N/C" />
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("EventType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Min" ItemStyle-HorizontalAlign="Center" SortExpression="MinTeamSize">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddMinTeamSize" runat="server">
                            <asp:ListItem Value="1"/>
                            <asp:ListItem Value="2"/>
                            <asp:ListItem Value="3"/>
                            <asp:ListItem Value="4"/>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# ((string)Eval("EventType")!="T")? "" : Eval("MinTeamSize") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Max" ItemStyle-HorizontalAlign="Center" SortExpression="MaxTeamSize">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddMaxTeamSize" runat="server">
                            <asp:ListItem Value="1"/>
                            <asp:ListItem Value="2"/>
                            <asp:ListItem Value="3"/>
                            <asp:ListItem Value="4"/>
                            <asp:ListItem Value="5"/>
                            <asp:ListItem Value="6"/>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# ((string)Eval("EventType")!="T")? "" : Eval("MaxTeamSize") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Upper" ItemStyle-HorizontalAlign="Center" SortExpression="isUpperclassmen">
                    <EditItemTemplate><asp:DropDownList ID="ddUpperclassmen" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# ((int)Eval("isUpperclassmen")==0)? "" : "Y" %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lower" ItemStyle-HorizontalAlign="Center" SortExpression="isLowerclassmen">
                    <EditItemTemplate><asp:DropDownList ID="ddLowerclassmen" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# ((int)Eval("isLowerclassmen")==0)? "" : "Y" %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Plus 1" ItemStyle-HorizontalAlign="Center" SortExpression="isPlusOne">
                    <EditItemTemplate><asp:DropDownList ID="ddPlusOne" runat="server"><asp:ListItem Value="1" Text="Yes" /><asp:ListItem Value="0" Text="No" /></asp:DropDownList></EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label8" runat="server" Text='<%# ((int)Eval("isPlusOne")==0)? "" : "Y" %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="%<br/>Obj" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" SortExpression="ObjectiveWeight">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditObjectiveWeight" runat="server" Text='<%# Bind("ObjectiveWeight") %>' Width="30px"/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("ObjectiveWeight") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="%<br/>Perf" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" SortExpression="PerformanceWeight">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditPerformanceWeight" runat="server" Text='<%# Bind("PerformanceWeight") %>' Width="30px"/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("PerformanceWeight") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="%<br/>Home" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" SortExpression="HomesiteWeight">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditHomesiteWeight" runat="server" Text='<%# Bind("HomesiteWeight") %>' Width="30px"/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("HomesiteWeight") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Prep" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" SortExpression="PrepTime">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditPrepTime" runat="server" Text='<%# Bind("PrepTime") %>' Width="30px"/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Eval("PrepTime") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Perf" ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" SortExpression="PerfTime">
                    <EditItemTemplate>
                        <asp:TextBox ID="EditPerfTime" runat="server" Text='<%# Bind("PerfTime") %>' Width="30px"/>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label13" runat="server" Text='<%# Eval("PerfTime") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Day" ItemStyle-HorizontalAlign="Center" SortExpression="PerfDay">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddPerfDay" runat="server">
                            <asp:ListItem Value="1"/>
                            <asp:ListItem Value="2"/>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label14" runat="server" Text='<%# Eval("PerfDay") %>'></asp:Label>
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

    <asp:SqlDataSource ID="sqlEventMaint" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT * FROM NationalEvents ORDER BY EventName" 
        DeleteCommand="UPDATE NationalEvents SET isInactive=1 WHERE EventID = @EventID" 
        InsertCommand="INSERT INTO NationalEvents (EventName, EventType) VALUES (@EventName, @EventType)"
        UpdateCommand="UPDATE NationalEvents SET EventName=@EventName,EventType=@EventType,MinTeamSize=@MinTeamSize,MaxTeamSize=@MaxTeamSize,isUpperclassmen=@isUpperclassmen,isLowerclassmen=@isLowerclassmen,isPlusOne=@isPlusOne,ObjectiveWeight=@ObjectiveWeight,PerformanceWeight=@PerformanceWeight,HomesiteWeight=@HomesiteWeight,isInactive=@isInactive,PrepTime=@PrepTime,PerfTime=@PerfTime,PerfDay=@PerfDay WHERE EventID=@EventID">
        <DeleteParameters>
            <asp:Parameter Name="EventID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="EventName" Type="String" />
            <asp:Parameter Name="EventType" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="EventID" Type="Int32" />
            <asp:Parameter Name="EventName" Type="String" />
            <asp:Parameter Name="EventType" Type="String" />
            <asp:Parameter Name="MinTeamSize" Type="Int32" />
            <asp:Parameter Name="MaxTeamSize" Type="Int32" />
            <asp:Parameter Name="isUpperclassmen" Type="Int32" />
            <asp:Parameter Name="isLowerclassmen" Type="Int32" />
            <asp:Parameter Name="isPlusOne" Type="Int32" />
            <asp:Parameter Name="ObjectiveWeight" Type="Int32" />
            <asp:Parameter Name="PerformanceWeight" Type="Int32" />
            <asp:Parameter Name="HomesiteWeight" Type="Int32" />
            <asp:Parameter Name="isInactive" Type="Int32" />
            <asp:Parameter Name="PrepTime" Type="Int32" />
            <asp:Parameter Name="PerfTime" Type="Int32" />
            <asp:Parameter Name="PerfDay" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
