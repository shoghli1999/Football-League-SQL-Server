-- Football league database: tables, keys and constraints (SQL Server / T-SQL)
--
-- Creates the 21 tables of databaseProject.mdf with the same column types,
-- primary keys, foreign keys, and unique, check and default constraints.
-- Constraints I named myself keep their names; the others were named by
-- SQL Server and are left unnamed here.
--
-- Notes:
--   * game.lebasTeamMizban, game.lebasTeamMehman and davar.naghsh are in
--     "database export.xlsx" but not in databaseProject.mdf, which is an
--     earlier save of the database.
--   * team.teamName is NVARCHAR(50) so the Persian team names load on any
--     server, whatever its default collation.
--
-- Run 01_schema.sql, then 02_data.sql, then 03_queries.sql.

CREATE TABLE league (
    leagueId    INT          NOT NULL PRIMARY KEY,
    leagueName  VARCHAR(50)  NOT NULL
);

CREATE TABLE team (
    teamId     INT           NOT NULL PRIMARY KEY,
    teamName   NVARCHAR(50)  NOT NULL CONSTRAINT uniqueName UNIQUE,
    teamCount  INT           CONSTRAINT tCount DEFAULT 25
                             CONSTRAINT check_count CHECK (teamCount < 26)
);

-- One row per team, league and season (dore): the standings.
CREATE TABLE league_team (
    leagueTeamId  INT         NOT NULL PRIMARY KEY,
    leagueId      INT         REFERENCES league (leagueId),
    teamId        INT         REFERENCES team (teamId),
    dore          VARCHAR(5),
    tedadeBaziha  INT,        -- games played
    bord          INT,        -- wins
    mosavi        INT,        -- draws
    bakht         INT,        -- losses
    golZade       INT,        -- goals for
    golKhorde     INT,        -- goals against
    tafazolGol    INT,        -- goal difference
    emtiaz        INT         -- points
);

-- Clubs
CREATE TABLE bashgah (
    bashgahId    INT          NOT NULL,
    bashgahName  VARCHAR(50)  NOT NULL,
    telefon      VARCHAR(50),
    email        VARCHAR(50),
    website      VARCHAR(50),
    saleTasis    DATE,        -- founding date (Solar Hijri year)
    CONSTRAINT PK_bashgah PRIMARY KEY (bashgahId),
    CONSTRAINT checkName UNIQUE (bashgahName)
);

-- Club CEOs
CREATE TABLE modiramel (
    codeMelli       BIGINT       NOT NULL,
    modiramelFName  VARCHAR(50)  NOT NULL,
    modiramelLName  VARCHAR(50)  NOT NULL,
    age             INT,
    telefon         VARCHAR(50),
    CONSTRAINT PK_person PRIMARY KEY (codeMelli)
);

-- Players
CREATE TABLE bazikon (
    codeMelli     BIGINT       NOT NULL,
    bazikonFName  VARCHAR(50)  NOT NULL,
    bazikonLName  VARCHAR(50)  NOT NULL,
    age           INT,
    telefon       VARCHAR(50),
    CONSTRAINT PK_bazikon PRIMARY KEY (codeMelli),
    CONSTRAINT agee CHECK (age > 8 AND age < 100)
);

-- Coaching staff
CREATE TABLE kadrefani (
    codeMelli       BIGINT       NOT NULL,
    kadrefaniFName  VARCHAR(50)  NOT NULL,
    kadrefaniLName  VARCHAR(50)  NOT NULL,
    age             INT,
    naghsh          VARCHAR(50)  NOT NULL,   -- role
    CONSTRAINT PK_kadrefani PRIMARY KEY (codeMelli),
    CONSTRAINT ageee CHECK (age > 8 AND age < 100)
);

-- Matches
CREATE TABLE game (
    gameId           INT         NOT NULL PRIMARY KEY,
    teamMizban       INT         REFERENCES team (teamId),   -- home team
    teamMehman       INT         REFERENCES team (teamId),   -- away team
    natije           VARCHAR(5)  NOT NULL,                   -- result
    vaqteNime1       INT         DEFAULT 0,                  -- added time, 1st half
    vaqteNime2       INT         DEFAULT 0,                  -- added time, 2nd half
    makan            VARCHAR(50),                            -- venue
    tarikh           DATE,                                   -- date (Solar Hijri)
    saat             TIME(7),                                -- kick-off
    tamashagar       INT,                                    -- spectators
    lebasTeamMizban  INT,                                    -- lebasId, home kit
    lebasTeamMehman  INT                                     -- lebasId, away kit
);

-- Match event types: corner, offside, injury, substitution, cards
CREATE TABLE rooydad (
    rooydadId    INT          NOT NULL PRIMARY KEY,
    rooydadName  VARCHAR(50)  NOT NULL
);

