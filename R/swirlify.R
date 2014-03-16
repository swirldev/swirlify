# TODO:
# - deal with case when start with yaml and open with rmd, etc.

#' Author lesson using content authoring tool
#' 
#' @param lesson Lesson name
#' @param course Course name
#' @param lesson_type Lesson type. At present, must be either 
#' "yaml" (default) or "rmd". Lesson types are allowed to differ
#' within the same course.
#' @examples
#' \dontrun{
#' 
#' swirlify("Linear Regression", "Statistics 101", "yaml")
#' }
#' @import shiny
#' @import swirl
#' @importFrom methods loadMethod
#' @export
swirlify <- function(lesson, course, lesson_type="yaml") {
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