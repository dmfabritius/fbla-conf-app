select *, 
 NumResps=[1]+[2]+[3]+[4]+[5],
 CommonChoice=case when [1]>[2] and [1]>[3] and [1]>[4] then 'A' when [2]>[3] and [2]>[4] then 'B' when [3]>[4] then 'C' else 'D' end,
 Commonality=CONVERT(nvarchar,round(case when [1]>[2] and [1]>[3] and [1]>[4] then [1] when [2]>[3] and [2]>[4] then [2] when [3]>[4] then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]),3)*100),
 PctRight=CONVERT(nvarchar,round(case CorrectAnswer when 'A'  then [1] when 'B' then [2] when 'C' then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]),3)*100)
-- NumRight=case CorrectAnswer when 'A'  then [1] when 'B' then [2] when 'C' then [3] else [4] end,
-- MultiResps=case when (case when [1]<>0 then 1 else 0 end+case when [2]<>0 then 1 else 0 end+case when [3]<>0 then 1 else 0 end+case when [4]<>0 then 1 else 0 end+case when [5]<>0 then 1 else 0 end)=1 then 0 else 1 end,
-- NumChoices=case when [1]<>0 then 1 else 0 end+case when [2]<>0 then 1 else 0 end+case when [3]<>0 then 1 else 0 end+case when [4]<>0 then 1 else 0 end+case when [5]<>0 then 1 else 0 end,
from (
	select * from (
		select r.ConferenceID, e.EventName, q.QuestionNumber, r.QuestionID,
		CorrectAnswer=case q.CorrectAnswer when 1 then 'A' when 2 then 'B' when 3 then 'C' else 'D' end,
		q.Question, q.AnswerChoice1, q.AnswerChoice2, q.AnswerChoice3, q.AnswerChoice4,
		r.MemberID, r.Response
		from TestResponses r inner join TestQuestions q on r.QuestionID=q.QuestionID inner join NationalEvents e on q.EventID=e.EventID
		where r.Response <> 5 --, r.Response <> q.CorrectAnswer
	) t
	pivot (count(t.MemberID) for t.Response in ([1],[2],[3],[4],[5])) p
) tbl
where
 [1]+[2]+[3]+[4]+[5] > 7
 and (
 case CorrectAnswer when 'A'  then [1] when 'B' then [2] when 'C' then [3] else [4] end = 0 OR
 (case CorrectAnswer when 'A'  then [1] when 'B' then [2] when 'C' then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]) < 0.07 -- PctRight
  and  case when [1]>[2] and [1]>[3] and [1]>[4] then [1] when [2]>[3] and [2]>[4] then [2] when [3]>[4] then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]) > 0.79)) -- Commonality
order by
 [1]+[2]+[3]+[4]+[5] desc, -- NumResps
 case when [1]>[2] and [1]>[3] and [1]>[4] then [1] when [2]>[3] and [2]>[4] then [2] when [3]>[4] then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]) desc, -- Commonality
 case CorrectAnswer when 'A'  then [1] when 'B' then [2] when 'C' then [3] else [4] end/convert(real,[1]+[2]+[3]+[4]+[5]) -- PctRight
 --case when [1]<>0 then 1 else 0 end+case when [2]<>0 then 1 else 0 end+case when [3]<>0 then 1 else 0 end+case when [4]<>0 then 1 else 0 end+case when [5]<>0 then 1 else 0 end -- NumChoices
