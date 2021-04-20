using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class EventWinners : System.Web.UI.Page {
    
        protected void Page_Load(object sender, EventArgs e) {

            string EventWinnersConferenceID = Session["EventWinnersConferenceID"].ToString();

            if (EventWinnersConferenceID == "") {
                Response.End();
                return;
            }

            DataSet ds = new DataSet();
            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());

            string sqlConferenceEvents =
                "SELECT EventID,EventName " +
                "FROM NationalEvents " +
                "WHERE isInactive=0 AND EventType<>'N'" +
                " AND EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=" + EventWinnersConferenceID + ") " +
                "ORDER BY EventName";

            string sqlConferenceEventTeams =
                "SELECT DISTINCT EventID,Place,"+
                " CASE WHEN TeamName IS NULL THEN ChapterName ELSE ChapterName+', '+TeamName END AS TeamName," +
                " Link=CAST(EventID as nvarchar)+CAST(C.ChapterID AS nvarchar)+ISNULL(TeamName,'')+Place " +
                "FROM ConferenceMemberEvents ME" +
                " INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID" +
                " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID " +
                "WHERE Place IS NOT NULL AND ConferenceID=" + EventWinnersConferenceID +
                " ORDER BY Place";

            string sqlConferenceEventWinners =
                "SELECT Place,FirstName+' '+LastName AS Name," +
                " Link=CAST(EventID as nvarchar)+CAST(C.ChapterID AS nvarchar)+ISNULL(TeamName,'')+Place " +
                "FROM ConferenceMemberEvents ME" +
                " INNER JOIN NationalMembers M ON ME.MemberID=M.MemberID" +
                " INNER JOIN Chapters C ON M.ChapterID=C.ChapterID " +
                "WHERE Place IS NOT NULL AND ConferenceID=" + EventWinnersConferenceID +
                "ORDER BY Place,LastName,FirstName,ChapterName";

            // Populate the dataset with 3 tables:
            //      Events:   main table, used to generate the conference events
            //      Teams:    child table use to list the teams for each event; non-team events will just have a single team
            //      Winners:  sub-child table used to list the winners for each team for each event
            SqlDataAdapter Events = new SqlDataAdapter(sqlConferenceEvents, cnn);
            Events.Fill(ds, "Events");

            SqlDataAdapter Teams = new SqlDataAdapter(sqlConferenceEventTeams, cnn);
            Teams.Fill(ds, "Teams");

            SqlDataAdapter Winners = new SqlDataAdapter(sqlConferenceEventWinners, cnn);
            Winners.Fill(ds, "Winners");

            // Link the tables together so we can populate the DataLists inside the DataRepeater
            ds.Relations.Add(
                "EventTeams",
                ds.Tables["Events"].Columns["EventID"],
                ds.Tables["Teams"].Columns["EventID"]);
            ds.Relations[0].Nested = true;

            ds.Relations.Add(
                "TeamWinners",
                ds.Tables["Teams"].Columns["Link"],
                ds.Tables["Winners"].Columns["Link"]);
            ds.Relations[1].Nested = true;

            rptConferenceEventWinners.DataSource = ds.Tables["Events"];

            Page.DataBind();
            cnn.Close();
        }

        protected DataView GetChildRelation(object dataItem, string relation) {
            DataRowView drv = dataItem as DataRowView;
            if (drv != null)
                return drv.CreateChildView(relation);
            else
                return null;
        }

    }
}