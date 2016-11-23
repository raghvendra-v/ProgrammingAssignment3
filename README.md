# ProgrammingAssignment3
R source for the assignment 3

Download the ProgAssignment3-data.zip containing the data for Programming Assignment 3 from
the Coursera web site. Unzip the in a directory that will serve as your working directory. When you
start up R make sure to change your working directory to the directory where you unzipped the data.
data can be found [here] (https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip "coursera")


test cases:
### Finding the best hospital in a state
source("best.R")

*	`best("TX", "heart attack")`
*	`best("TX", "heart failure")`
*	`best("MD", "heart attack")`
*	`best("MD", "pneumonia")`
*	`best("BB", "heart attack")`
*	`best("NY", "hert attack")`

### Ranking hospitals by outcome in a state
rm(list=ls())
source("rankhospital.R")
*	`rankhospital("TX", "heart failure", 4)`
*	`rankhospital("MD", "heart attack", "worst")`
*	`rankhospital("MN", "heart attack", 5000)`

### Ranking hospitals in all states
rm(list=ls())
source("rankall.R")
*	`head(rankall("heart attack", 20), 10)`
*	`tail(rankall("pneumonia", "worst"), 3)`
*	`tail(rankall("heart failure"), 10)`