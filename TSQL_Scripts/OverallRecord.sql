IF EXISTS(SELECT * from sys.objects WHERE [name]='OverallRecord' AND type = 'v') DROP VIEW OverallRecord;
go
CREATE VIEW OverallRecord
AS

WITH TEAM_RESULTS_A AS (
	SELECT 
		 team_id = gd.home_team_id
		,win = gd.home_team_win  
	FROM GameData gd
	WHERE gd.game_date <= '2009-01-21'
	UNION ALL
	SELECT 
		 team_id = gd.away_team_id
		,win = IIF(gd.home_team_win=0,1,0)  
	FROM GameData gd
	WHERE gd.game_date <= '2009-01-21'
),

TEAM_RESULTS_B AS (
	SELECT 
		 team_id
		,wins = SUM(win)
		,games_played = COUNT(*)
		,win_ratio = SUM(win)*1.0/COUNT(*)
	FROM TEAM_RESULTS_A
	GROUP BY team_id
)

SELECT 
	 team_id
	,wins
	,games_played
	,win_ratio
	,tertiles = NTILE(3) OVER(ORDER BY win_ratio)
FROM TEAM_RESULTS_B