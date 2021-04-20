using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Maint_Region : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

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
                }  else {
                    sqlViewRegionList.SelectCommand = "SELECT [RegionID], [RegionName] FROM [Regions] WHERE [RegionID]=" + Session["RegionID"];
                    ddRegions.DataBind();
                    // Regional Advisers cannot add or delete regions
                    btnAddRegion.Visible = false;
                    ((LinkButton)fvRegion.FindControl("DeleteButton")).Visible = true;
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegions.DataBind();
            fvRegion.DataBind();
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
            fvRegion.DataBind();
        }

        protected void btnAddRegion_Click(object sender, EventArgs e) {
            fvRegion.ChangeMode(FormViewMode.Insert);
        }

        protected void ddRegionalAdviser_DataBound(object sender, EventArgs e) {
            // If the list of available Advisers is empty, disable the dropdown
            DropDownList dd = (DropDownList)sender;
            if (dd.Items.Count == 0) {
                dd.Enabled = false;
                dd.Items.Add(new ListItem("[No Advisers available]", ""));
            }
        }

        protected void ddRegionalVP_DataBound(object sender, EventArgs e) {
            // If the list of available students is empty, disable the dropdown
            DropDownList dd = (DropDownList)sender;
            if (dd.Items.Count == 0) {
                dd.Enabled = false;
                dd.Items.Add(new ListItem("[No students available]", ""));
            }
        }

        protected void fvRegion_DataBound(object sender, EventArgs e) {
            // Once data has been bound to the form view, sync up the drop down list for the RegionalVP
            if (fvRegion.CurrentMode == FormViewMode.Edit) {
                DataRowView drv = (DataRowView)fvRegion.DataItem;
                ((DropDownList)fvRegion.FindControl("ddRegionalAdviser")).SelectedValue = drv["AdviserChapterID"].ToString();
                ((DropDownList)fvRegion.FindControl("ddRegionalVP")).SelectedValue = drv["RegionalVP"].ToString();
            }
        }

        protected void fvRegion_ItemUpdating(object sender, FormViewUpdateEventArgs e) {
            // When updating the record, use the value from the drop down list of students for the Regional VP
            sqlRegionMaint.UpdateParameters["AdviserChapterID"].DefaultValue = ((DropDownList)fvRegion.FindControl("ddRegionalAdviser")).SelectedValue;
            sqlRegionMaint.UpdateParameters["RegionalVP"].DefaultValue = ((DropDownList)fvRegion.FindControl("ddRegionalVP")).SelectedValue;
        }

        protected void sqlRegionMaint_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            // After creating a new region, make it be the current selection
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + " : " + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                DbCommand command = e.Command;
                ddRegions.DataBind();
                ddRegions.SelectedValue = command.Parameters["@RegionID"].Value.ToString();
            }
        }

        protected void sqlRegionMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = "Unable to delete region when it contains chapters.";
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                ddRegions.DataBind();
                fvRegion.DataBind();
            }
        }
    }
}