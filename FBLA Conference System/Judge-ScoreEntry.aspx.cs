using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Judge_ScoreEntry : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

            #region This page is restricted to performance event judges
            if ((string)Session["JudgingEvent"] != "true") {

                // If the session state is lost, check for the existence of a backup cookie
                HttpCookie SessionBackup = Request.Cookies.Get("FCSdata");
                if (SessionBackup != null) {
                    string[] FCSdata = Global.Decrypt(SessionBackup.Value).Split(';');
                    if (FCSdata[0] == "true") {
                        Session["JudgeID"] = FCSdata[1];
                        Session["ConferenceID"] = FCSdata[2];
                        Session["EventID"] = FCSdata[3];
                        Session["EventType"] = FCSdata[4];
                        Session["Name"] = FCSdata[5];
                    }
                    else {
                        // If the cookie is not valid, go to login in page
                        Server.Transfer("default.aspx");
                    }
                }
                else {
                    // If the cookie is missing , go to login in page
                    Server.Transfer("default.aspx");
                }
            }

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = "#JudgingEvent";
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
            #endregion

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            SqlCommand sqlCmd = new SqlCommand("", cnn);
            cnn.Open();

            if (!IsPostBack) {
                // After the page fully loads, run a client-side javascript to display the current total score
                Page.ClientScript.RegisterStartupScript(this.GetType(), "go",
                    "<script type=text/javascript>calcScore()</script>");

                // Populate the forms based on the currently signed-in judge and the event they're judging
                sqlPerfScoresMaint.SelectParameters["JudgeID"].DefaultValue = Session["JudgeID"].ToString();
                sqlPerfScoresMaint.SelectParameters["EventID"].DefaultValue = Session["EventID"].ToString();
                sqlPerfCommentsMaint.SelectParameters["JudgeID"].DefaultValue = Session["JudgeID"].ToString();

                #region Get the name of the conference and the event being tested on
                SqlDataAdapter sqlConfEvent = new SqlDataAdapter(
                    "SELECT ConferenceName, EventName, EventType " +
                    "FROM Conferences" +
                    " INNER JOIN NationalEvents E ON E.EventID=" + Session["EventID"] + " " +
                    "WHERE ConferenceID=" + Session["ConferenceID"], cnn);
                DataTable tblConfEvent = new DataTable();
                sqlConfEvent.Fill(tblConfEvent);
                lblConferenceName.Text = tblConfEvent.Rows[0]["ConferenceName"].ToString();
                lblEventName.Text = tblConfEvent.Rows[0]["EventName"].ToString();

                // As a backup of the session state, store an encrypted cookie
                /*
                HttpCookie cookie = new HttpCookie("FCSdata");
                cookie.Value = Global.Encrypt("true;" +
                    Session["ConferenceID"].ToString() + ";" +
                    Session["RegionalTestsID"].ToString() + ";" +
                    Session["MemberID"].ToString() + ";" +
                    Session["Name"].ToString() + ";" +
                    Session["EventID"].ToString() + ";" +
                    Session["EventType"].ToString());
                Response.Cookies.Add(cookie);
                */
                #endregion

                #region Fill the selection drop-down box with a list of competitors, either individuals or teams
                DataTable tblCompetitors = new DataTable();
                if (Session["EventType"].ToString() == "T") {
                    #region Populate drop-down with team names
                    // Get a list of students competing in this event, multiple rows per team
                    SqlDataAdapter sqlStudents = new SqlDataAdapter(
                        "select cme.MemberID, Team=ChapterName+', '+TeamName, LastName " +
                        "from ConferenceMemberEvents cme" +
                        " inner join NationalMembers m on cme.MemberID=m.MemberID" +
                        " inner join Chapters c on m.ChapterID=c.ChapterID " +
                        "where ConferenceID=" + Session["ConferenceID"] + " and EventID=" + Session["EventID"] + " " +
                        "order by ChapterName, TeamName, LastName, FirstName", cnn);
                    DataTable tblStudents = new DataTable();
                    sqlStudents.Fill(tblStudents);

                    // Create a table of teams for this event, combining the appropriate students together
                    tblCompetitors.Columns.Add("MemberID");
                    tblCompetitors.Columns.Add("Competitor");
                    string prevMemberID = tblStudents.Rows[0]["MemberID"].ToString();
                    string prevTeam = tblStudents.Rows[0]["Team"].ToString();
                    string members = " (";
                    foreach (DataRow rwStudents in tblStudents.Rows) {
                        if (prevTeam != rwStudents["Team"].ToString()) {
                            tblCompetitors.Rows.Add(prevMemberID, prevTeam + members.Substring(0, members.Length - 2) + ")");
                            prevMemberID = rwStudents["MemberID"].ToString();
                            prevTeam = rwStudents["Team"].ToString();
                            members = " (" + rwStudents["Lastname"] + ", ";
                        }
                        else {
                            members += rwStudents["Lastname"] + ", ";
                        }
                    }
                    tblCompetitors.Rows.Add(prevMemberID, prevTeam + members.Substring(0, members.Length - 2) + ")");
                    #endregion
                }
                else {
                    #region Populate drop-down with student names
                    SqlDataAdapter sqlCompetitors = new SqlDataAdapter(
                        "select cme.MemberID, Competitor=ChapterName+', '+FirstName+' '+LastName " +
                        "from ConferenceMemberEvents cme" +
                        " inner join NationalMembers m on cme.MemberID=m.MemberID" +
                        " inner join Chapters c on m.ChapterID=c.ChapterID " +
                        "where ConferenceID=" + Session["ConferenceID"] + " and EventID=" + Session["EventID"] + " " +
                        "order by ChapterName, FirstName, LastName", cnn);
                    sqlCompetitors.Fill(tblCompetitors);
                    #endregion
                }
                ddCompetitors.DataSource = tblCompetitors;
                ddCompetitors.DataBind();
                #endregion
            }

            // The page reloads every time the student/team is changed
            #region Determine if this event judge has entered scores for this student/team
            sqlCmd.CommandText =
                "SELECT Score=ISNULL(SUM(Response),0) FROM JudgeResponses " +
                "WHERE JudgeID=" + Session["JudgeID"].ToString() +
                " AND MemberID=" + ddCompetitors.SelectedValue;
            // If the score is zero, then we can start with a fresh slate
            if ((Int32)sqlCmd.ExecuteScalar() == 0) {
                // Just in case there's already a set of zeros, delete any existing responses
                sqlCmd.CommandText =
                    "DELETE FROM JudgeResponses " +
                    "WHERE JudgeID=" + Session["JudgeID"].ToString() +
                    " AND MemberID=" + ddCompetitors.SelectedValue;
                sqlCmd.ExecuteNonQuery();
                // Generate default responses of 0 for this judge for this competitor
                sqlCmd.CommandText =
                    "INSERT INTO JudgeResponses" +
                    " SELECT " + Session["JudgeID"].ToString() + "," + ddCompetitors.SelectedValue + ",PerfCriteriaID,0" +
                    " FROM JudgeCriteria C WHERE C.EventID=" + Session["EventID"].ToString();
                sqlCmd.ExecuteNonQuery();
            }
            #endregion

            #region Determine if this event judge has entered comments for this student/team
            sqlCmd.CommandText =
                "SELECT ISNULL(CO.PerfComments,'<empty>') " +
                "FROM JudgeCredentials CR" +
                " LEFT JOIN JudgeComments CO ON CR.JudgeID=CO.JudgeID AND CO.MemberID=" + ddCompetitors.SelectedValue + " " +
                "WHERE CR.JudgeID=" + Session["JudgeID"].ToString();
            string PerfComments = sqlCmd.ExecuteScalar().ToString();
            // If there are no comments, then we can start with a fresh slate
            if (PerfComments == "<empty>") {
                // Just in case, delete any existing record
                sqlCmd.CommandText =
                    "DELETE FROM JudgeComments " +
                    "WHERE JudgeID=" + Session["JudgeID"].ToString() +
                    " AND MemberID=" + ddCompetitors.SelectedValue;
                sqlCmd.ExecuteNonQuery();
                // Generate default responses for this judge for this competitor
                // Insert the conference and event ID because after the conference is over we delete the judge credentials
                sqlCmd.CommandText =
                    "INSERT INTO JudgeComments (JudgeID,MemberID,ConferenceID,EventID,PerfComments) VALUES (" +
                    Session["JudgeID"].ToString() + "," +
                    ddCompetitors.SelectedValue + "," +
                    Session["ConferenceID"].ToString() + "," +
                    Session["EventID"].ToString() + "," +
                    "'(No comments)')";
                sqlCmd.ExecuteNonQuery();
            }
            #endregion
            cnn.Close();
        }

        private int totalScore = 0;
        protected void gvEventScores_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Weight")) == 0) {
                    e.Row.Cells[0].Font.Bold = true;
                    e.Row.Cells[1].Visible = e.Row.Cells[2].Visible = false;
                }
                else {
                    TextBox tbEditScore = (TextBox)e.Row.Cells[2].FindControl("EditScore");
                    try {
                        totalScore += Int32.Parse(tbEditScore.Text);
                    }
                    catch { // anything that doesn't convert to a number doesn't get added to the score
                    }
                    tbEditScore.Attributes.Add(
                        "onchange",
                        "return rangeCheck(this," + DataBinder.Eval(e.Row.DataItem, "Weight") + ")");
                }
            }
            if (e.Row.RowType == DataControlRowType.Footer) {
                ((Label)e.Row.Cells[2].FindControl("TotalScore")).Text = totalScore.ToString();
            }
        }

        protected void ddCompetitors_SelectedIndexChanged(object sender, EventArgs e) {
            // Submit any changes for the current competitor and then bind the controls to the new competitor
            btnUpdate_Click(null, null);
        }

        protected void btnUpdate_Click(object sender, EventArgs e) {
            // Update all the criteria rows with any newly entered or modified scores
            bool isError = false;
            foreach (GridViewRow r in gvPerfScores.Rows) {
                try {
                    if (r.RowType == DataControlRowType.DataRow) {
                        gvPerfScores.UpdateRow(r.RowIndex, false);
                    }
                }
                catch {
                    isError = true;
                }
            }
            // Update the comments
            fvPerfComments.UpdateItem(false);

            // Bind the new data back to the page controls
            gvPerfScores.DataBind();
            fvPerfComments.DataBind();

            if (isError) {
                lblPopup.Text = "At least one score was entered with non-numeric data and was skipped. Please double-check the scores.";
                popupErrorMsg.Show();
            }
        }
    }
}