using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace FBLA_Conference_System {

    public partial class PasswordRequest : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            Panel panel = (Panel)Master.FindControl("LogoutLink");
            panel.Visible = false;
/*
            string strIPAddress = string.Empty;
            string strLocation = string.Empty;

            strIPAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (strIPAddress == "" || strIPAddress == null) strIPAddress = Request.ServerVariables["REMOTE_ADDR"];
            UserIP.Text = strIPAddress;

            HttpWebRequest objRequest = (HttpWebRequest)WebRequest.Create("http://freegeoip.appspot.com/xml/" + strIPAddress);
            try {
                HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();
                XmlTextReader objXmlTextReader = new XmlTextReader(objResponse.GetResponseStream());
                DataTable IPLocation = new DataTable();
                IPLocation.ReadXml(objXmlTextReader);
                if (IPLocation != null) {
                    if (IPLocation.Rows.Count > 0)
                        Location.Text = Convert.ToString(IPLocation.Rows[0]["City"]) + ", " +
                                        Convert.ToString(IPLocation.Rows[0]["RegionName"]);
                }

            } catch {
            }
 */
        }

        protected void Submit_Click(object sender, EventArgs e) {

            SmtpClient client = new SmtpClient();
            client.Host = ConfigurationManager.AppSettings["SMTPServerHostname"];
            client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPServerPort"]);
            client.EnableSsl = (ConfigurationManager.AppSettings["SMTPServerUseSSL"] == "true");
            if (ConfigurationManager.AppSettings["SMTPServerUseCredentials"] == "true") {
                client.Credentials = new System.Net.NetworkCredential(
                    ConfigurationManager.AppSettings["SMTPServerUsername"], ConfigurationManager.AppSettings["SMTPServerPassword"]);
            } else
                client.UseDefaultCredentials = true;
            
            MailMessage mail = new MailMessage();
            mail.IsBodyHtml = false;
            mail.From = new MailAddress(ConfigurationManager.AppSettings["SMTPServerFromAddress"]);
            mail.To.Add("dmfabritius@live.com");
            mail.Subject="test mail";
            mail.Body="This is a test message from FCS.  I hope it's not rejected.";

            try {
                client.Send(mail);
                RequestSent.Visible = true;
            } catch (Exception ex) {
                string errmsg = ex.ToString();
            }
        }
    }
}