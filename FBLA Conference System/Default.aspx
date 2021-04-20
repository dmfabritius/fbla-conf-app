<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="FBLA_Conference_System._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript">
        var dt = new Date();
        document.cookie = "TZO=" + -dt.getTimezoneOffset().toString() + ";path=/";
    </script>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
<div style="height:450px;background:url('img/students.png') no-repeat right bottom">
    <h2>Please sign in</h2>
    <br />
    <table cellpadding="5" cellspacing="12" style="margin-right:25px;border:1px solid #AAA">
        <col width="100px"/><col width="200px"/>
        <tr><td align="right">Username:</td><td><asp:TextBox ID="Username" runat="server" Width="100%"/></td></tr>
        <tr><td align="right">Password:</td><td><asp:TextBox ID="Password" runat="server" Width="100%" TextMode="Password"/></td></tr>
        <tr><td align="right" colspan="2"><asp:Button ID="LogIn" runat="server" Text="Log in" onclick="LogIn_Click" /></td></tr>
    </table>
    <asp:CheckBox ID="RememberMe" runat="server" /> Remember my username.
    <br />
    <p style="margin-top:30px 0"><i>Forgot your username or password?<br />Please contact your Adviser for assistance.</i></p>
    <asp:Label ID="NotFound" runat="server" ForeColor="Red" Font-Bold="true" Visible="false" Text="The username and/or password was not found."/>
</div>
</asp:Content>
