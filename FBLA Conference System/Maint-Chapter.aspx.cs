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

    public partial class Maint_Chapter : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            // Maintenance is restricted to Advisers
            if ((string)Session["UserType"] != "Adviser") Server.Transfer("default.aspx");

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
                    sqlViewRegionList.SelectCommand = "SELECT [RegionID], [RegionName] FROM [Regions] WHERE [RegionID]=" + Session["RegionID"];
                    ddRegions.DataBind();
                }

                // Regional admins can select any chapter in their region, all other users are limited to their own chapter
                if ((int)Session["ChapterID"] == 0) {
                    pnlSelChapter.Visible = true;
                    // Only the global and state admins can add, delete, or reassign chapters to different regions
                    if ((int)Session["RegionID"] != 0) {
                        ddChapters.DataBind();
                        btnAddChapter.Visible = false;
                        ((LinkButton)fvChapter.FindControl("DeleteButton")).Visible = false;
                        ((LinkButton)fvChapter.FindControl("ChangeRegionButton")).Visible = false;
                    }
                } else {
                    // Chapter admins can only view and maintain their own chapter
                    sqlViewChapterList.SelectCommand = "SELECT [ChapterID], [ChapterName] FROM [Chapters] WHERE [ChapterID]=" + Session["ChapterID"];
                    ddChapters.DataBind();
                    // They cannot delete their chapter or reassign it to a different region
                    ((LinkButton)fvChapter.FindControl("DeleteButton")).Visible = false;
                    ((LinkButton)fvChapter.FindControl("ChangeRegionButton")).Visible = false;
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegions.DataBind();
            ddChapters.DataBind();
            fvChapter.DataBind();
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
            fvChapter.DataBind();
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
            fvChapter.DataBind();
            // Only the global and state admins can reassign chapters to different regions
            if ((int)Session["RegionID"] != 0) ((LinkButton)fvChapter.FindControl("ChangeRegionButton")).Visible = false;
        }

        protected void btnAddChapter_Click(object sender, EventArgs e) {
            fvChapter.ChangeMode(FormViewMode.Insert);
        }

        protected void ddOutstandingStudent_DataBound(object sender, EventArgs e) {
            // If the list of available students is empty, disable the dropdown
            DropDownList dd = (DropDownList)sender;
            if (dd.Items.Count == 0) {
                dd.Enabled = false;
                dd.Items.Add(new ListItem("[No students available]", ""));
            }
        }

        protected void fvChapter_DataBound(object sender, EventArgs e) {
            // Once data has been bound to the form view, sync up the drop down list for the Outstanding Student
            if (fvChapter.CurrentMode == FormViewMode.Edit) {
                DataRowView drv = (DataRowView)fvChapter.DataItem;
                ((DropDownList)fvChapter.FindControl("ddShirtSize")).SelectedValue = drv["ShirtSize"].ToString();
                ((DropDownList)fvChapter.FindControl("ddOutstandingStudent")).SelectedValue = drv["OutstandingStudent"].ToString();
            }
        }

        protected void fvChapter_ItemInserting(object sender, FormViewInsertEventArgs e) {
            // When inserting a record, use the values from the drop down lists
            sqlChapterMaint.InsertParameters["ShirtSize"].DefaultValue = ((DropDownList)fvChapter.FindControl("ddShirtSize")).SelectedValue;
        }
        
        protected void fvChapter_ItemUpdating(object sender, FormViewUpdateEventArgs e) {
            // When updating the record, use the values from the drop down lists
            sqlChapterMaint.UpdateParameters["ShirtSize"].DefaultValue = ((DropDownList)fvChapter.FindControl("ddShirtSize")).SelectedValue;
            sqlChapterMaint.UpdateParameters["OutstandingStudent"].DefaultValue = ((DropDownList)fvChapter.FindControl("ddOutstandingStudent")).SelectedValue;
        }

        protected void sqlChapterMaint_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + "\n" + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                DbCommand command = e.Command;
                ddChapters.DataBind();
                ddChapters.SelectedValue = command.Parameters["@ChapterID"].Value.ToString();
            }
        }

        protected void sqlChapterMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = "Unable to delete chapter when it has students.";
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                ddChapters.DataBind();
                fvChapter.DataBind();
            }
        }

        protected void ChangeRegionButton_Click(object sender, EventArgs e) {
            // Check to see if any chapter members are signed up for the current region's conference
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Delete any conference event records for conferences that are in the future
                SqlCommand cmd = new SqlCommand(
                    "select count(*) " +
                    "from ConferenceMemberEvents cme " +
                    " inner join NationalMembers m on cme.MemberID=m.MemberID " +
                    " inner join Conferences c on cme.ConferenceID=c.ConferenceID " +
                    "where m.ChapterID=" + ddChapters.SelectedValue.ToString() + " and c.RegionID<>0 and c.ConferenceDate > GETDATE()", cnn);
                if ((int)cmd.ExecuteScalar() != 0) {
                    lblPopup.Text = "Cannot change regions when students are signed up for events in the current region's conference.";
                    popupErrorMsg.Show();
                } else {
                    fvChapter.Visible = false;
                    fvChangeRegion.DataBind();
                    fvChangeRegion.Visible = true;
                }
            }            
        }

        protected void CancelChangeRegionButton_Click(object sender, EventArgs e) {
            fvChapter.Visible = true;
            fvChangeRegion.Visible = false;
        }

        protected void fvChangeRegion_DataBound(object sender, EventArgs e) {
            DataRowView drv = (DataRowView)fvChangeRegion.DataItem;
            if (drv == null) return;

            // When changing a chapter's region, only allow it to be reassigned to another region in the same state
            DropDownList ddr = (DropDownList)fvChangeRegion.FindControl("ddRegionList");
            sqlRegionList.SelectParameters[0].DefaultValue = drv["StateID"].ToString();
            ddr.DataBind();
            ddr.SelectedValue = drv["RegionID"].ToString();
        }

        string _region;

        protected void fvChangeRegion_ItemUpdating(object sender, FormViewUpdateEventArgs e) {
            // When updating the record, use the values from the drop down lists for the region
            _region = ((DropDownList)fvChangeRegion.FindControl("ddRegionList")).SelectedValue;
            e.Keys.Add("RegionID", _region);
        }

        protected void fvChangeRegion_ItemUpdated(object sender, FormViewUpdatedEventArgs e) {
            fvChangeRegion.Visible = false;
            fvChapter.Visible = true;

            // Update the dropdowns to refelct the new region and its chapters, and make sure to re-select the current chapter
            ddRegions.SelectedValue = _region;
            string chapter = ddChapters.SelectedValue;
            ddChapters.DataBind();
            ddChapters.SelectedValue = chapter;
        }

        protected void gvStudents_RowDataBound(object sender, GridViewRowEventArgs e) {
            // Once data has been bound to the row for editing, sync up the drop down lists for the State officers
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate) | e.Row.RowState == DataControlRowState.Edit) {

                    // Populate the list of graduating classes based on the current date
                    DropDownList dd = (DropDownList)e.Row.FindControl("ddGraduatingClass");
                    for (int i = 1; i < 7; i++) dd.Items.Add((DateTime.Now.Year + i - ((System.DateTime.Now.Month < 8) ? 1 : 0)).ToString());

                    ((DropDownList)e.Row.FindControl("ddGraduatingClass")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "GraduatingClass").ToString();
                    ((DropDownList)e.Row.FindControl("ddGender")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "Gender").ToString();
                    ((DropDownList)e.Row.FindControl("ddShirtSize")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "ShirtSize").ToString();
                    ((DropDownList)e.Row.FindControl("ddPosition")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "ChapterPosition").ToString();
                    ((DropDownList)e.Row.FindControl("ddVotingDelegate")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isVotingDelegate").ToString();
                    ((DropDownList)e.Row.FindControl("ddStateEligible")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isStateEligible").ToString();
                    ((DropDownList)e.Row.FindControl("ddNationalEligible")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isNationalEligible").ToString();
                }
            }
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When updating a student record, use the values from the drop down lists to set the field values
            if (e.CommandName == "Update") {
                sqlStudents.UpdateParameters["GraduatingClass"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddGraduatingClass")).SelectedValue;
                sqlStudents.UpdateParameters["Gender"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddGender")).SelectedValue;
                sqlStudents.UpdateParameters["ShirtSize"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddShirtSize")).SelectedValue;
                sqlStudents.UpdateParameters["ChapterPosition"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddPosition")).SelectedValue;
                sqlStudents.UpdateParameters["isVotingDelegate"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddVotingDelegate")).SelectedValue;
                sqlStudents.UpdateParameters["isStateEligible"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddStateEligible")).SelectedValue;
                sqlStudents.UpdateParameters["isNationalEligible"].DefaultValue = ((DropDownList)gvStudents.Rows[gvStudents.EditIndex].FindControl("ddNationalEligible")).SelectedValue;
            }
        }

        protected void gvStudents_RowDeleting(Object sender, GridViewDeleteEventArgs e) {
            // Determine whether to delete the student record entirely or simply mark it as inactive
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Delete any conference event records for conferences that are in the future
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM ConferenceMemberEvents " +
                    "FROM ConferenceMemberEvents CME INNER JOIN Conferences C ON CME.ConferenceID=C.ConferenceID " +
                    "WHERE MemberID=" + gvStudents.DataKeys[e.RowIndex]["MemberID"] + " AND C.ConferenceDate > GETDATE()", cnn);
                cmd.ExecuteNonQuery();

                // If the student is a National member or has ever signed up for any past conference events, then don't delete the record -- mark it inactive
                cmd.CommandText =
                    "SELECT COUNT(*) FROM NationalMembers M" +
                    " LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID " +
                    "WHERE M.MemberID=" + gvStudents.DataKeys[e.RowIndex]["MemberID"] + " AND NationalMemberID IS NULL AND CME.ConferenceID IS NULL";
                if ((int)cmd.ExecuteScalar() == 0) {
                    e.Cancel = true;
                    cmd.CommandText = "UPDATE NationalMembers SET isPaid=0, isInactive=1 WHERE MemberID=" + gvStudents.DataKeys[e.RowIndex]["MemberID"];
                    cmd.ExecuteNonQuery();
                    gvStudents.DataBind();
                }
                cnn.Close();
            }
        }
    }
}