delete from ConferenceMemberEvents from ConferenceMemberEvents cme 
 inner join Conferences c on cme.ConferenceID=c.ConferenceID
where
 ISNULL(cme.ObjectiveScore,0)=0 and 
 ISNULL(cme.HomesiteScore,0)=0 and 
 ISNULL(cme.PerformanceScore,0)=0 and 
 eventid <> 72 and
 c.ConferenceDate < GETDATE();

DELETE FROM NationalMembers
WHERE MemberID IN (
 SELECT DISTINCT M.MemberID
 FROM NationalMembers M LEFT JOIN ConferenceMemberEvents CME ON M.MemberID=CME.MemberID
 WHERE ISNULL(M.NationalMemberID,0)=0 AND CME.ConferenceID IS NULL
);