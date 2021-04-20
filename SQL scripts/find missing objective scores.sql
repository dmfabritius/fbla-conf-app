select avg(convert(real,score)) from (
 SELECT R.ConferenceID Conf, R.MemberID Mem, Q.EventID Evt, Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID
 GROUP BY R.ConferenceID, R.MemberID, Q.EventID
) a;

select avg(convert(real,OnlineTestScore)) from ConferenceMemberEvents
where ConferenceID in (select distinct ConferenceID from TestResponses);

select count(score) from (
 SELECT R.ConferenceID Conf, R.MemberID Mem, Q.EventID Evt, Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID
 GROUP BY R.ConferenceID, R.MemberID, Q.EventID
) c;


select * from (
 SELECT
  cme.OnlineTestScore,
  R.ConferenceID Conf, R.MemberID Mem, Q.EventID Evt, Score=SUM(CASE WHEN R.Response=Q.CorrectAnswer THEN 1 ELSE 0 END)
 FROM TestResponses R INNER JOIN TestQuestions Q ON R.QuestionID=Q.QuestionID
  left join ConferenceMemberEvents cme on R.ConferenceID=CME.ConferenceID and R.MemberID=CME.MemberID AND Q.EventID=CME.EventID
 GROUP BY
  cme.OnlineTestScore,
  R.ConferenceID, R.MemberID, Q.EventID
) m
where m.OnlineTestScore is null;

--delete FROM TestResponses where ConferenceID=2058 and MemberID=6619 AND QuestionID IN (select questionID from TestQuestions where EventID=49)
