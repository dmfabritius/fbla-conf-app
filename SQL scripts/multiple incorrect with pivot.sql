select *, 
 WrongResps=case when [1]<>0 then 1 else 0 end+case when [2]<>0 then 1 else 0 end+case when [3]<>0 then 1 else 0 end+case when [4]<>0 then 1 else 0 end+case when [5]<>0 then 1 else 0 end,
 MultiWrong=case when (case when [1]<>0 then 1 else 0 end+case when [2]<>0 then 1 else 0 end+case when [3]<>0 then 1 else 0 end+case when [4]<>0 then 1 else 0 end+case when [5]<>0 then 1 else 0 end)=1 then 0 else 1 end 
from (
	select * from (
		select r.ConferenceID, r.QuestionID, q.CorrectAnswer, q.EventID, e.EventType, m.MemberID,
		 --c.RegionID, 
		 --c.ChapterID,
		 --m.Gender, 
		 --m.GraduatingClass,
		 r.Response
		from TestResponses r
		 inner join TestQuestions q on r.QuestionID=q.QuestionID
		 inner join NationalEvents e on q.EventID=e.EventID
		 inner join NationalMembers m on r.MemberID=m.MemberID
		 inner join Chapters c on m.ChapterID=c.ChapterID
		where r.Response <> q.CorrectAnswer
	) t
	pivot (count(t.MemberID) for t.Response in ([1],[2],[3],[4],[5])) p
) tbl
order by
 case when [1]<>0 then 1 else 0 end+
 case when [2]<>0 then 1 else 0 end+
 case when [3]<>0 then 1 else 0 end+
 case when [4]<>0 then 1 else 0 end+
 case when [5]<>0 then 1 else 0 end desc