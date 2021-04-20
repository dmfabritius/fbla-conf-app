select
 e.EventName, e.EventID, e.EventType,
 r.MemberID,
 count(*) NumQuestions,
 sum(case when r.Response=q.CorrectAnswer then 1.0 else 0.0 end) NumCorrect,
 sum(case when r.Response=q.CorrectAnswer then 1.0 else 0.0 end)/convert(real,count(*)) PctCorrect
from TestResponses r
 inner join TestQuestions q on r.QuestionID=q.QuestionID
 inner join NationalEvents e on q.EventID=e.EventID
group by e.EventName, e.EventID, e.EventType, r.MemberID
order by e.EventName
 --sum(case when r.Response=q.CorrectAnswer then 1.0 else 0.0 end)/convert(real,count(*))
 ;

 select
  e.EventName,
  count(cme.OnlineTestScore) TestsTaken
 from ConferenceMemberEvents cme
  inner join NationalEvents e on cme.EventID=e.EventID
group by cme.ConferenceID, e.EventName--, cme.OnlineTestScore
having cme.ConferenceID=2058 --and ISNULL(OnlineTestScore,0) > 1