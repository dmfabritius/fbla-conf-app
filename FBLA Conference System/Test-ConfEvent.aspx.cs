using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

namespace FBLA_Conference_System {

    public partial class Test_ConfEvent : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

            #region This page is restricted to those who have signed in to take a test
            if ((string)Session["TakingTest"] != "true") {

                // If the session state is lost, check for the existence of a backup cookie
                HttpCookie SessionBackup = Request.Cookies.Get("FCSdata");
                if (SessionBackup != null) {
                    string[] FCSdata = Global.Decrypt(SessionBackup.Value).Split(';');
                    if (FCSdata[0] == "true") {
                        Session["ConferenceID"] = FCSdata[1];
                        Session["RegionalTestsID"] = FCSdata[2];
                        Session["MemberID"] = FCSdata[3];
                        Session["Name"] = FCSdata[4];
                        Session["EventID"] = FCSdata[5];
                        Session["EventType"] = FCSdata[6];
                    } else {
                        // If the cookie is not valid, go to login in page
                        Server.Transfer("default.aspx");
                    }
                } else {
                    // If the cookie is missing , go to login in page
                    Server.Transfer("default.aspx");
                }
            }

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = "#TakingTest";
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
            #endregion

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            SqlCommand sqlCmd = new SqlCommand("", cnn);
            cnn.Open();

            if (!IsPostBack) {

                #region Get the name of the conference and the event being tested on
                SqlDataAdapter sqlConfEvent = new SqlDataAdapter(
                    "SELECT ConferenceName, EventName, EventType FROM Conferences INNER JOIN NationalEvents E ON" +
                    " E.EventID=" + Session["EventID"] + " WHERE ConferenceID=" + Session["ConferenceID"], cnn);
                DataTable tblConfEvent = new DataTable();
                sqlConfEvent.Fill(tblConfEvent);
                lblConferenceName.Text = tblConfEvent.Rows[0]["ConferenceName"].ToString();
                lblEventName.Text = tblConfEvent.Rows[0]["EventName"].ToString();
                Session["EventType"] = tblConfEvent.Rows[0]["EventType"].ToString();

                // As a backup of the session state, store an encrypted cookie
                HttpCookie cookie = new HttpCookie("FCSdata");
                cookie.Value = Global.Encrypt("true;" +
                    Session["ConferenceID"].ToString() + ";" +
                    Session["RegionalTestsID"].ToString() + ";" +
                    Session["MemberID"].ToString() + ";" +
                    Session["Name"].ToString() + ";" +
                    Session["EventID"].ToString() + ";" +
                    Session["EventType"].ToString());
                Response.Cookies.Add(cookie);
                #endregion

                #region Determine if the student is re-entering the test by seeing if they have an elapsed time for this event
                sqlCmd.CommandText =
                    "SELECT ElapsedTime=ISNULL(ObjectiveElapsedTime,0) FROM ConferenceMemberEvents " +
                    "WHERE ConferenceID=" + Session["ConferenceID"] +
                    " AND EventID=" + Session["EventID"] +
                    " AND MemberID=" + Session["MemberID"];
                int ElapsedTime = (Int32)sqlCmd.ExecuteScalar();
                #endregion

                #region Initialize new test
                Session.Remove("Questions");
                if (ElapsedTime == 0) {
                    // Assign a default score to indicate that the test has been taken
                    // For team events, update the objective score for all team members; otherwise, just update the member's individual score
                    string sqlMember;
                    if (Session["EventType"].ToString() == "T") {
                        sqlMember =
                            "MemberID IN (SELECT TM.MemberID FROM ConferenceMemberEvents CME" +
                            " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID" +
                            " INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName" +
                            " INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID " +
                            "WHERE" +
                            " CME.ConferenceID=" + Session["ConferenceID"] +
                            " AND CME.EventID=" + Session["EventID"] +
                            " AND CME.MemberID=" + Session["MemberID"] + ")";
                    } else {
                        sqlMember = "MemberID=" + Session["MemberID"];
                    }
                    // Give team members a default score of -9
                    sqlCmd.CommandText =
                        "UPDATE ConferenceMemberEvents SET ObjectiveScore=-9 " +
                        "WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND " + sqlMember;
                    sqlCmd.ExecuteNonQuery();
                    // Give the person who signed in a default score of -10
                    sqlCmd.CommandText =
                        "UPDATE ConferenceMemberEvents SET ObjectiveScore=-10 " +
                        "WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"];
                    sqlCmd.ExecuteNonQuery();

                    // Set Testing Time for only the person who is signed in for the test -- for team events, this is just one of the team members
                    sqlCmd.CommandText =
                        "UPDATE ConferenceMemberEvents SET TestingTime=SYSDATETIME()" +
                        " WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"];
                    sqlCmd.ExecuteNonQuery();

