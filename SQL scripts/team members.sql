select m.ChapterID, TeamName, Student=FirstName+' '+LastName
from ConferenceMemberEvents cme
 inner join NationalMembers m on cme.MemberID=m.MemberID
 inner join Chapters c on m.ChapterID=c.ChapterID
where ConferenceID=2058 and EventID=12
order by ChapterID, TeamName