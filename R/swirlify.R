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
#' @import shiny
#' @import swirl
swirlify <- function(){
  appDir <- system.file("swirlify-app", package = "swirlify")
  runApp(appDir, display.mode = "normal")
}