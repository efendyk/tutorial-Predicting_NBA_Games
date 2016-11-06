# Partition the data into a data set that will be used to create the training data set and a data set
# that will be used to create the testing data set

# Testing data
training.data <-
raw.data %>%
mutate(team = ifelse(team == home_team, "home", "visitor"), total_points = ifelse(is.na(points),0,points) + ifelse(is.na(reason) | is.na(result), 0, ifelse((reason == "foul" | reason == "technical") & result == "made", 1, 0))) %>%
group_by(home_team, away_team, game_date, team) %>%
summarise(points = sum(total_points)) %>% #addlogic to include points like free throws.
spread(team, points) %>%
mutate(home_team_win = ifelse(home > visitor, 1, 0), away_team_win = ifelse(home > visitor, 0, 1)) %>%
filter(game_date <= '2009-01-21')

# Testing data
testing.data <-
raw.data %>%
mutate(team = ifelse(team == home_team, "home", "visitor"), total_points = ifelse(is.na(points),0,points) + ifelse(is.na(reason) | is.na(result), 0, ifelse((reason == "foul" | reason == "technical") & result == "made", 1, 0))) %>%
group_by(home_team, away_team, game_date, team) %>%
summarise(points = sum(total_points)) %>% #addlogic to include points like free throws.
spread(team, points) %>%
mutate(home_team_win = ifelse(home > visitor, 1, 0), away_team_win = ifelse(home > visitor, 0, 1)) %>%
filter(game_date > '2009-01-21')
