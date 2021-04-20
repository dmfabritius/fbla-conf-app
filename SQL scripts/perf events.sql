select
 TimeBlock, EventName, NumTests=COUNT(*),
 EvtStations=CEILING((TimeBlock+PerfAndJudge*(COUNT(*)-1)+FLOOR((TimeBlock+PerfAndJudge*(COUNT(*)-1))/85)*10)/TotalTestingMin)
from (
	select distinct
	 e.EventName, e.EventType, ch.ChapterName, 
	 Name=ISNULL(cme.TeamName,m.FirstName+' '+m.LastName),
     TimeBlock=FLOOR((ISNULL(PrepTime,0)+PerfTime+case ISNULL(PrepTime,0) when 0 then 8 else 9 end)/5.0)*5,
	 PerfAndJudge=CASE WHEN PerfTime > 10 THEN 15 ELSE 10 END,
	 TotalTestingMin=DATEDIFF(mi,'00:00',PerfTestingEnd-PerfTestingStart)
	from ConferenceMemberEvents cme
	 inner join NationalEvents e on cme.EventID=e.EventID
	 inner join NationalMembers m on cme.MemberID=m.MemberID
	 inner join Chapters ch on m.ChapterID=ch.ChapterID
	 inner join Conferences c on cme.ConferenceID=c.ConferenceID
	where cme.ConferenceID=2058 and ISNULL(e.PerformanceWeight,0) <> 0
	--order by e.EventName, ch.ChapterName, ISNULL(cme.TeamName,m.FirstName+' '+m.LastName)
) s
group by TotalTestingMin, TimeBlock,PerfAndJudge, EventName, EventType
order by TimeBlock desc, EventType ,EventName;

/*
select distinct m.ChapterID, m.FirstName, m.LastName
from ConferenceMemberEvents cme inner join NationalMembers m on cme.MemberID=m.MemberID
where cme.ConferenceID=2058
order by m.ChapterID, m.FirstName, m.LastName;
*/

