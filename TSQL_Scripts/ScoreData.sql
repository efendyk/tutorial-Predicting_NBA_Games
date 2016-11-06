IF EXISTS(SELECT * from sys.objects WHERE [name]='ScoreData' AND type = 'v') DROP VIEW ScoreData;
go
CREATE VIEW ScoreData
AS

SELECT        
	 gd.game_id 
	,home_team = tih.team 
	,away_team = tia.team
	,day_type = 
		CASE 
			WHEN DATEPART(WEEKDAY, game_date) IN (1, 7) 
			THEN 'week_day' ELSE 'week_end' 
		END 
     ,home_team_record_level = 
		CASE 
			WHEN hr.tertiles = 1 THEN 'bad_at_home' 
			WHEN hr.tertiles = 2 THEN 'ok_at_home' 
			WHEN hr.tertiles = 3 THEN 'good_at_home' END
	,away_team_record_level = 
		CASE 
			WHEN ar.tertiles = 1 THEN 'bad_away' 
			WHEN ar.tertiles = 2 THEN 'ok_away' 
			WHEN ar.tertiles = 3 THEN 'good_away' 
		END
	,home_team_overall_record_level = 
		CASE 
			WHEN orh.tertiles = 1 THEN 'inferior' 
			WHEN orh.tertiles = 2 THEN 'neutral' 
			WHEN orh.tertiles = 3 THEN 'superior' 
		END
	,away_team_overall_record_level = 
		CASE 
			WHEN ora.tertiles = 1 THEN 'inferior' 
			WHEN ora.tertiles = 2 THEN 'neutral' 
			WHEN ora.tertiles = 3 THEN 'superior' 
		END
FROM dbo.GameData AS gd 
	INNER JOIN dbo.HomeRecords AS hr ON gd.home_team_id = hr.home_team_id 
	INNER JOIN dbo.AwayRecords AS ar ON gd.away_team_id = ar.away_team_id 
	INNER JOIN dbo.OverallRecord AS orh ON gd.home_team_id = orh.team_id 
	INNER JOIN dbo.OverallRecord AS ora ON gd.home_team_id = ora.team_id 
	INNER JOIN dbo.TeamInfo AS tih ON gd.home_team_id = tih.ID 
	INNER JOIN dbo.TeamInfo AS tia ON gd.home_team_id = tia.ID
WHERE gd.game_date > '20090305'