# In this step we serialize the model and add it to a table in SQL Server. It does so by dynamically creating the sql statement below for 
# for models that were created:
#
#	EXEC AddModel 
#		 @ModelName = '<model name>'
#		,@AIC = '<AIC Stat>'
#		,@Model_Serialized = '<string representation of the model>'
#
# The only parameter that is absolutely required is the @Model_Serialized parameter which is the parameter that actually contains the serialized
# version of the model. That parameter is passed to the stored procedure in SQL Server that converts it back into binary format and inserts
# it into a table designated to hold the model. The stored procedure that does not in our case is called "AddModel". The field type of the 
# column that the stored procedure inserts the model in is varbinary(max). You can create other columns in the table that you created to store
# store the model that represent attributes about that model. In our case we added the AIC statistic and the model name. 
#
# The model is operationalized via another stored procedure that passes the model to a R script. The model can be based on base R or traditional
# R packages. It can also leverage the scaleR functions that are available in SQL Server R Services. In this example we are using the rxGLM
# function to build our model. Given that we need to use the rxPredict function to score the data. The output of your prediction is a vector but
# in the rxPredict formula you have the option to return additional columns. The stored procedure we used to operationalize our model is the
# "PredictGameBatchMode" stored procedure. You can go to the NBAPredictions database to reference that stored procedure. I commented the stored
# procedure so you can read the comments to learn more.

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
