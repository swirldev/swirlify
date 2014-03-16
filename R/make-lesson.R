make_lesson <- function(lesson, course) UseMethod("make_lesson")

make_lesson.default <- function(lesson, course) {
  stop("Invalid lesson type! Must specify 'yaml', 'rmd', etc.")
}

make_lesson.yaml <- function(lesson, course) {
  # Make course directory name
  courseDir <- gsub(" ", "_", course)
  # Create path to lesson directory
  lessonDir <- file.path(courseDir, gsub(" ", "_", lesson))
  # NOTE: If we add .yaml, the file won't open automatically
  lessonFile <- file.path(lessonDir, "lesson")
  # Check if lesson directory exists  
  if(!file.exists(lessonDir)) {
    message("Creating directory ", lessonDir, " in your current
            working directory...")
    dir.create(lessonDir, recursive=TRUE)
    writeLines(c(
      "# Put initialization code in this file. The variables you create", 
      "# here will show up in the user's workspace when he or she begins", 
      "# the lesson."), file.path(lessonDir, "initLesson.R"))
    writeLines("# Put custom tests in this file.", 
               file.path(lessonDir,"customTests.R"))
    writeLines(c("- Class: meta", 
                 paste("  Course:", course),
                 paste("  Lesson:", lesson),
                 "  Author: Your name goes here",
                 "  Type: Standard",
                 "  Organization: Your organization goes here (optional)",
                 paste("  Version:", packageVersion("swirl"))),
               lessonFile)
  } else {
    message(lessonDir, " already exists in the current working directory")
  }
  message("\nOpening lesson for editing...")
  file.edit(lessonFile)
  return(lessonFile)
}

make_lesson.rmd <- function(lesson, course) {
  stop("You've reached make_lesson.rmd!")
}
