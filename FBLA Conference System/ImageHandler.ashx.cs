using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace FBLA_Conference_System {

    public class ImageHandler : IHttpHandler {

        public void ProcessRequest(HttpContext context) {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT ImageContent, ImageType FROM TestImages WHERE QuestionID=" + context.Request.QueryString["id"], conn);
            cmd.Prepare();
            try {
                SqlDataReader dr = cmd.ExecuteReader();
                dr.Read();
                if (dr["ImageType"].ToString().Length != 0) {
                    context.Response.ContentType = dr["ImageType"].ToString();
                    context.Response.BinaryWrite((byte[])dr["ImageContent"]);
                }
                dr.Close();
            } catch (Exception ex) { }
            conn.Close();
        }

        public bool IsReusable {
            get {
                return false;
            }
        }
    }
}