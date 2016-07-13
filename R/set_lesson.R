#' Select an existing lesson to work on
#' 
#' Choose a lesson to work on with swirlify by specifying the path to the
#' \code{lesson.yaml} file or interactively choose a lesson file.
#'
#' @param path_to_yaml Optional, full path to YAML lesson file. If not
#' specified, then you will be prompted to select file interactively.
#' @param open_lesson Should the lesson be opened automatically?
#' Default is \code{TRUE}.
#' @param silent Should the lesson be set silently? Default is
#' \code{FALSE}.
#' @export
#' @examples
#' \dontrun{
#' # Set the lesson interactively
#' set_lesson()
#' 
#' # You can also specify the path to the \code{yaml} file you wish to work on.
#' set_lesson(file.path("~", "R_Programming", "Functions", "lesson.yaml"))
#' }
set_lesson <- function(path_to_yaml = NULL, open_lesson = TRUE,
                       silent = FALSE) {
  if(!is.logical(open_lesson)) {
    stop("Argument 'open_lesson' must be logical!")
  }
  if(!is.logical(silent)) {
    stop("Argument 'silent' must be logical!")
  }
  options(swirlify_lesson_file_path = NULL)
  lesson_file_check(path_to_yaml)
  if(!silent) {
    message("\nThis lesson is located at ", getOption("swirlify_lesson_file_path"))
    message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...\n")
  }
  if(open_lesson) {
    file.edit(getOption("swirlify_lesson_file_path"))
  }
  invisible()
}
