using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {

            //Response.Redirect("http://fcs2.cloudapp.net/", true);

            if (!IsPostBack) {

                // Populate username from cookie if available
                HttpCookie cookie = Request.Cookies.Get("FCSUsername");
                if (cookie != null) {
                    Username.Text = cookie.Value;
                    Password.Focus();
                    RememberMe.Checked = true;
                } else {
                    Username.Focus();
                    RememberMe.Checked = false;
                }
            } else {
                // When a user logs out, they return to this page, so hide the logout link and reset the user type
                ((Panel)Master.FindControl("LogoutLink")).Visible = false;
                Session["UserType"] = "none";
                Session["TakingTest"] = "false";
                Session["JudgingEvent"] = "false";
                HttpCookie cookie = new HttpCookie("FCSdata");
                cookie.Value = "empty";
                cookie.Expires = DateTime.Now.AddHours(1);
                Response.Cookies.Add(cookie);
            }
        }

        private bool LoginCheck(string UserLevel, string UserType) {

            // UserLevel is one of: State, Region, Chapter
            // UserType is one of: Adviser or Students

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            conn.Open();
            SqlCommand login = new SqlCommand(
                "SELECT StateID, RegionID, ChapterID, " + UserLevel + "Name AS Name FROM " + UserLevel + "s " +
                "WHERE LOWER(" + UserType + "Username)=@username AND " + UserType + "Password=@password",conn);
            login.Parameters.Add("@username", SqlDbType.VarChar).Value = Username.Text.ToLower();
            login.Parameters.Add("@password", SqlDbType.VarChar).Value = Password.Text;
            SqlDataAdapter adapter = new SqlDataAdapter(login);
            DataTable tblLogins = new DataTable();
            adapter.Fill(tblLogins);
            conn.Close();
            if (tblLogins.Rows.Count != 0) {
                NotFound.Visible = false;
                Session["UserLevel"] = ((int)tblLogins.Rows[0]["StateID"] != 0) ? "#" + UserLevel : "#State";
                Session["UserType"] = UserType;
                Session["StateID"] = tblLogins.Rows[0]["StateID"];       // the global admin will have State = 0
                Session["RegionID"] = tblLogins.Rows[0]["RegionID"];     // state admins will have Region = 0
                Session["ChapterID"] = tblLogins.Rows[0]["ChapterID"];   // regional admins will have Chapter = 0
                Session["Name"] = tblLogins.Rows[0]["Name"];
                return true;
            } else
                return false;
        }

        private void JudgeLoginCheck() {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            conn.Open();
            SqlCommand login = new SqlCommand(
                "SELECT JudgeID, ConferenceID, E.EventID, E.EventType, JudgeUsername " +
                "FROM JudgeCredentials J" +
                " INNER JOIN NationalEvents E ON J.EventID=E.EventID "+
                "WHERE LOWER(JudgeUsername)=@username AND JudgePassword=@password", conn);
            login.Parameters.Add("@username", SqlDbType.VarChar).Value = Username.Text.ToLower();
            login.Parameters.Add("@password", SqlDbType.VarChar).Value = Password.Text;
            SqlDataAdapter adapter = new SqlDataAdapter(login);
            DataTable tblLogins = new DataTable();
            adapter.Fill(tblLogins);
            if (tblLogins.Rows.Count != 0) {
                NotFound.Visible = false;
                ((Panel)Master.FindControl("LogoutLink")).Visible = true;

                Session["JudgingEvent"] = "true";
                Session["JudgeID"] = tblLogins.Rows[0]["JudgeID"];
                Session["ConferenceID"] = tblLogins.Rows[0]["ConferenceID"];
                Session["EventID"] = tblLogins.Rows[0]["EventID"];
                Session["EventType"] = tblLogins.Rows[0]["EventType"];
                Session["Name"] = tblLogins.Rows[0]["JudgeUsername"];

                // Save session state variables in a cookie in case the session gets interrupted
                Response.Cookies["FCSdata"].Value = Global.Encrypt("true;" +
                    Session["JudgeID"].ToString() + ";" +
                    Session["ConferenceID"].ToString() + ";" +
                    Session["EventID"].ToString() + ";" +
                    Session["EventType"].ToString() + ";" +
                    Session["Name"].ToString());

                // Go to the judge score entry page
                Response.Redirect("Judge-ScoreEntry.aspx");
            }
        }

        private void TestLoginCheck() {
            string Redirect = "false";
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            conn.Open();
            SqlCommand login = new SqlCommand(
                "SELECT TC.ConferenceID, C.RegionalTestsID, M.MemberID, FirstName+' '+LastName AS Name " +
                "FROM TestCredentials TC"+
                " INNER JOIN Conferences C ON TC.ConferenceID=C.ConferenceID AND C.OnlineTestingEnd >= CONVERT(date, GETDATE()+(@TZO/1440.0))" +
                " INNER JOIN NationalMembers M ON TC.MemberID=M.MemberID " +
                "WHERE LOWER(TestUsername)=@username AND TestPassword=@password", conn);
            login.Parameters.Add("@username", SqlDbType.VarChar).Value = Username.Text.ToLower();
            login.Parameters.Add("@password", SqlDbType.VarChar).Value = Password.Text;
            login.Parameters.Add("@TZO", SqlDbType.VarChar).Value = (Request.Cookies["TZO"] != null) ? Request.Cookies["TZO"].Value.ToString() : "0";
            SqlDataAdapter adapter = new SqlDataAdapter(login);
            DataTable tblLogins = new DataTable();
            adapter.Fill(tblLogins);
            if (tblLogins.Rows.Count != 0) {
                NotFound.Visible = false;
                ((Panel)Master.FindControl("LogoutLink")).Visible = true;

                Session["TakingTest"] = "true";
                Session["ConferenceID"] = tblLogins.Rows[0]["ConferenceID"];
                Session["RegionalTestsID"] = tblLogins.Rows[0]["RegionalTestsID"];
                Session["MemberID"] = tblLogins.Rows[0]["MemberID"];
                Session["Name"] = tblLogins.Rows[0]["Name"];

                // Determine if this member is in the process of taking an event, which means they were taking one within the past 4 minutes
                SqlCommand cmd = new SqlCommand("SELECT ISNULL(MIN(EventID),0) FROM ConferenceMemberEvents " +
                    "WHERE (ObjectiveScore=-1 OR SYSDATETIME()<DATEADD(minute,4,TestingTime))" +
                    " AND ConferenceID=" + Session["ConferenceID"].ToString() +
                    " AND MemberID=" + Session["MemberID"].ToString(), conn);
                int TestInProgress = (Int32)cmd.ExecuteScalar();
                conn.Close();
                if (TestInProgress != 0) {
                    Session["EventID"] = TestInProgress;
                    Redirect = "Test-ConfEvent.aspx";
                } else {
                    Session["EventID"] = "0";
                    Redirect = "Test-Selection.aspx";
                }
                Response.Cookies["FCSdata"].Value = Global.Encrypt("true;" +
                    Session["ConferenceID"].ToString() + ";" +
                    Session["RegionalTestsID"].ToString() + ";" +
                    Session["MemberID"].ToString() + ";" +
                    Session["Name"].ToString() + ";" +
                    Session["EventID"].ToString() + ";I");
            }
            if (Redirect != "false") Response.Redirect(Redirect);
        }

        protected void LogIn_Click(object sender, EventArgs e) {

            // Check to see if a judge is logging in to for a performance event
            JudgeLoginCheck();

            // Check to see if a student is logging in to take a test
            TestLoginCheck();

            // Check the various accounts for a valid login
            if (!LoginCheck("State", "Adviser"))
                if (!LoginCheck("Region", "Adviser"))
                    if (!LoginCheck("Chapter", "Adviser"))
                        LoginCheck("Chapter", "Students");

            if ((string)Session["UserType"] == "none") {
                // If username/password not found, display error msg and stay on this page
                NotFound.Visible = true;
                Password.Focus();
            } else {
                if (RememberMe.Checked) {
                    HttpCookie cookie = new HttpCookie("FCSUsername");
                    cookie.Value = Username.Text;
                    cookie.Expires = DateTime.Now.AddYears(1);
                    Response.Cookies.Add(cookie);
                } else {
                    HttpCookie cookie = new HttpCookie("FCSUsername");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }

                // Each time someone successfully logs in, check to see if there's any system maintenance that needs doing
                SystemMaintenance();

                // If a chapter member/adviser logs in, import that chapter's members from Nationals
                if (Session["ChapterID"].ToString() != "0") ImportMembers(Session["ChapterID"].ToString());

                // Display logout link
                ((Panel)Master.FindControl("LogoutLink")).Visible = true;

                // Redirect to the conference sign-up page
                // May change this later to start on different pages for admins vs. students
                Server.Transfer("Event-SignUp.aspx");
            }
        }

        private void SystemMaintenance() {
            SqlDataAdapter daSysMaint = new SqlDataAdapter(
                "SELECT * FROM SystemMaintenance",
                ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            DataTable dtSysMaint = new DataTable();
            daSysMaint.Fill(dtSysMaint);

            // Check to see if we need to do system maintenance
            if (DateTime.Today.CompareTo((DateTime)dtSysMaint.Rows[0]["MaintenanceDate"]) <= 0) return;

            #region Weekly maintenance
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Update the date for the next maintenance check to be one week from now
                SqlCommand cmd = new SqlCommand("UPDATE SystemMaintenance SET MaintenanceDate=GETDATE()+7", cnn);
                cmd.ExecuteNonQuery();

                // For any past conferences:
                // * delete any judge sign-in credentials
                // * delete any unused judge comments
                // * delete any test sign-in credentials // and question responses (keeping responses for now)
                cmd.CommandText =
                    "DELETE FROM JudgeCredentials WHERE ConferenceID IN (SELECT ConferenceID FROM Conferences WHERE ConferenceDate < GETDATE()-3)";
                cmd.ExecuteNonQuery();
                cmd.CommandText =
                    "DELETE FROM JudgeComments WHERE PerfComments='(No comments)' AND ConferenceID IN (SELECT ConferenceID FROM Conferences WHERE ConferenceDate < GETDATE()-3)";
                cmd.ExecuteNonQuery();
                cmd.CommandText =
                    "DELETE FROM TestCredentials WHERE ConferenceID IN (SELECT ConferenceID FROM Conferences WHERE ConferenceDate < GETDATE()-3)";
                cmd.ExecuteNonQuery();

                //cmd.CommandText =
                //    "DELETE FROM TestResponses WHERE ConferenceID IN (SELECT ConferenceID FROM Conferences WHERE ConferenceDate < GETDATE()-3)";
                //cmd.ExecuteNonQuery();


                // There are a couple of once-a-year maintenance tasks we need to do after July
                if (DateTime.Now.Month > 7 && (int)dtSysMaint.Rows[0]["CurrentYear"] < DateTime.Now.Year) {

                    // Update to the current year
                    cmd.CommandText = "UPDATE SystemMaintenance SET CurrentYear=" + DateTime.Now.Year;
                    cmd.ExecuteNonQuery();

                    // Clear flags for everyone in the system
                    cmd.CommandText = "UPDATE NationalMembers SET isPaid=0, isVotingDelegate=0, isStateEligible=0, isNationalEligible=0,ChapterPosition=NULL";
                    cmd.ExecuteNonQuery();
                    cmd.CommandText = "UPDATE Chapters SET OutstandingStudent=NULL";
                    cmd.ExecuteNonQuery();

                    // Roll off the senior class that just graduated
                    cmd.CommandText = "UPDATE NationalMembers SET isInactive=1, NationalMemberID=NULL WHERE GraduatingClass=" + DateTime.Now.Year;
                    cmd.ExecuteNonQuery();

                    // Remove spurious members who are no longer National members and never signed up for any conference events
                    cmd.CommandText =
                        "DELETE FROM NationalMembers WHERE MemberID IN " +
                        "(SELECT DISTINCT M.MemberID" +
                        " FROM NationalMembers M LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID " +
                        "WHERE ISNULL(M.NationalMemberID,0)=0 AND CME.ConferenceID IS NULL)";
                    cmd.ExecuteNonQuery();
                }
                cnn.Close();
            }
            #endregion
        }

        private void ImportMembers(string ChapterID) {

            DataSet ds = new DataSet();
            SqlDataAdapter da;
            DataRow[] MemberRows;
            string NationalChapterID;
            string NationalMemberID, FirstName, LastName;
            bool MemberExists, NeedsUpdate;
            int GradYear;

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            cnn.Open();
            // The import will mark all the members from Nationals as paid, so start by setting everyone to not paid
            //SqlCommand cmd = new SqlCommand("UPDATE NationalMembers SET isPaid=0 WHERE ChapterID=" + ChapterID, cnn);
            //cmd.ExecuteNonQuery();
            SqlCommand cmd = new SqlCommand("", cnn);

            #region Fill a table with this Chapter's info and determine if an import is needed
            da = new SqlDataAdapter(
                "SELECT *, isImported=CASE WHEN ImportedDate=CONVERT(date,GETDATE()) THEN 'Y' ELSE 'N' END FROM Chapters WHERE ChapterID=" + ChapterID, cnn);
            da.Fill(ds, "Chapters");
            NationalChapterID = ds.Tables["Chapters"].Rows[0]["NationalChapterID"].ToString();

            // Only import the National members once per day
            if (ds.Tables["Chapters"].Rows[0]["isImported"].ToString() == "Y") return;
            
            #endregion

            #region Import data from Nationals web page using XML
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(
                new Uri("http://members.fbla-pbl.org/members_online/members/chapter_export_national.asp?AuthCode=Secret_Password&ChapterID=" + NationalChapterID));
            myRequest.Method = "GET";
            myRequest.Accept = "text/xml";
            myRequest.AllowAutoRedirect = true;

            int NationalMembers = 1; // This is the index in the DataSet for the table that holds the data from Nationals
            try {
                HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
                using (Stream responseStream = myResponse.GetResponseStream()) {
                    //StreamReader reader = new StreamReader(responseStream);
                    //string text = reader.ReadToEnd();
                    ds.ReadXml(responseStream, XmlReadMode.InferSchema);
                    if (ds.Tables.Count != 2 || ds.Tables[NationalMembers].Rows.Count == 0) return;
                }
            } catch (Exception ex) {
                // Something went wrong when trying to read from Nationals
                return;
            }
            #endregion

            #region Fill a table with Member info for students who haven't already graduated
            string strSQL =
                "select * from NationalMembers where" +
                // ** " ChapterID=" + ChapterID + " AND" + // ** Include all members so we can tell if a member switched to a different chapter
                " GraduatingClass >= " + ((DateTime.Now.Year) + ((DateTime.Now.Month > 7) ? 1 : 0));
            da = new SqlDataAdapter(strSQL, cnn);
            da.Fill(ds, "Members");
            #endregion
            
            // Loop through the National members for this chapter and update the system
            foreach (DataRow ImportRow in ds.Tables[NationalMembers].Rows) {
                NationalMemberID = ImportRow["IndId"].ToString();
                FirstName = ImportRow["FirstName"].ToString().Replace("'", "''").Trim();
                LastName = ImportRow["LastName"].ToString().Replace("'", "''").Trim();
                MemberExists = false; // Assume the member does not yet exist
                NeedsUpdate = false;  // Assume there are no updates needed

                #region Attempt to import student data
                try {
                    // If it's after July, we're in the first half of a new school year; otherwise, we're in the second half of the school year
                    GradYear = System.DateTime.Now.Year + 12 - Int32.Parse(ImportRow["FBLAYear"].ToString()) + ((System.DateTime.Now.Month > 7) ? 1 : 0);
                    // Attempt to locate student by National ID
                    MemberRows = ds.Tables["Members"].Select("NationalMemberID=" + NationalMemberID);
                    #region Found student by National ID
                    if (MemberRows.Length != 0) {
                        // Verify student hasn't been transferred to a different chapter
                        if (MemberRows[0]["ChapterID"].ToString() == ChapterID) {
                            MemberExists = true;
                            // See if anything needs to be updated
                            NeedsUpdate = MemberRows[0]["isPaid"].ToString() != "1";
                            NeedsUpdate |= MemberRows[0]["isInactive"].ToString() != "0";
                            NeedsUpdate |= MemberRows[0]["GraduatingClass"].ToString() != GradYear.ToString();
                            NeedsUpdate |= MemberRows[0]["FirstName"].ToString() != FirstName;
                            NeedsUpdate |= MemberRows[0]["LastName"].ToString() != LastName;
                            if (NeedsUpdate) {
                                cmd.CommandText =
                                    "UPDATE NationalMembers SET " +
                                    "isPaid=1, isInactive=0, GraduatingClass=" + GradYear + ", FirstName='" + FirstName + "', LastName='" + LastName + "' " +
                                    "WHERE NationalMemberID=" + NationalMemberID;
                                cmd.ExecuteNonQuery();
                            }
                        } else {
                            // Student was transferred to a different chapter
                            // Clear the NationalMemberID and paid flag so a new record can be created and set to that number
                            cmd.CommandText = "UPDATE NationalMembers SET NationalMemberID=NULL, isPaid=0, isInactive=1 WHERE NationalMemberID=" + NationalMemberID;
                            cmd.ExecuteNonQuery();
                        }
                    }
                    #endregion
                    #region Did not find student by National Student ID
                    if (!MemberExists) {
                        // Attempt to locate student by chapter & name
                        MemberRows = ds.Tables["Members"].Select(
                            "FirstName='" + FirstName + "' AND " +
                            "LastName='" + LastName + "' AND " +
                            "ChapterID=" + ChapterID);
                        #region Found student by chapter & name
                        if (MemberRows.Length != 0) {
                            // Update student by chapter & name
                            cmd.CommandText =
                                "UPDATE NationalMembers SET isPaid=1, isInactive=0," +
                                " GraduatingClass=" + GradYear + "," +
                                " NationalMemberID=" + NationalMemberID +
                                " FROM NationalMembers M INNER JOIN Chapters C ON M.ChapterID=C.ChapterID WHERE" +
                                " C.NationalChapterID=" + NationalChapterID + " AND M.FirstName='" + FirstName + "' AND M.LastName='" + LastName + "'";
                            cmd.ExecuteNonQuery();
                        }
                        #endregion
                        #region Student not found in database
                        else {
                            // Add new student record
                            cmd.CommandText =
                                "INSERT INTO NationalMembers (NationalMemberID, ChapterID, isPaid, FirstName, LastName, GraduatingClass) VALUES (" +
                                NationalMemberID + "," +
                                ChapterID + ",1," +
                                "'" + FirstName + "'," +
                                "'" + LastName + "'," +
                                GradYear + ")";
                            cmd.ExecuteNonQuery();
                        }
                        #endregion
                    }
                    #endregion
                }
                catch {
                    // Each student must have a valid graduating class before being marked as paid
                }
                #endregion
            }

            #region Clean up
            // Remove spurious members who are not National members and are not signed up for any conference events
            cmd.CommandText =
                "DELETE FROM NationalMembers WHERE MemberID IN" +
                "(SELECT DISTINCT M.MemberID" +
                " FROM NationalMembers M LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID " +
                "WHERE ISNULL(M.NationalMemberID,0)=0 AND CME.ConferenceID IS NULL)";

            // This query is timing out so I'm just going to skip this cleanup task -- Oct 18, 2014
            //cmd.ExecuteNonQuery();

            // Clear the paid flag for any member without a National ID
            cmd.CommandText = "UPDATE NationalMembers SET isPaid=0 WHERE NationalMemberID IS NULL";
            cmd.ExecuteNonQuery();

            // Update this chapter as having been imported today
            cmd.CommandText = "UPDATE Chapters SET ImportedDate=CONVERT(date,GETDATE()) WHERE ChapterID=" + ChapterID;
            cmd.ExecuteNonQuery();
            #endregion

            cnn.Close();
        }
    }
}
