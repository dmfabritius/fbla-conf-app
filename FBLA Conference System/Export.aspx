<%@ Page Language="C#" %>
<script runat="server">
    
    void Page_Load(object sender, EventArgs e) {

        // Don't do anything unless we receive the correct authentication code
        if (Request["AuthCode"] == "Secret_Password") {
            Response.Clear();
            Response.ContentType = "text/xml";
            Response.Write("<?xml version=\"1.0\"?>\n");

            // Query the database for all the students in a given chapter
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(
                "SELECT FirstName, LastName, GraduatingClass, Gender, M.ShirtSize " +
                "FROM NationalMembers M" +
                " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID " +
                "WHERE NationalChapterID = " + Request["ChapterID"],
                ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            System.Data.DataTable table = new System.Data.DataTable();
            adapter.Fill(table);
            table.TableName = "Students";

            // Return the results as XML text
            table.WriteXml(Response.OutputStream);
            Response.Flush();
        }
    }
</script>
