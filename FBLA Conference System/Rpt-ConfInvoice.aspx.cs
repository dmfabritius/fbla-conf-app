using System;
using System.Collections.Generic;
using System.Configuration;
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
    public partial class Rpt_ConfInvoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            // Only Advisers can access this page
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
            gvConferenceChapters.DataBind();
            gvConferenceChapters.SelectRow(0);
        }

        protected void ddRegions_DataBound(object sender, EventArgs e) {
            // If the list of available regions is empty, disable the dropdown
            if (ddRegions.Items.Count == 0) {
                ddRegions.Enabled = false;
                ddRegions.Items.Add(new ListItem("[No regions defined for this state]", "-1"));
            } else {
                ddRegions.Enabled = true;
                gvConferenceChapters.DataBind();
                gvConferenceChapters.SelectRow(0);
            }
        }

        protected void ddRegions_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global and state admins
            ddConferences.DataBind();
            gvConferenceChapters.DataBind();
            gvConferenceChapters.SelectRow(0);
            gvAttendanceSummary.DataBind();
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
                gvConferenceChapters.DataBind();
                gvConferenceChapters.SelectRow(0);
                gvAttendanceSummary.DataBind();
            }
        }

        protected void ddConferences_SelectedIndexChanged(object sender, EventArgs e) {
            Session["InvoiceConferenceID"] = ddConferences.SelectedValue;
            gvConferenceChapters.DataBind();
            gvConferenceChapters.SelectRow(0);
            gvAttendanceSummary.DataBind();
        }

        protected void gvConferenceChapters_DataBinding(object sender, EventArgs e) {

            // Make sure we have a ConferenceID before proceeding
            if (ddConferences.SelectedValue == "") return;

            // sub-query AS S: Distinct (regardless of how many events their participating in)
            //                 list of members(students) and their chapter
            StringBuilder sqlStudents = new StringBuilder();
            sqlStudents.Append("SELECT DISTINCT C.ConferenceID,CH.RegionID,M.ChapterID,M.MemberID,M.FirstName,M.LastName ");
            sqlStudents.Append("FROM ConferenceMemberEvents C ");
            sqlStudents.Append("INNER JOIN NationalMembers M ON C.MemberID=M.MemberID ");
            sqlStudents.Append("INNER JOIN Chapters CH ON M.ChapterID=CH.ChapterID ");
            sqlStudents.Append("WHERE C.ConferenceID=" + ddConferences.SelectedValue);

            // sub-query AS SC: Count of members(students) attending the conference for each chapter
            StringBuilder sqlSC = new StringBuilder();
            sqlSC.Append("SELECT ConferenceID,RegionID,ChapterID,NumStudents=COUNT(*) ");
            sqlSC.Append("FROM (" + sqlStudents.ToString() + ") AS S ");
            sqlSC.Append("GROUP BY ConferenceID,RegionID,ChapterID");

            // sub-query AS CC: Count of chaperones attending the conference for each chapter
            //                  this could be an empty list, so it is left joined into the NUM sub-query
            StringBuilder sqlCC = new StringBuilder();
            sqlCC.Append("SELECT ConferenceID,ChapterID,NumChaps=COUNT(*) ");
            sqlCC.Append("FROM ConferenceChapterChaperones ");
            sqlCC.Append("WHERE ConferenceID=" + ddConferences.SelectedValue + " ");
            sqlCC.Append("GROUP BY ConferenceID,ChapterID");

            // sub-query AS NUM: Combination of students and chaperones
            //                   for this conference for each chapter
            StringBuilder sqlNum = new StringBuilder();
            sqlNum.Append("SELECT ConferenceID=" + ddConferences.SelectedValue + ",SC.RegionID,SC.ChapterID,SC.NumStudents,ISNULL(CC.NumChaps,0) AS NumChaps ");
            sqlNum.Append("FROM (" + sqlSC.ToString() + ") AS SC ");
            sqlNum.Append("LEFT JOIN (" + sqlCC.ToString() + ") AS CC ON SC.ConferenceID=CC.ConferenceID AND SC.ChapterID=CC.ChapterID");

            // query: Invoice data for a given conference
            StringBuilder sqlInvoices = new StringBuilder();
            sqlInvoices.Append("SELECT ChapterName=CASE WHEN C.RegionID=0 THEN R.RegionName+', '+CH.ChapterName ELSE CH.ChapterName END,CH.ChapterID,C.ConferenceAdviserFee,C.ConferenceStudentFee,NUM.NumChaps,NUM.NumStudents,AdvSubtotal=C.ConferenceAdviserFee*NUM.NumChaps,StuSubtotal=C.ConferenceStudentFee*NUM.NumStudents,Total=C.ConferenceAdviserFee*NUM.NumChaps+C.ConferenceStudentFee*NUM.NumStudents ");
            sqlInvoices.Append("FROM Conferences C ");
            sqlInvoices.Append("INNER JOIN (" + sqlNum.ToString() + ") AS NUM ON C.ConferenceID=NUM.ConferenceID ");
            sqlInvoices.Append("INNER JOIN Chapters CH ON NUM.ChapterID=CH.ChapterID ");
            sqlInvoices.Append("INNER JOIN Regions R ON NUM.RegionID=R.RegionID ");
            sqlInvoices.Append("WHERE C.ConferenceID=" + ddConferences.SelectedValue);

            // State admins can select invoices for any region in their state
            if ((int)Session["RegionID"] == 0) {
                sqlInvoices.Append(" ORDER BY R.RegionName,CH.ChapterName");
            } else if ((int)Session["ChapterID"] == 0) {
                // Regional admins can select invoices for any chapter in their region
                sqlInvoices.Append(" AND R.RegionID=" + Session["RegionID"] + " ORDER BY CH.ChapterName");
            } else {
                // Chapter admins can only see their own invoices
                sqlInvoices.Append(" AND CH.ChapterID=" + Session["ChapterID"]);
            }

            SqlDataAdapter adapter = new SqlDataAdapter(
                sqlInvoices.ToString(),
                System.Configuration.ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            DataTable tblInvoices = new DataTable();
            adapter.Fill(tblInvoices);
            gvConferenceChapters.DataSource = tblInvoices;
        }

        protected void gvConferenceChapters_DataBound(object sender, EventArgs e) {
            Session["InvoiceChapterID"] = gvConferenceChapters.SelectedValue;
            if ((int)Session["ChapterID"] != 0) gvConferenceChapters.ShowFooter = false;
        }

        int _NumStudentsTotal;
        int _NumChapsTotal;
        int _GrandTotal;
        protected void gvConferenceChapters_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.Header) {
                _NumStudentsTotal = 0;
                _NumChapsTotal = 0;
                _GrandTotal = 0;
            } else if (e.Row.RowType == DataControlRowType.DataRow) {
                if ((int)Session["ChapterID"] != 0) ((LinkButton)e.Row.FindControl("SelectButton")).Visible = false;
                _NumStudentsTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumStudents"));
                _NumChapsTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "NumChaps"));
                _GrandTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Total"));
            } else if (e.Row.RowType == DataControlRowType.Footer) {
                e.Row.Cells[1].Text = "Totals:";
                // for the Footer, display the totals
                e.Row.Cells[2].Text = _NumStudentsTotal.ToString("d");
                e.Row.Cells[5].Text = _NumChapsTotal.ToString("d");
                e.Row.Cells[8].Text = _GrandTotal.ToString("C");
            }
        }

        protected void gvConferenceChapters_SelectedIndexChanged(object sender, EventArgs e) {
            if (gvConferenceChapters.SelectedValue != null) Session["InvoiceChapterID"] = gvConferenceChapters.SelectedValue;
        }

        string _SortExpression = "RegionName, ChapterName, Attendee, LastName, FirstName";
        protected void gvAttendanceSummary_DataBinding(object sender, EventArgs e) {
            // Make sure we have a ConferenceID before proceeding
            if (ddConferences.SelectedValue == "") return;

            // query: List of students, Advisers, and chaperones
            StringBuilder sqlAttendance = new StringBuilder();
            sqlAttendance.Append("SELECT * FROM ((");
            sqlAttendance.Append(   "SELECT R.RegionID,RegionName,C.ChapterID,ChapterName,FirstName,LastName,Attendee='Student',M.ShirtSize ");
            sqlAttendance.Append(   "FROM NationalMembers M");
            sqlAttendance.Append(   " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID");
            sqlAttendance.Append(   " INNER JOIN Regions R ON C.RegionID=R.RegionID");
            sqlAttendance.Append(   " INNER JOIN ConferenceMemberEvents ME ON ME.ConferenceID=" + ddConferences.SelectedValue + " AND M.MemberID=ME.MemberID");
            sqlAttendance.Append(") UNION (");
            /* Don't assume all chapter advisers are attending the conference
            sqlAttendance.Append(   "SELECT DISTINCT R.RegionID,RegionName,C.ChapterID,ChapterName,");
            sqlAttendance.Append(*****************   " RIGHT(AdviserName,LEN(AdviserName)-CHARINDEX(' ',AdviserName)) AS LastName,");
            sqlAttendance.Append(*****************   " LTRIM(LEFT(AdviserName,CHARINDEX(' ',AdviserName))) AS FirstName,");
            sqlAttendance.Append(   " Attendee='Adviser',C.ShirtSize ");
            sqlAttendance.Append(   "FROM NationalMembers M");
            sqlAttendance.Append(   " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID");
            sqlAttendance.Append(   " INNER JOIN Regions R ON C.RegionID=R.RegionID");
            sqlAttendance.Append(   " INNER JOIN ConferenceMemberEvents ME ON ME.ConferenceID=" + ddConferences.SelectedValue+" AND M.MemberID=ME.MemberID");
            */
            sqlAttendance.Append(   "SELECT R.RegionID,R.RegionName,C.ChapterID,C.ChapterName,");
            sqlAttendance.Append(   " FirstName=CASE WHEN LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)>0 THEN LTRIM(LEFT(ChaperoneName,CHARINDEX(' ',ChaperoneName))) ELSE '(No first name)' END,");
            sqlAttendance.Append(   " LastName=CASE WHEN LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)>0 THEN RIGHT(ChaperoneName,LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)) ELSE ChaperoneName END,");
            sqlAttendance.Append(   " Attendee='Adviser',CC.ShirtSize ");
            sqlAttendance.Append(   "FROM ConferenceChapterChaperones CC");
            sqlAttendance.Append(   " INNER JOIN Chapters C ON CC.ChapterID=C.ChapterID");
            sqlAttendance.Append(   " INNER JOIN Regions R ON C.RegionID=R.RegionID ");
            sqlAttendance.Append(   "WHERE ChaperoneType = 'A' AND ConferenceID=" + ddConferences.SelectedValue);
            sqlAttendance.Append(") UNION (");
            sqlAttendance.Append(   "SELECT R.RegionID,R.RegionName,C.ChapterID,C.ChapterName,");
            sqlAttendance.Append(   " FirstName=CASE WHEN LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)>0 THEN LTRIM(LEFT(ChaperoneName,CHARINDEX(' ',ChaperoneName))) ELSE '(No first name)' END,");
            sqlAttendance.Append(   " LastName=CASE WHEN LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)>0 THEN RIGHT(ChaperoneName,LEN(ChaperoneName)-CHARINDEX(' ',ChaperoneName)) ELSE ChaperoneName END,");
            sqlAttendance.Append(   " Attendee='Chaperone',CC.ShirtSize ");
            sqlAttendance.Append(   "FROM ConferenceChapterChaperones CC");
            sqlAttendance.Append(   " INNER JOIN Chapters C ON CC.ChapterID=C.ChapterID");
            sqlAttendance.Append(   " INNER JOIN Regions R ON C.RegionID=R.RegionID ");
            sqlAttendance.Append(   "WHERE ChaperoneType <> 'A' AND ConferenceID=" + ddConferences.SelectedValue);
            sqlAttendance.Append(")) U"); // WHERE 1=1

            // For chapter Advisers, limit the list of attendees to their own chapter
            if ((int)Session["ChapterID"] != 0) {
                sqlAttendance.Append(" WHERE ChapterID=" + Session["ChapterID"].ToString());
            }
            // For regional Advisers, limit the list of attendees to their own region
            else if ((int)Session["RegionID"] != 0) {
                sqlAttendance.Append(" WHERE RegionID=" + Session["RegionID"].ToString());
            }

            SqlDataAdapter adapter = new SqlDataAdapter(
                sqlAttendance.ToString(),
                System.Configuration.ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            DataTable tblAttendance = new DataTable();
            adapter.Fill(tblAttendance);
            tblAttendance.DefaultView.Sort = _SortExpression;
            gvAttendanceSummary.DataSource = tblAttendance;
        }

        protected void gvAttendanceSummary_Sorting(object sender, GridViewSortEventArgs e) {
            _SortExpression = e.SortExpression;
            gvAttendanceSummary.DataBind();
        }

    }
}