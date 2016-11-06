# This code is used to combine all 1,176 files into one data frame with the columns that we need.
library(readr)
library(lubridate)


setwd("C:/Users/rwade/Downloads/Delete/")
files <- list.files(".")
fields.to.keep <- c("period", "team", "etype", "player", "points", "reason", "result", "steal", "type")


first.pass = TRUE
for (file in files)
{

   	if (first.pass == TRUE)
   	{
   		individual.gd <- read_csv(file)
		individual.gd <- individual.gd[,fields.to.keep]
		at = substring(file, 10, 12)
		ht = substring(file, 13, 15)
		gd = ymd(substring(file, 1, 8))
	    individual.gd$away_team <- at
	    individual.gd$home_team <- ht
		individual.gd$game_date <- gd
		total.gd <- individual.gd
		first.pass = FALSE
   	} else
   	{
   		individual.gd <- read_csv(file)
	    individual.gd <- individual.gd[,fields.to.keep]
	 	at = substring(file, 10, 12)
		ht = substring(file, 13, 15)
	    gd = ymd(substring(file, 1, 8))
	    individual.gd$away_team <- at
	    individual.gd$home_team <- ht
		individual.gd$game_date <- gd
   		total.gd <- rbind(total.gd, individual.gd)
   	}
}

write_csv(total.gd,path = "combined_data.csv")