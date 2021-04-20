using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System
{
    public partial class Test_GenerateSignIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Maintenance is restricted to Advisers at the regional level and above
            if (((string)Session["UserType"] == "none") || ((string)Session["UserLevel"] == "#Chapter")) Server.Transfer("default.aspx");

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
                if ((int)Session["RegionID"] == 0) {
                    pnlSelRegion.Visible = true;
                } else {
                    // Regional and chapter admins are limited to their own region
                    sqlViewRegionList.SelectCommand = "SELECT RegionID, RegionName FROM Regions WHERE RegionID=" + Session["RegionID"];
                    ddRegions.DataBind();
                    ddConferences.DataBind();
                    gvSignIns.DataBind();
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global admin
            ddRegions.DataBind();
            ddConferences.DataBind();
            gvSignIns.DataBind();
        }

        protected void ddRegions_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            if (ddRegions.Items.Count == 0) {
                ddRegions.Enabled = false;
                ddRegions.Items.Add(new ListItem("[No regions defined for this state]", "-1"));
            }
            else {
                ddRegions.Enabled = true;
                ddConferences.DataBind();
                gvSignIns.DataBind();
            }
        }

        protected void ddRegions_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global and state admins
            ddConferences.DataBind();
            gvSignIns.DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If the list of available conferences is empty, disable the dropdown
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[There are no active conferences for this region]", "-1"));
            } else {
                ddConferences.Enabled = true;
                gvSignIns.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            gvSignIns.DataBind();
        }

        protected void btnGenerate_Click(object sender, EventArgs e) {

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());

            #region Fill a table with a list of members who need to take a test for the selected conference
            //
            string sqlConfTestMembers =
                "SELECT DISTINCT M.MemberID, M.FirstName, M.LastName, TC.TestUsername " +
                "FROM ConferenceMemberEvents CME" +
                " INNER JOIN Conferences C ON CME.ConferenceID=C.ConferenceID" +
                " INNER JOIN NationalEvents E ON CME.EventID=E.EventID" +
                " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID" +
                " INNER JOIN TestQuestions Q ON C.RegionalTestsID=Q.RegionalTestsID AND CME.EventID=Q.EventID" +
                " LEFT JOIN TestCredentials TC ON CME.ConferenceID=TC.ConferenceID AND CME.MemberID=TC.MemberID " +
                "WHERE ISNULL(M.isInactive,0)=0 AND ISNULL(ObjectiveWeight,0)<>0 AND CME.ConferenceID=" + ddConferences.SelectedValue;
            SqlDataAdapter daConfTestMembers = new SqlDataAdapter(sqlConfTestMembers, cnn);
            DataTable tblConfTestMembers = new DataTable("ConfTestMembers");
            daConfTestMembers.Fill(tblConfTestMembers);
            #endregion

            #region Assign credentials to any members who need them
            cnn.Open();
            string strPassword;
            foreach (DataRow ConfTestMember in tblConfTestMembers.Rows) {
                if (ConfTestMember["TestUsername"].ToString() == "") {
                    strPassword = GeneratePassword();
                    SqlCommand cmdUpdate = new SqlCommand(
                        "INSERT INTO TestCredentials (MemberID, ConferenceID, TestUsername, TestPassword) VALUES (" +
                        ConfTestMember["MemberID"] + "," +
                        ddConferences.SelectedValue + "," +
                        "'" + ConfTestMember["FirstName"].ToString().Replace("'", "").Replace(" ","") + ConfTestMember["LastName"].ToString().Replace("'", "").Replace(" ","") + "'," +
                        "'" + strPassword + "')", cnn);
                    cmdUpdate.ExecuteNonQuery();
                }
            }
            cnn.Close();
            #endregion

            gvSignIns.DataBind();
        }

        Random r = new Random(DateTime.Now.Millisecond);
        protected string GeneratePassword() {
            byte[] b = new byte[5];
            r.NextBytes(b);
            return System.Convert.ToBase64String(b).Substring(0,5);
        }
    }
}