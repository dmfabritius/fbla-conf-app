using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FBLA_Conference_System {

    public partial class Test_Import : System.Web.UI.Page {

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
            pnlWarning.Visible = ckOverwrite.Checked;
        }

        protected void ddStates_SelectedIndexChanged(object sender, EventArgs e) {
            ddRegionalTests.DataBind();
        }

        protected void ddRegionalTests_DataBound(object sender, EventArgs e) {
            // If the list of available conferences is empty, disable the dropdown
            if (ddRegionalTests.Items.Count == 0) {
                ddRegionalTests.Enabled = false;
                ddRegionalTests.Items.Add(new ListItem("[No regional tests defined for this state]", "-1"));
            } else {
                ddRegionalTests.Enabled = true;
                fvRegionalTests.DataBind();
            }
        }

        protected void ddRegionalTests_SelectedIndexChanged(object sender, EventArgs e) {
            fvRegionalTests.DataBind();
        }

        protected void btnAddRegionalTests_Click(object sender, EventArgs e) {
            fvRegionalTests.ChangeMode(FormViewMode.Insert);
        }

        protected void sqlRegionalTestsMaint_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
            if (e.Exception != null) {
                lblPopup.Text = e.Exception.Message + "\n" + e.Exception.InnerException;
                popupErrorMsg.Show();
                e.ExceptionHandled = true;
            } else {
                DbCommand command = e.Command;
                ddRegionalTests.DataBind();
                ddRegionalTests.SelectedValue = command.Parameters["@RegionalTestsID"].Value.ToString();
                fvRegionalTests.DataBind();
            }
        }

        protected void sqlRegionalTestsMaint_Deleted(object sender, SqlDataSourceStatusEventArgs e) {
            ddRegionalTests.DataBind();
            fvRegionalTests.DataBind();
        }

        protected void sqlRegionalTestsMaint_Updated(object sender, SqlDataSourceStatusEventArgs e) {
            string current = ddRegionalTests.SelectedValue;
            ddRegionalTests.DataBind();
            ddRegionalTests.SelectedValue = current;
            fvRegionalTests.DataBind();
        }

        protected void btnImport_Click(object sender, EventArgs e) {
            if (uplFile.HasFile) {

                lstResults.Items.Clear(); // empty the results list

                string f = Environment.GetEnvironmentVariable("TEMP") + "\\" + uplFile.FileName;
                if (File.Exists(f)) File.Delete(f);
                uplFile.SaveAs(f);

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
                conn.Open();

                // prepare for import by removing any existing questions
                SqlCommand cmd = new SqlCommand("DELETE FROM TestQuestions WHERE RegionalTestsID=" + ddRegionalTests.SelectedValue, conn);
                try {
                    if (ckOverwrite.Checked) cmd.ExecuteNonQuery();
                }
                catch (Exception ex) {
                    lblPopup.Text = "Test responses have already been assigned, cannot re-import.";
                    popupErrorMsg.Show();
                    return;
                }

                // open tab-delimited text file
                using (StreamReader sr = File.OpenText(f)) {
                    string s = "";
                    string[] x;
                    string prevEvent = "";
                    int EventID = 0;
                    int QuestionType;
                    int CorrectAnswer;
                    string part1, part2;

                    s = sr.ReadLine(); // read first line, which is the header -- it won't be processed
                    while ((s = sr.ReadLine()) != null) {
                        // 0=Event Name
                        // 1=Question Number
                        // 2=Question Type (can be M=multiple choice or T=true/false)
                        // 3=Question
                        // 4=Answer Choice #1
                        // 5=Answer Choice #2
                        // 6=Answer Choice #3
                        // 7=Answer Choice #4
                        // 8=Correct Answer
                        x = s.Split('\t');
                        if (x.Length < 9) {
                            lstResults.Items.Add("Import aborted - missing required field: " + s);
                            break;
                        }
                        x[3] = ProcessQuotes(x[3]);
                        x[4] = ProcessQuotes(x[4]);
                        x[5] = ProcessQuotes(x[5]);
                        x[6] = ProcessQuotes(x[6]);
                        x[7] = ProcessQuotes(x[7]);

                        try {
                            CorrectAnswer = Int32.Parse(x[8]);
                        }
                        catch (FormatException) {
                            switch (x[8].ToUpper()) {
                                case "A": CorrectAnswer = 1;
                                    break;
                                case "B": CorrectAnswer = 2;
                                    break;
                                case "C": CorrectAnswer = 3;
                                    break;
                                case "D": CorrectAnswer = 4;
                                    break;
                                default: CorrectAnswer = 1;
                                    break;
                            }
                        }

                        if (prevEvent != x[0]) {
                            cmd.CommandText = "SELECT EventID FROM NationalEvents WHERE EventName='" + x[0] + "'";
                            try {
                                EventID = (Int32)cmd.ExecuteScalar();
                                lstResults.Items.Add("Importing " + x[0]);
                                prevEvent = x[0];
                            }
                            catch {
                                lstResults.Items.Add("-Error- Unrecognized event: " + x[0]);
                                EventID = 0;
                            }
                        }

                        if (EventID != 0) {
                            QuestionType = (x[2].ToUpper() == "T") ? 2 : 1;
                            part1 =
                                "INSERT INTO TestQuestions " +
                                "(RegionalTestsID,EventID,QuestionNumber,QuestionType,Question,AnswerChoice1,AnswerChoice2,AnswerChoice3,AnswerChoice4,CorrectAnswer) " +
                                "VALUES (";
                            part2 =
                                ddRegionalTests.SelectedValue + "," +
                                EventID + "," +
                                x[1] + "," +
                                "'" + QuestionType + "'," +
                                "'" + x[3] + "'," +
                                "'" + x[4] + "'," +
                                "'" + x[5] + "'," +
                                "'" + x[6] + "'," +
                                "'" + x[7] + "'," +
                                CorrectAnswer + ")";
                            cmd.CommandText = part1 + part2;

                            try {
                                cmd.ExecuteNonQuery();
                                //lstResults.Items.Add("Question #" + x[1] + " added.");
                            }
                            catch (Exception ex) {
                                lstResults.Items.Add("-Error- Badly formed question data: " + part2);
                            }
                        }
                    }
                    lstResults.Items.Add("** Import complete");

                    conn.Close();
                    //File.Delete(f);
                }
            }
        }

        protected string ProcessQuotes(string input) {
            input = input.Replace("\"\"", "\"").Replace("'", "''").Replace('\uFFFD', ' ');
            if (input.StartsWith("\""))
                return input.Substring(1, input.Length - 2);
            else
                return input;
        }

    }
}