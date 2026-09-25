-- Queries for the course questions (SQL Server / T-SQL)
--
-- In 2021 I answered these questions in relational algebra
-- ("shirin shoghli 9625512123.pdf"). In 2026 I wrote them as SQL, one
-- query per answer, keeping the same joins where they made sense.
-- Question numbers follow the assignment. The queries use only CTEs,
-- joins and window functions, so tools/check_sqlite.py can run this same
-- file on SQLite.
--
-- How the tables connect: a match (game) has no league column, so a
-- match, goal or event is placed in a league and season (dore) through
-- the team's row in league_team.


-- Q1. Champion of each season of the Premier League and the Women's League
WITH ranked AS (
    SELECT lt.leagueId, lt.dore, lt.teamId, lt.emtiaz,
           RANK() OVER (PARTITION BY lt.leagueId, lt.dore
                        ORDER BY lt.emtiaz DESC, lt.tafazolGol DESC) AS rnk
    FROM league_team AS lt
    WHERE lt.leagueId IN (1, 5)          -- 1 = bartar, 5 = banovan
)
SELECT l.leagueName, r.dore, t.teamName, r.emtiaz AS points
FROM ranked AS r
JOIN league AS l ON l.leagueId = r.leagueId
JOIN team   AS t ON t.teamId   = r.teamId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore;


-- Q2. Top scorer of each season of each league, with the number of goals
WITH player_goals AS (
    SELECT lt.leagueId, lt.dore, g.bazikonId, COUNT(*) AS goals
    FROM golZadan AS g
    JOIN bazikon_team AS bt ON bt.bazikonId = g.bazikonId
    JOIN league_team  AS lt ON lt.teamId    = bt.teamId
    GROUP BY lt.leagueId, lt.dore, g.bazikonId
), ranked AS (
    SELECT pg.leagueId, pg.dore, pg.bazikonId, pg.goals,
           RANK() OVER (PARTITION BY pg.leagueId, pg.dore ORDER BY pg.goals DESC) AS rnk
    FROM player_goals AS pg
)
SELECT l.leagueName, r.dore, b.bazikonFName, b.bazikonLName, r.goals
FROM ranked AS r
JOIN league  AS l ON l.leagueId  = r.leagueId
JOIN bazikon AS b ON b.codeMelli = r.bazikonId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore;


-- Q3. Roughest team in each league and season (most fouls committed)
-- The fouls table (sabteKhata) has no rows in my data, so Q3 to Q5
-- return empty results until fouls are entered.
WITH team_fouls AS (
    SELECT lt.leagueId, lt.dore, bt.teamId, COUNT(*) AS fouls
    FROM sabteKhata AS k
    JOIN bazikon_team AS bt ON bt.bazikonId = k.khataKonanade
    JOIN league_team  AS lt ON lt.teamId    = bt.teamId
    GROUP BY lt.leagueId, lt.dore, bt.teamId
), ranked AS (
    SELECT tf.leagueId, tf.dore, tf.teamId, tf.fouls,
           RANK() OVER (PARTITION BY tf.leagueId, tf.dore ORDER BY tf.fouls DESC) AS rnk
    FROM team_fouls AS tf
)
SELECT l.leagueName, r.dore, t.teamName, r.fouls
FROM ranked AS r
JOIN league AS l ON l.leagueId = r.leagueId
JOIN team   AS t ON t.teamId   = r.teamId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore;


-- Q4. Roughest player in each league and season (most fouls committed)
WITH player_fouls AS (
    SELECT lt.leagueId, lt.dore, k.khataKonanade AS bazikonId, COUNT(*) AS fouls
    FROM sabteKhata AS k
    JOIN bazikon_team AS bt ON bt.bazikonId = k.khataKonanade
    JOIN league_team  AS lt ON lt.teamId    = bt.teamId
    GROUP BY lt.leagueId, lt.dore, k.khataKonanade
), ranked AS (
    SELECT pf.leagueId, pf.dore, pf.bazikonId, pf.fouls,
           RANK() OVER (PARTITION BY pf.leagueId, pf.dore ORDER BY pf.fouls DESC) AS rnk
    FROM player_fouls AS pf
)
SELECT l.leagueName, r.dore, b.bazikonFName, b.bazikonLName, r.fouls
FROM ranked AS r
JOIN league  AS l ON l.leagueId  = r.leagueId
JOIN bazikon AS b ON b.codeMelli = r.bazikonId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore;


