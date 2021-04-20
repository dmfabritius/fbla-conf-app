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

    public partial class Maint_State : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

            // Maintenance is restricted to the global and state Advisers
            if (((string)Session["UserLevel"] != "#Global") && ((string)Session["UserLevel"] != "#State")) Server.Transfer("default.aspx");

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
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegions.DataBind();
            ddChapters.DataBind();
            ddChapterStudents.DataBind();
            fvState.DataBind();
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
            ddChapters.DataBind();
            ddChapterStudents.DataBind();
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
            ddChapterStudents.DataBind();
        }

        protected void ddChapterStudents_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            DropDownList dd = (DropDownList)sender;
            if (dd.Items.Count == 0) {
                dd.Items.Add(new ListItem("[No eligible students available]", ""));
                dd.Enabled = 
                StatePresident.Enabled =
                StateSecretary.Enabled =
                StatePublicRelations.Enabled =
                StateParlimentarian.Enabled = false;
            } else {
                dd.Enabled =
                StatePresident.Enabled =
                StateSecretary.Enabled =
                StatePublicRelations.Enabled =
                StateParlimentarian.Enabled = true;
            }
        }

        protected void btnAssignOfficer_Click(object sender, EventArgs e) {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString()))
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE States SET "+((Button)sender).ID+"="+ddChapterStudents.SelectedValue+" WHERE StateID="+ddStates.SelectedValue, conn)) {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            fvState.DataBind();
        }
    }
}