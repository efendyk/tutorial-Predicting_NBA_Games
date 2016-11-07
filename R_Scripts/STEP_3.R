
# Retrieve data from SQL Server

# Connects to the SQL database then execute a query and returns the results back to R as a data frame then closes
# the connection
server.name = "<put the name of the machine that warehouses the database here>"
db.name = "NBAPredictions"
connection.string = paste("driver={SQL Server}",";","server=",server.name,";","database=", db.name, ";", "trusted_connection=true",sep="")
conn <- odbcDriverConnect(connection.string)
sql.statement = "SELECT * FROM dbo.PlayLevelData gd WHERE gd.team <> 'OFF'"
raw.data <- sqlQuery(channel = conn, sql.statement) # To get data from SQL
odbcClose(conn)

# Changes the game_date variable from a factor to a date and the period variable from a integer to a factor
raw.data <-
raw.data %>%
mutate(game_date = as.Date(game_date), period = as.factor(period))

# Removes unneeded variables
variables.to.remove <- c("conn", "connection.string", "db.name", "server.name", "sql.statement","variables.to.remove")
rm(list=variables.to.remove)