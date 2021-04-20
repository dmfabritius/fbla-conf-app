<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e) {
        if (Session["EventWinnersConferenceID"] == null) {
            Response.End();
            return;
        }
        string pdfFilename = "pdf\\" + Session.SessionID + DateTime.Now.Ticks.ToString() + ".pdf";
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        // Redirect the error stream of the child process.
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardError = true;
        p.StartInfo.FileName = ConfigurationManager.AppSettings["wkhtmltopdf"];
        p.StartInfo.Arguments =
            "--page-size Letter " +
            "--orientation Portrait " +
            "--margin-top 12.7mm " +
            "--margin-bottom 12.7mm " +
            "--margin-left 12.7mm " +
            "--margin-right 12.7mm " +
            "--disable-smart-shrinking " +
            "\"http://fcs.wafbla.org/eventwinners.aspx" +
                "?EventWinnersConferenceID=" + Session["EventWinnersConferenceID"].ToString() + "\" " +
            "\"" + AppDomain.CurrentDomain.BaseDirectory + pdfFilename + "\"";
        p.Start();
        string error = p.StandardError.ReadToEnd();
        p.WaitForExit();
        Server.Transfer(pdfFilename);
    }
</script>