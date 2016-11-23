assign.ranks <- function( mortality.rate, state.data ) {
    sort(state.data[ state.data[2] == mortality.rate,c(1) ])
}
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


get.ranked.hospital.in.state <- function(state, outcome.index, national.data, num = "best") {
    state.data <- national.data[national.data$State == state, c(2,outcome.index) ]
    
    state.mortality.rates <- sort(unique(state.data[,2]))
    ranked.hospitals <- unlist(sapply(state.mortality.rates,assign.ranks, state.data))
    
    #all the hospitals with NA mortality rates are still unranked
    un.ranked.hospitals <- state.data[is.na(state.data[2]),1]
    ranked.hospitals <- c(ranked.hospitals, un.ranked.hospitals)
    hospital.to.return <- NA
    
    if ( num == "best" ) { hospital.to.return <- ranked.hospitals[1]}
    else if ( num == "worst") {hospital.to.return <- ranked.hospitals[length(ranked.hospitals)]}
    else { hospital.to.return <- ranked.hospitals[num] }
    
    return (c(hospital.to.return,state))
}


rankall <- function(outcome, num = "best") {
    outcome.mapping <- list("heart attack"=9, "heart failure"=15, "pneumonia"=21)
    ## Read outcome data
    national.data <- read.national.data()
    if ( is.null(outcome.mapping[[outcome]])) {
        stop("invalid outcome")
    }
    outcome.index <- outcome.mapping[[outcome]] 
    ## For each state, find the hospital of the given rank
    hospital.list <- lapply( matrix(levels(national.data$State),ncol=1),  get.ranked.hospital.in.state, outcome.index,national.data, num)
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    df <- data.frame(matrix(unlist(hospital.list), ncol=2,byrow=T),stringsAsFactors = FALSE,row.names = levels(national.data$State))
    names(df) <- c("hospital","state")
    return(df)
}
