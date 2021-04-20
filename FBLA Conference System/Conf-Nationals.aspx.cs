using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System
{
    public partial class Conf_Nationals : System.Web.UI.Page
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
                else {
                    tabSelectionsList.Visible = false;
                    tabNationalsAssignments.Visible= false;
                    sqlViewRegionList.SelectCommand = "SELECT RegionID, RegionName FROM Regions WHERE RegionID=" + Session["RegionID"];
                }

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

        protected void ddChapters_DataBound(object sender, EventArgs e) {
            // If the list of available chapters is empty, disable the dropdown
            if (ddChapters.Items.Count == 0) {
                ddChapters.Enabled = false;
                ddChapters.Items.Add(new ListItem("[No chapters defined for this region]", "-1"));
            } else
                ddChapters.Enabled = true;
        }

        protected void ddChapters_SelectedIndexChanged(object sender, EventArgs e) {
            gvNationalsSelections.DataBind();
        }

        protected void ddConferences_DataBound(object sender, EventArgs e) {
            // If there are no conferences available, disable the dropdown and hide the assignment panels
            if (ddConferences.Items.Count == 0) {
                ddConferences.Enabled = false;
                ddConferences.Items.Add(new ListItem("[No conferences currently open for registration for this region]", "-1"));
            } else {
                ddConferences.Enabled = true;
                gvNationalsAssignments.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            gvNationalsSelections.DataBind();
            gvSelectionsList.DataBind();
            gvNationalsAssignments.DataBind();
        }

        protected void gvNationalsSelections_RowDataBound(object sender, GridViewRowEventArgs e) {
            // Once data has been bound to the row for editing, sync up the drop down lists
            if (e.Row.RowType == DataControlRowType.DataRow) {
                if (e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Alternate) | e.Row.RowState == DataControlRowState.Edit) {
                    ((DropDownList)e.Row.FindControl("ddAttendingNationals")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "isAttendingNationals").ToString();
                    ((DropDownList)e.Row.FindControl("ddEventPriority")).SelectedValue = DataBinder.Eval(e.Row.DataItem, "EventPriority").ToString();
                }
            }
        }

        private string isAttendingNationals;
        protected void gvNationalsSelections_RowCommand(object sender, GridViewCommandEventArgs e) {
            // When updating a student record, use the values from the drop down lists to set the field values
            if (e.CommandName == "Update") {
                isAttendingNationals = ((DropDownList)gvNationalsSelections.Rows[gvNationalsSelections.EditIndex].FindControl("ddAttendingNationals")).SelectedValue;
                sqlNationalsSelections.UpdateParameters["isAttendingNationals"].DefaultValue = isAttendingNationals;
                sqlNationalsSelections.UpdateParameters["EventPriority"].DefaultValue = ((DropDownList)gvNationalsSelections.Rows[gvNationalsSelections.EditIndex].FindControl("ddEventPriority")).SelectedValue;
            }
        }

        protected void gvNationalsSelections_RowUpdated(object sender, GridViewUpdatedEventArgs e) {
            // Update all the conference's event records for the member who was updated
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                SqlCommand cmdUpdate = new SqlCommand(
                    "UPDATE ConferenceMemberEvents SET isAttendingNationals=" + isAttendingNationals + " WHERE " +
                    "ConferenceID=" + ddConferences.SelectedValue +
                    " AND MemberID=" + e.Keys[0], cnn);
                cmdUpdate.ExecuteNonQuery();
                gvNationalsAssignments.DataBind();
                cnn.Close();
            }
        }

        DataSet ds = new DataSet();
        protected void gvNationalsAssignments_DataBinding(object sender, EventArgs e) {
            // Make sure we have a ConferenceID before proceeding
            if (ddConferences.SelectedValue == "") return;

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());

            #region Fill a table with a list of events and the number of available slots at Nationals
            //
            // change NumSlots to be 3 for all events - 4/23/2014
            // " NumSlots=CASE WHEN ISNULL(HomesiteWeight,0)=0 AND ISNULL(PerformanceWeight,0)=0 THEN 3 ELSE 2 END " +
            //
            string sqlEvents =
                "SELECT EventID, EventName," +
                " NumSlots=3 " +
                "FROM NationalEvents WHERE isInactive=0";
            SqlDataAdapter daEvents = new SqlDataAdapter(sqlEvents, cnn);
            daEvents.Fill(ds, "Events");
            #endregion

            #region Fill a table with a list of the student names (or team names) who placed and have indicated they are attending Nationals
            //
            string sqlSubtable =
                "SELECT"+
                " CME.MemberID,EventID,Place,EventPriority=CASE WHEN ISNULL(EventPriority,0)=0 THEN 1 ELSE EventPriority END,"+
                " FirstName=CASE WHEN ISNULL(TeamName,'')='' THEN M.FirstName ELSE 'Team:' END,"+
                " LastName=CASE WHEN ISNULL(TeamName,'')=''  THEN M.LastName ELSE TeamName END,"+
                " C.ChapterName,C.AdviserName,C.AdviserEmail "+
                "FROM ConferenceMemberEvents CME"+
                " INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID"+
                " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID "+
                "WHERE ISNULL(isInactive,0)=0 AND ConferenceID=" + ddConferences.SelectedValue + " AND Place IS NOT NULL AND isAttendingNationals=1";
            string sqlMemberSelections =
                "SELECT"+
                " MemberID=MIN(MemberID),EventID,Place=MIN(Place),EventPriority=MIN(EventPriority)," +
                " FirstName,LastName,ChapterName,AdviserName,AdviserEmail " +
                "FROM (" + sqlSubtable + ") S " +
                "GROUP BY EventID,FirstName,LastName,ChapterName,AdviserName,AdviserEmail " +
                "ORDER BY EventID,MIN(Place),MIN(EventPriority)";
            SqlDataAdapter daMemberSelections = new SqlDataAdapter(sqlMemberSelections, cnn);
            daMemberSelections.Fill(ds, "MemberSelections");

            /*
             * I could potentially loop through and for each student make sure their selection priorities are
             * uniquely and consecutively numbered from 1 to n
             */
            #endregion

            #region Create a table to hold the final Event Assignments; this will be bound to the Gridview control
            //
            DataColumn column;
            DataTable tblEventAssignments = new DataTable("EventAssignments");
            column = new DataColumn("EventID", Type.GetType("System.Int32"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("EventName", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("Slot", Type.GetType("System.Int32"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("MemberID", Type.GetType("System.Int32"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("FirstName", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("LastName", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("ChapterName", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("AdviserName", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("AdviserEmail", Type.GetType("System.String"));
            tblEventAssignments.Columns.Add(column);
            column = new DataColumn("isLocked", Type.GetType("System.Int32"));
            tblEventAssignments.Columns.Add(column);
            ds.Tables.Add(tblEventAssignments);
            #endregion

            #region Create a table to hold the Assignment Choices, i.e., all members who are eligible to be assigned to a slot for this event
            //
            DataTable tblAssignmentChoices = new DataTable("AssignmentChoices");
            column = new DataColumn("AssignmentID", Type.GetType("System.Int32"));
            column.AutoIncrement = true;
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("EventID", Type.GetType("System.Int32"));
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("Slot", Type.GetType("System.Int32"));
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("MemberID", Type.GetType("System.Int32"));
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("Place", Type.GetType("System.String"));
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("Priority", Type.GetType("System.Int32"));
            tblAssignmentChoices.Columns.Add(column);
            column = new DataColumn("isLocked", Type.GetType("System.Int32"));
            tblAssignmentChoices.Columns.Add(column);
            ds.Tables.Add(tblAssignmentChoices);
            #endregion

            #region Fill the Event Assignments and Assignment Choices tables
            //
            foreach (DataRow EventRow in ds.Tables["Events"].Rows) {
                DataRow EventAssignmentRow;
                DataRow[] EventWinners = ds.Tables["MemberSelections"].Select("EventID=" + EventRow["EventID"], "Place");
                for (int i = 0; i < (int)EventRow["NumSlots"]; i++) {
                    EventAssignmentRow = tblEventAssignments.NewRow();
                    EventAssignmentRow["EventID"] = EventRow["EventID"];
                    EventAssignmentRow["EventName"] = EventRow["EventName"];
                    EventAssignmentRow["Slot"] = i;
                    if (EventWinners.Length != 0) {
                        EventAssignmentRow["isLocked"] = 0;
                        foreach (DataRow WinnersRow in EventWinners) {
                            DataRow AssignmentChoiceRow;
                            AssignmentChoiceRow = tblAssignmentChoices.NewRow();
                            AssignmentChoiceRow["EventID"] = EventRow["EventID"];
                            AssignmentChoiceRow["Slot"] = i;
                            AssignmentChoiceRow["MemberID"] = WinnersRow["MemberID"];
                            AssignmentChoiceRow["Place"] = WinnersRow["Place"];
                            AssignmentChoiceRow["Priority"] = WinnersRow["EventPriority"];
                            ds.Tables["AssignmentChoices"].Rows.Add(AssignmentChoiceRow); // add row for this slot for this event
                        }
                    }
                    else {
                        EventAssignmentRow["isLocked"] = 1; // if no placeholders for this event are attending, we can lock this event slot
                    }
                    ds.Tables["EventAssignments"].Rows.Add(EventAssignmentRow);
                }
            }
            #endregion

            #region Assign event slots
            /*
             * Repeatedly loop through the unlocked event slot assignments and lock in those members who got their
             * highest available priority event until all available slots are locked
             *   1. if there is an event slot where a member with the highest place has marked it as their top priority, lock it in
             *   2. otherwise, if there is an event slot where two people have marked it as their highest priority,
             *      remove the lower placing member and promote any of their remaining selections (2nd priority becomes 1st, 3rd to 2nd, etc.)
             *   3. otherwise, if there is an event slot when a member has marked it as their highest priority but
             *      they hold the lowest place, remove them and promote any of their remaining selections
             */
            bool AllLocked = false;
            bool SlotLocked;
            bool BehindHigher;
            //bool LastPlace;

            while (!AllLocked) {
                SlotLocked = TopPriorityInTopPlace(ref AllLocked);
                if (!SlotLocked) {
                        BehindHigher = TopPriorityBehindHigherPlace();
                        if (!BehindHigher) {
                            // Find the lowest priority assignment and remove it
                            // This optimizes the members' priority/preference over their place ranking
                            DataRow[] Choices = ds.Tables["AssignmentChoices"].Select("", "Priority DESC");
                            Choices[0].Delete();
                            #region commented out -- a different design that optimizes for place rank vs. priority rank
                            /*
                            LastPlace = TopPriorityInLastPlace();
                            if (!LastPlace) {
                                AllLocked = true;
                                lblPopup.Text = "Event assignment logic was incomplete.";
                                popupErrorMsg.Show();
                            }
                            */
                            #endregion
                        }
                }
            }
            #endregion

            gvNationalsAssignments.DataSource = ds.Tables["EventAssignments"];
        }

        protected bool TopPriorityInTopPlace(ref bool AllLocked) {
            bool LockedEmpty = false;

            // Look through all the unlocked event slots
            DataRow[] EventAssignments = ds.Tables["EventAssignments"].Select("isLocked = 0");
            if (EventAssignments.Length == 0) {
                AllLocked = true;
                return true;
            }

            // Look at the assignment choices for each event slot
            foreach (DataRow EventAssignmentRow in EventAssignments) {
                DataRow[] AssignmentChoices = ds.Tables["AssignmentChoices"]
                    .Select("EventID=" + EventAssignmentRow["EventID"] + " AND Slot=" + EventAssignmentRow["Slot"], "Place");
                if (AssignmentChoices.Length != 0) {

                    // If there is an event slot where a member with the highest place has marked it as their top priority, lock it in
                    if ((int)AssignmentChoices[0]["Priority"] == 1) {
                        DataRow[] Members = ds.Tables["MemberSelections"].Select("MemberID=" + AssignmentChoices[0]["MemberID"]);
                        EventAssignmentRow["isLocked"] = 1;
                        EventAssignmentRow["MemberID"] = AssignmentChoices[0]["MemberID"];
                        EventAssignmentRow["FirstName"] = Members[0]["FirstName"];
                        EventAssignmentRow["LastName"] = Members[0]["LastName"];
                        EventAssignmentRow["ChapterName"] = Members[0]["ChapterName"];
                        EventAssignmentRow["AdviserName"] = Members[0]["AdviserName"];
                        EventAssignmentRow["AdviserEmail"] = Members[0]["AdviserEmail"];

                        // Remove this member from all other assignment possibilities
                        DataRow[] ExtraAssignments = ds.Tables["AssignmentChoices"]
                           .Select("MemberID=" + AssignmentChoices[0]["MemberID"] + " AND AssignmentID<>" + AssignmentChoices[0]["AssignmentID"]);
                        foreach (DataRow Extra in ExtraAssignments)
                            Extra.Delete();

                        // If there are other members in line for this event slot, remove them and promote any of their remaining selections
                        for (int i = 1; i < AssignmentChoices.Length; i++) {
                            int MemberID = (int)AssignmentChoices[i]["MemberID"];
                            int BasePriority = (int)AssignmentChoices[i]["Priority"];
                            AssignmentChoices[i].Delete();
                            PromoteSelections(MemberID, BasePriority);
                        }

                        // After locking in an event slot and making the consequential changes,
                        // exit so we can restart the process of looping through the event assignments 
                        return true;
                    }
                }
                else {
                    // No one wants this event slot, lock it and keep going through the event assignments
                    //EventAssignmentRow["AssignmentID"] = DBNull;
                    EventAssignmentRow["isLocked"] = 1;
                    LockedEmpty = true;
                }
            }
            return LockedEmpty;
        }

        protected void RemoveLowestPrioritySelection() {
            // Find the lowest priority assignment and remove it
            DataRow[] Choices = ds.Tables["AssignmentChoices"].Select("", "Priority DESC");
            int AssignmentID = (int)Choices[0]["AssignmentID"];
            int EventID = (int)Choices[0]["EventID"];
            int Slot = (int)Choices[0]["Slot"];
            Choices[0].Delete();
        }

        protected bool TopPriorityBehindHigherPlace() {
            int MemberID = 0;
            // If there is an event slot where two people have marked it as their highest priority,
            // remove the lower placing member and promote any of their remaining selections

            // Look at the assignment choices for each event slot
            DataRow[] EventAssignments = ds.Tables["EventAssignments"].Select("isLocked = 0");
            foreach (DataRow EventAssignmentRow in EventAssignments) {

                // Working from the lowest place to the highest, see if there is a member who has their highest priority
                // behind another member who has the same event as their highest priority
                DataRow[] AssignmentChoices = ds.Tables["AssignmentChoices"]
                    .Select("EventID=" + EventAssignmentRow["EventID"] + " AND Slot=" + EventAssignmentRow["Slot"], "Place DESC");
                foreach (DataRow Choice in AssignmentChoices) {
                    if ((int)Choice["Priority"] == 1) {
                        // If we had already found a member, then they placed lower and will not be able to get this event slot,
                        // so we can remove them and promote any of their remaining selections
                        if (MemberID != 0) {
                            int BasePriority = (int)Choice["Priority"];
                            Choice.Delete();
                            PromoteSelections(MemberID, BasePriority);

                            // Exit so we can restart the process of locking in event slots
                            return true;
                        }
                        else
                            MemberID = (int)Choice["MemberID"];
                    }
                }
            }
            return false;
        }

        protected bool TopPriorityInLastPlace() {
            // Look at the assignment choices for each event slot
            DataRow[] EventAssignments = ds.Tables["EventAssignments"].Select("isLocked = 0");
            foreach (DataRow EventAssignmentRow in EventAssignments) {

                // See if there is an event slot where a member with the lowest place has marked it as their top priority
                DataRow[] AssignmentChoices = ds.Tables["AssignmentChoices"]
                    .Select("EventID=" + EventAssignmentRow["EventID"] + " AND Slot=" + EventAssignmentRow["Slot"], "Place DESC");

                // Remove the lowest place finisher and promote any of their other choices
                if ((int)AssignmentChoices[0]["Priority"] == 1) {
                    int MemberID = (int)AssignmentChoices[0]["MemberID"];
                    int BasePriority = (int)AssignmentChoices[0]["Priority"];
                    AssignmentChoices[0].Delete();
                    PromoteSelections(MemberID, BasePriority);

                    // Exit so we can restart the process of locking in event slots
                    return true;
                }
            }
            return false;
        }

        protected void PromoteSelections(int MemberID, int BasePriority) {
            // Check to see if there is another selection with the same priority still available
            // If so, don't promote any of the other selections
            DataRow[] AssignmentChoices = ds.Tables["AssignmentChoices"]
                .Select("MemberID = " + MemberID + " AND Priority = " + BasePriority);

            if (AssignmentChoices.Length == 0) {
                // Promote any remaining selections (2nd priority becomes 1st, 3rd to 2nd, etc.)
                AssignmentChoices = ds.Tables["AssignmentChoices"]
                    .Select("MemberID = " + MemberID + " AND Priority > " + BasePriority);
                foreach (DataRow Choice in AssignmentChoices) Choice["Priority"] = (int)Choice["Priority"] - 1;
            }
        }
    }
}