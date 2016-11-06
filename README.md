# Predicting NBA Games using SQL Server R Services

In this repo I included the R code, T-SQL code, and database used in my presentation on SQL Server R Services. The steps are as follows:

1. Developed the model to predict the final quarter of the 2008 - 2009 NBA season using data from the first 3/4 of the season. The model was developed in RTVS. Here are the scripts:
  - STEP_1.R
  - STEP_2.R
  - STEP_3.R
  - STEP_4.R
  - STEP_5.R
  - STEP_6.R
  - STEP_7.R

2. Created the NBAModels table and the AddModel stored procedure in the NBAPredictions database. The NBAModels table warehouses the actual model as well as additional columns that have attributes about the model. The AddModel stored procedure is used to get the serialized version of the model from R, convert the model to a binary format, then insert the model along with with the attributes about the model that were passed to SQL Server from R to the NBAModels table.

3. Executed the STEP_8.R script to add the 8 models that we developed in R to the NBAModels table that we created in SQL Server

4. Created a AwayRecords.sql, HomeRecords.sql, OverallRecords.sql, and ScoreData.sql views to create the features for the games that we are predicting

5. Executed the PredictGameBatchMode stored procedure to predicted the last quarter of the season.