-- Q5. In each league, the players fouled most and least often, with counts
WITH fouled AS (
    SELECT lt.leagueId, k.khataShavande AS bazikonId, COUNT(*) AS fouls_suffered
    FROM sabteKhata AS k
    JOIN bazikon_team AS bt ON bt.bazikonId = k.khataShavande
    JOIN league_team  AS lt ON lt.teamId    = bt.teamId
    GROUP BY lt.leagueId, k.khataShavande
), ranked AS (
    SELECT f.leagueId, f.bazikonId, f.fouls_suffered,
           RANK() OVER (PARTITION BY f.leagueId ORDER BY f.fouls_suffered DESC) AS rank_most,
           RANK() OVER (PARTITION BY f.leagueId ORDER BY f.fouls_suffered ASC)  AS rank_least
    FROM fouled AS f
)
SELECT l.leagueName,
       CASE WHEN r.rank_most = 1 THEN 'most' ELSE 'least' END AS fouled,
       b.bazikonFName, b.bazikonLName, r.fouls_suffered
FROM ranked AS r
JOIN league  AS l ON l.leagueId  = r.leagueId
JOIN bazikon AS b ON b.codeMelli = r.bazikonId
WHERE r.rank_most = 1 OR r.rank_least = 1
ORDER BY l.leagueName, fouled DESC;


-- Q6. Match with the most and the fewest spectators in each season of each league
-- (the league and season come from the home team)
WITH ranked AS (
    SELECT lt.leagueId, lt.dore, gm.gameId, gm.teamMizban, gm.teamMehman,
           gm.tarikh, gm.tamashagar,
           RANK() OVER (PARTITION BY lt.leagueId, lt.dore ORDER BY gm.tamashagar DESC) AS rank_most,
           RANK() OVER (PARTITION BY lt.leagueId, lt.dore ORDER BY gm.tamashagar ASC)  AS rank_fewest
    FROM game AS gm
    JOIN league_team AS lt ON lt.teamId = gm.teamMizban
)
SELECT l.leagueName, r.dore,
       CASE WHEN r.rank_most = 1 THEN 'most' ELSE 'fewest' END AS spectators,
       home.teamName AS home_team, away.teamName AS away_team,
       r.tarikh, r.tamashagar
FROM ranked AS r
JOIN league AS l    ON l.leagueId    = r.leagueId
JOIN team   AS home ON home.teamId   = r.teamMizban
JOIN team   AS away ON away.teamId   = r.teamMehman
WHERE r.rank_most = 1 OR r.rank_fewest = 1
ORDER BY l.leagueName, r.dore, spectators DESC;


-- Q7. Suspended players: second yellow card (6) or straight red card (7)
SELECT gm.tarikh, gm.gameId, b.bazikonFName, b.bazikonLName, r.rooydadName
FROM game_bazikon AS gb
JOIN rooydad AS r  ON r.rooydadId  = gb.rooydadId
JOIN bazikon AS b  ON b.codeMelli  = gb.bazikonId
JOIN game    AS gm ON gm.gameId    = gb.gameId
WHERE gb.rooydadId IN (6, 7)
ORDER BY gm.tarikh, b.bazikonLName;


-- Q9. League table for each league and season
SELECT l.leagueName, lt.dore,
       RANK() OVER (PARTITION BY lt.leagueId, lt.dore
                    ORDER BY lt.emtiaz DESC, lt.tafazolGol DESC, lt.golZade DESC) AS place,
       t.teamName,
       lt.tedadeBaziha AS played, lt.bord AS won, lt.mosavi AS drawn, lt.bakht AS lost,
       lt.golZade AS goals_for, lt.golKhorde AS goals_against,
       lt.tafazolGol AS goal_diff, lt.emtiaz AS points
FROM league_team AS lt
JOIN league AS l ON l.leagueId = lt.leagueId
JOIN team   AS t ON t.teamId   = lt.teamId
ORDER BY l.leagueName, lt.dore, place;


