# This step incrementally serialize each of the 8 models created in step 7 then add them to the NBAModels table in SQL Server. It does so by dynamically 
# creating the sql statement below which executes the AddModel stored procedure in the NBAPredictions database:
#
#	EXEC AddModel 
#		 @ModelName = '<model name>'
#		,@AIC = '<AIC Stat>'
#		,@Model_Serialized = '<string representation of the model>'
#
# The only parameter that is absolutely required to operationalize the model is the @Model_Serialized parameter which is the parameter that contains the 
# serialized version of the model. That parameter is passed to the AddModel stored procedure in SQL Server and is converted back into a binary format then 
# inserted into the NBAModels table. The field type of the column in the NBAModels table that stores the model is varbinary(max). Two columns were added to the 
# table. The AIC field was added to hold the AIC statistic and a field was also added to hold the model's name. 
#
# The model is operationalized via the "PredictGameBatchMode" stored procedure. This stored procedure passes the model that you want to use to score the last quarter 
# of the season from the NBAModels table to a R script. The R script uses the rxPredict function to score the data. The output of rxPredict function is normally a 
# vector but rxPredict gives you the option to return additional columns. The game_id is returned so that we can join the scored data with the other data in the database.

# Connects to the database
server.name = "<put the name of the machine that warehouses the database here>"
db.name = "NBAPredictions"
connection.string = paste("driver={SQL Server}",";","server=",server.name,";","database=", db.name, ";", "trusted_connection=true",sep="")
conn <- odbcDriverConnect(connection.string)

# Dynamically builds the stored procedure needed to add the models to the database for each model. The first model name
# is "model.1" and subsequent model names are incremented by 1. You have to tell the "for" loop how big your range is.

for (i in 1:8){

	# Searialize the model
	expression <- paste("serialize(model.", i, ", NULL)",sep="")
	modelbin <- eval(parse(text=expression)) # the eval(parse()) combo enables you to execute dynamically generated code
	modelbinstr = paste(modelbin, collapse = "")

	# Gets the model name and AIC score
	model.name <- paste("model.", i, sep = "")
	expression <- paste("model.", i, "$aic[1]", sep = "")
	AIC.Score <- eval(parse(text=expression))

	# Builds the SQL Statement and execute it using the sqlQuery command
	q<-paste("EXEC AddModel ", "@ModelName='", model.name, "', ", "@AIC='", AIC.Score, "', ", "@Model_Serialized='", modelbinstr,"'", sep="") 
	sqlQuery(conn, q) 

	print(i)
}

odbcClose(conn)
