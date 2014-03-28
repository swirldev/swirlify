#' Author lesson using full web app
#' 
#' @export
authorMe <- function() {
  x <- runApp(system.file("fullapp", package="swirlify"))
  outfile <- "test_output.txt"
  message("\nWriting output to ", sQuote(outfile), "...\n")
  writeLines(x, outfile)
}