                    // Delete any previous test responses for this event for this member, just in case
                    sqlCmd.CommandText =
                        "DELETE R FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID " +
                        "WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"];
                    sqlCmd.ExecuteNonQuery();

                    // Generate default answers for this test for this member
                    sqlCmd.CommandText =
                        "INSERT INTO TestResponses" +
                        " SELECT MemberID=" + Session["MemberID"] + ", ConferenceID=" + Session["ConferenceID"] + ", QuestionID, Response=5" +
                        " FROM TestQuestions Q" +
                        " WHERE Q.RegionalTestsID=" + Session["RegionalTestsID"] + " AND Q.EventID=" + Session["EventID"];
                    sqlCmd.ExecuteNonQuery();

                    // Start the test time limit countdown
                    Session["TestTimeLimit"] = DateTime.Now.AddMinutes(60);
                }
                #endregion

                #region Re-enter a test in progress
                if (ElapsedTime != 0) {
                    // If there is a non-zero elapsed time, then the student is re-entering a test already in progress.
                    // The TestResponses table contains all the answers they've entered so far.
                    // We just need to reset the objective score (in case it's been set to -1) and set the countdown clock to give them as much time as they had remaining.
                    sqlCmd.CommandText =
                        "UPDATE ConferenceMemberEvents SET ObjectiveScore=-10 " +
                        "WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"];
                    sqlCmd.ExecuteNonQuery();
                    TimeSpan time1 = new TimeSpan(0, 0, 0, 0, ElapsedTime);
                    Session["TestTimeLimit"] = DateTime.Now.AddMinutes(60).Subtract(time1);
                }
                #endregion

                #region Populate the form with the questions for this test and the responses for this student
                sqlTestQuestions.SelectParameters["RegionalTestsID"].DefaultValue = Session["RegionalTestsID"].ToString();
                sqlTestQuestions.SelectParameters["ConferenceID"].DefaultValue = Session["ConferenceID"].ToString();
                sqlTestQuestions.SelectParameters["EventID"].DefaultValue = Session["EventID"].ToString();
                sqlTestQuestions.SelectParameters["MemberID"].DefaultValue = Session["MemberID"].ToString();
                sqlTestQuestions.DataBind();
                fvTestQuestions.DataBind();
                lblCurrentQuestion.Text = (fvTestQuestions.PageIndex + 1).ToString();
                lblTotalQuestions.Text = fvTestQuestions.PageCount.ToString();
                #endregion
            }

            #region Every time the page loads, see if we have a cached table containing the current responses; generate one if needed
            DataTable tblCurrentResponses = new DataTable();
            if (Session["Responses"] == null) {
                SqlDataAdapter sqlQuestionResponses = new SqlDataAdapter(
                    "SELECT R.* FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID " +
                    "WHERE Q.EventID=" + Session["EventID"] +
                    " AND R.ConferenceID=" + Session["ConferenceID"] +
                    " AND R.MemberID=" + Session["MemberID"], cnn);
                sqlQuestionResponses.Fill(tblCurrentResponses);
                Session["Responses"] = tblCurrentResponses;
            } else {
                tblCurrentResponses = (DataTable)Session["Responses"];
            }
            #endregion

            #region Every time the page loads, display the number of unanswered questions remaining and how much time is left
            DataRow[] NumUnanswered = tblCurrentResponses.Select("Response=5");
            lblUnanswered.Text = NumUnanswered.Length.ToString();
            Timer1_Tick(null, null);
            #endregion

            cnn.Close();
        }

        protected void fvTestQuestions_DataBound(object sender, EventArgs e) {
            DataRowView drv = (DataRowView)fvTestQuestions.DataItem;
            if (drv == null) return;
            if (drv["ImageType"].ToString().Length == 0) ((Image)fvTestQuestions.FindControl("QuestionImage")).Visible = false;
            ((RadioButton)fvTestQuestions.FindControl("AnswerChoice3")).Visible = (drv["QuestionType"].ToString() != "2");
            ((RadioButton)fvTestQuestions.FindControl("AnswerChoice4")).Visible = (drv["QuestionType"].ToString() != "2");
            lblCurrentQuestion.Text = (fvTestQuestions.PageIndex + 1).ToString();
        }

        protected void AnswerChoice_Changed(Object sender, EventArgs e) {
            string control = ((RadioButton)sender).ID;
            string AnswerChoice = control.Substring(control.Length - 1, 1);

            // Update the cached copy of the current responses so we can calculate how many unanswered questions there are when the page loads
            DataTable tblCurrentResponses = (DataTable)Session["Responses"];
            DataRow[] CurrentQuestion = tblCurrentResponses.Select("QuestionID=" + ((Label)fvTestQuestions.FindControl("QuestionID")).Text);
            CurrentQuestion[0][3] = AnswerChoice;
            Session["Responses"] = tblCurrentResponses;

            // Record the response
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                SqlCommand cmd = new SqlCommand(
                    "UPDATE TestResponses SET Response=" + AnswerChoice +
                    " WHERE ConferenceID=" + Session["ConferenceID"] +
                    " AND MemberID=" + Session["MemberID"] +
                    " AND QuestionID=" + ((Label)fvTestQuestions.FindControl("QuestionID")).Text, cnn);
                cmd.ExecuteNonQuery();
                // Save the the current and elapsed time for the member who's signed in to take the test
                TimeSpan ElapsedTime = new TimeSpan();
                ElapsedTime = DateTime.Now.AddMinutes(60) - (DateTime)Session["TestTimeLimit"];
                cmd.CommandText =
                    "UPDATE ConferenceMemberEvents SET TestingTime=SYSDATETIME(), ObjectiveElapsedTime=" + ((int)ElapsedTime.TotalMilliseconds).ToString() +
                    " WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"];
                cmd.ExecuteNonQuery();

                #region Score
                /*
                 * DO NOT calculate and save the score each time they answer a question -- it's too slow (1/29/2014)
                 * 

                // For team events, update the objective score for all team members; otherwise, just update the member's individual score
                string sqlMember;
                if (Session["EventType"].ToString() == "T") {
                    sqlMember =
                        "MemberID IN (SELECT TM.MemberID FROM ConferenceMemberEvents CME" +
                        " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID" +
                        " INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName" +
                        " INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID " +
                        "WHERE" +
                        " CME.ConferenceID=" + Session["ConferenceID"] +
                        " AND CME.EventID=" + Session["EventID"] +
                        " AND CME.MemberID=" + Session["MemberID"] + ")";
                } else {
                    sqlMember = "MemberID=" + Session["MemberID"];
                }
                string sqlScore =
                    "SELECT Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END) " +
                    "FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID " +
                    "WHERE R.ConferenceID=" + Session["ConferenceID"] + " AND Q.EventID=" + Session["EventID"] + " AND R.MemberID=" + Session["MemberID"];
                cmd.CommandText =
                    "UPDATE ConferenceMemberEvents SET OnlineTestScore=S.Score, ObjectiveScore=S.Score" +
                    " FROM (" + sqlScore + ") S" +
                    " WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND " + sqlMember;
                cmd.ExecuteNonQuery();

                */
                #endregion

                cnn.Close();
            }
        }

        protected void btnUnanswered_Click(object sender, EventArgs e) {

            // Get a list of the unanswered questions from our cached table of responses
            DataRow[] Unanswered = ((DataTable)Session["Responses"]).Select("Response=5");
            const int QuestionID = 2;

            // Get a list of the test questions so we can determine the correct page index
            // If it's not already cached locally, query the database
            DataTable tblTestQuestions = new DataTable();
            if (Session["Questions"] == null) {
                using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                    cnn.Open();
                    SqlDataAdapter sqlTestQuestions = new SqlDataAdapter(
                        "SELECT QuestionID FROM TestQuestions" +
                        " WHERE RegionalTestsID=" + Session["RegionalTestsID"] + " AND EventID=" + Session["EventID"] +
                        " ORDER BY QuestionNumber", cnn);
                    sqlTestQuestions.Fill(tblTestQuestions);
                    Session["Questions"] = tblTestQuestions;
                    cnn.Close();
                }
            } else {
                tblTestQuestions = (DataTable)Session["Questions"];
            }

            bool Found = false;
            // If we're on the last question, we'll need to start from the beginning
            // Otherwise, start looking for an unanswered question starting with the next available question after the current one
            if (fvTestQuestions.PageIndex + 1 < fvTestQuestions.PageCount) {
                for (int i = fvTestQuestions.PageIndex + 1; i < tblTestQuestions.Rows.Count; i++) {
                    for (int j = 0; j < Unanswered.Length; j++) {
                        if ((int)tblTestQuestions.Rows[i][0] == Int32.Parse(Unanswered[j][QuestionID].ToString())) {
                            Found = true;
                            fvTestQuestions.PageIndex = i;
                            break;
                        }
                    }
                    if (Found) break;
                }
            }

            // If we haven't found a match yet, start looking for an unanswered question from the beginning
            if (!Found) {
                for (int i = 0; i < fvTestQuestions.PageIndex; i++) {
                    for (int j = 0; j < Unanswered.Length; j++) {
                        if ((int)tblTestQuestions.Rows[i][0] == Int32.Parse(Unanswered[j][QuestionID].ToString())) {
                            Found = true;
                            fvTestQuestions.PageIndex = i;
                            break;
                        }
                    }
                    if (Found) break;
                }
            }
        }

        protected void btnFinished_Click(object sender, EventArgs e) {
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Clear the testing time for the member who signed in when they've finished taking this test
                SqlCommand cmd = new SqlCommand(
                    "UPDATE ConferenceMemberEvents SET TestingTime=NULL " +
                    "WHERE ConferenceID=" + Session["ConferenceID"] + " AND EventID=" + Session["EventID"] + " AND MemberID=" + Session["MemberID"], cnn);
                cmd.ExecuteNonQuery();
                cnn.Close();
            }
            popupErrorMsg.Show();
        }

        protected void Timer1_Tick(object sender, EventArgs e) {
            if (Session["TestTimeLimit"] == null) return;

            TimeSpan time1 = new TimeSpan();
            time1 = (DateTime)Session["TestTimeLimit"] - DateTime.Now;
            if (time1.TotalSeconds <= 0) {
                Timer1.Enabled = false;
                lblPopup.Text = "Time limit reached.";
                popupErrorMsg.Show();
            }
            else {
                lblCountdown.Text = String.Format("{0}:{1:D2}", time1.Minutes,time1.Seconds);
            }
        }
    }
}