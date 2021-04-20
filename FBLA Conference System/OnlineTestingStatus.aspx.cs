using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class OnlineTestingStatus : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {

        }

        int _Total;
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e) {
            if (e.Row.RowType == DataControlRowType.Header) {
                _Total = 0;
            } else if (e.Row.RowType == DataControlRowType.DataRow) {
                _Total += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Num"));
            } else if (e.Row.RowType == DataControlRowType.Footer) {
                e.Row.Cells[0].Text = "Total:";
                e.Row.Cells[1].Text = _Total.ToString("#,##0");
            }
        }
    }
}