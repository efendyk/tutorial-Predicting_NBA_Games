# In this step we create a XDF file to store our data frame to disk. The XDF file will be used by the rxGLM function to 
# build the models. We create 8 different models and rank them using the AIC statistics.

# Creates a folder to store the XDF if it does not already exist
xdfdir <- './xdfs_folder'
if(!file.exists(xdfdir)) {dir.create(xdfdir)}

# Creates the filepath string of the xdf file that will be used in rxImport function. The rxImport function will be
# used to create the Xdf file.
ModelTrainDataXdf <- file.path(xdfdir, "ModelTrainData.xdf")
rxImport(inData = model.train.data, outFile = ModelTrainDataXdf, overwrite = TRUE)

# Model 1
team.formula.one <- as.formula("home_team_win ~ home_team_record_level")
model.1 <- rxGlm(team.formula.one, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

team.formula.one.v2 <- as.formula("home_team_win ~ home_team_record_level -1")
model.one.v2 <- rxGlm(team.formula.one.v2, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 2
team.formula.two <- as.formula("home_team_win ~ away_team_record_level")
model.2 <- rxGlm(team.formula.two, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 3
team.formula.three <- as.formula("home_team_win ~ home_team_overall_record_level")
model.3 <- rxGlm(team.formula.three, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 4
team.formula.four <- as.formula("home_team_win ~ away_team_overall_record_level")
model.4 <- rxGlm(team.formula.four, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 5
team.formula.five <- as.formula("home_team_win ~ home_team_record_level + away_team_record_level")
model.5 <- rxGlm(team.formula.five, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 6
team.formula.six <- as.formula("home_team_win ~ home_team_overall_record_level + away_team_overall_record_level")
model.6 <- rxGlm(team.formula.six, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 7
team.formula.seven <- as.formula("home_team_win ~ home_team_record_level + away_team_record_level + home_team_overall_record_level + away_team_overall_record_level")
model.7 <- rxGlm(team.formula.seven, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Model 8
team.formula.eight <- as.formula("home_team_win ~ day_type + home_team_record_level + away_team_record_level + home_team_overall_record_level + away_team_overall_record_level")
model.8 <- rxGlm(team.formula.eight, data = ModelTrainDataXdf, family = binomial, reportProgress = 0, computeAIC = TRUE)

# Print out the results of the AIC 
cat("model.1 aic = ", model.1$aic[1], '\n')
cat("model.2 aic = ", model.2$aic[1], '\n')
cat("model.3 aic = ", model.3$aic[1], '\n')
cat("model.4 aic = ", model.4$aic[1], '\n')
cat("model.5 aic = ", model.5$aic[1], '\n')
cat("model.6 aic = ", model.6$aic[1], '\n')
cat("model.7 aic = ", model.7$aic[1], '\n')
cat("model.8 aic = ", model.8$aic[1], '\n')
