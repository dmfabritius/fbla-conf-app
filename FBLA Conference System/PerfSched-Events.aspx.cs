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

    public partial class PerfSched_Events : System.Web.UI.Page {

        private string SchedConferenceID, Layout;

        protected void Page_Load(object sender, EventArgs e) {

            Layout = (Request.QueryString["layout"] != null) ? Request.QueryString["layout"].ToString() : "m";
            SchedConferenceID = (Session["SchedConferenceID"] != null) ? Session["SchedConferenceID"].ToString() : "2083";
            if (SchedConferenceID == "") Server.Transfer("default.aspx");

            SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConfDB"].ToString());
            cnn.Open();

            // Determine if this is a regional or state conference
            SqlCommand cmd = new SqlCommand("SELECT RegionID FROM Conferences WHERE ConferenceID=" + SchedConferenceID, cnn);
            int RegionID = (Int32)cmd.ExecuteScalar();
            if (RegionID != 0) {
                // For regional conferences, all testing is done on one day
                CreateSchedule(0, cnn);
            } else {
                // For the state conference, testing is spread across two days
                CreateSchedule(1, cnn);
                CreateSchedule(2, cnn);
            }
            cnn.Close();
        }

        protected void CreateSchedule(int PerfDay, SqlConnection cnn) {

            DataSet ds = new DataSet();

            #region Define variables and create the HTML objects
            // Set the level of granularity for scheduling
            int _TimeBlockSize = Int32.Parse(ConfigurationManager.AppSettings["SchedTimeBlockSize"].ToString());
            // Reserver some time between events for students to move around and for judges to take a break
            int _MemSchedBuffer = (6 / _TimeBlockSize);           // Give students a 6 min buffer before & after an event (effectively 12 min between events)
            int _BreakInterval = (105 / _TimeBlockSize);          // Take a break after 1hr 45min
            int _BreakLength = (10 / _TimeBlockSize);             // Break for 10 min

            // Reserve space in the event schedule for header info
            const int _EvtSchedHeaderRows = 1;      // row 0 = event prep/testing station names
            const int _EvtSchedHeaderCols = 1;      // col 0 = time info, e.g., 8:30 AM
            // Reserve space in the member schedule for header info
            const int _MemSchedHeaderRows = 1;      // row 0 = time info, e.g., 8:30 AM
            const int _MemSchedHeaderCols = 4;      // col 0 thru 3 = region, chapter, first, last
            string[] MemberInfo = new string[] { "RegionName", "ChapterName", "FirstName", "LastName" };

            string[] HeaderColors = new string[] { "203764", "305496", "4472C4" };
            int HeaderColorIndex = 0;
            string[] CellColors = new string[] { "FFAFAF", "FFDDAB", "FFFFAF", "B9FFB9", "CDE4BE", "CDFFFF", "BDD7EE", "D6BBEB" };
            //string[] CellColors = new string[] { "FFFFAF", "B9FFB9", "CDFFFF", "BDD7EE" };
            int CellColorIndex = 0;

            DataRow EventMemberRow, TeamEventMemberRow;
            DataRow[] EventRows, MemberRows;
            int EventIndex = _EvtSchedHeaderCols;
            int EventMemberIndex;
            int TotalTimeSlots, TestTimeIndex, BreakSlots;
            int EvtStations = 0, StationsIndex = 0, TestStationIndex = 0;
            int TimeBlock = 0, PrepAndTrans = 0, PerfAndJudge = 0, HasPrepStation = 0;
            int MemberIndex = 0, TeamMemberIndex = 0;
            string MemberID, TeamMemberNames = "";
            bool isNoConflict, isSameTeam, isNewEvent;
            int NumEvtParticipants = 0;

            // Dynamically build HTML tables to contain the performance testing schedules
            //  m = two matrix reports for Excel, one by event and another by member
            //  s = one station report for Word, for posting at each testing station
            HtmlTable EvtSched = new HtmlTable();
            HtmlTable MemSched = new HtmlTable();
            HtmlTable StationSched;
            HtmlTableRow row;
            HtmlTableCell cell;
            if (Layout == "m") {
                Schedule.Controls.Add(EvtSched);
                Schedule.Controls.Add(MemSched);
            }
            #endregion

            #region Determine the start time and number of time slots in the conference schedule
            string sqlConfInfo =
                "select ConferenceName, ConferenceDate, PerfTestingStart,"+
                " TotalTimeSlots=CEILING(DATEDIFF(mi,'00:00',PerfTestingEnd-PerfTestingStart)/" + _TimeBlockSize + ") " +
                "from Conferences where ConferenceID=" + SchedConferenceID;
            SqlDataAdapter daConfInfo = new SqlDataAdapter(sqlConfInfo, cnn);
            daConfInfo.Fill(ds,"ConfInfo");
            string ConferenceName = ds.Tables["ConfInfo"].Rows[0]["ConferenceName"].ToString();
            DateTime ConferenceDate = new DateTime();
            ConferenceDate = (DateTime)ds.Tables["ConfInfo"].Rows[0]["ConferenceDate"];

            TotalTimeSlots = (int)ds.Tables["ConfInfo"].Rows[0]["TotalTimeSlots"];
            DateTime PerfTestingStart = new DateTime();
            PerfTestingStart = (DateTime)ds.Tables["ConfInfo"].Rows[0]["PerfTestingStart"];
            #endregion

            #region Fill a table with a list of performance events, the total end-to-end time for a team/member to be tested, and the number of testing stations needed
            // This list is sorted by how long it takes to process a test (including prep, transition, presentation, and judging)
            // and is used to build the basic structure of the event schedule table
            // For the state conference, the testing is split across two days, so take that into account if necessary
            string sqlPerfDay = (PerfDay != 0) ? " AND ISNULL(e.PerfDay,1)=" + PerfDay : "";
            string MaxParts = ConfigurationManager.AppSettings["MaxParticipantsPerPerfEvent"].ToString();
            string sqlEvents =
                "SELECT *,EvtStations=CEILING((TimeBlock+(PerfAndJudge*(NumTests-1))+" + ConfigurationManager.AppSettings["SchedMultiStationFactor"].ToString() + ")/TotalTestingMin) " +
                "FROM (" +
                " SELECT EventName,EventType," +
                "  PrepAndTrans,PerfAndJudge,TimeBlock,HasPrepStation,TotalTestingMin," +
                "  NumTests=CASE WHEN PerformanceWeight=100 THEN COUNT(*) ELSE CASE WHEN COUNT(*) > " + MaxParts + " THEN " + MaxParts + " ELSE COUNT(*) END END" +
                " FROM (" +
                "  SELECT DISTINCT e.EventName,e.EventType," +
                "   PerformanceWeight,ch.ChapterName,Name=ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)," +
                "   PrepAndTrans=CEILING(ISNULL(PrepTime,0)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "," +
                "   PerfAndJudge=CEILING((ISNULL(PerfTime,0)+1)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "," +
                "   TimeBlock=CEILING(ISNULL(PrepTime,0)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "+CEILING((ISNULL(PerfTime,0)+1)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "," +
                "   HasPrepStation=CASE WHEN ISNULL(PrepTime,0)=0 THEN 0 ELSE 1 END," +
                "   TotalTestingMin=DATEDIFF(mi,'00:00',c.PerfTestingEnd-c.PerfTestingStart)" +
                "  FROM ConferenceMemberEvents cme" +
                "   INNER JOIN NationalEvents e ON cme.EventID=e.EventID" +
                "    AND e.EventID NOT IN (SELECT EventID FROM ExcludedPerformances WHERE ConferenceID=" + SchedConferenceID + ")" +
                "    AND e.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=" + SchedConferenceID + ")" +
                "    AND ISNULL(e.PerformanceWeight,0) <> 0" + sqlPerfDay +
                "   INNER JOIN NationalMembers m ON cme.MemberID=m.MemberID" +
                "   INNER JOIN Chapters ch ON m.ChapterID=ch.ChapterID" +
                "   INNER JOIN Conferences c ON cme.ConferenceID=c.ConferenceID" +
                "  WHERE cme.ConferenceID=" + SchedConferenceID +
                "   AND (ISNULL(e.ObjectiveWeight,0)=0 OR (ISNULL(e.ObjectiveWeight,0)<>0 AND ISNULL(cme.ObjectiveScore,0)>0))" +
                "   AND (ISNULL(e.HomesiteWeight,0)=0 OR (ISNULL(e.HomesiteWeight,0)<>0 AND ISNULL(cme.HomesiteScore,0)>0)) " +
                "  ) t1" +
                " GROUP BY EventName,EventType,PerformanceWeight," +
                "  PrepAndTrans,PerfAndJudge,TimeBlock,HasPrepStation,TotalTestingMin" +
                " ) t2 " +
                "ORDER BY EventType DESC,EventName";
            SqlDataAdapter daEvents = new SqlDataAdapter(sqlEvents, cnn);
            daEvents.Fill(ds, "Events");
            #endregion

            #region Fill a table with a list of performance events and the members competing in them (including each team member)
            string sqlEventMembers =
                "SELECT DISTINCT EventName,EventType," +
                " ch.ChapterName,MemberID=ISNULL(t.MemberID,m.MemberID),Name=ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)," +
                " t.FirstName,t.LastName,PerformanceWeight," +
                " Score=ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0)" +
                "FROM ConferenceMemberEvents cme" +
                " INNER JOIN NationalEvents e ON cme.EventID=e.EventID" +
                "  AND e.EventID NOT IN (SELECT EventID FROM ExcludedPerformances WHERE ConferenceID=" + SchedConferenceID + ")" +
                "  AND e.EventID NOT IN (SELECT EventID FROM ExcludedEvents WHERE ConferenceID=" + SchedConferenceID + ")" +
                "  AND ISNULL(e.PerformanceWeight,0)<>0" + sqlPerfDay +
                " INNER JOIN NationalMembers m ON cme.MemberID=m.MemberID" +
                " INNER JOIN Chapters ch ON m.ChapterID=ch.ChapterID" +
                " LEFT JOIN (" +
                "  SELECT team.ConferenceID,team.EventID,team.TeamName," +
                "   mates.ChapterID,mates.MemberID,mates.FirstName,mates.LastName" +
                "  FROM ConferenceMemberEvents team" +
                "   INNER JOIN NationalMembers mates ON team.MemberID=mates.MemberID" +
                "  ) t ON cme.ConferenceID=t.ConferenceID" +
                "   AND cme.EventID=t.EventID" +
                "   AND cme.TeamName=t.TeamName" +
                "   AND m.ChapterID=t.ChapterID " +
                "WHERE cme.ConferenceID=" + SchedConferenceID +
                " AND (ISNULL(e.ObjectiveWeight,0)=0 OR (ISNULL(e.ObjectiveWeight,0)<>0 AND ISNULL(cme.ObjectiveScore,0)>0)) " +
                " AND (ISNULL(e.HomesiteWeight,0)=0 OR (ISNULL(e.HomesiteWeight,0)<>0 AND ISNULL(cme.HomesiteScore,0)>0)) " +
                "ORDER BY EventType DESC,EventName," +
                " ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0) DESC," +
                " ch.ChapterName,ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)";
/*
                "select distinct" +
                " n.NumTests,n.TimeBlock,n.EvtStations," +
                " e.EventName, e.EventType, ch.ChapterName," +
                " MemberID=ISNULL(t.MemberID,m.MemberID), Name=ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)," +
                " t.FirstName, t.LastName, PerformanceWeight, Score=ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0) " +
                "from ConferenceMemberEvents cme" +
                "  inner join NationalEvents e on cme.EventID=e.EventID" +
                "   and e.EventID not in (select EventID from ExcludedPerformances where ConferenceID=" + SchedConferenceID + ")" +
                "   and e.EventID not in (select EventID from ExcludedEvents where ConferenceID=" + SchedConferenceID + ")" +
                "   and ISNULL(e.PerformanceWeight,0) <> 0" + sqlPerfDay +
                " inner join (" +
                "  select" +
                "   EventID, NumTests=COUNT(*),TimeBlock," +
                "   EvtStations=CEILING((TimeBlock+(PerfAndJudge*(COUNT(*)-1))+" + ConfigurationManager.AppSettings["SchedMultiStationFactor"].ToString() + ")/DATEDIFF(mi,'00:00',PerfTestingEnd-PerfTestingStart))" +
                "  from (" +
                "   select distinct e.EventID," +
                "    PerfAndJudge=CEILING((ISNULL(PerfTime,0)+1)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "," +
                "    TimeBlock=CEILING(ISNULL(PrepTime,0)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "+CEILING((ISNULL(PerfTime,0)+1)/" + _TimeBlockSize + ".0)*" + _TimeBlockSize + "," +
                "    PerfTestingEnd,PerfTestingStart" +
                "   from ConferenceMemberEvents cme" +
                "    inner join Conferences c on cme.ConferenceID=c.ConferenceID" +
                "    inner join NationalEvents e on cme.EventID=e.EventID" +
                "     and e.EventID not in (select EventID from ExcludedPerformances where ConferenceID=" + SchedConferenceID + ")" +
                "     and e.EventID not in (select EventID from ExcludedEvents where ConferenceID=" + SchedConferenceID + ")" +
                "     and ISNULL(e.PerformanceWeight,0) <> 0" + sqlPerfDay +
                "    inner join NationalMembers m on cme.MemberID=m.MemberID" +
                "   where cme.ConferenceID=" + SchedConferenceID + " and ISNULL(e.PerformanceWeight,0) <> 0" +
                "  ) teams" +
                "  group by EventID,TimeBlock,PerfAndJudge,PerfTestingStart,PerfTestingEnd" +
                " ) n on e.EventID=n.EventID" +
                " inner join NationalMembers m on cme.MemberID=m.MemberID" +
                " inner join Chapters ch on m.ChapterID=ch.ChapterID" +
                " left join (" +
                "  select" +
                "   team.ConferenceID, team.EventID, team.TeamName," +
                "   mates.ChapterID, mates.MemberID, mates.FirstName, mates.LastName" +
                "  from ConferenceMemberEvents team" +
                "   inner join NationalMembers mates on team.MemberID=mates.MemberID" +
                " ) t on cme.ConferenceID=t.ConferenceID and cme.EventID=t.EventID and cme.TeamName=t.TeamName and m.ChapterID=t.ChapterID " +
                "where cme.ConferenceID=" + SchedConferenceID + " " +
                " and (isnull(e.ObjectiveWeight,0) = 0 or (isnull(e.ObjectiveWeight,0) <> 0 and isnull(cme.ObjectiveScore,0) > 0)) " +
                " and (isnull(e.HomesiteWeight,0) = 0 or (isnull(e.HomesiteWeight,0) <> 0 and isnull(cme.HomesiteScore,0) > 0)) " +
                "order by " + ConfigurationManager.AppSettings["SchedSortOrder"].ToString() + ",EventName,"+
                " ISNULL(ObjectiveScore,0)*ISNULL(ObjectiveWeight,0)+ISNULL(HomesiteScore,0)*ISNULL(HomesiteWeight,0) desc,ch.ChapterName,ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)";
*/
            SqlDataAdapter daEventMembers = new SqlDataAdapter(sqlEventMembers, cnn);
            daEventMembers.Fill(ds, "EventMembers");

            #region Create array of "sorted" event member indexes
            EventMemberIndex = 0;
            int[] SortedIndexArray = new int[ds.Tables["EventMembers"].Rows.Count];
            // int EvtMemStartIndex = 0, SortedIndex = 0, SortDirection = -1;
            // Turns out just doing them in alphabetical order is fine...
            for (int i = 0; i < ds.Tables["EventMembers"].Rows.Count; i++) SortedIndexArray[i] = i;
            /*
            // Because the event members are alphabetized by chapter, we're more likely to see scheduling conflicts
            // at the beginning of the day for chapter names at the beginning of the alphabet and vice versa.
            // Create an index array that flips the order of the chapters for every other event
            do {
                if ((EventMemberIndex + 1 >= ds.Tables["EventMembers"].Rows.Count) ||
                    (ds.Tables["EventMembers"].Rows[EventMemberIndex]["EventName"].ToString() != ds.Tables["EventMembers"].Rows[EventMemberIndex + 1]["EventName"].ToString())) {
                    // When the event changes, populate SortedIndexArray using the current sorting direction
                    if (SortDirection == 1) {
                        for (int j = EvtMemStartIndex; j <= EventMemberIndex; j++) {
                            SortedIndexArray[SortedIndex++] = j;
                        }
                    } else {
                        for (int j = EventMemberIndex; j >= EvtMemStartIndex; j--) {
                            SortedIndexArray[SortedIndex++] = j;
                        }
                    }
                    // Reset index to point to the next new event and flip the sort order
                    EvtMemStartIndex = EventMemberIndex + 1;
                    SortDirection = (SortDirection == -1) ? 1 : -1;
                }
                EventMemberIndex++;
            } while (EventMemberIndex < ds.Tables["EventMembers"].Rows.Count);
            */
            #endregion

            #endregion

            #region Fill a table with a list of students participating in one or more performance events
            string sqlMembers =
                "select *, Row=ROW_NUMBER() OVER(order by RegionName, ChapterName, FirstName, LastName)-1 from (" +
                " select distinct  RegionName, ChapterName, FirstName, LastName, cme.MemberID" +
                " from ConferenceMemberEvents cme" +
                "  inner join NationalEvents e on cme.EventID=e.EventID" +
                "   and e.EventID not in (select EventID from ExcludedPerformances where ConferenceID=" + SchedConferenceID + ")" +
                "   and e.EventID not in (select EventID from ExcludedEvents where ConferenceID=" + SchedConferenceID + ")" +
                "   and ISNULL(e.PerformanceWeight,0) <> 0" + sqlPerfDay +
                "  inner join NationalMembers m on cme.MemberID=m.MemberID" +
                "  inner join Chapters ch on m.ChapterID=ch.ChapterID" +
                "  inner join Regions r on ch.RegionID=r.RegionID" +
                " where ConferenceID=" + SchedConferenceID +
                "  and (isnull(e.ObjectiveWeight,0) = 0 or (isnull(e.ObjectiveWeight,0) <> 0 and isnull(cme.ObjectiveScore,0) > 0))" +
                "  and (isnull(e.HomesiteWeight,0) = 0 or (isnull(e.HomesiteWeight,0) <> 0 and isnull(cme.HomesiteScore,0) > 0)) " +
                ") t " +
                "order by RegionName, ChapterName, FirstName, LastName";
            SqlDataAdapter daMembers = new SqlDataAdapter(sqlMembers, cnn);
            daMembers.Fill(ds, "Members");
            #endregion

            #region Create the table to hold the performance testing schedule by member (to block time on members' schedules)
            // Add row 0 showing the time slots
            row = new HtmlTableRow();
            cell = new HtmlTableCell(); cell.InnerText = "Region"; row.Cells.Add(cell);
            cell = new HtmlTableCell(); cell.InnerText = "Chapter"; row.Cells.Add(cell);
            cell = new HtmlTableCell(); cell.InnerText = "First Name"; row.Cells.Add(cell);
            cell = new HtmlTableCell(); cell.InnerText = "Last Name"; row.Cells.Add(cell);
            for (int i = 0; i < TotalTimeSlots; i++) {
                cell = new HtmlTableCell();
                cell.InnerHtml = String.Format("{0:h:mm tt} ", PerfTestingStart.AddMinutes(i * _TimeBlockSize));
                row.Cells.Add(cell);
            }
            MemSched.Rows.Add(row);
            // Add row for each member
            foreach (DataRow MemberRow in ds.Tables["Members"].Rows) {
                row = new HtmlTableRow();
                // Populate the first columns with basic member info
                foreach (string Info in MemberInfo) {
                    cell = new HtmlTableCell();
                    cell.InnerHtml = MemberRow[Info].ToString();
                    row.Cells.Add(cell);
                }
                for (int i = 0; i < TotalTimeSlots; i++) {
                    cell = new HtmlTableCell();
                    row.Cells.Add(cell);
                }
                MemSched.Rows.Add(row);
            }
            #endregion

            #region Create the table to hold the performance testing schedule by event (to block time at event testing stations)
            for (int j = 0; j < _EvtSchedHeaderRows + TotalTimeSlots; j++) {
                row = new HtmlTableRow();
                // Add col 0 for time slots
                cell = new HtmlTableCell();
                if (j >= _EvtSchedHeaderRows) {
                    cell.InnerHtml = String.Format("{0:h:mm tt} ", PerfTestingStart.AddMinutes((j - _EvtSchedHeaderRows) * _TimeBlockSize));
                    cell.Attributes.Add("style", "color:white;font-weight:bold;background-color:#" + HeaderColors[0]);
                }
                row.Cells.Add(cell);
                // Add a column for each event, possibly multiple columns for popular events
                foreach (DataRow EventRow in ds.Tables["Events"].Rows) {
                    for (int i = 1; i <= Int32.Parse(EventRow["EvtStations"].ToString()); i++) {
                        // Some events need a prep station
                        if (Int32.Parse(EventRow["HasPrepStation"].ToString()) == 1) {
                            cell = new HtmlTableCell();
                            // Fill in the header row with event names
                            if (j == 0) {
                                cell.InnerHtml = EventRow["EventName"] + ((i > 1) ? "[#" + i.ToString() + "]" : "") + ", Prep";
                                cell.BgColor = HeaderColors[HeaderColorIndex];
                                cell.Attributes.Add("style", "color:white;font-weight:bold");
                            }
                            row.Cells.Add(cell);
                        }
                        // All events need a testing station
                        cell = new HtmlTableCell();
                        // Fill in the header row with event names
                        if (j == 0) {
                            cell.InnerHtml = EventRow["EventName"] + ((i > 1) ? "[#" + i.ToString() + "]" : "") + ", Test";
                            cell.BgColor = HeaderColors[HeaderColorIndex];
                            cell.Attributes.Add("style", "color:white;font-weight:bold");
                        }
                        // Allocate time slots for a break
                        for (int k = 0; k < _BreakLength; k++) {
                            if ((j - k + _EvtSchedHeaderRows) == _BreakInterval) {
                                cell.InnerHtml = "BREAK";
                                cell.BgColor = "A0A0A0";
                            }
                        }
                        row.Cells.Add(cell);
                        HeaderColorIndex = ((HeaderColorIndex + 1) % HeaderColors.Length);
                    }
                }
                EvtSched.Rows.Add(row);
                HeaderColorIndex = ((HeaderColorIndex + 1) % HeaderColors.Length);
            }
            #endregion

            #region Populate the event and member schedules
            EventMemberIndex = 0;
            isNewEvent = true;
            while(true) {
                EventMemberRow = ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex]];

                #region If we just switched to a new event, then we need to look up and calculate its properties
                if (isNewEvent) {
                    isNewEvent = false;
                    NumEvtParticipants = 1; // Count the participants for each event so we can cut it off at a maximum number
                    EventRows = ds.Tables["Events"].Select("EventName='" + EventMemberRow["EventName"].ToString() + "'");
                    EvtStations = Int32.Parse(EventRows[0]["EvtStations"].ToString());
                    HasPrepStation = Int32.Parse(EventRows[0]["HasPrepStation"].ToString());
                    TimeBlock = Int32.Parse(EventRows[0]["TimeBlock"].ToString()) / _TimeBlockSize;
                    PrepAndTrans = Int32.Parse(EventRows[0]["PrepAndTrans"].ToString()) / _TimeBlockSize;
                    PerfAndJudge = Int32.Parse(EventRows[0]["PerfAndJudge"].ToString()) / _TimeBlockSize;
                }
                #endregion

                #region Determine the first available time slot starting at the beginning of the day
                // Find the test start by skipping past the time needed to prep & trans for this event
                TestTimeIndex = PrepAndTrans + _EvtSchedHeaderRows;
                do {
                    #region Look at the evt sched and see if this time slot is open across however many testing stations there are for this event
                    StationsIndex = 0;
                    do {
                        TestStationIndex = (EventIndex + HasPrepStation + (StationsIndex * (1 + HasPrepStation))) - 1;
                        isNoConflict = true;
                        // make sure the entire time for performance and judging is free and doesn't conflict with the pre-allocated breaks
                        BreakSlots = 0;
                        for (int i = 0; i < PerfAndJudge; i++) {
                            if (StationsIndex == 0 && EvtSched.Rows[TestTimeIndex + i].Cells[TestStationIndex + _EvtSchedHeaderCols].InnerHtml == "BREAK") {
                                BreakSlots++;
                            }
                        }
                        TestTimeIndex += BreakSlots;
                        for (int i = 0; i < PerfAndJudge; i++) {
                            isNoConflict &= (EvtSched.Rows[TestTimeIndex + i].Cells[TestStationIndex + _EvtSchedHeaderCols].InnerHtml == "");
                        }
                        if (isNoConflict) break;
                        StationsIndex++;
                    } while (StationsIndex < EvtStations);
                    #endregion

                    // If we didn't exceed the number of available stations, then we can evaluate this time slot for conflicts
                    if (StationsIndex < EvtStations) {
                        isNoConflict = true;
                        TeamMemberIndex = 0;
                        TeamEventMemberRow = ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex + TeamMemberIndex]];
                        TeamMemberNames = TeamEventMemberRow["Name"].ToString() + " (";
                        #region Check each team member to see if any of them have a conflict in this time block
                        do {
                            TeamMemberIndex++;
                            TeamMemberNames += (TeamEventMemberRow["FirstName"].ToString() + ", ");
                            MemberID = TeamEventMemberRow["MemberID"].ToString();
                            MemberRows = ds.Tables["Members"].Select("MemberID=" + MemberID);
                            MemberIndex = Int32.Parse(MemberRows[0]["Row"].ToString());
                            // Look at all the time slots being consumed by this event, plus some buffer on either side
                            for (int i = -_MemSchedBuffer; i < TimeBlock + _MemSchedBuffer; i++) {
                                int offset = (TestTimeIndex - _EvtSchedHeaderRows) - PrepAndTrans + _MemSchedHeaderCols + i;
                                if (offset >= _MemSchedHeaderCols && offset < MemSched.Rows[0].Cells.Count) {
                                    isNoConflict &= (MemSched.Rows[MemberIndex + _MemSchedHeaderRows].Cells[offset].InnerHtml == "");
                                }
                            }
                            // Otherwise, look at the next event member to see if they're on the same team
                            if (EventMemberIndex + TeamMemberIndex >= ds.Tables["EventMembers"].Rows.Count) {
                                isSameTeam = false;
                            } else {
                                TeamEventMemberRow = ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex + TeamMemberIndex]];
                                isSameTeam =
                                    (EventMemberRow["EventName"].ToString() == TeamEventMemberRow["EventName"].ToString()) &&
                                    (EventMemberRow["ChapterName"].ToString() == TeamEventMemberRow["ChapterName"].ToString()) &&
                                    (EventMemberRow["Name"].ToString() == TeamEventMemberRow["Name"].ToString());
                            }
                            // Keep doing this for everyone on the same team
                        } while (isSameTeam);
                        TeamMemberNames += ")";
                        TeamMemberNames = TeamMemberNames.Replace(" (, )", "").Replace(", )", ")");
                        #endregion

                        if (isNoConflict) {
                            #region Assign the time slot to the event schedule
                            // Avoid duplicate sequential colors
                            try {
                                while (EvtSched.Rows[TestTimeIndex - 1].Cells[TestStationIndex + _EvtSchedHeaderCols].BgColor == CellColors[CellColorIndex] ||
                                    EvtSched.Rows[TestTimeIndex + PerfAndJudge].Cells[TestStationIndex + _EvtSchedHeaderCols].BgColor == CellColors[CellColorIndex]) {
                                    CellColorIndex = ((CellColorIndex + 1) % CellColors.Length);
                                }
                            } catch {
                                // If we try to check the color beyond the last row, it's fine; just keep going
                            }
                            // If needed, show the event schedule time slot for prep/trans
                            if (HasPrepStation != 0) {
                                using (HtmlTableCell c = EvtSched.Rows[TestTimeIndex - PrepAndTrans].Cells[TestStationIndex + _EvtSchedHeaderCols - 1]) {
                                    c.InnerHtml = EventMemberRow["EventName"].ToString() + ", " + EventMemberRow["ChapterName"].ToString() + ", " + TeamMemberNames;
                                    c.BgColor = CellColors[CellColorIndex];
                                }
                            }
                            // Assign the event schedule time slots for perf/judge
                            for (int i = 0; i < PerfAndJudge; i++) {
                                using (HtmlTableCell c = EvtSched.Rows[TestTimeIndex + i].Cells[TestStationIndex + _EvtSchedHeaderCols]) {
                                    c.InnerHtml = EventMemberRow["EventName"].ToString() + ", " + EventMemberRow["ChapterName"].ToString() + ", " + TeamMemberNames;
                                    c.BgColor = CellColors[CellColorIndex];
                                }
                            }
                            CellColorIndex = ((CellColorIndex + 1) % CellColors.Length);
                            #endregion
                            #region Assign the time slots to the members' schedules
                            TeamMemberIndex = 0;
                            TeamEventMemberRow = ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex + TeamMemberIndex]];
                            do {
                                MemberID = TeamEventMemberRow["MemberID"].ToString();
                                MemberRows = ds.Tables["Members"].Select("MemberID=" + MemberID);
                                MemberIndex = Int32.Parse(MemberRows[0]["Row"].ToString());
                                // Block out the event time slots
                                for (int i = 0; i < TimeBlock; i++) {
                                    MemSched.Rows[MemberIndex + _MemSchedHeaderRows].Cells[(TestTimeIndex - _EvtSchedHeaderRows) - PrepAndTrans + _MemSchedHeaderCols + i].InnerHtml = EventMemberRow["EventName"].ToString();
                                }
                                // Block out some buffer time on either side of the event
                                for (int i = 0; i < _MemSchedBuffer; i++) {
                                    int offset = (TestTimeIndex - _EvtSchedHeaderRows) - PrepAndTrans + _MemSchedHeaderCols - _MemSchedBuffer + i;
                                    if (offset >= _MemSchedHeaderCols) {
                                        MemSched.Rows[MemberIndex + _MemSchedHeaderRows].Cells[offset].InnerHtml = "b";
                                    }
                                    offset = (TestTimeIndex - _EvtSchedHeaderRows) - PrepAndTrans + _MemSchedHeaderCols + TimeBlock + i;
                                    if (offset < MemSched.Rows[0].Cells.Count) {
                                        MemSched.Rows[MemberIndex + _MemSchedHeaderRows].Cells[offset].InnerHtml = "b";
                                    }
                                }
                                TeamMemberIndex++;
                                if (EventMemberIndex + TeamMemberIndex >= ds.Tables["EventMembers"].Rows.Count) {
                                    isSameTeam = false;
                                } else {
                                    TeamEventMemberRow = ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex + TeamMemberIndex]];
                                    isSameTeam =
                                        (EventMemberRow["EventName"].ToString() == TeamEventMemberRow["EventName"].ToString()) &&
                                        (EventMemberRow["ChapterName"].ToString() == TeamEventMemberRow["ChapterName"].ToString()) &&
                                        (EventMemberRow["Name"].ToString() == TeamEventMemberRow["Name"].ToString());
                                }
                                // Keep doing this for everyone on the same team
                            } while (isSameTeam);
                            #endregion

                            // We are in a loop searching through time slots, which we can exit since we made a successful assignment
                            break;
                        }
                    }

                    // If we exceeded the number of stations without finding a time slot with no conflicts,
                    // then we need to jump to the next possible time slot for this event
                    //TestTimeIndex += PerfAndJudge;
                    TestTimeIndex++;

                    // Make sure there's enough time left for another test
                }
                while (TestTimeIndex + PerfAndJudge < EvtSched.Rows.Count);
                #endregion

                #region If we've gone past the end of the testing time period, indicate that we can't avoid conflicts for this team/member
                if (TestTimeIndex + PerfAndJudge >= EvtSched.Rows.Count) {
                    using (Label l = new Label()) {
                        l.Text = "</span><p>Can't avoid conflict for: " + EventMemberRow["EventName"] + ", " + EventMemberRow["ChapterName"] + ", " + TeamMemberNames + "</p><span>";
                        Conflicts.Controls.Add(l);
                        Conflicts.Visible = true;
                    }
                }
                #endregion

                #region Advance to next team/member
                EventMemberIndex += TeamMemberIndex;
                if (EventMemberIndex >= ds.Tables["EventMembers"].Rows.Count) break;

                // Check the member event that we just moved to and see if we changed to a new event
                if (isNewEvent = (ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex]]["EventName"].ToString() != EventMemberRow["EventName"].ToString())) {
                    EventIndex += EvtStations * (1 + HasPrepStation);
                }
                else {
                // For perf events with objective/homesite components, we only want to allow the top-scoring students/teams
                // to actually participate in the performance testing
                    NumEvtParticipants += 1;
                    if (NumEvtParticipants > Int32.Parse(ConfigurationManager.AppSettings["MaxParticipantsPerPerfEvent"].ToString())
                        && Int32.Parse(ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex]]["PerformanceWeight"].ToString()) < 100) {
                        do {
                            EventMemberIndex += 1;
                        } while (ds.Tables["EventMembers"].Rows[SortedIndexArray[EventMemberIndex]]["EventName"].ToString() == EventMemberRow["EventName"].ToString()
                                 && EventMemberIndex < ds.Tables["EventMembers"].Rows.Count);
                        if (EventMemberIndex >= ds.Tables["EventMembers"].Rows.Count) break;
                        isNewEvent = true;
                        EventIndex += EvtStations * (1 + HasPrepStation);
                    }
                }
                #endregion
            }
            #endregion

            #region Create the station schedule based on the completed event schedule matrix
            if (Layout == "s") {

                // Hide the instructions and conflicts info when printing out event station schedules
                Instructions.Visible = false;
                Conflicts.Visible = false;

                // Loop through the columns of the event schedule to determine 1) the events, 2) if they have a prep, and 3) number of stations
                // Create a table that can be printed and posted for at event station
                string TestStation;
                int PrepTimeSlotIndex, TestTimeSlotIndex;
                for (int i = _EvtSchedHeaderCols; i < EvtSched.Rows[0].Cells.Count; i++) {
                    StationSched = new HtmlTable();
                    StationSched.Attributes.Add("style", "page-break-after:always");

                    // Check to see if this event has a prep station
                    // If it does, advance our looping index by one so that we're on the test column
                    i += (HasPrepStation = (EvtSched.Rows[0].Cells[i].InnerHtml.EndsWith("Prep")) ? 1 : 0);

                    // Determine the number of the event's testing station
                    if (EvtSched.Rows[0].Cells[i].InnerHtml.IndexOf('#') != -1) {
                        TestStation = EvtSched.Rows[0].Cells[i].InnerHtml.Substring(EvtSched.Rows[0].Cells[i].InnerHtml.IndexOf('#') + 1, 1);
                    }
                    else {
                        TestStation = "1";
                    }

                    #region Add header rows for each page of the stations schedule 
                    // Conference name and date
                    row = new HtmlTableRow();
                    cell = new HtmlTableCell(); cell.ColSpan = 5; cell.Attributes.Add("class", "conf");
                    cell.InnerHtml = ConferenceName + "<br><br>"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "conf");
                    cell.InnerHtml = ConferenceDate.AddDays((PerfDay == 2) ? 1 : 0).ToShortDateString() + "<br><br>"; row.Cells.Add(cell);
                    StationSched.Rows.Add(row);
                    // Room number (to be filled in manually)
                    row = new HtmlTableRow();
                    cell = new HtmlTableCell(); cell.ColSpan = 6; cell.Attributes.Add("class", "head");
                    cell.InnerHtml = "Room # _____________________<br><br>"; row.Cells.Add(cell);
                    StationSched.Rows.Add(row);
                    // Event name and station number
                    row = new HtmlTableRow();
                    cell = new HtmlTableCell(); cell.ColSpan = 5; cell.Attributes.Add("class", "head");
                    string EventName = EvtSched.Rows[0].Cells[i].InnerHtml.Split(',')[0];
                    EventName = (EventName.Contains("#")) ? EventName.Substring(0, EventName.IndexOf('[')) : EventName;
                    cell.InnerHtml = EventName + "<br><br>"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "head");
                    cell.InnerHtml = "Station #" + TestStation + "<br><br>"; row.Cells.Add(cell);
                    StationSched.Rows.Add(row);
                    // Column headers
                    row = new HtmlTableRow();
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "<br>Completed"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "Prep<br>Start Time"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "Performance<br>Start Time"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "<br>School"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "<br>Team"; row.Cells.Add(cell);
                    cell = new HtmlTableCell(); cell.Attributes.Add("class", "cols");
                    cell.InnerHtml = "<br>Student name(s)"; row.Cells.Add(cell);
                    StationSched.Rows.Add(row);
                    #endregion

                    #region Determine the start times for each student/team
                    //
                    PrepTimeSlotIndex = TestTimeSlotIndex = _EvtSchedHeaderRows;
                    while (true) {

                        #region Determine prep and test time slots
                        // If there is a prep column, then loop to find a non-empty cell -- that's the prep time
                        //   then loop thru test column to find a matching cell -- that's the test time
                        // If there is no prep column, just loop thru test column
                        if (HasPrepStation == 1) {
                            // Loop thru prep time slots until we find an assigned slot
                            while (EvtSched.Rows[PrepTimeSlotIndex].Cells[i - 1].InnerText == "" ||
                                   EvtSched.Rows[PrepTimeSlotIndex].Cells[i - 1].InnerText == EvtSched.Rows[PrepTimeSlotIndex - 1].Cells[i - 1].InnerText ||
                                   EvtSched.Rows[PrepTimeSlotIndex].Cells[i - 1].InnerHtml == "BREAK") {
                                PrepTimeSlotIndex++;
                                if (PrepTimeSlotIndex >= EvtSched.Rows.Count) break;
                            }
                            // Loop thru test time slots until we find a matching team/student assignment 
                            if (PrepTimeSlotIndex < EvtSched.Rows.Count) {
                                while (EvtSched.Rows[TestTimeSlotIndex].Cells[i].InnerText != EvtSched.Rows[PrepTimeSlotIndex].Cells[i - 1].InnerText) {
                                    TestTimeSlotIndex++;
                                    if (TestTimeSlotIndex >= EvtSched.Rows.Count) break;
                                }
                            }
                        }
                        else {
                            // For events with no prep, just loop thru the test time slots until we find an assigned slot
                            while (EvtSched.Rows[TestTimeSlotIndex].Cells[i].InnerText == "" ||
                                   EvtSched.Rows[TestTimeSlotIndex].Cells[i].InnerText == EvtSched.Rows[TestTimeSlotIndex - 1].Cells[i].InnerText ||
                                   EvtSched.Rows[TestTimeSlotIndex].Cells[i].InnerHtml == "BREAK") {
                                TestTimeSlotIndex++;
                                if (TestTimeSlotIndex >= EvtSched.Rows.Count) break;
                            }
                        }
                        if (PrepTimeSlotIndex >= EvtSched.Rows.Count || TestTimeSlotIndex >= EvtSched.Rows.Count) break;
                        #endregion

                        #region Build a row of the station schedule table
                        // Each row will show the starting times for a student/team's prep (if needed) and performance at this station
                        string Assignment = EvtSched.Rows[TestTimeSlotIndex].Cells[i].InnerHtml;
                        string[] AssignmentInfo = Assignment.Split(',');
                        row = new HtmlTableRow();
                        cell = new HtmlTableCell(); cell.InnerHtml = "[&nbsp;&nbsp;]"; row.Cells.Add(cell);                                     // A place to manually mark complete
                        cell = new HtmlTableCell();
                        cell.InnerHtml = (HasPrepStation == 1) ? EvtSched.Rows[PrepTimeSlotIndex].Cells[0].InnerText : " ";                     // Start time (needs to be prep)
                        row.Cells.Add(cell);
                        cell = new HtmlTableCell(); cell.InnerHtml = EvtSched.Rows[TestTimeSlotIndex].Cells[0].InnerText; row.Cells.Add(cell);  // Start time (needs to be perf)
                        cell = new HtmlTableCell(); cell.InnerHtml = AssignmentInfo[1].TrimStart(); row.Cells.Add(cell);                        // School
                        if (AssignmentInfo[2].Contains("Team")) {
                            cell = new HtmlTableCell(); cell.InnerHtml = AssignmentInfo[2].Substring(1, AssignmentInfo[2].IndexOf('(') - 2);    // Team name
                            row.Cells.Add(cell);
                            int x = Assignment.IndexOf('(') + 1;
                            cell = new HtmlTableCell(); cell.InnerHtml = Assignment.Substring(x, Assignment.Length - x - 1);                    // Student names
                            row.Cells.Add(cell);
                        }
                        else {
                            cell = new HtmlTableCell(); cell.InnerHtml = " "; row.Cells.Add(cell);                                              // No team name
                            cell = new HtmlTableCell(); cell.InnerHtml = AssignmentInfo[2]; row.Cells.Add(cell);                                // Student name
                        }
                        StationSched.Rows.Add(row);
                        #endregion

                        PrepTimeSlotIndex++;
                        TestTimeSlotIndex++;
                        if (PrepTimeSlotIndex >= EvtSched.Rows.Count || TestTimeSlotIndex >= EvtSched.Rows.Count) break;

                    }
                    Schedule.Controls.Add(StationSched);
                    #endregion
                }
            }
            #endregion

            #region Clean up schedule formatting
            for (int i = 0; i < MemSched.Rows.Count; i++) {
                for (int j = 0; j < MemSched.Rows[0].Cells.Count; j++) {
                    using (HtmlTableCell c = MemSched.Rows[i].Cells[j]) {
                        if (c.InnerHtml == "b") {
                            c.InnerHtml = "";
                            c.BgColor = "D9D9D9";
                        }
                    }
                }
            }
            #endregion
        }
    }
}