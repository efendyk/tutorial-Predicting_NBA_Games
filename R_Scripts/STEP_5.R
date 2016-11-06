# This is the feature engineering step. First I will get the data in a "tidy" format then I will add the following
# features (day_type, home.team.record.level, away.team.record.level, home.team.overall.record.level, and 
# away.team.overall.record.level).

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
base.train.data <-
training.data %>%
mutate(day_type = as.factor(ifelse(wday(ymd(game_date)) %in% c(6,7),"Weekend","Weekday"))) %>%
select(home_team, away_team, game_date, day_type, home_team_win, away_team_win)

base.test.data <-
testing.data %>%
mutate(day_type = as.factor(ifelse(wday(ymd(game_date)) %in% c(6,7),"Weekend","Weekday"))) %>%
select(home_team, away_team, game_date, day_type, home_team_win, away_team_win)

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
# Home team performance
home.team.performance <-
base.train.data %>%
group_by(home_team) %>%
summarize(total_wins = sum(home_team_win), times_played = n(), win_ratio = total_wins / times_played) #compare the summarize function to the summarize function in DAX

home.team.performance <-
home.team.performance %>%
mutate(tertiles = ntile(win_ratio, 3), home_team_record_level = Recode(tertiles, "1='bad_at_home';2='ok_at_home';3='good_at_home'"))

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
# Away team performance
away.team.performance <-
base.train.data %>%
group_by(away_team) %>%
summarize(total_away_team_wins = sum(away_team_win), times_played = n(), win_ratio = total_away_team_wins / times_played) #compare the summarize function to the summarize function in DAX

away.team.performance <-
away.team.performance %>%
mutate(tertiles = ntile(win_ratio, 3), away_team_record_level = Recode(tertiles, "1='bad_away';2='ok_away';3='good_away'"))

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
# Overall record

# Make data frame of all of the home teams with a field that showes whether they one or lost
home.team.records <- base.train.data[, c('home_team', 'home_team_win')]
home.team.records <- home.team.records %>% rename(team = home_team, win = home_team_win)
away.team.records <- base.train.data[, c('away_team', 'away_team_win')]
away.team.records <- away.team.records %>% rename(team = away_team, win = away_team_win) 

# Combine home.team.records and away.team.records then group the data by team and add additional
# descriptive fields
team.records <-
rbind(home.team.records, away.team.records) %>%
group_by(team) %>%
summarise(wins = sum(win), total_games = n(), losses = total_games - wins, win_ratio = wins / total_games) %>%
select(team, wins, losses, total_games, win_ratio)

# Adds percentiles using a lambda function that leverages the ecdf function
team.records <-
team.records %>%
mutate(tertiles = ntile(win_ratio, 3), overall_record_level = Recode(tertiles, "1='inferior';2='neutral';3='superior'"))

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
# Model training data
model.train.data <-
base.train.data %>%
inner_join(home.team.performance, by = c("home_team" = "home_team")) %>% #tell about behavior if you don't specify
inner_join(away.team.performance, by = c("away_team" = "away_team")) %>% #tell about behavior if you don't specify
inner_join(team.records, by = c("home_team" = "team")) %>% # explain about this being something like a key value pair or named vector
rename(home_team_overall_record_level = overall_record_level) %>%
select(home_team, away_team, day_type, home_team_record_level, away_team_record_level, home_team_overall_record_level, home_team_win)

model.train.data <-
model.train.data %>%
inner_join(team.records, by = c("away_team" = "team")) %>% # explain about this being something like a key value pair or named vector
rename(away_team_overall_record_level = overall_record_level) %>%
select(home_team, away_team, day_type, home_team_record_level, away_team_record_level, home_team_overall_record_level, away_team_overall_record_level, home_team_win) %>%
mutate(home_team_record_level = as.factor(home_team_record_level), away_team_record_level = as.factor(away_team_record_level), 
	   home_team_overall_record_level = as.factor(home_team_overall_record_level), away_team_overall_record_level = as.factor(away_team_overall_record_level)
)

#*******************************************************************************************************************************************
#*******************************************************************************************************************************************
# Model testing data
model.test.data <-
base.test.data %>%
inner_join(home.team.performance, by = c("home_team" = "home_team")) %>% #tell about behavior if you don't specify
inner_join(away.team.performance, by = c("away_team" = "away_team")) %>% #tell about behavior if you don't specify
inner_join(team.records, by = c("home_team" = "team")) %>% # explain about this being something like a key value pair or named vector
rename(home_team_overall_record_level = overall_record_level) %>%
select(home_team, away_team, day_type, home_team_record_level, away_team_record_level, home_team_overall_record_level, home_team_win)

model.test.data <-
model.test.data %>%
inner_join(team.records, by = c("away_team" = "team")) %>% # explain about this being something like a key value pair or named vector
rename(away_team_overall_record_level = overall_record_level) %>%
select(home_team, away_team, day_type, home_team_record_level, away_team_record_level, home_team_overall_record_level, away_team_overall_record_level, home_team_win) %>%
mutate(home_team_record_level = as.factor(home_team_record_level), away_team_record_level = as.factor(away_team_record_level), 
	   home_team_overall_record_level = as.factor(home_team_overall_record_level), away_team_overall_record_level = as.factor(away_team_overall_record_level)
)

