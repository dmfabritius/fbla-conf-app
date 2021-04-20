using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Maint_Event : System.Web.UI.Page {
    
        protected void Page_Load(object sender, EventArgs e) {
            // Only the global admin can maintain events
            if ((string)Session["UserLevel"] != "#State") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
        }

        protected void btnAddEvent_Click(object sender, EventArgs e) {
            sqlEventMaint.InsertParameters["EventName"].DefaultValue = " (new event)";
            sqlEventMaint.InsertParameters["EventType"].DefaultValue = "I";
            sqlEventMaint.Insert();
            gvEventMaint.DataBind();
        }

        protected void gvEventMaint_RowDataBound(object sender, GridViewRowEventArgs e) {
            // Add some tool tips since the headers are so short and abbreviated
            if (e.Row.RowType == DataControlRowType.Header) {
                e.Row.Cells[2].ToolTip = "Events cannot be deleted, but can be marked as inactive";
                e.Row.Cells[3].ToolTip = "Event type can be Individual, Team, Chapter, or non-competitive";
                e.Row.Cells[4].ToolTip = "For team events, set the minimum number of team members";
                e.Row.Cells[5].ToolTip = "For team events, set the maximum number of team members";
                e.Row.Cells[6].ToolTip = "Used to indicate that an event is open to upperclass students only";
                e.Row.Cells[7].ToolTip = "Used to indicate that an event is open to lowerclass students only";
                e.Row.Cells[8].ToolTip = "** I forget what 'plus one' means...";
                e.Row.Cells[9].ToolTip = "Weighting of objective score when calculating the event's overall score";
                e.Row.Cells[10].ToolTip = "Weighting of performance score when calculating the event's overall score";
                e.Row.Cells[11].ToolTip = "Weighting of homesite score when calculating the event's overall score";
                e.Row.Cells[12].ToolTip = "Number of minutes of prep time allowed (can be zero) for performance events";
                e.Row.Cells[13].ToolTip = "Number of minutes of presentation allowed for performance events";
                e.Row.Cells[14].ToolTip = "Day of the State Conference when this event's performance testing is done";
            }
            // Once data has been bound to the row for editing, sync up the drop down lists for the State officers
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate) | e.Row.RowState == DataControlRowState.Edit) {
                    ((DropDownList)e.Row.FindControl("ddTeamEvent")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "EventType").ToString();
                    ((DropDownList)e.Row.FindControl("ddMinTeamSize")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "MinTeamSize").ToString();
                    ((DropDownList)e.Row.FindControl("ddMaxTeamSize")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "MaxTeamSize").ToString();
                    ((DropDownList)e.Row.FindControl("ddUpperclassmen")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isUpperclassmen").ToString();
                    ((DropDownList)e.Row.FindControl("ddLowerclassmen")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isLowerclassmen").ToString();
                    ((DropDownList)e.Row.FindControl("ddPlusOne")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isPlusOne").ToString();
                    ((DropDownList)e.Row.FindControl("ddInactive")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isInactive").ToString();
                    ((DropDownList)e.Row.FindControl("ddPerfDay")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "PerfDay").ToString();
                }
            }
        }

        protected void gvEventMaint_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When updating a student record, use the values from the drop down lists to set the field values
            if (e.CommandName == "Update") {
                sqlEventMaint.UpdateParameters["EventType"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddTeamEvent")).SelectedValue;
                sqlEventMaint.UpdateParameters["MinTeamSize"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddMinTeamSize")).SelectedValue;
                sqlEventMaint.UpdateParameters["MaxTeamSize"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddMaxTeamSize")).SelectedValue;
                sqlEventMaint.UpdateParameters["isUpperclassmen"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddUpperclassmen")).SelectedValue;
                sqlEventMaint.UpdateParameters["isLowerclassmen"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddLowerclassmen")).SelectedValue;
                sqlEventMaint.UpdateParameters["isPlusOne"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddPlusOne")).SelectedValue;
                sqlEventMaint.UpdateParameters["isInactive"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddInactive")).SelectedValue;
                sqlEventMaint.UpdateParameters["PerfDay"].DefaultValue = ((DropDownList)gvEventMaint.Rows[gvEventMaint.EditIndex].FindControl("ddPerfDay")).SelectedValue;
            } else if (e.CommandName == "Delete") {
                // no special adjustments are needed for the delete command
            }
        }
    }
}