        library(dplyr)
        library(lubridate)
		

        start.date = "20081027"; end.date = "20090417"

        Dates <- seq(ymd(start.date), ymd(end.date), by="days") 
        FiscalYearEndMonth = 6 # Based on an assumed 6-30 fical end date

        DateTable <- data.frame(Dates)

        DateTable <- 
            DateTable %>%
            mutate("DateKey" = format(Dates, "%Y%m%d")
                   ,"Year" = year(Dates)
                   ,"Month Name" = format(Dates, "%b")
                   ,"Month Key" = month(Dates)
                   ,"Weekday Name" = wday(Dates, label = TRUE) 
                   ,"Weekday Key" = wday(Dates) 
				   ,"Weekend" = ifelse(wday(Dates) %in% c(1, 7), TRUE, FALSE)
            )
     