using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Rpt_Region : System.Web.UI.Page {

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
                }
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegions.DataBind();
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
            // probably nothing...
        }

        private int _NumLeadershipTotal;
        private int _NumRegionalTotal;
        protected void gvRegionConfSummary_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.Header) {
                _NumLeadershipTotal = 0;
                _NumRegionalTotal = 0;
            } else if (e.Row.RowType == DataControlRowType.DataRow) {
                _NumLeadershipTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumLeadership"));
                _NumRegionalTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumRegional"));
            } else if (e.Row.RowType == DataControlRowType.Footer) {
                // for the Footer, display the totals
                e.Row.Cells[0].Text = "Totals:";
                e.Row.Cells[1].Text = _NumLeadershipTotal.ToString("d");
                e.Row.Cells[2].Text = _NumRegionalTotal.ToString("d");
            }
        }

        private int _NumMembersTotal;
        private int _NumSeniorsTotal;
        private int _NumJuniorsTotal;
        private int _NumSophomoresTotal;
        private int _NumFreshmenTotal;
        private int _NumMiddleTotal;
        private int _NumMalesTotal;
        private int _NumFemalesTotal;
        protected void gvRegionStudentSummary_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                _NumMembersTotal = 0;
                _NumSeniorsTotal = 0;
                _NumJuniorsTotal = 0;
                _NumSophomoresTotal = 0;
                _NumFreshmenTotal = 0;
                _NumMiddleTotal = 0;
                _NumMalesTotal = 0;
                _NumFemalesTotal = 0;
            }
            else if (e.Row.RowType == DataControlRowType.DataRow)
            {
                _NumMembersTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumMembers"));
                _NumSeniorsTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumSeniors"));
                _NumJuniorsTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumJuniors"));
                _NumSophomoresTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumSophomores"));
                _NumFreshmenTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumFreshmen"));
                _NumMiddleTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumMiddle"));
                _NumMalesTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumMales"));
                _NumFemalesTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumFemales"));
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                // for the Footer, display the totals
                e.Row.Cells[0].Text = "Totals:";
                e.Row.Cells[1].Text = _NumMembersTotal.ToString("d");
                e.Row.Cells[2].Text = _NumSeniorsTotal.ToString("d");
                e.Row.Cells[3].Text = _NumJuniorsTotal.ToString("d");
                e.Row.Cells[4].Text = _NumSophomoresTotal.ToString("d");
                e.Row.Cells[5].Text = _NumFreshmenTotal.ToString("d");
                e.Row.Cells[6].Text = _NumMiddleTotal.ToString("d");
                e.Row.Cells[7].Text = _NumMalesTotal.ToString("d");
                e.Row.Cells[8].Text = _NumFemalesTotal.ToString("d");
            }
        }
    }
}