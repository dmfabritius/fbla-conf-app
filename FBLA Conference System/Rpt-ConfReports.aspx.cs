using System;
using System.Collections.Generic;
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
    public partial class Rpt_ConfReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {

            // Conference event reports are restricted to Advisers at the regional level and above
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
            // Only available to global admin
            ddRegions.DataBind();
            ddConferences.DataBind();
        }

        protected void ddRegions_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            if (ddRegions.Items.Count == 0) {
                ddRegions.Enabled = false;
                ddRegions.Items.Add(new ListItem("[No regions defined for this state]", "-1"));
            } else {
                ddRegions.Enabled = true;
            }
        }

        protected void ddRegions_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global and state admins
            ddConferences.DataBind();
            gvEventsSummary.DataBind();
            gvEventsDetail.DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If the list of available conferences is empty, disable the dropdown
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences defined for this region]", "-1"));
                Session["InvoiceConferenceID"] = "";
            } else {
                ddConferences.Enabled = true;
                Session["InvoiceConferenceID"] = ddConferences.SelectedValue;
                gvEventsSummary.DataBind();
                gvEventsDetail.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            Session["InvoiceConferenceID"] = ddConferences.SelectedValue;
            gvEventsSummary.DataBind();
            gvEventsDetail.DataBind();
        }
    }
}