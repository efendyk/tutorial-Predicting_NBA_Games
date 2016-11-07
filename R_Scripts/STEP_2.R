# The checkpoint library is used to make sure that we are using the most recent version of the packages as of the date that we passed
# to the "checkpoint" function. It scans all of the scripts in the working directory to perform the test and if the test fails 
# "Checkpoint" will download the package that meets that criteria from MRAN.

library(checkpoint)
checkpoint("2015-08-14")

# Loads the packages that will be used in this project
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(RODBC)
library(ROCR)
library(car)
