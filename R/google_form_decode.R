#' Decode Student's Submissions from Google Forms
#' 
#' @param path The path to a \code{csv} file downloaded from Google Forms or
#' Google Sheets which contains student's encoded responses.
#' @return A data frame containing each student's results.
#' @importFrom base64enc base64decode
#' @importFrom readr read_csv
#' @export
#' @examples 
#' \dontrun{
#' 
#' # Choose the csv file yourself
#' google_form_decode()
#' 
#' # Explicity specify the path
#' google_form_decode("~/Desktop/My_Course.csv")
#' 
#' }
google_form_decode <- function(path = file.choose()){
  encoded <- suppressMessages(suppressWarnings(read_csv(path)))
  decoded <- list()
  
  for(i in 1:nrow(encoded)){
    decoded[[i]] <- suppressMessages(
                      read_csv(
                        rawToChar(
                          base64decode(
                            as.character(encoded[i,2])))))
  }
  
  result <- as.data.frame(do.call("rbind", decoded))
  attributes(result)$spec <- NULL
  attributes(result)$row.names <- 1:nrow(result)
  result
}
