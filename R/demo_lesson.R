#' Demo the current lesson in swirl
#' 
#' \strong{Warning:} In future versions of swirlify this function will be called 
#' \code{demo_lesson}. Please do not incorperate this function into any of your
#' programs since the API will change. This function is experimental so please
#' use it with caution. Avoid using this function with versions of swirl later
#' than 2.3.
#'
#' @param from Question number to begin with. Defaults to beginning of lesson.
#' @param to Question number to end with. Defaults to end of lesson.
#' @importFrom swirl swirl install_course_directory
#' @export
#' @examples
#' \dontrun{
#' # Demo current lesson from beginning through the end
#' testit()
#' # Demo current lesson from question 5 through the end
#' testit(5)
#' # Demo current lesson from question 8 through question 14
#' testit(8, 14)
#' }
testit <- function(from=NULL, to=NULL) {
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