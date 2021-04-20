<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RefreshSessionState.aspx.cs" Inherits="FBLA_Conference_System.RefreshSessionState" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <%
     Response.Write(@"<meta http-equiv=""refresh"" content=""300;url=RefreshSessionState.aspx?x=" +
     Server.UrlEncode(DateTime.Now.ToString()) + @""" />");
     %>
</head>
<body>
</body>
</html>
