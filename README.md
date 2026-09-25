# Football league database (SQL Server)

[![check](https://github.com/shoghli1999/Football-League-SQL-Server/actions/workflows/check.yml/badge.svg)](https://github.com/shoghli1999/Football-League-SQL-Server/actions/workflows/check.yml)

My project for the Database Design course of my bachelor's at Islamic Azad University, South Tehran Branch (January 2021). The task was to design a database for all Iranian club football competitions, build it in Microsoft SQL Server, fill it with test data and answer the course questions with queries. I drew the ER model in Visio and built 21 tables with their keys and constraints in SQL Server.

## The database

Table and column names are Persian words in Latin letters.

| Area | Tables |
|---|---|
| Leagues and standings | `league`, `team`, `league_team` (one row per team, league and season with games, wins, goals and points) |
| Clubs and people | `bashgah` (clubs), `modiramel` (CEOs), `bazikon` (players), `kadrefani` (coaching staff), `bazikon_team`, `kadrefani_team`, `qarardad_bazikon` and `qarardad_kadrefani` (contracts) |
| Matches | `game`, `lebas` (kits), `tarkibavaliye` (line-ups), `rooydad` and `game_bazikon` (events such as cards, corners and substitutions), `golZadan` (goals), `penaltiGereftan` (penalties), `sabteKhata` (fouls) |
| Referees | `davar`, `gozareshKardan` (referee reports) |

A few words that come up a lot: dore = season, emtiaz = points or rating, bazikon = player, davar = referee, tamashagar = spectators.

Besides 21 primary keys and 32 foreign keys, I added these rules: players' and staff ages must be between 9 and 99, a team's player count (`teamCount`) is at most 25 and defaults to 25, team and club names are unique, and added time defaults to 0.

## Files

| File | What it is |
|---|---|
| `erd.pdf`, `erd.vsdx` | ER diagram (Visio, labels in Persian) |
| `databaseProject.mdf`, `databaseProject_log.ldf`, `databaseProject.zip` | The SQL Server database files from 2021 |
| `database export.xlsx`, `database export.pdf` | Every table's rows, exported in January 2021 |
| `shirin shoghli 9625512123.pdf` | My handwritten answers in relational algebra (questions 1 to 7, 9 and 11 to 14) |
| `sql/scratch_2021/` | SQL I wrote in SSMS while building the database: creating tables, adding constraints and a first try at question 1 |
| `sql/01_schema.sql` | Creates the 21 tables with all keys and constraints |
| `sql/02_data.sql` | Inserts the 251 rows from the export |
| `sql/03_queries.sql` | My relational-algebra answers written as SQL, 12 queries |
| `tools/check_sqlite.py` | Builds the database in SQLite and runs the queries |

## What is from 2021 and what I added in 2026

In 2021 I built the database in SQL Server Management Studio and answered the questions in relational algebra. Only a few of my SQL scripts from then were saved; they are in `sql/scratch_2021/` unchanged.

In 2026 I added the `sql/` scripts so the project can be read and run without attaching the .mdf file:

- `01_schema.sql` is read from the table definitions stored in `databaseProject.mdf`: the same column types, keys and constraints, and my constraint names where I had given one. Three columns (`game.lebasTeamMizban`, `game.lebasTeamMehman`, `davar.naghsh`) are in the export but not in the .mdf, so the export comes from a slightly later version of the database; they are included here. `teamName` is NVARCHAR instead of VARCHAR so the Persian team names load on any server.
- `02_data.sql` is the export, row for row. The only edit is a stray line break removed from the end of one team name.
- `03_queries.sql` turns my relational-algebra answers into SQL with CTEs and window functions (`RANK() OVER`), mostly following the same joins.

## Running it

In SQL Server, create an empty database and run the three files in order, in SSMS or with sqlcmd:

```
sqlcmd -S localhost -C -Q "CREATE DATABASE footballLeague"
sqlcmd -S localhost -C -d footballLeague -f 65001 -i sql/01_schema.sql -i sql/02_data.sql -i sql/03_queries.sql
```

You can also attach `databaseProject.mdf` in SSMS (Databases > Attach). That is the 2021 file, without the three later columns.

Without SQL Server:

```
python tools/check_sqlite.py
```

This loads the same scripts into SQLite with foreign keys switched on, checks the row count and every foreign key, and prints the result of each query. GitHub Actions runs it on every push. The queries only use SQL that SQL Server and SQLite share.

Example, question 7 (players sent off with a second yellow or a red card):

```
tarikh      gameId  bazikonFName  bazikonLName  rooydadName
1389-08-09  173     damoon        damooni       kartQermez
1389-09-08  183     dara          darayi        kartZard2
1391-01-01  103     sam           salamat       kartQermez
1391-01-10  113     mehrab        mehrabi       kartZard2
1396-06-06  53      ali           karimi        kartQermez
1396-06-16  153     sasan         sasani        kartZard2
1397-07-07  63      ali           dayi          kartZard2
```

## Limits of the data and the design

- The rows are test data. Team names are real, but the people, matches and numbers are made up, so some figures don't add up (one team has 3 wins from 2 games).
- Five tables are empty: fouls, penalties, line-ups and the two contract tables. Questions 3 to 5 need fouls, so they return no rows, and question 14 finds no substitutions for the teams that have a league row.
- `game` has no league or season column, so the queries place a match in a league through the home team's row in `league_team`. Adding `leagueId` and `dore` to `game` is the first thing I would change now.
- `davar` has one row per referee and match. A referee table plus a separate assignment table would avoid repeating names.
- Dates are Solar Hijri dates stored in DATE columns (for example 1394-03-03). They sort correctly, but date arithmetic on them gives wrong results.

## Tech

SQL Server (T-SQL) · SSMS · Microsoft Visio · SQLite · Python · GitHub Actions