-- Events per player and match, with the player's rating (emtiaz)
CREATE TABLE game_bazikon (
    gameBazikonId  INT      NOT NULL PRIMARY KEY,
    bazikonId      BIGINT   REFERENCES bazikon (codeMelli),
    gameId         INT      REFERENCES game (gameId),
    rooydadId      INT      REFERENCES rooydad (rooydadId),
    saat           TIME(7),
    emtiaz         INT
);

-- Starting line-ups
CREATE TABLE tarkibavaliye (
    tarkibAvaliyeId  INT          NOT NULL PRIMARY KEY,
    gameId           INT          REFERENCES game (gameId),
    bazikonId        BIGINT       REFERENCES bazikon (codeMelli),
    mogheiyat        VARCHAR(50)  -- position
);

-- Which player plays for which team
CREATE TABLE bazikon_team (
    bazikonTeamId  INT     NOT NULL PRIMARY KEY,
    bazikonId      BIGINT  REFERENCES bazikon (codeMelli),
    teamId         INT     REFERENCES team (teamId)
);

-- Kits: colours of the first, second and third set
CREATE TABLE lebas (
    lebasId  INT          NOT NULL PRIMARY KEY,
    set1     VARCHAR(50),
    set2     VARCHAR(50),
    set3     VARCHAR(50)
);

-- Which staff member works for which team
CREATE TABLE kadrefani_team (
    kadrefaniTeamId  INT     NOT NULL PRIMARY KEY,
    teamId           INT     REFERENCES team (teamId),
    kadrefaniId      BIGINT  REFERENCES kadrefani (codeMelli)
);

-- Staff contracts
CREATE TABLE qarardad_kadrefani (
    qarardadKadrefani  INT   NOT NULL PRIMARY KEY,
    kadrefaniTeamId    INT   REFERENCES kadrefani_team (kadrefaniTeamId),
    bashgahId          INT   REFERENCES bashgah (bashgahId),
    tarikh             DATE,
    modatQarardad      INT,  -- length
    mablaq             INT   -- amount
);

-- Player contracts
CREATE TABLE qarardad_bazikon (
    qarardadBazikon  INT     NOT NULL PRIMARY KEY,
    bazikonId        BIGINT  REFERENCES bazikon (codeMelli),
    bashgahId        INT     REFERENCES bashgah (bashgahId),
    tarikh           DATE,
    modatQarardad    INT,
    mablaq           INT
);

-- Goals
CREATE TABLE golZadan (
    golId          INT          NOT NULL PRIMARY KEY,
    bazikonId      BIGINT       REFERENCES bazikon (codeMelli),
    gameId         INT          REFERENCES game (gameId),
    bazikonTeamId  INT          REFERENCES bazikon_team (bazikonTeamId),
    saat           TIME(7),
    modeleGol      VARCHAR(50)  -- how it was scored: pa, sar, penalti, ...
);

-- Penalties: taker, goalkeeper and their teams
CREATE TABLE penaltiGereftan (
    penaltiId         INT      NOT NULL PRIMARY KEY,
    bazikonId         BIGINT   REFERENCES bazikon (codeMelli),
    darvazebanId      BIGINT   REFERENCES bazikon (codeMelli),
    gameId            INT      REFERENCES game (gameId),
    bazikonTeamId     INT      REFERENCES bazikon_team (bazikonTeamId),
    darvazebanTeamId  INT      REFERENCES bazikon_team (bazikonTeamId),
    saat              TIME(7)
);

-- Referees, one row per referee and match
CREATE TABLE davar (
    davarId     INT          NOT NULL PRIMARY KEY,
    davarFName  VARCHAR(50),
    davarLName  VARCHAR(50),
    gameId      INT          REFERENCES game (gameId),
    emtiaz      INT,         -- rating
    naghsh      VARCHAR(50)  -- role: davar vasat, davar komaki, davar chaharom
);

-- Referee reports
CREATE TABLE gozareshKardan (
    gozareshId  INT           NOT NULL PRIMARY KEY,
    gameId      INT           REFERENCES game (gameId),
    davarId     INT           REFERENCES davar (davarId),
    tozihat     VARCHAR(200)
);

-- Fouls: who committed it and on whom
CREATE TABLE sabteKhata (
    khataId        INT     NOT NULL PRIMARY KEY,
    gameId         INT     REFERENCES game (gameId),
    davarId        INT     REFERENCES davar (davarId),
    khataKonanade  BIGINT  REFERENCES bazikon (codeMelli),
    khataShavande  BIGINT  REFERENCES bazikon (codeMelli),
    zaman          INT
);
