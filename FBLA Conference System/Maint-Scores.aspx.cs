using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

namespace FBLA_Conference_System
{
    public partial class Maint_Scores : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // Only Advisers can access this page
            if ((string)Session["UserType"] != "Adviser") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();

            if (!IsPostBack) {
                // The global admin can select any state, all other users are limited to their own state
                if ((int)Session["StateID"] == 0)
                    pnlSelState.Visible = true;
                else {
                    sqlViewStateList.SelectCommand = "SELECT [StateID], [StateName] FROM [States] WHERE [StateID]=" + Session["StateID"];
                    ddStates.DataBind();
                }

                // State admins can select any region in their state, all other users are limited to their own region
                if ((int)Session["RegionID"] == 0)
                    pnlSelRegion.Visible = true;
                else {
                    // Regional and chapter admins are limited to their own region
                    sqlViewRegionList.SelectCommand = "SELECT RegionID, RegionName FROM Regions WHERE RegionID=" + Session["RegionID"];
                    ddRegions.DataBind();
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegions.DataBind();
            ddConferences.DataBind();
            ddEvents.DataBind();
            gvEventScores.DataBind();
        }

        protected void ddRegions_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            if (ddRegions.Items.Count == 0) {
                ddRegions.Enabled = false;
                ddRegions.Items.Add(new ListItem("[No regions defined for this state]", "-1"));
            } else {
                ddRegions.Enabled = true;
                ddConferences.DataBind();
                ddEvents.DataBind();
                gvEventScores.DataBind();
            }
        }

