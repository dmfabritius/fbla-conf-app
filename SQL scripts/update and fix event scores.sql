-- Update Individual Events
UPDATE ConferenceMemberEvents SET
 OnlineTestScore=S.Score, ObjectiveScore=S.Score 
FROM (
 SELECT distinct R.ConferenceID Conf, R.MemberID Mem, Q.EventID Evt, Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID INNER JOIN NationalEvents E ON Q.EventID=E.EventID
 GROUP BY R.ConferenceID, R.MemberID, Q.EventID, E.EventType
 HAVING E.EventType='I'
 ) S
WHERE ConferenceID=S.Conf AND MemberID=S.Mem AND EventID=S.Evt;

-- Update Team Events
UPDATE ConferenceMemberEvents SET
 OnlineTestScore=S.Score, ObjectiveScore=S.Score 
FROM (
 SELECT distinct R.ConferenceID Conf, R.MemberID Mem, Q.EventID Evt, Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID INNER JOIN NationalEvents E ON Q.EventID=E.EventID
 GROUP BY R.ConferenceID, R.MemberID, Q.EventID, E.EventType
 HAVING E.EventType='T'
 ) S
WHERE ConferenceID=S.Conf AND EventID=S.Evt AND MemberID IN (
	SELECT TM.MemberID FROM ConferenceMemberEvents CME
	 INNER JOIN NationalMembers        M    ON CME.MemberID=M.MemberID
	 INNER JOIN ConferenceMemberEvents TEAM ON CME.ConferenceID=TEAM.ConferenceID AND CME.EventID=TEAM.EventID AND CME.TeamName=TEAM.TeamName
	 INNER JOIN NationalMembers        TM   ON TEAM.MemberID=TM.MemberID AND M.ChapterID=TM.ChapterID
	WHERE
	 CME.ConferenceID=S.Conf AND
	 CME.EventID=S.Evt AND
	 CME.MemberID=s.Mem
 )
