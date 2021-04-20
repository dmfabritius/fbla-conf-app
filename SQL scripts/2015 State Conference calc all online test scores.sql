UPDATE ConferenceMemberEvents SET
 OnlineTestScore=S.Score, ObjectiveScore=S.Score 
 FROM (
 SELECT
 Mem=R.MemberID,Conf=R.ConferenceID,Evt=Q.EventID,
 Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R
 INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID
 WHERE R.ConferenceID=2087
 GROUP BY R.MemberID,R.ConferenceID,Q.EventID
 ) S 
 WHERE ConferenceID=S.Conf AND ConferenceMemberEvents.EventID=S.Evt AND ConferenceMemberEvents.MemberID IN (
 SELECT S.Mem UNION
 SELECT TM.MemberID FROM ConferenceMemberEvents CME
 INNER JOIN NationalMembers M ON CME.MemberID=M.MemberID
 INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName
 INNER JOIN NationalMembers TM ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID
 WHERE CME.ConferenceID=S.Conf
 AND CME.EventID=S.Evt
 AND CME.MemberID=S.Mem)