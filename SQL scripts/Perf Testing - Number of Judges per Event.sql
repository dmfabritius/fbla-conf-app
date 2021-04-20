select EventID, MaxJudges=MAX(NumJudges) from
 (select EventID, MemberID, NumJudges=COUNT(JudgeID) from
  (select JC.EventID, JC.JudgeID, JR.MemberID
  from JudgeCredentials JC
   inner join JudgeResponses JR on JC.JudgeID=JR.JudgeID
  where ConferenceID=2058
  group by JC.EventID, JC.JudgeID, JR.MemberID
  having SUM(JR.Response) <> -1
  ) JudgesByMember
 group by EventID, MemberID
 ) JudgeCount
group by EventID