<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HotelInvoice.aspx.cs" Inherits="FBLA_Conference_System.HotelInvoice" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<style type="text/css">
@page 
{
    margin: 0.5in;
}
table {
	border: 2px #000080 solid;
	border-width:0 0 1px 1px;
	margin-bottom:12px;
}
th {
	border: #000080 solid;
	border-width: 2px 1px 1px 0;
	background: #f4f4f4;
	font: bold 10pt Arial;
}
td {
	border: #000080 solid;
	border-width: 0 1px 0 0;
	font: 10pt Arial;
}
.subtable {
	border-width:0;
    margin-left: 10px;
    width: 470px;
}
#subcells td {
	border-width:0;
	font: 8pt Arial Narrow;
}
p {
    page-break-after:always;
}
</style>
</head>
<body>
<asp:Repeater ID="rptConferenceHotelInvoices" runat="server"><ItemTemplate>
    <table cellpadding="5px" cellspacing="0" style="width: 720px;table-layout:fixed">
	    <colgroup>
		    <col width="60px" /><col width="120px" /><col span="2" width="180px" /><col span="2" width="90px" />
	    </colgroup>
	    <tr valign="top">
		    <th align="left" colspan="4"><%# Eval("RegionName") %> <%= ConfigurationManager.AppSettings["ConferenceSystemName"]%></th>
		    <th colspan="2">INVOICE</th>
	    </tr>
	    <tr>
		    <td colspan="6" style="padding:5px 0 15px 5px"><%# Eval("InvoiceAddress") %><br />
            <%# Eval("InvoiceCity") %>, <%# Eval("StateAbbr")%> <%# Eval("InvoiceZip") %></td>
	    </tr>
	    <tr valign="top">
		    <td align="center" style="border-right-width:0;font-weight:bold"><br />
		    TO</td>
		    <td colspan="3" style="padding:5px 0 15px 5px;border-right-width:0"><%# Eval("AdviserName") %><br />
		    <%# Eval("ChapterName") %><br />
		    <%# Eval("ChapterAddress") %><br />
		    <%# Eval("ChapterCity") %>, <%# Eval("StateAbbr")%> <%# Eval("ChapterZip") %></td>
		    <td colspan="2" align="right">Invoice #HTL<%# Eval("ChapterID") %>-<%# Eval("ConferenceID") %><br />
		    Date: <%# Eval("CurrentDate","{0:MM/dd/yyyy}") %></td>
	    </tr>
	    <tr>
		    <th colspan="2">CONTACT</th>
		    <th style="width:180px">CONFERENCE</th>
		    <th style="width:180px">PAYMENT TERMS</th>
		    <th colspan="2" style="width:180px">DUE DATE</th>
	    </tr>
	    <tr>
		    <td colspan="2" align="center"><%# Eval("InvoiceContact") %></td>
		    <td align="center"><%# Eval("ConferenceName") %></td>
		    <td align="center">Due on receipt</td>
		    <td colspan="2" align="center"><%# Eval("DueDate", "{0:MM/dd/yyyy}")%></td>
	    </tr>
	    <tr>
		    <th>QTY</th>
		    <th colspan="3">DESCRIPTION</th>
		    <th>PRICE</th>
		    <th>SUBTOTAL</th>
	    </tr>
	    <tr>
            <td></td>
            <td colspan="3"><%# Eval("ConferenceName") %> Hotel Packages</td>
            <td>&nbsp;</td>
            <td></td>
        </tr>
        <asp:Repeater ID="rptPackages" runat="server" DataSource='<%#  ((System.Data.DataRowView)Container.DataItem).Row.GetChildRows("HotelInvoiceChapterPackages") %>'>
            <ItemTemplate>
                <tr>
		            <td align="center"><%# DataBinder.Eval(Container.DataItem, "[\"Amount\"]", "{0:##}")%></td>
		            <td colspan="3" style="padding-left:20px"><%# DataBinder.Eval(Container.DataItem, "[\"PackageDesc\"]")%></td>
		            <td align="right"><%# DataBinder.Eval(Container.DataItem, "[\"PackagePrice\"]", "{0:C}")%></td>
		            <td align="right"><%# DataBinder.Eval(Container.DataItem, "[\"ExtendedPrice\"]", "{0:C}")%></td>
	            </tr>
            </ItemTemplate>
        </asp:Repeater>
	    <tr style="height:385px">
            <td></td>
            <td colspan="3" style="background:url('img/fbla-bkg.jpg') bottom no-repeat">&nbsp;</td>
            <td>&nbsp;</td>
            <td></td>
        </tr>
	    <tr>
		    <td>&nbsp;</td>
		    <td colspan="3">&nbsp;</td>
		    <th style="border-bottom-width:0">TOTAL</th>
		    <th align="right" style="border-bottom-width:0"><%# Eval("PackagesTotal","{0:C}")%></th>
	    </tr>
	    <tr>
		    <th colspan="6" style="width: 700px">Make all checks payable to <b><%# Eval("RegionName") %> <%= ConfigurationManager.AppSettings["ConferenceSystemName"]%></b><br />
		    ENJOY THE CONFERENCE!</th>
	    </tr>
    </table>
    <p/>
</ItemTemplate></asp:Repeater>
</body>
</html>