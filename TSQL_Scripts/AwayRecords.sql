IF EXISTS(SELECT * from sys.objects WHERE [name]='AwayRecords' AND type = 'v') DROP VIEW AwayRecords;
go
CREATE VIEW AwayRecords
AS

WITH TEAM_RESULTS_A AS (
	SELECT 
		 away_team_id = gd.away_team_id
		,win = gd.home_team_win  
	FROM GameData gd
	WHERE gd.game_date <= '2009-01-21'
),

TEAM_RESULTS_B AS (
	SELECT 
		 away_team_id
		,wins = COUNT(*) - SUM(win)
		,games_played = COUNT(*)
		,win_ratio = (COUNT(*) - SUM(win))*1.0/COUNT(*)
	FROM TEAM_RESULTS_A
	GROUP BY away_team_id
)

SELECT 
	 away_team_id
	,wins
	,games_played
	,win_ratio
	,tertiles = NTILE(3) OVER(ORDER BY win_ratio)
FROM TEAM_RESULTS_B
