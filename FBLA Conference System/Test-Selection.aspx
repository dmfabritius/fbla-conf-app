<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Test-Selection.aspx.cs" Inherits="FBLA_Conference_System.Test_Selection" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <table style="margin: 0 0 20px 0;padding:0" cellpadding="0" cellspacing="0"><tr valign="middle">
        <td><h2>Test Selection</h2></td><td style="padding-left:20px">
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="100" DynamicLayout="false">
            <ProgressTemplate>
                <img src="img/activity.gif" alt="activity" /> accessing database...
            </ProgressTemplate>
        </asp:UpdateProgress>
    </td></tr></table>
    <ul>
        <li>You have <b>60 minutes</b> to complete each test.</li>
        <li>If you are taking multiple tests, you do <i>not</i> have to complete them all in a single session.</li>
        <li>Once started, you <i>cannot</i> pause or leave a test and then come back to continue at a later time.</li>
        <li>If you experience Internet connectivity issues or get disconnected, you can refresh your browser<br />or immediately sign back in to continue your progress.</li>
        <li>Be sure to <b>click the 'Finished' button</b> when you have completed taking the test.</li>
        <li>By clicking the 'Start Test' button, you agree to the following:</li>
        <ul>
            <li>You agree to not make a copy of any of the test questions, in whole or in part.</li>
            <li>You agree to not share the test questions, in whole or in part, with anyone else.</li>
        </ul>
        <li>Good luck!</li>
    </ul>

    <h2>Select a test for the <asp:Label ID="lblConference" runat="server" /></h2><br />
    <asp:RadioButtonList ID="TestList" runat="server" Font-Size="Medium" /><br />
    <asp:Button ID="btnStartTest" runat="server" Text="Start Test" OnClick="btnStartTest_Click"
        OnClientClick="javascript:return confirm('Are you sure you are ready to begin the test? Once you have started, you cannot restart or continue at a later time.')"/>

    <asp:Panel ID="pnlPopup" runat="server" CssClass="ModalWindow">
        <asp:UpdatePanel ID="updPopup" runat="server"><ContentTemplate>
            <div style="width:100%;text-align:center">
                <asp:Label ID="lblPopup" runat="server" />
                <br /><br />
                <asp:Button ID="btnClosePopup" runat="server" Text="OK" />
            </div>
            <asp:Button ID="btnShowPopup" runat="server" style="display:none" />
            <asp:ModalPopupExtender ID="popupErrorMsg" runat="server" BackgroundCssClass="ModalBackground"
                PopupControlID="pnlPopup" TargetControlID="btnShowPopup" CancelControlID="btnClosePopup" OnCancelScript="window.location.href='Default.aspx'" />
        </ContentTemplate></asp:UpdatePanel>
    </asp:Panel>

</asp:Content>