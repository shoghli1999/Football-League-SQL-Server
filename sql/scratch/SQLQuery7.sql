/*alter table team
ADD CONSTRAINT tCount
DEFAULT 25 for teamCount;*/

create table league_team(
leagueTeamId int primary key,
leagueId int FOREIGN KEY REFERENCES league(leagueId),
teamId int FOREIGN KEY REFERENCES team(teamId),
dore varchar(5),
tedadeBaziha int,
bord int,
mosavi int,
bakht int,
golZade int,
golKhorde int,
tafazolGol int,
emtiaz int,
)