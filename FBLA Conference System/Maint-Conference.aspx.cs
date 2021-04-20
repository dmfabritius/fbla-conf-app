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

namespace FBLA_Conference_System
{
    public partial class Maint_Conference : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Everyone can access this page, but only regional admins and above can do maintenance -- chapters Advisers and students can view
            if ((string)Session["UserType"] == "none") Server.Transfer("default.aspx");

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
                    fvConference.DataBind();
                }

                // Only global and state admins can add/delete new conferences and create hotel packages
                btnAddConference.Visible = ((int)Session["RegionID"] == 0);
                tabPackages.Visible = ((int)Session["RegionID"] == 0);
            }
            LinkButton btnDel = ((LinkButton)fvConference.FindControl("DeleteButton"));
            if (btnDel != null) btnDel.Visible = ((int)Session["RegionID"] == 0);
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global admin
            ddRegions.DataBind();
            ddConferences.DataBind();
            fvConference.DataBind();
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
            ddConferences.DataBind();
            fvConference.DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If the list of available conferences is empty, disable the dropdown
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences defined for this region]", "-1"));
                Session["SchedConferenceID"] = "";
            } else {
                Session["SchedConferenceID"] = ddConferences.SelectedValue;
                ddConferences.Enabled = true;
                fvConference.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            Session["SchedConferenceID"] = ddConferences.SelectedValue;
            fvConference.DataBind();
        }

        protected void btnAddConference_Click(object sender, EventArgs e) {
            fvConference.ChangeMode(FormViewMode.Insert);
            //gvExcludedEventsMaint.Visible = false;
            //gvExcludedEventsDisplay.Visible = false;
            tabsExcluded.Visible = false;
        }

        protected void ddTests_DataBound(object sender, EventArgs e) {
            // If the list of available tests is empty, disable the dropdown
            DropDownList dd = (DropDownList)sender;
            if (dd.Items.Count == 0) {
                dd.Enabled = false;
                dd.Items.Add(new ListItem("[No tests available]", ""));
            }
        }

        protected void fvConference_DataBound(object sender, EventArgs e) {

            if (fvConference.CurrentMode == FormViewMode.Insert) {
                // State admins can create state and regional conferences
                if ((int)Session["RegionID"] == 0) ((DropDownList)fvConference.FindControl("ddConferenceLevel")).Items.Add("State");
                // The global admin can create conferences at all levels
                if ((int)Session["StateID"] == 0) ((DropDownList)fvConference.FindControl("ddConferenceLevel")).Items.Add("National");
            }

            DataRowView drv = (DataRowView)fvConference.DataItem;
            if (drv == null) {
                //pnlGenerateEventWinners.Visible = false;
                //gvExcludedEventsMaint.Visible = false;
                //gvExcludedEventsDisplay.Visible = false;
                tabsExcluded.Visible = false;
                return;
            }

            if (fvConference.CurrentMode == FormViewMode.Edit) {
                // Once data has been bound to the form view, sync up the drop down list for the Members Only flag
                ((DropDownList)fvConference.FindControl("ddMembersOnly")).SelectedValue = drv["isMembersOnly"].ToString();
                ((DropDownList)fvConference.FindControl("ddTests")).SelectedValue = drv["RegionalTestsID"].ToString();
                // Only global and state admins can edit the name of conferences
                if ((int)Session["RegionID"] != 0) {
                    ((TextBox)fvConference.FindControl("EditConferenceName")).Enabled = false;
                    ((DropDownList)fvConference.FindControl("ddMembersOnly")).Enabled = false;
                }
            }
            else if (fvConference.CurrentMode == FormViewMode.ReadOnly) {
                // Hide the links to generate the schedules unless start/end times have been entered
                if (drv["PerfTestingStart"].ToString() == "" || drv["PerfTestingEnd"].ToString() == "") {
                    ((HyperLink)fvConference.FindControl("lnkSchedMatrix")).Visible = false;
                    ((HyperLink)fvConference.FindControl("lnkStationSched")).Visible = false;
                    ((Label)fvConference.FindControl("lblSchedNote")).Visible = true;
                } else {
                    ((HyperLink)fvConference.FindControl("lnkSchedMatrix")).Visible = true;
                    ((HyperLink)fvConference.FindControl("lnkStationSched")).Visible = true;
                    ((Label)fvConference.FindControl("lblSchedNote")).Visible = false;
                }
            }

            if ((int)Session["RegionID"] == 0) {
                //pnlGenerateEventWinners.Visible = true && ((int)drv["isMembersOnly"] == 1);
                //gvExcludedEventsMaint.Visible = true && ((int)drv["isMembersOnly"] == 1);
                tabsExcluded.Visible = true && ((int)drv["isMembersOnly"] == 1);
                gvExcludedEventsMaint.Visible = true;
                gvExcludedPerfsMaint.Visible = true;
                gvExcludedEventsDisplay.Visible = false;
                gvExcludedPerfsDisplay.Visible = false;
            }
            else {
                // Regional admins can edit and delete conferences in their region, but not state-wide conferences
                if ((int)Session["ChapterID"] == 0) {
                    if ((int)drv["RegionID"] != 0) {
                        //pnlGenerateEventWinners.Visible = true && ((int)drv["isMembersOnly"] == 1);
                        //gvExcludedEventsMaint.Visible = true && ((int)drv["isMembersOnly"] == 1);
                        tabsExcluded.Visible = true && ((int)drv["isMembersOnly"] == 1);
                        gvExcludedEventsMaint.Visible = true;
                        gvExcludedPerfsMaint.Visible = true;
                        gvExcludedEventsDisplay.Visible = false;
                        gvExcludedPerfsDisplay.Visible = false;
                    }
                    else {
                        ((LinkButton)fvConference.FindControl("EditButton")).Visible = false;
                        ((LinkButton)fvConference.FindControl("DeleteButton")).Visible = false;
                        //pnlGenerateEventWinners.Visible = false;
                        tabsExcluded.Visible = true && ((int)drv["isMembersOnly"] == 1);
                        gvExcludedEventsMaint.Visible = false;
                        gvExcludedPerfsMaint.Visible = false;
                        gvExcludedEventsDisplay.Visible = true;
                        gvExcludedPerfsDisplay.Visible = true;
                    }
                } else {
                    // Chapters admins cannot performance conference management, they can only view
                    ((LinkButton)fvConference.FindControl("EditButton")).Visible = false;
                    ((LinkButton)fvConference.FindControl("DeleteButton")).Visible = false;
                    //pnlGenerateEventWinners.Visible = false;
                    tabsExcluded.Visible = true && ((int)drv["isMembersOnly"] == 1);
                    gvExcludedEventsMaint.Visible = false;
                    gvExcludedPerfsMaint.Visible = false;
                    gvExcludedEventsDisplay.Visible = true;
                    gvExcludedPerfsDisplay.Visible = true;
                }
            }
        }

        protected void fvConference_ItemInserting(object sender, FormViewInsertEventArgs e) {
            string level = ((DropDownList)fvConference.FindControl("ddConferenceLevel")).SelectedValue;

            if (level == "National") {
                sqlConferenceMaint.InsertParameters["StateID"].DefaultValue = "0";
                sqlConferenceMaint.InsertParameters["RegionID"].DefaultValue = "0";

            } else if (level == "State") {
                sqlConferenceMaint.InsertParameters["StateID"].DefaultValue = ddStates.SelectedValue;
                sqlConferenceMaint.InsertParameters["RegionID"].DefaultValue = "0";
            
            } else {
                sqlConferenceMaint.InsertParameters["StateID"].DefaultValue = ddStates.SelectedValue;
                sqlConferenceMaint.InsertParameters["RegionID"].DefaultValue = ddRegions.SelectedValue;
            }
            sqlConferenceMaint.InsertParameters["isMembersOnly"].DefaultValue = ((DropDownList)fvConference.FindControl("ddMembersOnly")).SelectedValue;
            sqlConferenceMaint.InsertParameters["RegionalTestsID"].DefaultValue = ((DropDownList)fvConference.FindControl("ddTests")).SelectedValue;
        }

        protected void fvConference_ItemUpdating(object sender, FormViewUpdateEventArgs e) {
            sqlConferenceMaint.UpdateParameters["isMembersOnly"].DefaultValue = ((DropDownList)fvConference.FindControl("ddMembersOnly")).SelectedValue;
            sqlConferenceMaint.UpdateParameters["RegionalTestsID"].DefaultValue = ((DropDownList)fvConference.FindControl("ddTests")).SelectedValue;
        }

        protected void sqlConferenceMaint_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + "\n" + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                DbCommand command = e.Command;
                ddConferences.DataBind();
                ddConferences.SelectedValue = command.Parameters["@ConferenceID"].Value.ToString();
            }
        }

        protected void sqlConferenceMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = "Unable to delete conference when it has members signed up for events,<br>advisers/chaperones assigned, or other dependencies.";
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                // Regional and chapter admins can view (but not add, edit, or delete) state-wide conferences
                if ((int)Session["RegionID"] != 0)
                    sqlViewConferenceList.SelectCommand =
                        "SELECT [ConferenceID], [ConferenceName] FROM [Conferences] " +
                        "WHERE (([StateID] = @StateID) AND (([RegionID] = " + Session["RegionID"] + ") OR ([RegionID] = 0))) ORDER BY [ConferenceName]";
                ddConferences.DataBind();
                fvConference.DataBind();
            }
        }

        protected void gvExcludedEventsMaint_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When inserting an event exclusion, use the values from the drop down lists to set the field values
            if (e.CommandName == "Insert") {
                sqlExcludedEventsMaint.InsertParameters["ConferenceID"].DefaultValue = ddConferences.SelectedValue;
                sqlExcludedEventsMaint.InsertParameters["EventID"].DefaultValue = ((DropDownList)gvExcludedEventsMaint.HeaderRow.FindControl("ddEventList")).SelectedValue;
                sqlExcludedEventsMaint.Insert();
            }

            // Also, clean up any existing judge sign-ins for the performance event that was just excluded
            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            cnn.Open();
            SqlCommand cmd = new SqlCommand("", cnn);
            cmd.CommandText =
                "DELETE FROM JudgeCredentials " +
                "WHERE ConferenceID=" + ddConferences.SelectedValue +
                " AND EventID=" + ((DropDownList)gvExcludedEventsMaint.HeaderRow.FindControl("ddEventList")).SelectedValue;
            cmd.ExecuteNonQuery();
            cnn.Close();
        }

        protected void gvExcludedPerfsMaint_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When inserting a performance exclusion, use the values from the drop down lists to set the field values
            if (e.CommandName == "Insert") {
                sqlExcludedPerfsMaint.InsertParameters["ConferenceID"].DefaultValue = ddConferences.SelectedValue;
                sqlExcludedPerfsMaint.InsertParameters["EventID"].DefaultValue = ((DropDownList)gvExcludedPerfsMaint.HeaderRow.FindControl("ddPerfEventList")).SelectedValue;
                sqlExcludedPerfsMaint.Insert();

                // Also, clean up any existing judge sign-ins for the performance event that was just excluded
                SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
                cnn.Open();
                SqlCommand cmd = new SqlCommand("", cnn);
                cmd.CommandText =
                    "DELETE FROM JudgeCredentials " +
                    "WHERE ConferenceID=" + ddConferences.SelectedValue +
                    " AND EventID=" + ((DropDownList)gvExcludedPerfsMaint.HeaderRow.FindControl("ddPerfEventList")).SelectedValue;
                cmd.ExecuteNonQuery();
                cnn.Close();
            }
        }

        protected void sqlExcluded_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + "\n" + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            }
        }

        protected void gvHotelPackageMaint_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When inserting an event exclusion, use the values from the drop down lists to set the field values
            if (e.CommandName == "Insert") {
                sqlHotelPackageMaint.InsertParameters["PackageDesc"].DefaultValue = ((TextBox)gvHotelPackageMaint.HeaderRow.FindControl("InsertHotelPackageDesc")).Text;
                sqlHotelPackageMaint.InsertParameters["PackagePrice"].DefaultValue = ((TextBox)gvHotelPackageMaint.HeaderRow.FindControl("InsertHotelPackagePrice")).Text;
                try {
                    sqlHotelPackageMaint.Insert();
                }
                catch (Exception ex) {
                    lblPopup.Text = ex.Message + "\n" + ex.InnerException;
                    popupErrorMsg.Show();
                }
            }
        }
    }
}