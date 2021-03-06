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

namespace FBLA_Conference_System
{
    public partial class Rpt_ConfHotels : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            if ((string)Session["UserType"] != "Adviser") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
            
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

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If there are no conferences available, disable the dropdown and hide the assignment panels
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences currently open for registration for this region]", "-1"));
            } else {
                ddConferences.Enabled = true;
                gvHotelPackages.DataBind();
                Session["InvoiceConferenceID"] = ddConferences.SelectedValue;
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            gvHotelPackages.DataBind();
            Session["InvoiceConferenceID"] = ddConferences.SelectedValue;
        }

        protected void ddChapters_DataBound(object sender, EventArgs e) {
            // If the list of available chapters is empty, disable the dropdown
            if (ddChapters.Items.Count == 0) {
                ddChapters.Enabled = false;
                ddChapters.Items.Add(new ListItem("[No chapters defined for this region]", "-1"));
            }
            else {
                ddChapters.Enabled = true;
                gvHotelPackages.DataBind();
                Session["InvoiceChapterID"] = ddChapters.SelectedValue;
            }
        }

        protected void ddChapters_SelectedIndexChanged(object sender, EventArgs e) {
            gvHotelPackages.DataBind();
            Session.Add("InvoiceChapterID", ddChapters.SelectedValue);
        }

        protected void btnUpdate_Click(object sender, EventArgs e) {
            // Update all the rows with new amounts
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Clear any existing packages
                SqlCommand cmdUpdate = new SqlCommand("",cnn);
                string ConfID = ddConferences.SelectedValue;
                string ChapID = ddChapters.SelectedValue;
                cmdUpdate.CommandText="DELETE FROM ConferenceChapterHotels WHERE ConferenceID="+ConfID+" AND ChapterID="+ChapID;
                cmdUpdate.ExecuteNonQuery();

                foreach (GridViewRow r in gvHotelPackages.Rows) {
                    //gvHotelPackages.UpdateRow(r.RowIndex, true);
                    cmdUpdate.CommandText =
                        "INSERT INTO ConferenceChapterHotels (ConferenceID, ChapterID, HotelPackageID, Amount)" +
                        " VALUES (" + ConfID + "," + ChapID + "," +
                        gvHotelPackages.DataKeys[r.RowIndex].Value + "," + // HotelPackageID
                        ((TextBox)r.Cells[3].Controls[1]).Text + ")";      // Amount
                    try {
                        cmdUpdate.ExecuteNonQuery();
                    }
                    catch { }
                }
                cnn.Close();
            }
            gvHotelPackages.DataBind();
        }
    }
}