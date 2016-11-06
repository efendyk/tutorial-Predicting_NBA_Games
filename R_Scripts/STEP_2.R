# The checkpoint library is used to make sure that we are using the most recent version of the packages for your project.
# It scans all of the scripts in your working directory and makes sure that you have the most recent version of the packages
# in your scripts and if you do not it goes to MRAN to download it.

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