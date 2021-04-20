using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Event_SignUp : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            if ((string)Session["UserType"] == "none") Server.Transfer("default.aspx");

            /* FOR TESTING
            Session["UserLevel"] = "#State";
            Session["UserType"] = "Adviser";
            Session["StateID"] = 0;
            Session["RegionID"] = 0;
            Session["ChapterID"] = 0;
            */

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();


            // Include timezone offset information from the client browser if available
            sqlViewConferenceList.SelectParameters["TZO"].DefaultValue =
                (Request.Cookies["TZO"] != null) ? Request.Cookies["TZO"].Value.ToString() : "0";

            if (!IsPostBack) {
                // The global admin can select any state, all other users are limited to their own state
                if ((int)Session["StateID"] == 0)
                    pnlSelState.Visible = true;
                else
                    sqlViewStateList.SelectCommand = "SELECT StateID, StateName FROM States WHERE StateID=" + Session["StateID"];

                // Global and state admins can select any region in the state, all other users are limited to their own region
                if ((int)Session["RegionID"] == 0)
                    pnlSelRegion.Visible = true;
                else
                    sqlViewRegionList.SelectCommand = "SELECT RegionID, RegionName FROM Regions WHERE RegionID=" + Session["RegionID"];

                // Globa, state, and regional admins can see all the chapters in the selected region
                if ((int)Session["ChapterID"] == 0)
                    pnlSelChapter.Visible = true;
                else
                    sqlViewChapterList.SelectCommand = "SELECT ChapterID, ChapterName FROM Chapters WHERE ChapterID=" + Session["ChapterID"];

                ddStates.DataBind();
                ddRegions.DataBind();
                ddChapters.DataBind();
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global admin
            ddRegions.DataBind();
            ddChapters.DataBind();
            ddConferences.DataBind();
        }

        protected void ddRegions_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            if (ddRegions.Items.Count == 0) {
                ddRegions.Enabled = false;
                ddRegions.Items.Add(new ListItem("[No regions defined for this state]", "-1"));
            } else
                ddRegions.Enabled = true;
        }

        protected void ddRegions_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global and state admins
            ddChapters.DataBind();
            ddConferences.DataBind();
        }

        protected void ddChapters_DataBound(object sender, EventArgs e) {
            // If the list of available chapters is empty, disable the dropdown
            if (ddChapters.Items.Count == 0) {
                ddChapters.Enabled = false;
                ddChapters.Items.Add(new ListItem("[No chapters defined for this region]", "-1"));
            } else
                ddChapters.Enabled = true;
        }

        protected void ddChapters_SelectedIndexChanged(object sender, EventArgs e) {
            ddStudents_DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If there are no conferences available, disable the dropdown and hide the assignment panels
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences currently open for registration for this region]", "-1"));
                pnlAssignStudentEvents.Visible = false;
                pnlAssignChapterEvents.Visible = false;
                pnlAddStudent.Visible = false;
            } else {
                ddConferences.Enabled = true;
                pnlAssignStudentEvents.Visible = true;
                // Only Advisers can sign up for chapter events
                pnlAssignChapterEvents.Visible = ((string)Session["UserType"] == "Adviser");
                ddStudents_DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            ddStudents_DataBind();
        }

        protected void ddStudents_DataBind() {

            // Query the selected conference for its properties
            DataTable conf = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString()))
            using (SqlDataAdapter adapter = new SqlDataAdapter("SELECT StateID, RegionID, isMembersOnly FROM Conferences WHERE ConferenceID=" + ddConferences.SelectedValue, conn)) {
                conn.Open();
                adapter.Fill(conf);
                conn.Close();
            }

            // Only show the add students panel for regional conferences that aren't limited to members only
            pnlAddStudent.Visible = ((int)((DataRow)conf.Rows[0])["isMembersOnly"] != 1);

            // If there are no chapters are available, hide the assignment panels and exit
            if (ddChapters.Items.Count == 0) {
                pnlAssignStudentEvents.Visible = false;
                pnlAssignChapterEvents.Visible = false;
                pnlAddStudent.Visible = false;
                return;
            } else {
                pnlAssignStudentEvents.Visible = true;
                // Assignment of chapter events is only available for conferences with events and only to Advisers
                pnlAssignChapterEvents.Visible =
                    ((int)((DataRow)conf.Rows[0])["isMembersOnly"] == 1) && ((string)Session["UserType"] == "Adviser");
            }

            // For the national conference, only national eligible students can sign up for events
            if ((int)((DataRow)conf.Rows[0])["StateID"] == 0) {
                sqlStudentList.SelectCommand =
                    "SELECT MemberID, LastName+', '+FirstName AS Name FROM NationalMembers WHERE ChapterID = " + ddChapters.SelectedValue +
                    " AND ISNULL(isInactive,0)=0 AND isNationalEligible=1 AND isPaid=1 ORDER BY LastName, FirstName";
            }
                // For state conferences, only state eligible students can sign up for events
            else if ((int)((DataRow)conf.Rows[0])["RegionID"] == 0) {
                sqlStudentList.SelectCommand =
                    "SELECT MemberID, LastName+', '+FirstName AS Name FROM NationalMembers WHERE ChapterID = " + ddChapters.SelectedValue +
                    " AND ISNULL(isInactive,0)=0 AND isStateEligible=1 AND isPaid=1 ORDER BY LastName, FirstName";
            }
                // For regional conferences, find out if it's open or closed to non-members
            else {
                // If the conference is limited to members only, then only students imported from the National office can participate
                if ((int)((DataRow)conf.Rows[0])["isMembersOnly"] == 1) {
                    sqlStudentList.SelectCommand =
                        "SELECT MemberID, LastName+', '+FirstName AS Name FROM NationalMembers WHERE ChapterID=" + ddChapters.SelectedValue +
                        " AND ISNULL(isInactive,0)=0 AND isPaid=1 ORDER BY LastName, FirstName";
                } else {
                    // If the conference is not limited to members only, then students who added themselves to the database at the chapter level can participate
                    sqlStudentList.SelectCommand =
                        "SELECT MemberID, LastName+', '+FirstName AS Name FROM NationalMembers WHERE ChapterID=" + ddChapters.SelectedValue +
                        " AND ISNULL(isInactive,0)=0 ORDER BY LastName, FirstName";
                }
            }
            ddStudents.DataBind();
            lstSelectedStudentEvents.DataBind();
            ddChapterStudents.DataBind();
            lstSelectedChapterEvents.DataBind();
        }

        protected void ddStudents_DataBound(object sender, EventArgs e) {
            // If the list of available students is empty, disable the dropdown and the add button
            if (ddStudents.Items.Count == 0) {
                ddStudents.Enabled = false;
                ddStudents.Items.Add(new ListItem("[No eligible students defined for this chapter]", "-1"));
                btnAddStudentEvent.Enabled = false;
            } else {
                ddStudents.Enabled = true;
                btnAddStudentEvent.Enabled = true;
            }
        }

        protected void lstSelectedStudentEvents_DataBound(object sender, EventArgs e) {
            // If the list of student events is empty, disable the remove button
            if (lstSelectedStudentEvents.Items.Count == 0)
                btnRemoveStudentEvent.Enabled = false;
            else {
                // For team events, the team member names are listed below the event name indented by non-breaking spaces
                // Apply a different color to the student names to help offset them from the event names
                for (int i = 0; i < lstSelectedStudentEvents.Items.Count; i++) {
                    if (lstSelectedStudentEvents.Items[i].Text.StartsWith("\u00a0")) {
                        lstSelectedStudentEvents.Items[i].Attributes.Add("style", "color:#5D7B9D");
                    }
                }
                btnRemoveStudentEvent.Enabled = true;
                lstSelectedStudentEvents.SelectedIndex = 0;
            }
        }

        protected void ddChapterStudents_DataBound(object sender, EventArgs e) {
            // If the list of available students is empty, disable the dropdown and the add button
            if (ddChapterStudents.Items.Count == 0) {
                ddChapterStudents.Enabled = false;
                ddChapterStudents.Items.Add(new ListItem("[No eligible students defined for this chapter]", "-1"));
                btnAddChapterEvent.Enabled = false;
            } else {
                ddChapterStudents.Enabled = true;
                btnAddChapterEvent.Enabled = true;
            }
        }

        protected void lstSelectedChapterEvents_DataBound(object sender, EventArgs e) {
            // If the list of chapter events is empty, disable the remove button
            if (lstSelectedChapterEvents.Items.Count == 0)
                btnRemoveChapterEvent.Enabled = false;
            else {
                btnRemoveChapterEvent.Enabled = true;
                lstSelectedChapterEvents.SelectedIndex = 0;
            }
        }

        protected void ddEvents_DataBound(object sender, EventArgs e) {
            // Display the number of events that the student has signed up for
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(
                    "SELECT" +
                    " NumTotalEvents=COUNT(*)," +
                    " NumPerfEvents=SUM(CASE WHEN ISNULL(E.PerformanceWeight,0)<>0 THEN 1 ELSE 0 END) " +
                    "FROM ConferenceMemberEvents CME" +
                    " INNER JOIN NationalEvents E ON CME.EventID=E.EventID " +
                    "WHERE ConferenceID=" + ddConferences.SelectedValue + " AND MemberID=" + ddStudents.SelectedValue, conn);
                DataTable evt = new DataTable();
                adapter.Fill(evt);
                lblNumTotalEvents.Text = ((DataRow)evt.Rows[0])["NumTotalEvents"].ToString();
                lblNumPerfEvents.Text = ((DataRow)evt.Rows[0])["NumPerfEvents"].ToString();
                if (lblNumPerfEvents.Text == "") lblNumPerfEvents.Text = "0";
                conn.Close();
            }
            
            if (ddEvents.Items.Count == 0) {
                ddEvents.Enabled = false;
                ddEvents.Items.Add(new ListItem("[No more events available]", "-1"));
                ddTeamNames.Enabled = false;
                ddTeamNames.Items.Clear();
                ddTeamNames.Items.Add(new ListItem("[Not a team event]", ""));
                btnAddStudentEvent.Enabled = false;
            } else {
                ddEvents.Enabled = true;
                ddTeamNames_DataBind();
                btnAddStudentEvent.Enabled = true;
            }
        }

        protected void ddEvents_SelectedIndexChanged(object sender, EventArgs e) {
            ddTeamNames_DataBind();
            lstSelectedStudentEvents_DataBound(null, null);
        }

        protected void ddTeamNames_DataBind() {
            // When the selected event that a student is signing up for changes, populate the list of team choices

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                conn.Open();
                ddTeamNames.Items.Clear();
                // Find out if it is a team event and what the maximum team size is
                SqlDataAdapter adapter = new SqlDataAdapter("SELECT EventType, MaxTeamSize FROM NationalEvents WHERE EventID=" + ddEvents.SelectedValue, conn);
                DataTable evt = new DataTable();
                adapter.Fill(evt);

                // If it is not a team event, then there's not much to do
                if ((string)((DataRow)evt.Rows[0])["EventType"] != "T") {
                    ddTeamNames.Enabled = false;
                    ddTeamNames.Items.Add(new ListItem("[Not a team event]", ""));
                } else {
                    ddTeamNames.Enabled = true;
                    // For team events, populate the list with available teams that have not already reached the maximum size
                    // We use fixed team names of the form "Team 1", "Team 2", etc.
                    for (int i = 1; i <= Convert.ToInt32(ConfigurationManager.AppSettings["MaxTeamsPerChapter"]); i++)
                        using (SqlCommand cmdTeamSize = new SqlCommand(
                                "SELECT COUNT(*) FROM ConferenceMemberEvents WHERE" +
                                " ConferenceID=" + ddConferences.SelectedValue + " AND" +
                                " TeamName = 'Team " + i + "' AND" +
                                " EventID = " + ddEvents.SelectedValue + " AND" +
                                " MemberID IN (SELECT MemberID FROM NationalMembers WHERE ChapterID = " + ddChapters.SelectedValue + ")", conn))
                            if ((int)cmdTeamSize.ExecuteScalar() < (int)((DataRow)evt.Rows[0])["MaxTeamSize"])
                                ddTeamNames.Items.Add("Team " + i.ToString());
                }
                conn.Close();

                // If the list of available teams is empty, then the maximum number of teams for the chapter has been reached
                if (ddTeamNames.Items.Count == 0) {
                    ddTeamNames.Enabled = false;
                    ddTeamNames.Items.Add(new ListItem("[No more teams available for this event]", "Full"));
                    btnAddStudentEvent.Enabled = false;
                } else {
                    btnAddStudentEvent.Enabled = true;
                }
            }
        }

        protected void btnAddStudentEvent_Click(object sender, EventArgs e) {
            try {
                sqlStudentEventMaint.Insert();
                ddEvents.DataBind();
                lstSelectedStudentEvents.DataBind();
            } catch (Exception ex) {
                lblPopup.Text = ex.Message + ((ex.InnerException != null) ? ex.InnerException.Message : "");
                popupErrorMsg.Show();
            }
        }

        protected void btnRemoveStudentEvent_Click(object sender, EventArgs e) {
            try {
                sqlStudentEventMaint.Delete();
                ddEvents.DataBind();
                lstSelectedStudentEvents.DataBind();

                using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                    cnn.Open();

                    // If this student is no longer signed up for any events for this conference,
                    // delete any associated test credentials which might have been created
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(EventID) FROM ConferenceMemberEvents " +
                        "WHERE ConferenceID=" + ddConferences.SelectedValue + " AND M.MemberID=" + ddStudents.SelectedValue, cnn);
                    if ((int)cmd.ExecuteScalar() == 0) {
                        cmd.CommandText =
                            "DELETE FROM TestCredentials WHERE ConferenceID=" + ddConferences.SelectedValue + " AND MemberID=" + ddStudents.SelectedValue;
                        cmd.ExecuteNonQuery();
                    }

                    // Check to see if this student is either a National member or has signed up for other conference events
                    cmd.CommandText =
                        "SELECT COUNT(*) FROM NationalMembers M" +
                        " LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID " +
                        "WHERE M.MemberID=" + ddStudents.SelectedValue + " AND M.NationalMemberID IS NULL AND CME.ConferenceID IS NULL";

                    // For non-National members with no other events, we can delete the student record as well
                    if ((int)cmd.ExecuteScalar() != 0) {
                        sqlStudentList.Delete();
                        ddStudents_DataBind();
                    }
                    cnn.Close();
                }
            } catch {
                // no error handling defined
            }
        }

        protected void btnAddChapterEvent_Click(object sender, EventArgs e) {
            try {
                sqlChapterEventMaint.Insert();
                ddChapterEvents.DataBind();
                lstSelectedChapterEvents.DataBind();
            } catch (Exception ex) {
                lblPopup.Text = ex.Message + ((ex.InnerException != null) ? ex.InnerException.Message : "");
                popupErrorMsg.Show();
            }
        }

        protected void btnRemoveChapterEvent_Click(object sender, EventArgs e) {
            try {
                sqlChapterEventMaint.Delete();
                ddChapterEvents.DataBind();
                lstSelectedChapterEvents.DataBind();
            } catch {
                // no error handling defined
            }
        }

        protected void fvStudent_DataBound(object sender, EventArgs e) {
            // Populate the list of graduating classes based on the current date
            DropDownList dd = (DropDownList)fvStudent.FindControl("ddGraduatingClass");
            for (int i = 1; i < 7; i++) dd.Items.Add((DateTime.Now.Year + i - ((System.DateTime.Now.Month < 8) ? 1 : 0)).ToString());
        }

        protected void fvStudent_ItemInserting(object sender, FormViewInsertEventArgs e) {
            string First, Last;
            First = ((TextBox)fvStudent.FindControl("InsertFirstName")).Text.Replace("'", "''");
            Last = ((TextBox)fvStudent.FindControl("InsertLastName")).Text.Replace("'", "''");

            // Before inserting new student record, make sure there isn't already a matching record
            SqlDataAdapter adapter = new SqlDataAdapter(
                "SELECT * FROM NationalMembers WHERE" +
                " ChapterID=" + ddChapters.Text + " AND" +
                " FirstName='" + First + "' AND LastName='" + Last + "'",
                System.Configuration.ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            DataTable tblStudent = new DataTable();
            adapter.Fill(tblStudent);
            if (tblStudent.Rows.Count == 0) {
                // When inserting a student, use the values from the drop down lists
                sqlStudentList.InsertParameters["Gender"].DefaultValue = ((DropDownList)fvStudent.FindControl("ddGender")).SelectedValue;
                sqlStudentList.InsertParameters["ShirtSize"].DefaultValue = ((DropDownList)fvStudent.FindControl("ddShirtSize")).SelectedValue;
                sqlStudentList.InsertParameters["GraduatingClass"].DefaultValue = ((DropDownList)fvStudent.FindControl("ddGraduatingClass")).SelectedValue;
                sqlStudentList.InsertParameters["ChapterPosition"].DefaultValue = ((DropDownList)fvStudent.FindControl("ddPosition")).SelectedValue;
            }
            else if ((int)tblStudent.Rows[0]["IsInactive"] == 1) {
                string MemberID = tblStudent.Rows[0]["MemberID"].ToString();
                using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                    cnn.Open();
                    // Reactive an existing student
                    SqlCommand cmd = new SqlCommand("UPDATE NationalMembers SET IsInactive=0 WHERE MemberID=" + MemberID, cnn);
                    cmd.ExecuteNonQuery();
                    cnn.Close();
                }
                e.Cancel = true;
                //lblPopup.Text = First + " " + Last + " is now an active member.";
                //popupErrorMsg.Show();
                LeadershipSignUp(MemberID, First, Last);
            }
            else {
                e.Cancel = true;
                lblPopup.Text = First + " " + Last + " is already a member.";
                popupErrorMsg.Show();
            }
        }

        protected void sqlStudentList_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            // Make the new student be the current selection
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + " : " + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            }
            else {
                DbCommand command = e.Command;
                LeadershipSignUp(
                    command.Parameters["@MemberID"].Value.ToString(),
                    command.Parameters["@FirstName"].Value.ToString(),
                    command.Parameters["@LastName"].Value.ToString());
            }
        }

        protected void LeadershipSignUp(string MemberID, string First, string Last) {
            ddStudents_DataBind();
            ddStudents.SelectedValue = MemberID;
            sqlStudentEventList.Select(DataSourceSelectArguments.Empty);
            ddEvents.DataBind();

            // Since you can only add students for the Leadership conferences, and
            // since leadership conferences only have one event, then we know we can go ahead and
            // add the selected event for the new student
            try {
                sqlStudentEventMaint.Insert();
                ddEvents.DataBind();
                lstSelectedStudentEvents.DataBind();
                lblPopup.Text =
                    First + " " + Last + " successfully added to the Leadership Conference.";
                popupErrorMsg.Show();
            }
            catch (Exception ex) {
                lblPopup.Text = ex.Message + ((ex.InnerException != null) ? ex.InnerException.Message : "");
                popupErrorMsg.Show();
            }

        }

    }
}