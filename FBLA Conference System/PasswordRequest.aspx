<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PasswordRequest.aspx.cs" Inherits="FBLA_Conference_System.PasswordRequest" %>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div style="height:450px;background-image:url('img/students-bw.png');background-position:right bottom;background-repeat:no-repeat">
    <h2>Password Request</h2>
    <br />
    <table cellpadding="5" cellspacing="12" style="width:320px;margin-right:25px;border:1px solid #AAA">
        <col width="120px"/><col width="140px"/>
        <tr><td colspan="2">
            <p>Please enter your chapter number to have your username and password e-mailed to you.</p>
            <p>Your IP Address and its associated location will be sent with your request for verification purposes.</p>
        </td></tr>
        <tr><td align="right">Chapter Number:</td><td><asp:TextBox ID="Username" runat="server" Width="100%"></asp:TextBox></td></tr>
        <tr><td align="right" colspan="2"><asp:Button ID="Submit" runat="server" 
                Text="Submit" onclick="Submit_Click" /></td></tr>
    </table>
    <br />
    IP Address: <asp:Label ID="UserIP" runat="server"/><br />
    Location: <asp:Label ID="Location" runat="server"/><br />

    <br /><br /><asp:Label ID="RequestSent" runat="server" ForeColor="Red" Text="An e-mail has been sent to the chapter Adviser." Visible="false"/>



        <asp:HyperLink ID="ForgotUsername" runat="server" Font-Underline="true" NavigateUrl="~/PasswordRequest.aspx">Forgot your username or password?</asp:HyperLink>



</div>
</asp:Content>
