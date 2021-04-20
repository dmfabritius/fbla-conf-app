using System;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System
{
    public partial class Rpt_Chapter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            if ((string)Session["UserType"] == "none") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();

            // Apply filter selection
            sqlStudentsByEvent.FilterExpression =
                (Session["StudentsByEventFilter"] == null) ? " " : Session["StudentsByEventFilter"].ToString();

            #region !IsPostBack
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
            #endregion
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
            } else {
                ddChapters.Enabled = true;
                lblNumberOfStudents_DataBind();
            }
        }

        protected void ddChapters_SelectedIndexChanged(object sender, EventArgs e) {
            lblNumberOfStudents_DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If there are no conferences available, disable the dropdown and hide the assignment panels
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences currently open for registration for this region]", "-1"));
            } else {
                ddConferences.Enabled = true;
                lblNumberOfStudents_DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            lblNumberOfStudents_DataBind();
        }

        protected void lblNumberOfStudents_DataBind() {
            if (ddChapters.Items.Count == 0 || ddConferences.Items.Count == 0) return;

            // Count up the number of students in this chapter attending this conference
            using (SqlDataAdapter adapter = new SqlDataAdapter("SELECT " +
                "Students = (SELECT COUNT(*) FROM (SELECT DISTINCT C.MemberID FROM ConferenceMemberEvents AS C " +
                    "INNER JOIN NationalMembers AS M ON C.MemberID = M.MemberID WHERE " +
                    "C.ConferenceID = " + ddConferences.SelectedValue + " AND " +
                    "M.ChapterID = " + ddChapters.SelectedValue + ") AS M)",
                System.Configuration.ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                DataTable tbl = new DataTable();
                adapter.Fill(tbl);
                if (tbl.Rows.Count != 0) {
                    lblNumberOfStudents.Text = tbl.Rows[0]["Students"].ToString();
                }
            }
        }

        protected void gvStudentsByEvent_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.Header) {
                ((DropDownList)e.Row.FindControl("ddEventType")).SelectedValue =
                    (Session["StudentsByEventFilter"] == null) ? " " : Session["StudentsByEventFilter"].ToString();
            }
        }

        protected void ddEventType_SelectedIndexChanged(object sender, EventArgs e) {
            sqlStudentsByEvent.FilterExpression = ((DropDownList)sender).SelectedValue;
            // Save filter selection so it can be reapplied on postback
            Session.Add("StudentsByEventFilter", ((DropDownList)sender).SelectedValue);
        }
    }
}