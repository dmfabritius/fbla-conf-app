using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System
{
    public partial class Maint_EventPerfCriteria : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            // Only the global admin can maintain performance event criteria
            if ((string)Session["UserLevel"] != "#State") Server.Transfer("default.aspx");

            // Display menu
            ((SiteMapDataSource)Master.FindControl("FCSSiteMapData")).StartingNodeUrl = Session["UserLevel"].ToString();
            ((Menu)Master.FindControl("FCSMenu")).DataBind();
            
            if (!IsPostBack) {
                // The global admin can select any state, all other users are limited to their own state
                //ddEvents.DataBind();
            }
        }

        protected void ddEvents_DataBound(object sender, EventArgs e) {
            gvPerfCriteriaMaint.DataBind();
        }

        protected void ddEvents_SelectedIndexChanged(object sender, EventArgs e) {
            gvPerfCriteriaMaint.DataBind();
        }
        
        protected void btnAddCriteria_Click(object sender, EventArgs e) {
            sqlPerfCriteriaMaint.InsertParameters["Criteria"].DefaultValue = " (new criteria)";
            sqlPerfCriteriaMaint.Insert();
            gvPerfCriteriaMaint.DataBind();
        }

    }
}