# Creates skeleton for new course/lesson.
make_skeleton <- function() {
  # Course directory name
  courseDirName <- gsub(" ", "_", getOption("swirlify_course_name"))
  # Lesson directory name
  lessonDirName <- gsub(" ", "_", getOption("swirlify_lesson_name"))
  # Full path to lesson directory
  lessonDirPath <- file.path(getwd(), courseDirName, lessonDirName)
  # Full path to lesson file
  lessonPath <- file.path(lessonDirPath, "lesson.yaml")
  # Check if lesson directory exists  
  if(!file.exists(lessonDirPath)) {
    message("\nCreating lesson directory:\n\n", lessonDirPath)
    dir.create(lessonDirPath, recursive=TRUE)
    writeLines(c("- Class: meta", 
                 paste("  Course:", getOption("swirlify_course_name")),
                 paste("  Lesson:", getOption("swirlify_lesson_name")),
                 paste("  Author:", getOption("swirlify_author")),
                 "  Type: Standard",
                 paste("  Organization:", getOption("swirlify_organization")),
                 paste("  Version:", packageVersion("swirl")),
                 paste("\n")),
               lessonPath)
    writeLines(c(
      "# Put initialization code in this file. The variables you create", 
      "# here will show up in the user's workspace when he or she begins", 
      "# the lesson."), file.path(lessonDirPath, "initLesson.R"))
    writeLines("# Put custom tests in this file.", 
               file.path(lessonDirPath,"customTests.R"))
  } else {
    message("\nLesson directory already exists:\n\n", lessonDirPath)
    message("\nOpening existing lesson for editing...")
  }
  # Return full path to lesson file
  return(lessonPath)
}

#' Lauch a Shiny application for writing swirl lessons
#' 
#' This function launches a user interface for writing
#' swirl lessons.
#' 
#' @param lesson_name The name of the new lesson you want to
#' create. The default value is \code{NULL}. If you've
#' already selected a lesson to work on using \code{\link{set_lesson}}
#' then you do not need to provide a value for this argument.
#' @param course_name The name of the new course you want to
#' create. The default value is \code{NULL}. If you've
#' already selected a course to work on using \code{\link{set_lesson}}
#' then you do not need to provide a value for this argument.
#' 
#'
#' @import shiny
#' @import swirl
#' @import shinyAce
#' @export
swirlify <- function(lesson_name = NULL, course_name = NULL){
  if(is.null(getOption("swirlify_lesson_file_path")) || 
     !file.exists(getOption("swirlify_lesson_file_path"))){
    if(is.null(lesson_name) || is.null(course_name)){
      stop("Please provide arguments for both lesson_name and course_name.")
    } 
    new_lesson(lesson_name, course_name, open_lesson = FALSE)
  }
  
  appDir <- system.file("swirlify-app", package = "swirlify")
  
  x <- list()
  x <- runApp(appDir, display.mode = "normal")
  
  if(isTRUE(x$demo)){
    course_path <- getOption("swirlify_course_dir_path")
    install_course_directory(course_path)
    swirl("test", test_course = course_name, test_lesson = lesson_name)
  }
  invisible()
}
