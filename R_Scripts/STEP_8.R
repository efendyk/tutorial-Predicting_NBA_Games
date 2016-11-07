# This step incrementally serialize each model then add thme to the NBAModels table in SQL Server. It does so by dynamically creating the sql statement below 
# that executes the AddModel stored procedure in the NBAPredictions database:
#
#	EXEC AddModel 
#		 @ModelName = '<model name>'
#		,@AIC = '<AIC Stat>'
#		,@Model_Serialized = '<string representation of the model>'
#
# The only parameter that is absolutely required is the @Model_Serialized parameter which is the parameter that contains the serialized
# version of the model. That parameter is passed to the AddModel stored procedure in SQL Server and is converted back into a binary format then 
# inserted into the NBAModels table. The field type of the column in the NBAModels table that stores the model is varbinary(max). Other columns 
# were created to store important attributes about the model. A column was created for the AIC statistic and for the model name. 
#
# The model is operationalized via another stored procedure that passes the model to a R script. The model can be based on traditional
# R or SQL Server R Services. In this example SQL Server R Services was used. The rxGLM function was used to build the model and the rxPredict function 
# was used to score the last quarter of the season. The output of rxPredict is a vector but rxPredict gives you the option to return additional columns. 
#
# In this case the "PredictGameBatchMode" stored procedure was used to operationalize the model. It can be found in the NBAPredictions database.

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
