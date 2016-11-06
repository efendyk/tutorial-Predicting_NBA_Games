IF EXISTS(SELECT * from sys.objects WHERE [name]='HomeRecords' AND type = 'v') DROP VIEW HomeRecords;
go
CREATE VIEW HomeRecords
AS

WITH TEAM_RESULTS_A AS (
	SELECT 
		 gd.home_team_id
		,win = gd.home_team_win  
	FROM GameData gd
	WHERE gd.game_date <= '2009-01-21'
),

TEAM_RESULTS_B AS (
	SELECT 
		 home_team_id
		,wins = SUM(win)
		,games_played = COUNT(*)
		,win_ratio = SUM(win)*1.0/COUNT(*)
	FROM TEAM_RESULTS_A
	GROUP BY home_team_id
)

SELECT 
	 home_team_id
	,wins
	,games_played
	,win_ratio
	,tertiles = NTILE(3) OVER(ORDER BY win_ratio)
FROM TEAM_RESULTS_B