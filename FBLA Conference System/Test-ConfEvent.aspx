<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Test-ConfEvent.aspx.cs" Inherits="FBLA_Conference_System.Test_ConfEvent" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0" width="920"><tr valign="middle">
        <td><h2>
            <asp:Label ID="lblConferenceName" runat="server"/><br />
            <asp:Label ID="lblEventName" runat="server"/>
        </h2></td>
        <td style="padding-left:20px">
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false"><ProgressTemplate>
                    <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate></asp:UpdateProgress>
        </td>
        <td align="right" style="color:White">
            <asp:UpdatePanel ID="updCountdown" runat="server"><ContentTemplate>
                <asp:Timer ID="Timer1" runat="server" Interval="10000" OnTick="Timer1_Tick" /> 
                Time remaining: <asp:Label ID="lblCountdown" runat="server" Text="60:00" /><br />
                Unanswered Questions remaining: <asp:Label ID="lblUnanswered" runat="server" />
            </ContentTemplate></asp:UpdatePanel>
        </td>
    </tr></table>

    <asp:UpdatePanel ID="updfvTestQuestions" runat="server"><ContentTemplate>
        <h3>Question <asp:Label ID="lblCurrentQuestion" runat="server"/> of <asp:Label ID="lblTotalQuestions" runat="server"/></h3>
        <asp:FormView ID="fvTestQuestions" runat="server" DataSourceID="sqlTestQuestions" DataKeyNames="RegionalTestsID,EventID"
            ForeColor="#333333" AllowPaging="True"
            OnDataBound="fvTestQuestions_DataBound">
            <ItemTemplate>
                <asp:Label ID="QuestionID" runat="server" Text='<%# Eval("QuestionID")%>' Visible="false"></asp:Label>
                <div style="min-height:275px"><table width="650px" cellpadding="4" cellspacing="0" style="font-size:12pt">
                    <col width="50px" /><col width="600px" />
                    <tr><td colspan="2"><%# Eval("Question")%><br /><asp:Image ID="QuestionImage" runat="server" ImageUrl='<%# "ImageHandler.ashx?id=" + Eval("QuestionID") %>' /></td></tr>
                    <tr>
                        <td><asp:RadioButton ID="AnswerChoice1" runat="server" AutoPostBack="true" OnCheckedChanged="AnswerChoice_Changed"
                            GroupName="AnswerChoices" Checked='<%# ((int)Eval("Response")==1)? true : false %>' /></td>
                        <td><%# Eval("AnswerChoice1") %></td>
                    </tr>
                    <tr>
                        <td><asp:RadioButton ID="AnswerChoice2" runat="server" AutoPostBack="true" OnCheckedChanged="AnswerChoice_Changed"
                            GroupName="AnswerChoices" Checked='<%# ((int)Eval("Response")==2)? true : false %>' /></td>
                        <td><%# Eval("AnswerChoice2") %></td>
                    </tr>
                    <tr>
                        <td><asp:RadioButton ID="AnswerChoice3" runat="server" AutoPostBack="true" OnCheckedChanged="AnswerChoice_Changed"
                            GroupName="AnswerChoices" Checked='<%# ((int)Eval("Response")==3)? true : false %>' /></td>
                        <td><%# Eval("AnswerChoice3") %></td>
                    </tr>
                    <tr>
                        <td><asp:RadioButton ID="AnswerChoice4" runat="server" AutoPostBack="true" OnCheckedChanged="AnswerChoice_Changed"
                            GroupName="AnswerChoices" Checked='<%# ((int)Eval("Response")==4)? true : false %>' /></td>
                        <td><%# Eval("AnswerChoice4") %></td>
                    </tr>
                    <tr valign="bottom">
                        <td><asp:RadioButton ID="AnswerChoice5" runat="server" AutoPostBack="true" OnCheckedChanged="AnswerChoice_Changed"
                            GroupName="AnswerChoices" Checked='<%# ((int)Eval("Response")==5)? true : false %>' /></td>
                        <td><br />Skip this question and return to it later.</td>
                    </tr>
                </table></div>
            </ItemTemplate>
        <PagerSettings Mode="NextPrevious" />
            <PagerTemplate>
                <table cellpadding="5" width="600px" style="margin-top:24px;font-size:20px;color:#707070;border-top:1px solid black">
                <tr valign="middle">
                    <td><asp:ImageButton ID="btnPrev" runat="server" CommandName="Page" CommandArgument="Prev" ImageUrl="~/img/btnPrev.png" Height="28px" /></td>
                    <td style="padding-bottom:13px">Previous</td>
                    <td style="padding-bottom:13px;text-align:right">Next</td>
                    <td><asp:ImageButton ID="btnNext" runat="server" CommandName="Page" CommandArgument="Next" ImageUrl="~/img/btnNext.png" Height="28px" /></td>
                    <td style="padding-bottom:13px;text-align:right">Next Unanswered</td>
                    <td><asp:ImageButton ID="btnUnanswered" runat="server" OnClick="btnUnanswered_Click" ImageUrl="~/img/btnNextUnanswered.png" Height="28px" /></td>
                    <td style="padding-bottom:13px;text-align:right">Finished</td>
                    <td><asp:ImageButton ID="btnFinished" runat="server" OnClick="btnFinished_Click" ImageUrl="~/img/btnFinished.png" Height="28px" /></td>
                </tr>
                </table>
            </PagerTemplate>
        </asp:FormView>
    </ContentTemplate></asp:UpdatePanel>

    <asp:Panel ID="pnlPopup" runat="server" CssClass="ModalWindow">
        <asp:UpdatePanel ID="updPopup" runat="server"><ContentTemplate>
            <div style="width:100%;text-align:center">
                <asp:Label ID="lblPopup" runat="server" Text="Are you sure you're ready to exit the test?" />
                <br /><br />
                <asp:Button ID="btnOK" runat="server" Text="Yes, I've finished" />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="No, return to the test" />
            </div>
            <asp:Button ID="btnShowPopup" runat="server" style="display:none" />
            <asp:ModalPopupExtender ID="popupErrorMsg" runat="server" BackgroundCssClass="ModalBackground"
                PopupControlID="pnlPopup" TargetControlID="btnShowPopup" CancelControlID="btnCancel"
                OkControlID="btnOK" OnOkScript="window.location.href='Test-Selection.aspx'" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

    <asp:SqlDataSource ID="sqlTestQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT Q.*, I.ImageType, R.Response FROM TestQuestions Q LEFT JOIN TestImages I ON Q.QuestionID=I.QuestionID INNER JOIN TestResponses R ON Q.QuestionID=R.QuestionID AND R.MemberID=@MemberID AND R.ConferenceID=@ConferenceID WHERE Q.RegionalTestsID=@RegionalTestsID AND Q.EventID=@EventID ORDER BY QuestionNumber">
        <SelectParameters>
            <asp:Parameter Name="RegionalTestsID" Type="Int32" />
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="EventID" Type="Int32" />
            <asp:Parameter Name="MemberID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlUnanswered" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="--Implemented in code behind">
        <SelectParameters>
            <asp:Parameter Name="ConferenceID" Type="Int32" />
            <asp:Parameter Name="MemberID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>