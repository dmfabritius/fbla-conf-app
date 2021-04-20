using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class HotelInvoice : System.Web.UI.Page {
    
        protected void Page_Load(object sender, EventArgs e) {

            string HotelInvoiceConferenceID = (Session["InvoiceConferenceID"] != null) ? Session["InvoiceConferenceID"].ToString() : "";
            string HotelInvoiceChapterID = (Session["InvoiceChapterID"] != null) ? Session["InvoiceChapterID"].ToString() : "";

            if (HotelInvoiceConferenceID == "" || HotelInvoiceChapterID == "") {
                //HotelInvoiceConferenceID = "18";
                //HotelInvoiceChapterID = "24";
                Server.Transfer("default.aspx");
            }

            DataSet ds = new DataSet();
            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());

            // query: list of hotel packages for a chapter
            StringBuilder sqlChapterPackages = new StringBuilder();
            sqlChapterPackages.Append("SELECT H.ChapterID, H.Amount, P.PackageDesc, P.PackagePrice, ExtendedPrice=H.Amount*P.PackagePrice ");
            sqlChapterPackages.Append("FROM ConferenceChapterHotels H");
            sqlChapterPackages.Append(" INNER JOIN ConferenceHotelPackages P ON H.HotelPackageID=P.HotelPackageID ");
            sqlChapterPackages.Append("WHERE H.Amount<>0 AND H.ConferenceID=" + HotelInvoiceConferenceID + " AND H.ChapterID=" + HotelInvoiceChapterID);

            // sub-query AS P: Total price of all hotel packages for this chapter
            StringBuilder sqlPackagesTotal = new StringBuilder();
            sqlPackagesTotal.Append("SELECT H.ChapterID, PackagesTotal=SUM(H.Amount*P.PackagePrice) ");
            sqlPackagesTotal.Append("FROM ConferenceChapterHotels H");
            sqlPackagesTotal.Append(" INNER JOIN ConferenceHotelPackages P ON H.HotelPackageID=P.HotelPackageID ");
            sqlPackagesTotal.Append("GROUP BY H.ConferenceID, H.ChapterID ");
            sqlPackagesTotal.Append("HAVING H.ConferenceID=" + HotelInvoiceConferenceID + " AND H.ChapterID=" + HotelInvoiceChapterID);

            // query: HotelInvoice data for a given chapter at a given conference
            StringBuilder sqlHotelInvoices = new StringBuilder();
            sqlHotelInvoices.Append("SELECT");
            sqlHotelInvoices.Append(" CurrentDate=GETDATE(),S.StateAbbr,");
            sqlHotelInvoices.Append(" RegionName=CASE WHEN C.RegionID=0 THEN S.StateName+' State' ELSE R.RegionName END,");
            sqlHotelInvoices.Append(" InvoiceAddress=CASE WHEN C.RegionID=0 THEN S.Address ELSE R.InvoiceAddress END,");
            sqlHotelInvoices.Append(" InvoiceCity=CASE WHEN C.RegionID=0 THEN S.City ELSE R.InvoiceCity END,");
            sqlHotelInvoices.Append(" InvoiceZip=CASE WHEN C.RegionID=0 THEN S.Zip ELSE R.InvoiceZip END,");
            sqlHotelInvoices.Append(" InvoiceContact=CASE WHEN C.RegionID=0 THEN S.AdviserName ELSE R.InvoiceContact END,");
            sqlHotelInvoices.Append(" C.ConferenceID, C.ConferenceName,DATEADD(day,10,C.ConferenceDate) AS DueDate,");
            sqlHotelInvoices.Append(" CH.AdviserName,CH.ChapterName,CH.Address AS ChapterAddress,CH.City AS ChapterCity,CH.Zip AS ChapterZip,");
            sqlHotelInvoices.Append(" CH.ChapterID,P.PackagesTotal ");
            sqlHotelInvoices.Append("FROM Conferences C");
            sqlHotelInvoices.Append(" INNER JOIN Chapters CH ON CH.ChapterID=" + HotelInvoiceChapterID);
            sqlHotelInvoices.Append(" INNER JOIN Regions R ON CH.RegionID=R.RegionID");
            sqlHotelInvoices.Append(" INNER JOIN States S ON C.StateID=S.StateID");
            sqlHotelInvoices.Append(" INNER JOIN (" + sqlPackagesTotal.ToString() + ") P ON CH.ChapterID=P.ChapterID AND P.PackagesTotal <> 0 ");
            sqlHotelInvoices.Append("WHERE C.ConferenceID=" + HotelInvoiceConferenceID);

            // Populate the dataset with 2 tables:
            //      HotelInvoices:   main table, used to generate the conference chapter HotelInvoices
            //      ChapterPackages: child table used to list the conference chapter packages
            SqlDataAdapter HotelInvoices = new SqlDataAdapter(sqlHotelInvoices.ToString(), cnn);
            HotelInvoices.Fill(ds, "HotelInvoices");

            SqlDataAdapter ChapterPackages = new SqlDataAdapter(sqlChapterPackages.ToString(), cnn);
            ChapterPackages.Fill(ds, "ChapterPackages");

            // Link the tables together so we can populate the DataLists inside the DataRepeater
            ds.Relations.Add(
                "HotelInvoiceChapterPackages",
                ds.Tables["HotelInvoices"].Columns["ChapterID"],
                ds.Tables["ChapterPackages"].Columns["ChapterID"]);

            rptConferenceHotelInvoices.DataSource = ds.Tables["HotelInvoices"];
            Page.DataBind();
            cnn.Close();
        }
    }
}