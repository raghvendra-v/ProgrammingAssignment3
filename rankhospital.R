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
assign.ranks <- function( mortality.rate, state.data ) {
    sort(state.data[ state.data[2] == mortality.rate,c(1) ])
}


rankhospital <- function(state, outcome, num = "best") {
    
    outcome.mapping <- list("heart attack"=9, "heart failure"=15, "pneumonia"=21)
    national.data <- read.national.data()
    if( ! state %in% levels(national.data$State) ) {
        stop("invalid state")
    }
    if ( is.null(outcome.mapping[[outcome]])) {
        stop("invalid outcome")
    }
    
    outcome.index <- outcome.mapping[[outcome]] 
    state.data <- national.data[national.data$State == state, c(2,outcome.index) ]
    
    state.mortality.rates <- sort(unique(state.data[,2]))
    ranked.hospitals <- unlist(sapply(state.mortality.rates,assign.ranks, state.data))
    
    #all the hospitals with NA mortality rates are still unranked
    #un.ranked.hospitals <- assign.ranks(NA, state.data)
    #ranked.hospitals <- c(ranked.hospitals, un.ranked.hospitals)
    
    if ( num == "best" ) { return (ranked.hospitals[1])}
    else if ( num == "worst") { return ( ranked.hospitals[length(ranked.hospitals)])}
    else { return (ranked.hospitals[num])}
}