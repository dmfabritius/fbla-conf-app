using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

namespace FBLA_Conference_System
{
    public partial class Maint_Tests : System.Web.UI.Page {

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
            }
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global admin
            ddRegionalTests.DataBind();
            ddEvents.DataBind();
            fvTestQuestions.DataBind();
        }

        protected void ddRegionalTests_DataBound(object sender, EventArgs e) {
            // If the list of available regional tests is empty, disable the dropdown
            if (ddRegionalTests.Items.Count == 0) {
                ddRegionalTests.Enabled = false;
                ddRegionalTests.Items.Add(new ListItem("[No regional tests defined for this state]", "-1"));
            } else {
                ddRegionalTests.Enabled = true;
                ddEvents.DataBind();
                fvTestQuestions.DataBind();
            }
        }

        protected void ddRegionalTests_SelectedIndexChanged(object sender, EventArgs e) {
            // Only available to global and state admins
            ddEvents.DataBind();
            fvTestQuestions.DataBind();
        }

        protected void ddEvents_DataBound(object sender, EventArgs e) {
            fvTestQuestions.DataBind();
        }

        protected void ddEvents_SelectedIndexChanged(object sender, EventArgs e) {
            fvTestQuestions.ChangeMode(FormViewMode.ReadOnly);
            fvTestQuestions.DataBind();
        }

        protected void btnAdd_Click(object sender, EventArgs e) {
            fvTestQuestions.ChangeMode(FormViewMode.Insert);
        }

        protected void fvTestQuestions_DataBound(object sender, EventArgs e) {
            // If there are no questions for this conference & event, start in insert mode
            if (fvTestQuestions.PageCount == 0) fvTestQuestions.ChangeMode(FormViewMode.Insert);

            // Once data has been bound to the form view for editing, sync up the drop down lists
            if (fvTestQuestions.CurrentMode == FormViewMode.Edit) {
                DataRowView drv = (DataRowView)fvTestQuestions.DataItem;
                ((DropDownList)fvTestQuestions.FindControl("ddQuestionType")).SelectedValue = drv["QuestionType"].ToString();
                ((DropDownList)fvTestQuestions.FindControl("ddCorrectAnswer")).SelectedValue = drv["CorrectAnswer"].ToString();
                if (drv["ImageType"].ToString().Length == 0) ((Image)fvTestQuestions.FindControl("QuestionImage")).Visible = false;
            } else if (fvTestQuestions.CurrentMode == FormViewMode.ReadOnly) {
                DataRowView drv = (DataRowView)fvTestQuestions.DataItem;
                Session["QuestionID"] = drv["QuestionID"].ToString();
                if (drv["ImageType"].ToString().Length == 0) {
                    ((Button)fvTestQuestions.FindControl("RemoveImage")).Visible = false;
                    ((Image)fvTestQuestions.FindControl("QuestionImage")).Visible = false;
                }
            }
        }

        protected void fvTestQuestions_ItemInserting(object sender, FormViewInsertEventArgs e) {
            // When inserting a record, use the values from the drop down lists
            sqlTestQuestionMaint.InsertParameters["QuestionType"].DefaultValue = ((DropDownList)fvTestQuestions.FindControl("ddQuestionType")).SelectedValue;
            sqlTestQuestionMaint.InsertParameters["CorrectAnswer"].DefaultValue = ((DropDownList)fvTestQuestions.FindControl("ddCorrectAnswer")).SelectedValue;
        }

        protected void fvTestQuestions_ItemUpdating(object sender, FormViewUpdateEventArgs e) {
            // When updating the record, use the values from the drop down lists
            sqlTestQuestionMaint.UpdateParameters["QuestionType"].DefaultValue = ((DropDownList)fvTestQuestions.FindControl("ddQuestionType")).SelectedValue;
            sqlTestQuestionMaint.UpdateParameters["CorrectAnswer"].DefaultValue = ((DropDownList)fvTestQuestions.FindControl("ddCorrectAnswer")).SelectedValue;

            FileUpload uplFile = (FileUpload)fvTestQuestions.FindControl("uplFile");
            //if (uplFile.PostedFile != null && uplFile.PostedFile.FileName != "") {
            if (uplFile.HasFile) {

                byte[] myimage = new byte[uplFile.PostedFile.ContentLength];
                HttpPostedFile Image = uplFile.PostedFile;
                Image.InputStream.Read(myimage, 0, (int)uplFile.PostedFile.ContentLength);

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
                conn.Open();

                // remove any pre-existing image for this question
                SqlCommand deleteimage = new SqlCommand("DELETE FROM TestImages WHERE QuestionID=" + e.Keys[0].ToString(), conn);
                deleteimage.ExecuteNonQuery();

                SqlCommand storeimage = new SqlCommand(
                    "INSERT INTO TestImages (QuestionID,ImageType,ImageContent)" +
                    " VALUES (@id, @imagetype, @image)", conn);
                storeimage.Parameters.Add("@id", SqlDbType.Int).Value = e.Keys[0];
                storeimage.Parameters.Add("@imagetype", SqlDbType.VarChar, 100).Value = uplFile.PostedFile.ContentType;
                storeimage.Parameters.Add("@image", SqlDbType.VarBinary, myimage.Length).Value = myimage;
                storeimage.ExecuteNonQuery();

                conn.Close();
            }
        }

        protected void ddQuestionType_SelectedIndexChanged(object sender, EventArgs e) {
            if (((DropDownList)sender).SelectedValue == "2") {
                ((TextBox)fvTestQuestions.FindControl("AnswerChoice1")).Text = "True";
                ((TextBox)fvTestQuestions.FindControl("AnswerChoice2")).Text = "False";
                ((TextBox)fvTestQuestions.FindControl("AnswerChoice3")).Text = "";
                ((TextBox)fvTestQuestions.FindControl("AnswerChoice4")).Text = "";
            }
        }

        protected void RemoveImage_Click(object sender, EventArgs e) {
            using (SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString())) {
                cnn.Open();
                // Update the date for the next maintenance check to be one week from now
                SqlCommand cmd = new SqlCommand("DELETE FROM TestImages WHERE QuestionID=" + Session["QuestionID"], cnn);
                cmd.ExecuteNonQuery();
                cnn.Close();
                fvTestQuestions.DataBind();
            }
        }
    }
}