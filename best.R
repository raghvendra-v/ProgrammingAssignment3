read.national.data <- function() {
    ## Read outcome data
    col.classes <- c("character","character","character","NULL","NULL","factor","factor","character", "factor", "character",
                     rep(c("character","factor","character","character","character","factor"),3), #mortality rates
                     rep(c("character","factor","character","character","character","factor"),3) ) #readmission   
    national.data <- read.csv("data/outcome-of-care-measures.csv", header = T, colClasses = col.classes)
    for ( i in grep("^Hospital\\.30.Day*",names(national.data)) ) {
        suppressWarnings(national.data[,i] <- as.numeric(national.data[,i] ))
    }
    for ( i in grep("^Lower\\.*",names(national.data)) ) {
        suppressWarnings(national.data[,i] <- as.numeric(national.data[,i] ))
    }
    for ( i in grep("^Upper\\.*",names(national.data)) ) {
        suppressWarnings(national.data[,i] <- as.numeric(national.data[,i] ))
    }
    for ( i in grep("^Number\\.of\\.Patients\\.\\.\\.Hospital*",names(national.data)) ) {
        suppressWarnings( national.data[,i] <- as.integer(national.data[,i] ))
    }    ## Check that state and outcome are valid
    return(national.data)
}



best <- function(state, outcome) {
    outcome.mapping <- list("heart attack"=9, "heart failure"=15, "pneumonia"=21)
    national.data <- read.national.data()
    if( ! state %in% levels(national.data$State) ) {
        stop("invalid state")
    }
    if ( is.null(outcome.mapping[[outcome]])) {
        stop("invalid outcome")
    }
    
    ## Return hospital name in that state with lowest 30-day death
    lowest.mortality.rate <- min(national.data[national.data$State == state, outcome.mapping[[outcome]] ],na.rm = T)
    hospitals <- national.data[national.data$State == state & national.data[,outcome.mapping[[outcome]]] == lowest.mortality.rate , "Hospital.Name" ]
    ## rate
    return ( sort(hospitals)[1])
}