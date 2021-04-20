using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Import : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // Maintenance is restricted to the global and state Advisers
            if (((string)Session["UserLevel"] != "#Global") && ((string)Session["UserLevel"] != "#State")) Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
        }

        protected void btnImport_Click(object sender, EventArgs e) {
            if (uplFile.HasFile) {

                lstResults.Items.Clear(); // empty the results list

                string f = Environment.GetEnvironmentVariable("TEMP") + "\\" + uplFile.FileName;
                if (File.Exists(f)) File.Delete(f);
                uplFile.SaveAs(f);
                string[] lines = File.ReadAllLines(f);

                // used to perform any needed update queries
                SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
                cnn.Open();
                SqlCommand cmd = new SqlCommand("", cnn);

                // Fill a table with Chapter info
                SqlDataAdapter da = new SqlDataAdapter("select * from Chapters", cnn);
                DataTable Chapters = new DataTable();
                da.Fill(Chapters);
                DataRow[] ChapterRows;
                // Fill a table with Member info for students who haven't already graduated
                da = new SqlDataAdapter(
                    "select * from NationalMembers where GraduatingClass >= " + ((DateTime.Now.Year) + ((DateTime.Now.Month > 7) ? 1 : 0)), cnn);
                DataTable Members = new DataTable();
                da.Fill(Members);
                DataRow[] MemberRows;

                string[] ImportRow;
                string NationalChapterID, NationalMemberID, FirstName, LastName;
                bool MemberExists, NeedsUpdate;
                int GradYear;

                // ind_id, ind_first_name, ind_middle_initial, ind_last_name, school_name, school_name2, fbla_oid, member_type, state, fbla_year, fbla_office, last_active_year, date_paid
                // 0 = NationalMemberID
                // 1 = FirstName
                // 3 = LastName
                // 6 = NationalChapterID
                // 9 = student's grade: 7, 8, 9, 10, 11, or 12
                for (int i = 1; i < lines.Length; i++) {
                    ImportRow = lines[i].Split('\t');
                    NationalMemberID = ImportRow[0];
                    FirstName = ImportRow[1].Replace("'", "''").Trim();
                    LastName = ImportRow[3].Replace("'", "''").Trim();
                    NationalChapterID = ImportRow[6];
                    MemberExists = false; // Assume the member does not yet exist
                    NeedsUpdate = false;  // Assume there are no updated needed

                    #region Attempt to import/update student data
                    try {
                        // If it's after July, we're in the first half of a new school year; otherwise, we're in the second half of the school year
                        GradYear = DateTime.Now.Year + 12 - Int32.Parse(ImportRow[9]) + ((DateTime.Now.Month > 7) ? 1 : 0);
                        // Attempt to locate chapter by NationalID
                        ChapterRows = Chapters.Select("NationalChapterID=" + NationalChapterID);
                        if (ChapterRows.Length != 0) {
                            // Attempt to locate student by National ID
                            MemberRows = Members.Select("NationalMemberID=" + NationalMemberID);
                            #region Found student by National ID
                            if (MemberRows.Length != 0) {
                                // Verify student hasn't been transferred to a different chapter
                                if (MemberRows[0]["ChapterID"].ToString() == ChapterRows[0]["ChapterID"].ToString()) {
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
                                    cmd.CommandText =
                                        "UPDATE NationalMembers SET NationalMemberID=NULL, isPaid=0, isInactive=1 " +
                                        "WHERE NationalMemberID=" + NationalMemberID;
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            #endregion
                            #region Did not find student by National Student ID
                            if (!MemberExists) {
                                // Attempt to locate student by chapter & name
                                MemberRows = Members.Select(
                                    "FirstName='" + FirstName + "' AND " +
                                    "LastName='" + LastName + "' AND " +
                                    "ChapterID=" + ChapterRows[0]["ChapterID"].ToString());
                                #region Found student by chapter & name
                                if (MemberRows.Length != 0) {
                                    // Update student by chapter & name
                                    cmd.CommandText =
                                        "UPDATE NationalMembers SET isPaid=1, isInactive=0," +
                                        " GraduatingClass=" + GradYear + "," +
                                        " NationalMemberID=" + NationalMemberID +
                                        "  WHERE MemberID=" + MemberRows[0]["MemberID"].ToString();
                                    cmd.ExecuteNonQuery();
                                }
                                #endregion
                                #region Student not found in database
                                else {
                                    // Add new student record
                                    cmd.CommandText =
                                        "INSERT INTO NationalMembers (NationalMemberID, ChapterID, isPaid, FirstName, LastName, GraduatingClass) VALUES (" +
                                        NationalMemberID + "," +
                                        ChapterRows[0]["ChapterID"].ToString() + ",1," +
                                        "'" + FirstName + "'," +
                                        "'" + LastName + "'," +
                                        GradYear + ")";
                                    cmd.ExecuteNonQuery();
                                }
                                #endregion
                            }
                            #endregion
                        } else {
                            lstResults.Items.Add(
                                "Cannot update " + FirstName + " " + LastName + ", chapter not found: NationalChapterID=" + NationalChapterID + ", School=" + ImportRow[4]);
                        }
                    }
                    catch {
                        // Each student must have a valid graduating class before being marked as paid
                        lstResults.Items.Add(
                            "Cannot update " + FirstName + " " + LastName + ", graduating class not specified, School=" + ImportRow[4]);
                    }
                    #endregion
                }
                lstResults.Items.Add("** Import complete");

                // Remove spurious members who are not National members and are not signed up for any conference events
                cmd.CommandText =
                    "DELETE FROM NationalMembers WHERE MemberID IN" +
                    "(SELECT DISTINCT M.MemberID" +
                    " FROM NationalMembers M LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID " +
                    "WHERE ISNULL(M.NationalMemberID,0)=0 AND CME.ConferenceID IS NULL)";
                // There are too many CME records now, so this takes too long
                // I might work on structuring the query to be more efficient at some point...
                //cmd.ExecuteNonQuery();

                cnn.Close();
                //File.Delete(f);
            }
        }

        private void Import_XML() {

            string NationalChapterID = "5791";

            DataTable myDataTable = new DataTable();
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(
                new Uri("http://ams.fbla-pbl.org/fbla/main/chapter_export_national.asp?AuthCode=Secret_Password&ChapterID=" + NationalChapterID));
            myRequest.Method = "GET";
            myRequest.Accept = "text/xml";
            myRequest.AllowAutoRedirect = true; 

            try {
                HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
                using (Stream responseStream = myResponse.GetResponseStream()) {
                    myDataTable.ReadXml(responseStream);
                }
            } catch { }
        
        }

        /* private void Reading_Writing_XML() {
            // Example for reading XML file into SQL table.
            DataTable sourceData = new DataTable();
            sourceData.ReadXml("c:\\nationalevents.xml");
            using (SqlBulkCopy bulk = new SqlBulkCopy(ConfigurationManager.ConnectionStrings["FBLA Sign-Up ConnectionString"].ToString(), SqlBulkCopyOptions.TableLock)) {
                bulk.BatchSize = 512;
                bulk.BulkCopyTimeout = 120;
                bulk.DestinationTableName = "_tmp_NationalEvents";
                bulk.WriteToServer(sourceData);
            }

         * // Example for writting SQL table to XML file.
            SqlDataAdapter adapter = new SqlDataAdapter(
                "SELECT * FROM Students",
                ConfigurationManager.ConnectionStrings["FBLA Sign-Up ConnectionString"].ToString());
            DataTable table = new DataTable();
            adapter.Fill(table);
            table.TableName = "Students";
            table.WriteXml("c:\\students.xml", XmlWriteMode.WriteSchema, false);
        }
        */
    }
}