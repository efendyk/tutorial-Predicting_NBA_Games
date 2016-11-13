# Predicting NBA Games using SQL Server R Services

In this repo I included the R code, T-SQL code, and the database used in my presentation on SQL Server R Services. The steps that I used in the presentation are as follows:

   1. I developed the models to predict the final quarter of the 2008 - 2009 NBA season using data from the first 3/4 of the season. The model was developed in RTVS. Listed are the R scripts used to develop the model broken out into logical units of work: 

    - STEP_1.R:  Sets working directory
    
    - STEP_2.R:  The checkpoint library is used to make sure that we are using the most recent version of the packages as of the date that we pass to the "checkpoint" function. It scans all of the scripts in the working directory to perform the test and if the test fails "Checkpoint" will download the package that meets that criteria from MRAN.
    
    - STEP_3.R
    - STEP_4.R
    - STEP_5.R
    - STEP_6.R
    - STEP_7.R

   2. I created the NBAModels table and the AddModel stored procedure in the NBAPredictions database. The NBAModels table warehouses the actual model as well as additional columns for the model attributes. The AddModel stored procedure is used to get the serialized version of the model from R, convert the model to a binary format, then insert the model along with some of its attributes into the NBAModels table.

   3. I executed the STEP_8.R script to add the 8 models and some of its attributes to the NBAModels table by calling the AddModel stored procedure that was created in step 2.

   4. I created the AwayRecords.sql, HomeRecords.sql, OverallRecords.sql, and ScoreData.sql views. These views were used to create the features for the games in the last quarter of the season.

   5. I executed the PredictGameBatchMode stored procedure to predicted the last quarter of the season.
   
   6. I visualized the results in Power BI via the NBA_Report.pbix file.

The raw data was obtained from the www.basketballgeek.com/data/ website. I used the CombineGamePlayByPlayData.R script to combine all of the 1,176 individual game data files into one data frame. The resulting data frame was saved to a csv file and used as the source data for the PlayLevelData table data in the NBAPredictions database.