        protected void ddRegions_SelectedIndexChanged(object sender, EventArgs e) {
            ddConferences.DataBind();
            ddEvents.DataBind();
            gvEventScores.DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If the list of available conferences is empty, disable the dropdown
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences defined for this region]", "-1"));
            } else {
                ddConferences.Enabled = true;
                ddEvents.DataBind();
                gvEventScores.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            ddEvents.DataBind();
            gvEventScores.DataBind();
        }

        protected void ddEvents_SelectedIndexChanged(object sender, EventArgs e) {
            gvEventScores.DataBind();
        }

        protected void gvEventScores_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "ObjectiveWeight")) == 0) {
                    e.Row.Cells[4].Visible = false;
                    gvEventScores.HeaderRow.Cells[4].Visible = false;
                    e.Row.Cells[7].Visible = false;
                    gvEventScores.HeaderRow.Cells[7].Visible = false;
                }
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "PerformanceWeight")) == 0 ||
                    Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NoPerformance")) != 0) {
                    e.Row.Cells[5].Visible = false;
                    gvEventScores.HeaderRow.Cells[5].Visible = false;
                    e.Row.Cells[8].Visible = false;
                    gvEventScores.HeaderRow.Cells[8].Visible = false;
                }
                if (Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "HomesiteWeight")) == 0) {
                    e.Row.Cells[6].Visible = false;
                    gvEventScores.HeaderRow.Cells[6].Visible = false;
                }
            }
            /* -- Can use this type of code to save the original data and later only update the rows which have changed
             * -- For now, I'm just going to update every row every time
            if (e.Row.RowType == DataControlRowType.DataRow)
                if (e.Row.RowIndex == 1) {
                    ViewState["originalValuesDataTable"] = _originalDataTable = ((DataRowView)e.Row.DataItem).Row.Table.Copy();
                }
             */
        }

        protected void btnCalcScores_Click(object sender, EventArgs e) {
            int ObjRowsUpdated = 0, PerfRowsUpdated = 0;

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            cnn.Open();

            #region Calculate all event objective scores for this conference from online test reponses
            SqlCommand cmd = new SqlCommand(
                "UPDATE ConferenceMemberEvents SET" +
                " OnlineTestScore=S.Score, ObjectiveScore=S.Score " +
                "FROM (" +
                " SELECT" +
                "  Mem=R.MemberID,Conf=R.ConferenceID,Evt=Q.EventID," +
                "  Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)" +
                " FROM TestResponses R" +
                "  INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID" +
                " WHERE  R.ConferenceID=" + ddConferences.SelectedValue +
                " GROUP BY R.MemberID,R.ConferenceID,Q.EventID" +
                " ) S " +
                "WHERE ConferenceID=S.Conf AND ConferenceMemberEvents.EventID=S.Evt AND ConferenceMemberEvents.MemberID IN (" +
                "   SELECT S.Mem UNION SELECT TM.MemberID FROM ConferenceMemberEvents CME" +
                "    INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID" +
                "    INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName" +
                "    INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID" +
                "  WHERE CME.ConferenceID=S.Conf" +
                "    AND CME.EventID=S.Evt" +
                "    AND CME.MemberID=S.Mem)", cnn);
            cmd.CommandTimeout = 900;
            try {
                ObjRowsUpdated = cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) {
                lblPopup.Text = "Error updating objective scores: " + ex.Message + "; " + ex.InnerException;
                popupErrorMsg.Show();
            }
            #endregion

            #region Calculate all performance scores for this conference from online judging responses
            // All the competitors need to be reviewed by the same number of judges, whatever the maximum is
            string sqlJudgeCount =
                "select EventID, MemberID, NumJudges=COUNT(JudgeID) " +
                "from (" +
                "  select C.EventID, C.JudgeID, MemberID" +
                "  from JudgeCredentials C" +
                "    inner join JudgeResponses R on C.JudgeID=R.JudgeID" +
                "  where ConferenceID=" + ddConferences.SelectedValue +
                "  group by C.EventID, C.JudgeID, R.MemberID" +
                "  having SUM(R.Response) <> 0" +
                ") JudgesByMember " +
                "group by EventID, MemberID";
            // Calculate the average score across the judges and assign it to the competitors (indiv or entire team)
            cmd = new SqlCommand(
               "update ConferenceMemberEvents set" +
               "  OnlineJudgeScore=S.AverageScore, PerformanceScore=S.AverageScore " +
               "from (" +
               "  select" +
               "    ConferenceID=" + ddConferences.SelectedValue + ", ScoresByJudge.EventID, MemberID," +
               "    AverageScore=case when NumJudges=MaxJudges then AVG(Score) else -2 end" +
               "  from (" +
               "    select C.EventID, R.JudgeID, R.MemberID, JudgeCount.NumJudges, Score=SUM(R.Response)*100" +
               "    from JudgeResponses R" +
               "      inner join JudgeCredentials C on R.JudgeID=C.JudgeID" +
               "      inner join (" + sqlJudgeCount + ") JudgeCount" +
               "        on C.EventID=JudgeCount.EventID AND R.MemberID=JudgeCount.MemberID" +
               "    group by C.EventID, R.JudgeID, R.MemberID, JudgeCount.NumJudges" +
               "    having SUM(R.Response) >= 0" +
               "  ) ScoresByJudge" +
               "    inner join (" +
               "      select EventID, MaxJudges=MAX(NumJudges)" +
               "      from (" + sqlJudgeCount + ") JudgeCount" +
               "      group by EventID" +
               "    ) RequiredJudges on ScoresByJudge.EventID=RequiredJudges.EventID" +
               "  group by ScoresByJudge.EventID, MemberID, NumJudges, MaxJudges" +
               "  ) S " +
               "where ConferenceMemberEvents.ConferenceID=" + ddConferences.SelectedValue +
               "  and ConferenceMemberEvents.EventID=S.EventID" +
               "  and ConferenceMemberEvents.MemberID in (" +
               "    SELECT S.MemberID UNION" +
                "	SELECT TM.MemberID FROM ConferenceMemberEvents CME" +
                "	  INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID" +
                "	  INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName" +
                "	  INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID" +
                "	WHERE CME.ConferenceID=S.ConferenceID"+
                "     AND CME.EventID=S.EventID" +
                "     AND CME.MemberID=S.MemberID)", cnn);
            cmd.CommandTimeout = 900;
            try {
                PerfRowsUpdated = cmd.ExecuteNonQuery();
            }
            catch (SqlException ex) {
                lblPopup.Text = "Error updating performance scores: " + ex.Message + "; " + ex.InnerException;
                popupErrorMsg.Show();
            }
            #endregion

            lblPopup.Text = "Updated " + ObjRowsUpdated.ToString() + " objective scores and " + PerfRowsUpdated.ToString() + " performance scores.";
            popupErrorMsg.Show();

            #region Score all the events
            SqlDataAdapter da = new SqlDataAdapter("select * from NationalEvents", cnn);
            DataTable tblEvents = new DataTable();
            da.Fill(tblEvents);
            da.Dispose();

            foreach (DataRow r in tblEvents.Rows) {
            if (r["EventType"].ToString() == "T")
                ScoreTeamEvent(r["EventID"].ToString(), cnn);
            else
                ScoreIndivEvent(r["EventID"].ToString(), cnn);
            }
            MarkWinnersEligible(cnn);
            #endregion
            cnn.Close();

            // Bind the new data back to the page controls
            int currentEvent = ddEvents.SelectedIndex;
            ddEvents.DataBind();
            ddEvents.SelectedIndex = currentEvent;
            gvEventScores.DataBind();
        }

        protected void btnUpdate_Click(object sender, EventArgs e) {
            // Update all the rows with any newly entered or modified scores
            bool isError = false;
            foreach (GridViewRow r in gvEventScores.Rows)
                try {
                    gvEventScores.UpdateRow(r.RowIndex, false);
                } catch {
                    isError = true;
                }

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            cnn.Open();

            // Clear any existing places
            SqlCommand cmd = new SqlCommand(
                "UPDATE ConferenceMemberEvents SET Place=NULL " +
                "WHERE ConferenceID=" + ddConferences.SelectedValue + " AND EventID=" + ddEvents.SelectedValue, cnn);
            cmd.ExecuteNonQuery();

            // Determine the type of the current event
            cmd = new SqlCommand("SELECT EventType FROM NationalEvents WHERE EventID=" + ddEvents.SelectedValue, cnn);
            if (((string)cmd.ExecuteScalar() == "T"))
                ScoreTeamEvent(ddEvents.SelectedValue, cnn);
            else
                ScoreIndivEvent(ddEvents.SelectedValue, cnn);
            MarkWinnersEligible(cnn);

            cnn.Close();

            // Bind the new data back to the page controls
            int currentEvent = ddEvents.SelectedIndex;
            ddEvents.DataBind();
            ddEvents.SelectedIndex = currentEvent;
            gvEventScores.DataBind();

            if (isError) {
                lblPopup.Text = "At least one score was entered with non-numeric data and was skipped. Please double-check the scores.";
                popupErrorMsg.Show();
            }
        }

        private string[] places = new string[] { "'1st'", "'2nd'", "'3rd'", "'4th'", "'5th'", "'6th'", "NULL" };

        protected void ScoreIndivEvent(string EventID, SqlConnection cnn) {
            // Determine the top place winners
            string strSQL =
                "SELECT ConferenceID,ME.EventID,MemberID," +
                " Score=ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+" +
                "  ISNULL(PerformanceScore,0)*ISNULL(PerformanceWeight,0)+" +
                "  ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0) " +
                "FROM ConferenceMemberEvents ME" +
                " INNER JOIN NationalEvents E ON ME.EventID=E.EventID " +
                "WHERE" +
                " ConferenceID=" + ddConferences.SelectedValue + 
                "  AND ME.EventID=" + EventID + 
                "  AND (CASE WHEN (ISNULL(ObjectiveWeight,0)<>0 AND ObjectiveScore IS NULL)"+
                "   OR (ISNULL(PerformanceWeight,0)<>0 AND PerformanceScore IS NULL)"+
                "   OR (ISNULL(HomesiteWeight,0)<>0 AND HomesiteScore IS NULL) THEN 'F' ELSE 'T' END) = 'T' " +
                "ORDER BY" +
                " ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+" +
                " ISNULL(PerformanceScore,0)*ISNULL(PerformanceWeight,0)+" +
                " ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0) DESC, ObjectiveElapsedTime";
            SqlDataAdapter adapterScores = new SqlDataAdapter(strSQL, cnn);
            DataTable tblTopScores = new DataTable();
            adapterScores.Fill(tblTopScores);
            adapterScores.Dispose();

            // Update the places for the winners
            SqlCommand cmd = new SqlCommand("", cnn);
            int currentPlace;
            for (int i = 0; i < tblTopScores.Rows.Count; i++) {
                /* this logic allows for multiple people to have the same place if there are ties with the same score
                //int prevScore = -1;
                currentPlace = ((int)tblTopScores.Rows[i]["Score"] == prevScore) ? currentPlace : Math.Min(i, 5);
                prevScore = (int)tblTopScores.Rows[i]["Score"];
                if (prevScore == 0) currentPlace = 5;
                 */
                currentPlace = Math.Min(i, (places.Length - 1)); // The last place entry is NULL
                cmd.CommandText =
                    "UPDATE ConferenceMemberEvents SET Place=" + places[currentPlace] + " WHERE" +
                    " ConferenceID=" + tblTopScores.Rows[i]["ConferenceID"] + " AND" +
                    " EventID=" + tblTopScores.Rows[i]["EventID"] + " AND" +
                    " MemberID=" + tblTopScores.Rows[i]["MemberID"];
                cmd.ExecuteNonQuery();
            }
        }

        protected void ScoreTeamEvent(string EventID, SqlConnection cnn) {
            // Calculate the average score for each team
            string strSQL =
            "SELECT" +
            " ConferenceID,ME.EventID,ChapterID,TeamName,Score=0," +
            " ObjectiveElapsedTime=MAX(ISNULL(ObjectiveElapsedTime,0))," +
            " ObjectiveScore=AVG(ISNULL(ObjectiveScore,0)),ObjectiveWeight=ISNULL(ObjectiveWeight,0)," +
            " PerformanceScore=AVG(ISNULL(PerformanceScore,0)),PerformanceWeight=ISNULL(PerformanceWeight,0)," +
            " HomesiteScore=AVG(ISNULL(HomesiteScore,0)),HomesiteWeight=ISNULL(HomesiteWeight,0) " +
            "FROM ConferenceMemberEvents ME" +
            " INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID" +
            " INNER JOIN NationalEvents E ON ME.EventID=E.EventID " +
            "WHERE" +
            " ConferenceID=" + ddConferences.SelectedValue + " AND" +
            " ME.EventID=" + EventID + 
            " AND (CASE WHEN (ISNULL(ObjectiveWeight,0)<>0 AND ObjectiveScore IS NULL)"+
            "  OR (ISNULL(PerformanceWeight,0)<>0 AND PerformanceScore IS NULL)"+
            "  OR (ISNULL(HomesiteWeight,0)<>0 AND HomesiteScore IS NULL) THEN 'F' ELSE 'T' END) = 'T' " +
            "GROUP BY ConferenceID,ME.EventID,ChapterID,TeamName,ObjectiveWeight,PerformanceWeight,HomesiteWeight";
            SqlDataAdapter adapterTeams = new SqlDataAdapter(strSQL, cnn);
            DataTable tblEventTeams = new DataTable();
            adapterTeams.Fill(tblEventTeams);
            adapterTeams.Dispose();

            // Calculate the total score for each team
            for (int i = 0; i < tblEventTeams.Rows.Count; i++) {
                tblEventTeams.Rows[i]["Score"] =
                    (int)tblEventTeams.Rows[i]["ObjectiveScore"] * (int)tblEventTeams.Rows[i]["ObjectiveWeight"] +
                    (int)tblEventTeams.Rows[i]["PerformanceScore"] * (int)tblEventTeams.Rows[i]["PerformanceWeight"] +
                    (int)tblEventTeams.Rows[i]["HomesiteScore"] * (int)tblEventTeams.Rows[i]["HomesiteWeight"];
            }

            // Generated a sorted array of data rows
            DataRow[] tblSortedTeams;
            tblSortedTeams = tblEventTeams.Select(null, "Score DESC, ObjectiveElapsedTime");

            // Update the scores and place for the members of each team
            SqlCommand cmd = new SqlCommand("", cnn);
            int currentPlace;
            for (int i = 0; i < tblSortedTeams.Length; i++) {
                /* 
                //int prevScore = -1;
                currentPlace = ((int)tblSortedTeams[i]["Score"] == prevScore) ? currentPlace : Math.Min(i,5);
                prevScore = (int)tblSortedTeams[i]["Score"];
                if (prevScore == 0) currentPlace = 5;
                 */
                currentPlace = Math.Min(i, (places.Length - 1)); // The last place entry is NULL
                cmd.CommandText =
                    "UPDATE ConferenceMemberEvents SET" +
                    " Place=" + places[currentPlace] + "," +
                    " ObjectiveScore=" + tblSortedTeams[i]["ObjectiveScore"] + "," +
                    " PerformanceScore=" + tblSortedTeams[i]["PerformanceScore"] + "," +
                    " HomesiteScore=" + tblSortedTeams[i]["HomesiteScore"] + " " +
                    "FROM ConferenceMemberEvents ME INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID " +
                    "WHERE ConferenceID=" + tblSortedTeams[i]["ConferenceID"] +
                    " AND EventID=" + tblSortedTeams[i]["EventID"] +
                    " AND ChapterID=" + tblSortedTeams[i]["ChapterID"] +
                    " AND TeamName='" + tblSortedTeams[i]["TeamName"] + "'";
                cmd.ExecuteNonQuery();
            }
        }

        protected void MarkWinnersEligible(SqlConnection cnn) {
            // Determine the level of the conference (regional or state)
            SqlCommand cmd = new SqlCommand(
                "SELECT CASE WHEN RegionID=0 THEN 'State' ELSE 'Regional' END " +
                "FROM Conferences WHERE ConferenceID=" + ddConferences.SelectedValue, cnn);
            string confType = (string)cmd.ExecuteScalar();

            if (confType == "Regional") {
                // Clear any existing flags for all members in this conferences's region
                cmd.CommandText =
                    "UPDATE M SET M.isStateEligible=0 " +
                    "FROM Conferences CO" +
                    " INNER JOIN Chapters CH ON CO.RegionID=CH.RegionID" +
                    " INNER JOIN NationalMembers M ON CH.ChapterID=M.ChapterID " +
                    "WHERE ConferenceID=" + ddConferences.SelectedValue;
                cmd.ExecuteNonQuery();
                // Set the elgibility flag for the winners
                cmd.CommandText =
                    "UPDATE M SET M.isStateEligible=1 " +
                    "FROM ConferenceMemberEvents CME" +
                    " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID " +
                    "WHERE Place IS NOT NULL AND ConferenceID=" + ddConferences.SelectedValue;
                cmd.ExecuteNonQuery();
            } else { // State
                // Clear any existing flags for all members in this conferences's state
                cmd.CommandText =
                    "UPDATE M SET M.isNationalEligible=0 " +
                    "FROM Conferences CO" +
                    " INNER JOIN Chapters CH ON CO.StateID=CH.StateID" +
                    " INNER JOIN NationalMembers M ON CH.ChapterID=M.ChapterID " +
                    "WHERE ConferenceID=" + ddConferences.SelectedValue;
                cmd.ExecuteNonQuery();

                // Set the elgibility flag for the winners
                /*
                    "WHERE ((E.ObjectiveWeight= 100 AND (CME.Place='1st' OR CME.Place='2nd' OR CME.Place='3rd'))" +
                    " OR (E.ObjectiveWeight<>100 AND (CME.Place='1st' OR CME.Place='2nd')))" +
                 
                    "WHERE (CME.Place='1st' OR CME.Place='2nd' OR CME.Place='3rd')"+

                 */
                cmd.CommandText =
                    "UPDATE M SET M.isNationalEligible=1 " +
                    "FROM ConferenceMemberEvents CME" +
                    " INNER JOIN NationalEvents E ON CME.EventID=E.EventID" +
                    " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID " +
                    "WHERE ((E.ObjectiveWeight=100 AND (CME.Place='1st' OR CME.Place='2nd' OR CME.Place='3rd' OR CME.Place='4th'))" +
                    " OR (E.ObjectiveWeight<>100 AND (CME.Place='1st' OR CME.Place='2nd' OR CME.Place='3rd')))" +
                    " AND CME.ConferenceID=" + ddConferences.SelectedValue;
                cmd.ExecuteNonQuery();
            }
        }
    }
}