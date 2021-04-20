<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Judge-ScoreEntry.aspx.cs"
    Inherits="FBLA_Conference_System.Judge_ScoreEntry" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        function rangeCheck(obj, max) {
            calcScore()
            obj.style.backgroundColor = '#d9e9ff'
            if (max < 0) {
                if (obj.value == 0 || obj.value == max) {
                    obj.style.backgroundColor = '#d9e9ff'
                    return true
                } else {
                    obj.style.backgroundColor = '#ffd0d0'
                    alert("Scores for penalty criteria should be zero/blank or the penalty amount indicated.")
                    return false
                }
            } else {
                if (obj.value >= 0 & obj.value <= max) {
                    obj.style.backgroundColor = '#d9e9ff'
                    return true
                } else {
                    obj.style.backgroundColor = '#ffd0d0'
                    alert("Please enter a score within the range indicated.")
                    return false
                }
            }
        }
        function calcScore() {
            var i = 0;
            var t = 0;
            var x = 0;
            do {
                o = document.getElementById("MainContent_gvPerfScores_EditScore_" + i)
                if (o==null) {
                    x++;
                } else {
                    t += 1*o.value
                    x = 0
                }
                i++
            } while (x < 2)
            document.getElementById("MainContent_gvPerfScores_TotalScore").innerHTML = t
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0">
        <tr><td><h2>
            <asp:Label ID="lblConferenceName" runat="server"/><br />
            <asp:Label ID="lblEventName" runat="server"/>
        </h2></td>
        <td style="padding-left:20px">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
                <ProgressTemplate>
                    <img src="img/activity.gif" alt="activity" /> accessing database...
                </ProgressTemplate>
            </asp:UpdateProgress>
    </td></tr></table>

    <asp:Panel ID="pnlCompetitors" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddCompetitors" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:140px">Select a student/team:</span>
            <asp:DropDownList ID="ddCompetitors" runat="server" AutoPostBack="true"
                DataTextField="Competitor" DataValueField="MemberID"
                OnSelectedIndexChanged="ddCompetitors_SelectedIndexChanged" />
            &nbsp;<asp:Button ID="btnUpdate" runat="server" onclick="btnUpdate_Click"
                Text="Submit score for this student/team" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <br />
    <asp:UpdatePanel ID="updPerfScores" runat="server"><ContentTemplate>
        <asp:GridView ID="gvPerfScores" runat="server" DataSourceID="sqlPerfScoresMaint" DataKeyNames="PerfCriteriaID,JudgeID,MemberID"
            AutoGenerateColumns="False" CellPadding="4" CellSpacing="1" ForeColor="#333333" AllowSorting="false" GridLines="None" ShowFooter="true"
            OnRowDataBound="gvEventScores_RowDataBound">
            <Columns>
                <asp:BoundField DataField="Criteria" HeaderText="Criteria" ReadOnly="true" />
                <asp:TemplateField HeaderText="Range" ItemStyle-HorizontalAlign="Center" FooterText="Total Score:" FooterStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Label ID="lblRange" runat="server" Width="75px"
                            Text='<%# ((int)Eval("Weight") > 0)? "0 - " + Eval("Weight") : Eval("Weight") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Score" ItemStyle-HorizontalAlign="Center" FooterStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:TextBox ID="EditScore" runat="server" Width="50px" Text='<%# Bind("Response") %>'
                            onchange="return rangeCheck(this,'*** set in code-behind ***'" />
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:Label ID="TotalScore" runat="server" Text="-0-" />
                    </FooterTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        </asp:GridView>
    </ContentTemplate></asp:UpdatePanel>
    <br />
    <asp:UpdatePanel ID="updPerfComments" runat="server"><ContentTemplate>
        <asp:FormView ID="fvPerfComments" runat="server" CellPadding="6" DefaultMode="Edit"
            DataKeyNames="JudgeID,MemberID" DataSourceID="sqlPerfCommentsMaint" ForeColor="#333333">
            <EditItemTemplate>
                &nbsp; Comments:<br />
                &nbsp; <asp:TextBox ID="CommentsTextBox" runat="server" Width="800px" TextMode="MultiLine" Rows="8"
                    Text='<%# Bind("PerfComments") %>' onchange="this.style.backgroundColor='#d9e9ff'" /> &nbsp;
                <br />&nbsp;
            </EditItemTemplate>
            <EditRowStyle BackColor="#cccccc" />
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
        
    <asp:SqlDataSource ID="sqlPerfScoresMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="select c.PerfCriteriaID, c.Criteria, c.Weight, r.JudgeID, r.MemberID, r.Response from JudgeCriteria c left join JudgeResponses r on c.PerfCriteriaID=r.PerfCriteriaID and r.JudgeID=@JudgeID and r.MemberID=@MemberID where c.EventID=@EventID order by c.SortOrder"
        UpdateCommand="update JudgeResponses set Response=@Response where PerfCriteriaID=@PerfCriteriaID and JudgeID=@JudgeID and MemberID=@MemberID">
        <SelectParameters>
            <asp:Parameter Name="EventID" Type="Int32" />
            <asp:Parameter Name="JudgeID" Type="Int32" />
            <asp:ControlParameter ControlID="ddCompetitors" Name="MemberID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Response" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlPerfCommentsMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>"
        SelectCommand="SELECT * FROM JudgeComments WHERE JudgeID=@JudgeID and MemberID=@MemberID"
        UpdateCommand="UPDATE JudgeComments SET PerfComments=@PerfComments WHERE JudgeID=@JudgeID and MemberID=@MemberID">
        <SelectParameters>
            <asp:Parameter Name="JudgeID" Type="Int32" />
            <asp:ControlParameter ControlID="ddCompetitors" Name="MemberID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="PerfComments" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
