#' (Deprecated)
#' 
#' This function is deprecated. Please use \code{demo_lesson}
#' instead.
#'
#' @param from Question number to begin with. Defaults to beginning of lesson.
#' @param to Question number to end with. Defaults to end of lesson.
#' @importFrom swirl swirl install_course_directory
#' @export
testit <- function(from=NULL, to=NULL) {
  .Deprecated("demo_lesson")
  # Check that we're working on a lesson
  lesson_file_check()
  
  # Check that if MANIFEST exists, lesson is listed
  path2man <- file.path(getOption("swirlify_course_dir_path"), "MANIFEST")
  if(file.exists(path2man)) {
    manifest <- readLines(path2man, warn=FALSE)
    if(!(getOption('swirlify_lesson_dir_name') %in% manifest)) {
      stop("Please run add_to_manifest() before demoing",
           " this lesson.")
    }
  }
  # Install course
  install_course_directory(getOption("swirlify_course_dir_path"))
  # Run lesson in "test" mode
  suppressPackageStartupMessages(
    swirl("test",
          test_course=getOption("swirlify_course_name"),
          test_lesson=getOption("swirlify_lesson_name"),
          from=from,
          to=to))
  invisible()
}

#' Demo the current lesson in swirl
#' 
#' Jump right in to the current swirl lesson without needing
#' to navigate swirl's menus. It's also possible to jump
#' into the middle of a lesson.
#'
#' @param from Question number to begin with. Defaults to beginning of lesson.
#' @param to Question number to end with. Defaults to end of lesson.
#' @importFrom swirl swirl install_course_directory
#' @importFrom stringr str_trim
#' @export
#' @examples
#' \dontrun{
#' # Demo current lesson from beginning through the end
#' demo_lesson()
#' # Demo current lesson from question 5 through the end
#' demo_lesson(5)
#' # Demo current lesson from question 8 through question 14
#' demo_lesson(8, 14)
#' }
demo_lesson <- function(from=NULL, to=NULL) {
  # Check that we're working on a lesson
  lesson_file_check()
  
  # Check that if MANIFEST exists, lesson is listed
  path2man <- file.path(getOption("swirlify_course_dir_path"), "MANIFEST")
  if(file.exists(path2man)) {
    manifest <- str_trim(readLines(path2man, warn=FALSE))
    if(!(getOption('swirlify_lesson_dir_name') %in% manifest)) {
      stop("Please run add_to_manifest() before demoing",
           " this lesson.")
    }
  }
  # Install course
  install_course_directory(getOption("swirlify_course_dir_path"))
  # Run lesson in "test" mode
  suppressPackageStartupMessages(
    swirl("test",
          test_course=getOption("swirlify_course_name"),
          test_lesson=getOption("swirlify_lesson_name"),
          from=from,
          to=to))
  invisible()
}