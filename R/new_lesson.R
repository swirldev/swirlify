#' Create new lesson in the YAML format.
#'
#' Creates a new lesson and possibly a new course in your working directory. If
#' the name you provide for \code{course_name} is not a directory in your
#' working directory, then a new course directory will be created. However if
#' you've already started a course with the name you provide for \code{course_name}
#' and that course is in your working directory, then a new lesson will be created
#' inside of that course with the name you provide for \code{lesson_name}.
#'
#' @param lesson_name The name of the lesson.
#' @param course_name The name of the course.
#' @param open_lesson If \code{TRUE} the new \code{lesson.yaml} file will open
#' for editing via \code{\link[utils]{file.edit}}. The default value is \code{TRUE}.
#' @export
#' @examples
#' \dontrun{
#' # Make sure you have your working directory set to where you want to
#' # create the course.
#' setwd(file.path("~", "Developer", "swirl_courses"))
#' 
#' # Make a new course with a new lesson
#' new_lesson("How to use pnorm", "Normal Distribution Functions in R")
#' 
#' # Make a new lesson in an existing course
#' new_lesson("How to use qnorm", "Normal Distribution Functions in R")
#' }
new_lesson <- function(lesson_name, course_name, open_lesson = TRUE) {
  lessonDir <- file.path(gsub(" ", "_", course_name),
                         gsub(" ", "_", lesson_name))
  if(file.exists(lessonDir)) {
    lessonDir <- normalizePath(lessonDir)
    stop("Lesson already exists in ", lessonDir)
  }
  dir.create(lessonDir, recursive=TRUE)
  lessonDir <- normalizePath(lessonDir)
  message("Creating new lesson in ", lessonDir)
  cat("# Code placed in this file fill be executed every time the
      # lesson is started. Any variables created here will show up in
      # the user's working directory and thus be accessible to them
      # throughout the lesson.",
      file = file.path(lessonDir, "initLesson.R"))
  cat("# Put custom tests in this file.
      
      # Uncommenting the following line of code will disable
      # auto-detection of new variables and thus prevent swirl from
      # executing every command twice, which can slow things down.
      
      # AUTO_DETECT_NEWVAR <- FALSE
      
      # However, this means that you should detect user-created
      # variables when appropriate. The answer test, creates_new_var()
      # can be used for for the purpose, but it also re-evaluates the
      # expression which the user entered, so care must be taken.",
      file = file.path(lessonDir, "customTests.R"))
  cat("",
      file = file.path(lessonDir, "dependson.txt"))
  
  # The YAML faq, http://www.yaml.org/faq.html, encourages
  # use of the .yaml (as opposed to .yml) file extension
  # whenever possible.
  lesson_file <- file.path(lessonDir, "lesson.yaml")
  writeLines(c("- Class: meta",
               paste("  Course:", course_name),
               paste("  Lesson:", lesson_name),
               "  Author: your name goes here",
               "  Type: Standard",
               "  Organization: your organization's name goes here",
               paste("  Version:", packageVersion("swirl"))),
             lesson_file)
  if(open_lesson){
    file.edit(lesson_file)
  }
  message("If the lesson file doesn't open automatically, you can open it now to begin editing...")
  # Set options
  set_swirlify_options(lesson_file)
}
