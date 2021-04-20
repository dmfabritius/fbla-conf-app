<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maint-Tests.aspx.cs" Inherits="FBLA_Conference_System.Maint_Tests" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Test Maintenance</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>

    <asp:Panel ID="pnlSelState" runat="server" BorderColor="Transparent" BorderWidth="3" Visible="false">
        <span style="display:inline-block;width:120px">Select a State:</span>
        <asp:DropDownList ID="ddStates" runat="server" Width="400px" AutoPostBack="true"
            DataSourceID="sqlViewStateList" DataTextField="StateName" DataValueField="StateID" 
            onselectedindexchanged="ddStates_SelectedIndexChanged"/>
    </asp:Panel>
    <asp:Panel ID="pnlSelRegionalTests" runat="server" BorderColor="Transparent" BorderWidth="3">
        <asp:UpdatePanel ID="updddRegionalTests" runat="server"><ContentTemplate>
            <span style="display:inline-block;width:120px">Select Tests:</span>
            <asp:DropDownList ID="ddRegionalTests" runat="server" Width="400px" AutoPostBack="true"
                DataSourceID="sqlViewRegionalTestsList" DataTextField="Description" DataValueField="RegionalTestsID" 
                ondatabound="ddRegionalTests_DataBound" onselectedindexchanged="ddRegionalTests_SelectedIndexChanged" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>
    <asp:Panel ID="pnlSelEvent" runat="server" BorderColor="Transparent" BorderWidth="3">
        <span style="display:inline-block;width:120px">Select an Event:</span>
        <asp:DropDownList ID="ddEvents" runat="server" Width="400px" AutoPostBack="true"
            DataSourceID="sqlViewEventList" DataTextField="EventName" DataValueField="EventID" 
            onselectedindexchanged="ddEvents_SelectedIndexChanged" />
    </asp:Panel>
    <br />

    <asp:FormView ID="fvTestQuestions" runat="server" DataSourceID="sqlTestQuestionMaint" DataKeyNames="QuestionID"
            ForeColor="#333333" AllowPaging="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-PageButtonCount="10"
            oniteminserting="fvTestQuestions_ItemInserting"
            onitemupdating="fvTestQuestions_ItemUpdating"
            ondatabound="fvTestQuestions_DataBound">
        <EmptyDataTemplate>
            <div style="padding-top:40px;border-top:1px solid black;font-style:italic"><b>There are currently no questions for this test.</b></div>
        </EmptyDataTemplate>
        <EditItemTemplate>
            <table cellpadding="4" cellspacing="0" style="background-color:White">
                <col width="175px" /><col width="550px" />
                <tr><td>Question Number:</td><td>
                    <asp:TextBox ID="EditQuestionNumber" runat="server" Width="50px" Text='<%# Bind("QuestionNumber") %>' /> 
                </td></tr>
                <tr class="altrow"><td>Question Type:</td><td>
                    <asp:DropDownList ID="ddQuestionType" runat="server" Width="150px" OnSelectedIndexChanged="ddQuestionType_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="1" Text="Multiple Choice" />
                        <asp:ListItem Value="2" Text="True/False" />
                    </asp:DropDownList>
                </td></tr>
                <tr valign="top"><td>Question:</td><td>
                    <asp:TextBox ID="EditQuestion" runat="server" Width="400px" TextMode="MultiLine" Wrap="True" Rows="4" Text='<%# Bind("Question") %>' />
                </td></tr>
                <tr valign="top" class="altrow"><td>Image/Diagram:</td><td>
                    <asp:FileUpload ID="uplFile" runat="server"/> (leave blank to keep any existing image)<br />
                    <asp:Image ID="QuestionImage" runat="server" ImageUrl='<%# "ImageHandler.ashx?id=" + Eval("QuestionID") %>' />
                </td></tr>
                <tr><td>Answer Choice #1:</td><td>
                    <asp:TextBox ID="AnswerChoice1" runat="server" Width="400px" Text='<%# Bind("AnswerChoice1") %>' />
                </td></tr>
                <tr class="altrow"><td>Answer Choice #2:</td><td>
                    <asp:TextBox ID="AnswerChoice2" runat="server" Width="400px" Text='<%# Bind("AnswerChoice2") %>' />
                </td></tr>
                <tr><td>Answer Choice #3:</td><td>
                    <asp:TextBox ID="AnswerChoice3" runat="server" Width="400px" Text='<%# Bind("AnswerChoice3") %>' />
                </td></tr>
                <tr class="altrow"><td>Answer Choice #4:</td><td>
                    <asp:TextBox ID="AnswerChoice4" runat="server" Width="400px" Text='<%# Bind("AnswerChoice4") %>' />
                </td></tr>
                <tr><td>Correct Answer:</td><td>
                    <asp:DropDownList ID="ddCorrectAnswer" runat="server" Width="150px">
                        <asp:ListItem Value="1" Text="Answer Choice #1" />
                        <asp:ListItem Value="2" Text="Answer Choice #2" />
                        <asp:ListItem Value="3" Text="Answer Choice #3" />
                        <asp:ListItem Value="4" Text="Answer Choice #4" />
                    </asp:DropDownList>
                </td></tr>
            </table>
            <div style="padding:5px 0">
                &nbsp;<asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="False" CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </div>
        </EditItemTemplate>
        <InsertItemTemplate>
            <table cellpadding="4" cellspacing="0" style="background-color:White">
                <col width="175px" /><col width="550px" />
                <tr><td>Question Number:</td><td>
                    <asp:TextBox ID="InsertQuestionNumber" runat="server" Width="50px" Text='<%# Bind("QuestionNumber") %>' /> 
                </td></tr>
                <tr class="altrow"><td>Question Type:</td><td>
                    <asp:DropDownList ID="ddQuestionType" runat="server" Width="150px" OnSelectedIndexChanged="ddQuestionType_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="1" Text="Multiple Choice" />
                        <asp:ListItem Value="2" Text="True/False" />
                    </asp:DropDownList>
                </td></tr>
                <tr valign="top"><td>Question:</td><td>
                    <asp:TextBox ID="InsertQuestion" runat="server" Width="400px" TextMode="MultiLine" Wrap="True" Rows="4" Text='<%# Bind("Question") %>' />
                </td></tr>
                <tr valign="top"><td>Image/Diagram:</td><td>[Edit question to optionally add an image after it has been inserted.]</td></tr>
                <tr><td>Answer Choice #1:</td><td>
                    <asp:TextBox ID="AnswerChoice1" runat="server" Width="400px" Text='<%# Bind("AnswerChoice1") %>' />
                </td></tr>
                <tr class="altrow"><td>Answer Choice #2:</td><td>
                    <asp:TextBox ID="AnswerChoice2" runat="server" Width="400px" Text='<%# Bind("AnswerChoice2") %>' />
                </td></tr>
                <tr><td>Answer Choice #3:</td><td>
                    <asp:TextBox ID="AnswerChoice3" runat="server" Width="400px" Text='<%# Bind("AnswerChoice3") %>' />
                </td></tr>
                <tr class="altrow"><td>Answer Choice #4:</td><td>
                    <asp:TextBox ID="AnswerChoice4" runat="server" Width="400px" Text='<%# Bind("AnswerChoice4") %>' />
                </td></tr>
                <tr><td>Correct Answer:</td><td>
                    <asp:DropDownList ID="ddCorrectAnswer" runat="server" Width="150px">
                        <asp:ListItem Value="1" Text="Answer Choice #1" />
                        <asp:ListItem Value="2" Text="Answer Choice #2" />
                        <asp:ListItem Value="3" Text="Answer Choice #3" />
                        <asp:ListItem Value="4" Text="Answer Choice #4" />
                    </asp:DropDownList>
                </td></tr>
            </table>
            <div style="padding:5px 0">
                &nbsp;<asp:LinkButton ID="InsertButton" runat="server" CausesValidation="False" CommandName="Insert" Text="Insert" />
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </div>
        </InsertItemTemplate>
        <ItemTemplate>
            <table cellpadding="4" cellspacing="0" style="background-color:White">
                <col width="175px" /><col width="700px" />
                <tr><td>Question Number:</td><td class="data"><%# Eval("QuestionNumber")%></td></tr>
                <tr class="altrow"><td>Question Type:</td><td class="data"><%# (Eval("QuestionType").ToString()=="1")? "Multiple Choice":"True/False" %></td></tr>
                <tr valign="top"><td>Question:</td><td class="data"><%# Eval("Question")%></td></tr>
                <tr valign="top" class="altrow"><td>Image/Diagram:</td><td class="data">
                    <asp:Button ID="RemoveImage" runat="server" Text="Remove" OnClick="RemoveImage_Click" /><br />
                    <asp:Image ID="QuestionImage" runat="server" ImageUrl='<%# "ImageHandler.ashx?id=" + Eval("QuestionID") %>' />
                </td></tr>
                <tr><td>Choice #1:</td><td class="data"><%# Eval("AnswerChoice1")%></td></tr>
                <tr class="altrow"><td>Choice #2:</td><td class="data"><%# Eval("AnswerChoice2")%></td></tr>
                <tr><td>Choice #3:</td><td class="data"><%# Eval("AnswerChoice3")%></td></tr>
                <tr class="altrow"><td>Choice #4:</td><td class="data"><%# Eval("AnswerChoice4")%></td></tr>
                <tr><td>Correct Answer:</td><td class="data"><%# Eval("CorrectAnswer")%></td></tr>

            </table>
            <div style="padding:5px 0">
                &nbsp;<asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"
                    OnClientClick="javascript:return confirm('Are you sure you want to delete this question?')"/>
                &nbsp;<asp:LinkButton ID="InsertButton" runat="server" CausesValidation="False" onclick="btnAdd_Click" Text="Add New" />
            </div>
        </ItemTemplate>
        <RowStyle BackColor="#CCCCCC" ForeColor="#222222" />
        <PagerStyle BackColor="#5D7B9D" Font-Size="Large" Font-Bold="True" ForeColor="White" />
    </asp:FormView>

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
    <asp:SqlDataSource ID="sqlViewEventList" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT EventID, EventName FROM NationalEvents WHERE isInactive=0 AND EventType <> 'N' ORDER BY EventName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sqlTestQuestionMaint" runat="server" ConnectionString="<%$ ConnectionStrings:ConfDB %>" 
        SelectCommand="SELECT Q.*, I.ImageType FROM TestQuestions Q LEFT JOIN TestImages I ON Q.QuestionID=I.QuestionID  WHERE RegionalTestsID=@RegionalTestsID AND EventID=@EventID ORDER BY QuestionNumber" 
        InsertCommand="INSERT INTO TestQuestions (RegionalTestsID, EventID, QuestionNumber, QuestionType, CorrectAnswer, Question, AnswerChoice1, AnswerChoice2, AnswerChoice3, AnswerChoice4) VALUES (@RegionalTestsID, @EventID, @QuestionNumber, @QuestionType, @CorrectAnswer, @Question, @AnswerChoice1, @AnswerChoice2, @AnswerChoice3, @AnswerChoice4)"
        UpdateCommand="UPDATE TestQuestions SET QuestionNumber=@QuestionNumber, QuestionType=@QuestionType, CorrectAnswer=@CorrectAnswer, Question=@Question, AnswerChoice1=@AnswerChoice1, AnswerChoice2=@AnswerChoice2, AnswerChoice3=@AnswerChoice3, AnswerChoice4=@AnswerChoice4 WHERE QuestionID=@QuestionID"
        DeleteCommand="DELETE FROM TestQuestions WHERE QuestionID=@QuestionID">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddRegionalTests" Name="RegionalTestsID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="ddRegionalTests" Name="RegionalTestsID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="ddEvents" Name="EventID" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="QuestionNumber" Type="Int32" />
            <asp:Parameter Name="QuestionType" Type="Int32" />
            <asp:Parameter Name="CorrectAnswer" Type="Int32" />
            <asp:Parameter Name="Question" Type="String" />
            <asp:Parameter Name="AnswerChoice1" Type="String" />
            <asp:Parameter Name="AnswerChoice2" Type="String" />
            <asp:Parameter Name="AnswerChoice3" Type="String" />
            <asp:Parameter Name="AnswerChoice4" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="QuestionID" Type="Int32" />
            <asp:Parameter Name="QuestionNumber" Type="Int32" />
            <asp:Parameter Name="QuestionType" Type="Int32" />
            <asp:Parameter Name="CorrectAnswer" Type="Int32" />
            <asp:Parameter Name="Question" Type="String" />
            <asp:Parameter Name="AnswerChoice1" Type="String" />
            <asp:Parameter Name="AnswerChoice2" Type="String" />
            <asp:Parameter Name="AnswerChoice3" Type="String" />
            <asp:Parameter Name="AnswerChoice4" Type="String" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="QuestionID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