-- Q11. Goals scored and conceded by each team per season, by type of goal
-- (pa = foot, sar = header, penalti = penalty, dast = hand)
WITH goal_team AS (
    SELECT g.golId, g.modeleGol, bt.teamId AS scoring_team,
           CASE WHEN gm.teamMizban = bt.teamId THEN gm.teamMehman
                WHEN gm.teamMehman = bt.teamId THEN gm.teamMizban
           END AS conceding_team
    FROM golZadan AS g
    JOIN bazikon_team AS bt ON bt.bazikonTeamId = g.bazikonTeamId
    JOIN game         AS gm ON gm.gameId        = g.gameId
), per_team AS (
    SELECT scoring_team AS teamId, modeleGol, 1 AS scored, 0 AS conceded
    FROM goal_team
    UNION ALL
    SELECT conceding_team, modeleGol, 0, 1
    FROM goal_team
    WHERE conceding_team IS NOT NULL
)
SELECT l.leagueName, lt.dore, t.teamName, p.modeleGol,
       SUM(p.scored) AS scored, SUM(p.conceded) AS conceded
FROM per_team AS p
JOIN league_team AS lt ON lt.teamId  = p.teamId
JOIN league      AS l  ON l.leagueId = lt.leagueId
JOIN team        AS t  ON t.teamId   = p.teamId
GROUP BY l.leagueName, lt.dore, t.teamName, p.modeleGol
ORDER BY l.leagueName, lt.dore, t.teamName, p.modeleGol;


-- Q12. Number of matches each team played in each kit, per season
WITH team_kits AS (
    SELECT teamMizban AS teamId, lebasTeamMizban AS lebasId FROM game
    UNION ALL
    SELECT teamMehman, lebasTeamMehman FROM game
)
SELECT l.leagueName, lt.dore, t.teamName, k.lebasId, COUNT(*) AS matches
FROM team_kits AS k
JOIN league_team AS lt ON lt.teamId  = k.teamId
JOIN league      AS l  ON l.leagueId = lt.leagueId
JOIN team        AS t  ON t.teamId   = k.teamId
GROUP BY l.leagueName, lt.dore, t.teamName, k.lebasId
ORDER BY l.leagueName, lt.dore, t.teamName, k.lebasId;


-- Q13. Busiest main referee in each season of each league
-- davar has one row per referee and match, so matches are counted per name.
WITH ref_matches AS (
    SELECT lt.leagueId, lt.dore, d.davarFName, d.davarLName, COUNT(*) AS matches
    FROM davar AS d
    JOIN game        AS gm ON gm.gameId = d.gameId
    JOIN league_team AS lt ON lt.teamId = gm.teamMizban
    WHERE d.naghsh = 'davar vasat'
    GROUP BY lt.leagueId, lt.dore, d.davarFName, d.davarLName
), ranked AS (
    SELECT rm.leagueId, rm.dore, rm.davarFName, rm.davarLName, rm.matches,
           RANK() OVER (PARTITION BY rm.leagueId, rm.dore ORDER BY rm.matches DESC) AS rnk
    FROM ref_matches AS rm
)
SELECT l.leagueName, r.dore, r.davarFName, r.davarLName, r.matches
FROM ranked AS r
JOIN league AS l ON l.leagueId = r.leagueId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore, r.davarLName;


-- Q14. Team with the most substitutions in each season of each league
WITH subs AS (
    SELECT lt.leagueId, lt.dore, bt.teamId, COUNT(*) AS substitutions
    FROM game_bazikon AS gb
    JOIN bazikon_team AS bt ON bt.bazikonId = gb.bazikonId
    JOIN league_team  AS lt ON lt.teamId    = bt.teamId
    WHERE gb.rooydadId = 4               -- taaviz
    GROUP BY lt.leagueId, lt.dore, bt.teamId
), ranked AS (
    SELECT s.leagueId, s.dore, s.teamId, s.substitutions,
           RANK() OVER (PARTITION BY s.leagueId, s.dore ORDER BY s.substitutions DESC) AS rnk
    FROM subs AS s
)
SELECT l.leagueName, r.dore, t.teamName, r.substitutions
FROM ranked AS r
JOIN league AS l ON l.leagueId = r.leagueId
JOIN team   AS t ON t.teamId   = r.teamId
WHERE r.rnk = 1
ORDER BY l.leagueName, r.dore;
