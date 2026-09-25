select max(emtiaz) as maxEmtiaz,dore
	from league_team
	where leagueId=1
	group by emtiaz,dore
	
/*select teamId from
	(select *
	from league_team
	where leagueId=5
	group by dore
	)as y where emtiaz=MAX(emtiaz)*/


