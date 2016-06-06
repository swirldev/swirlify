#' Decode Student's Submissions from Google Forms
#' 
#' @param path The path to a \code{csv} file downloaded from Google Forms or
#' Google Sheets which contains student's encoded responses.
#' @return A data frame containing each student's results.
#' @importFrom base64enc base64decode
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
  encoded <- suppressWarnings(read.csv(path, header = TRUE, stringsAsFactors = FALSE))
  decoded <- list()
  
  for(i in 1:nrow(encoded)){
    temp_write <- tempfile()
    writeChar(encoded[i,2], temp_write)
    temp_log <- tempfile()
    base64decode(file = temp_write, output = temp_log)
    decoded[[i]] <- read.csv(temp_log, header = TRUE, stringsAsFactors = FALSE)
  }
  
  do.call("rbind", decoded)
}
