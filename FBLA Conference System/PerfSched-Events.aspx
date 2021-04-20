<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PerfSched-Events.aspx.cs" Inherits="FBLA_Conference_System.PerfSched_Events" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>FBLA Performance Event Testing</title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<style type="text/css">
@page {margin: 0.25in;margin-top:1.0in}
table {border:0;border-width:0;border-spacing:0;padding:0;width:1008px}
td {border:0;border-width:0;font:12pt Calibri;vertical-align:bottom}
td.conf {font-size:16pt;font-weight:bold}
td.head {font-size:14pt;font-weight:bold}
td.cols {font-size:12pt;font-weight:bold;border-bottom:1px black solid}
p {margin:0;font:12pt Calibri}
</style>
</head>
<body>
<asp:Panel ID="Instructions" runat="server">
<p>This page includes two schedules, the first is organized by event and the second is organized by student.</p>
<p>Press Ctrl-A to select the entire page, Ctrl-C to copy to the clipboard, switch to Excel, and then Ctrl-V to paste everything into a spreadsheet.<br /></p>
</asp:Panel>
<asp:PlaceHolder ID="Conflicts" runat="server" Visible="false" />
<asp:PlaceHolder ID="Schedule" runat="server" />
</body></html>
