using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Invoice : System.Web.UI.Page {
    
        protected void Page_Load(object sender, EventArgs e) {

            string InvoiceConferenceID = (Session["InvoiceConferenceID"] != null) ? Session["InvoiceConferenceID"].ToString() : "";
            string InvoiceChapterID = (Session["InvoiceChapterID"] != null) ? Session["InvoiceChapterID"].ToString() : "";

            if (InvoiceConferenceID == "" || InvoiceChapterID == "") {
                //InvoiceConferenceID = "4";
                //InvoiceChapterID = "22";
                Server.Transfer("default.aspx");
            }

            DataSet ds = new DataSet();
            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());

            // query: list of conference chaperones for a chapter
            StringBuilder sqlChaperones = new StringBuilder();
            sqlChaperones.Append("SELECT C.ChapterID,ChaperoneName ");
            sqlChaperones.Append("FROM ConferenceChapterChaperones C ");
            sqlChaperones.Append("WHERE C.ConferenceID=" + InvoiceConferenceID + " AND ChapterID=" + InvoiceChapterID);

            // query: list of conference chaperones for a chapter who elected to join BEA
            StringBuilder sqlBEASignups = new StringBuilder();
            sqlBEASignups.Append("SELECT C.ChapterID,ChaperoneName ");
            sqlBEASignups.Append("FROM ConferenceChapterChaperones C ");
            sqlBEASignups.Append("WHERE JoinBEA=1 AND C.ConferenceID=" + InvoiceConferenceID + " AND ChapterID=" + InvoiceChapterID);

            // -- 8/6/2012 - Advisers must now be explicitly added as a conf chaperone
            //sqlChaperones.Append(" UNION ");
            //sqlChaperones.Append("SELECT ChapterID, AdviserName AS ChaperoneName ");
            //sqlChaperones.Append("FROM Chapters ");
            //sqlChaperones.Append("WHERE ChapterID=" + InvoiceChapterID);

            // sub-query AS S: Distinct (regardless of how many events they're participating in)
            //                 list of members(students) and their chapter
            StringBuilder sqlStudents = new StringBuilder();
            sqlStudents.Append("SELECT DISTINCT ");
            sqlStudents.Append(    "M.ChapterID,M.MemberID,M.FirstName,M.LastName ");
            sqlStudents.Append("FROM ");
            sqlStudents.Append(    "ConferenceMemberEvents C ");
            sqlStudents.Append(    "INNER JOIN NationalMembers M ON C.MemberID=M.MemberID ");
            sqlStudents.Append("WHERE ");
            sqlStudents.Append(    "C.ConferenceID=" + InvoiceConferenceID + " AND M.ChapterID=" + InvoiceChapterID);

            // sub-query AS SC: Count of members(students) attending the conference for each chapter
            StringBuilder sqlSC = new StringBuilder();
            sqlSC.Append("SELECT ChapterID,NumStudents=COUNT(*) ");
            sqlSC.Append("FROM ("+sqlStudents.ToString()+") AS S ");
            sqlSC.Append("GROUP BY ChapterID");

            // sub-query AS CC: Count of chaperones attending the conference for each chapter
            //                  this could be an empty list, so it is left joined into the NUM sub-query
            StringBuilder sqlCC = new StringBuilder();
            sqlCC.Append("SELECT ChapterID,NumChaps=COUNT(*),NumBEA=SUM(JoinBEA) ");
            sqlCC.Append("FROM ConferenceChapterChaperones ");
            sqlCC.Append("WHERE ConferenceID=" + InvoiceConferenceID + " AND ChapterID=" + InvoiceChapterID + " ");
            sqlCC.Append("GROUP BY ChapterID");

            // sub-query AS BEA: Count of advisers/chaperones who elected to join BEA

            // sub-query AS NUM: Combination of students and chaperones
            //                   for this conference for each chapter
            StringBuilder sqlNum = new StringBuilder();
            sqlNum.Append("SELECT ");
            sqlNum.Append(" ConferenceID=" + InvoiceConferenceID + ",SC.ChapterID,SC.NumStudents,");
            sqlNum.Append(" NumChaps=ISNULL(CC.NumChaps,0),NumBEA=ISNULL(CC.NumBEA,0) ");
            sqlNum.Append("FROM ");
            sqlNum.Append(" (" + sqlSC.ToString() + ") AS SC ");
            sqlNum.Append(" LEFT JOIN (" + sqlCC.ToString() + ") AS CC ON SC.ChapterID=CC.ChapterID");

            // query: Invoice data for a given conference
            StringBuilder sqlInvoices = new StringBuilder();
            sqlInvoices.Append("SELECT");
            sqlInvoices.Append(" CurrentDate=GETDATE(),S.StateAbbr,");
            sqlInvoices.Append(" RegionName=CASE WHEN C.RegionID=0 THEN S.StateName+' State' ELSE R.RegionName END,");
            sqlInvoices.Append(" InvoiceAddress=CASE WHEN C.RegionID=0 THEN S.Address ELSE R.InvoiceAddress END,");
            sqlInvoices.Append(" InvoiceCity=CASE WHEN C.RegionID=0 THEN S.City ELSE R.InvoiceCity END,");
            sqlInvoices.Append(" InvoiceZip=CASE WHEN C.RegionID=0 THEN S.Zip ELSE R.InvoiceZip END,");
            sqlInvoices.Append(" InvoiceContact=CASE WHEN C.RegionID=0 THEN S.AdviserName ELSE R.InvoiceContact END,");
            sqlInvoices.Append(" C.ConferenceName,DueDate=DATEADD(day,10,C.ConferenceDate),");
            sqlInvoices.Append(" C.ConferenceAdviserFee,C.ConferenceStudentFee,S.BEADues,");
            sqlInvoices.Append(" NUM.ConferenceID,NUM.ChapterID,NUM.NumChaps,NUM.NumStudents,NUM.NumBEA,");
            sqlInvoices.Append(" CH.AdviserName,CH.ChapterName,CH.Address AS ChapterAddress,CH.City AS ChapterCity,CH.Zip AS ChapterZip,");
            sqlInvoices.Append(" BEAName=S.StateName+' State',BEASubtotal=S.BEADues*NUM.NumBEA,");
            sqlInvoices.Append(" AdvSubtotal=C.ConferenceAdviserFee*NUM.NumChaps,");
            sqlInvoices.Append(" StuSubtotal=C.ConferenceStudentFee*NUM.NumStudents,");
            sqlInvoices.Append(" Total=C.ConferenceAdviserFee*NUM.NumChaps+C.ConferenceStudentFee*NUM.NumStudents+S.BEADues*NUM.NumBEA ");
            sqlInvoices.Append("FROM Conferences C");
            sqlInvoices.Append(" INNER JOIN (" + sqlNum.ToString() + ") AS NUM ON C.ConferenceID=NUM.ConferenceID ");
            sqlInvoices.Append(" INNER JOIN Chapters CH ON NUM.ChapterID=CH.ChapterID ");
            sqlInvoices.Append(" INNER JOIN Regions R ON CH.RegionID=R.RegionID ");
            sqlInvoices.Append(" INNER JOIN States S ON C.StateID=S.StateID ");
            sqlInvoices.Append("WHERE C.ConferenceID=" + InvoiceConferenceID + " AND CH.ChapterID=" + InvoiceChapterID);

            // Populate the dataset with 3 tables:
            //      Invoices:   main table, used to generate the conference chapter invoices
            //      Students:   child table used to list the conference chapter attendees
            //      Chaperones: child table used to list the conference chapter chaperones
            SqlDataAdapter Invoices = new SqlDataAdapter(sqlInvoices.ToString(), cnn);
            Invoices.Fill(ds, "Invoices");

            SqlDataAdapter Students = new SqlDataAdapter(sqlStudents.ToString(), cnn);
            Students.Fill(ds, "Students");

            SqlDataAdapter Chaperones = new SqlDataAdapter(sqlChaperones.ToString(), cnn);
            Chaperones.Fill(ds, "Chaperones");


            SqlDataAdapter BEASignups = new SqlDataAdapter(sqlBEASignups.ToString(), cnn);
            BEASignups.Fill(ds, "BEASignups");

            // Link the tables together so we can populate the DataLists inside the DataRepeater
            ds.Relations.Add(
                "InvoiceStudents",
                ds.Tables["Invoices"].Columns["ChapterID"],
                ds.Tables["Students"].Columns["ChapterID"]);

            if (ds.Tables["Chaperones"].Rows.Count != 0) {
                ds.Relations.Add(
                    "InvoiceChaperones",
                    ds.Tables["Invoices"].Columns["ChapterID"],
                    ds.Tables["Chaperones"].Columns["ChapterID"]);
            }

            if (ds.Tables["BEASignups"].Rows.Count != 0) {
                ds.Relations.Add(
                    "InvoiceBEASignups",
                    ds.Tables["Invoices"].Columns["ChapterID"],
                    ds.Tables["BEASignups"].Columns["ChapterID"]);
            }

            rptConferenceInvoices.DataSource = ds.Tables["Invoices"];

            Page.DataBind();
            cnn.Close();
        }
    }
}