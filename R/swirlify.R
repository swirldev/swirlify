#' Author lesson using content authoring tool
#' 
#' @param lesson Lesson name
#' @param course Course name
#' @param lesson_type Lesson type. At present, must be either 
#' "yaml" (default) or "rmd".
#' @param where Directory within which course directory will be created. By default, your current working directory.
#' @examples
#' \dontrun{
#' 
#' swirlify("Linear Regression", "Statistics 101", "yaml")
#' }
#' @import shiny
#' @import swirl
#' @importFrom methods loadMethod
#' @export
swirlify <- function(lesson, course, lesson_type="yaml", where=NULL) {
  if(!is.null(where)) {
    swirl_out("Changing your current working directory to ",
              normalizePath(where))
    setwd(where)
  }
  # Assign class based on lesson_type
  class(lesson) <- lesson_type
  # Create course skeleton and open new lesson file
  lessonFile <- make_lesson(lesson, course)
  # Initialize result
  result <- TRUE
  # Loop until user is done
  while(isTRUE(result)) {
    result <- write_unit(lesson, lessonFile)
  }
  if(identical(result, "test")) {
    # Make course directory name
    courseDir <- gsub(" ", "_", course)
    # Install course
    install_course_directory(courseDir)
    # Run lesson in "test" mode
    swirl("test", test_course=course, test_lesson=lesson)
  }
  invisible()
}