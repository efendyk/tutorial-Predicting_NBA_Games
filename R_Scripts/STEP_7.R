# The AIC statistic suggests that the best model is "model.5". We look at the ROC curve to see how good the model predicts outcoumes.

# Do the predict part here
columns <- c("day_type", "home_team_record_level", "away_team_record_level", "home_team_overall_record_level", "away_team_overall_record_level")
home.team.win.probabilities <- rxPredict(modelObject = model.5, data = model.test.data[,columns])
pred <- prediction(home.team.win.probabilities, model.test.data$home_team_win)

# Develop and ROC curve here (add some annotation to the curve)
roc.perf <- performance(pred, measure = "tpr", x.measure = "fpr")
plot(roc.perf)
abline(a=0, b= 1)

# Calculate the AUC (Area Under the Curve)
auc.perf <- performance(pred, measure = "auc")
auc.perf@y.values
