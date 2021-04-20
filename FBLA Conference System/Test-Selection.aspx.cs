using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Test_Selection : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

            // This page is restricted to those who have signed in to take a test
            if ((string)Session["TakingTest"] != "true") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = "#TakingTest";
            ((Menu)Master.FindControl("FCSMenu")).DataBind();

            if (!IsPostBack) {

                // Determine if this member has any available tests to take
                SqlDataAdapter sqlEvents = new SqlDataAdapter(
                    "SELECT DISTINCT ConferenceName, E.EventID, EventName " +
                    "FROM ConferenceMemberEvents CME" +
                    " INNER JOIN Conferences C ON CME.ConferenceID=C.ConferenceID" +
                    " INNER JOIN NationalEvents E ON CME.EventID=E.EventID " +
                    " INNER JOIN TestQuestions Q ON C.RegionalTestsID=Q.RegionalTestsID AND CME.EventID=Q.EventID " +
                    "WHERE ISNULL(CME.ObjectiveScore,-1)=-1 AND CME.ConferenceID=" + Session["ConferenceID"].ToString() +
                    " AND CME.MemberID=" + Session["MemberID"].ToString(),
                    System.Configuration.ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
                DataTable tblEvents = new DataTable();
                sqlEvents.Fill(tblEvents);

                if (tblEvents.Rows.Count == 0) {
                    lblPopup.Text = "There are no additional tests available for you to take.<br>Click OK to sign out.";
                    popupErrorMsg.Show();
                } else {
                    lblConference.Text = tblEvents.Rows[0]["ConferenceName"].ToString();
                    TestList.DataSource = tblEvents;
                    TestList.DataValueField = "EventID";
                    TestList.DataTextField = "EventName";
                    TestList.DataBind();
                    TestList.SelectedIndex = 0;
                }
            }
        }

        protected void btnStartTest_Click(object sender, EventArgs e) {
            Session["EventID"] = TestList.SelectedValue;
            // As a backup of the session state, store an encrypted cookie
            Response.Cookies["FCSdata"].Value = Global.Encrypt("true;" +
                Session["ConferenceID"].ToString() + ";" +
                Session["RegionalTestsID"].ToString() + ";" +
                Session["MemberID"].ToString() + ";" +
                Session["Name"].ToString() + ";" +
                Session["EventID"].ToString() + ";I");
            Response.Redirect("Test-ConfEvent.aspx");
        }
    }
}