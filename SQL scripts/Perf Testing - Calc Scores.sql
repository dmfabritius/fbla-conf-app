use FBLAConferenceDb 
declare @ConferenceID int = 2058

update ConferenceMemberEvents set
  OnlineTestScore=S.AverageScore, PerformanceScore=S.AverageScore
from (
  select
    ConferenceID=@ConferenceID, ScoresByJudge.EventID, MemberID, 
    AverageScore=case when NumJudges=MaxJudges then AVG(Score) else -2 end
  from (
    select C.EventID, R.JudgeID, R.MemberID, JudgeCount.NumJudges, Score=SUM(R.Response)*100
    from JudgeResponses R
      inner join JudgeCredentials C on R.JudgeID=C.JudgeID
      inner join (select EventID, MemberID, NumJudges=COUNT(JudgeID) from (select C.EventID, C.JudgeID, MemberID from JudgeCredentials C inner join JudgeResponses R on C.JudgeID=R.JudgeID where ConferenceID=@ConferenceID group by C.EventID, C.JudgeID, R.MemberID having SUM(R.Response) <> -1) JudgesByMember group by EventID, MemberID) JudgeCount
        on C.EventID=JudgeCount.EventID AND R.MemberID=JudgeCount.MemberID
    group by C.EventID, R.JudgeID, R.MemberID, JudgeCount.NumJudges
    having SUM(R.Response) >= 0
  ) ScoresByJudge
    inner join (
      select EventID, MaxJudges=MAX(NumJudges)
      from (select EventID, MemberID, NumJudges=COUNT(JudgeID) from (select C.EventID, C.JudgeID, MemberID from JudgeCredentials C inner join JudgeResponses R on C.JudgeID=R.JudgeID where ConferenceID=@ConferenceID group by C.EventID, C.JudgeID, R.MemberID having SUM(R.Response) <> -1) JudgesByMember group by EventID, MemberID) JudgeCount
      group by EventID
    ) RequiredJudges on ScoresByJudge.EventID=RequiredJudges.EventID
  group by ScoresByJudge.EventID, MemberID, NumJudges, MaxJudges
  ) S
where ConferenceMemberEvents.ConferenceID=@ConferenceID
  and ConferenceMemberEvents.EventID=S.EventID
  and ConferenceMemberEvents.MemberID in (
    SELECT TM.MemberID FROM ConferenceMemberEvents CME
      INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID
      INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName
      INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID
    WHERE CME.ConferenceID=S.ConferenceID
      AND CME.EventID=S.EventID
	  AND CME.MemberID=S.MemberID)
