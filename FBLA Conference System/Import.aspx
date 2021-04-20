<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Import.aspx.cs" Inherits="FBLA_Conference_System.Import" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:FileUpload ID="uplFile" runat="server"/>
    <asp:Button ID="btnImport" runat="server" Text="Import" onclick="btnImport_Click"/>

    <br />
    Results:<br />
    <asp:ListBox ID="lstResults" runat="server" Rows="50" Width="800px" Enabled="false"  />

</asp:Content>
