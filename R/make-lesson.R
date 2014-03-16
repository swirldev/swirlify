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
    swirl_out("Creating directory", lessonDir, 
              "in your current working directory...")
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
    swirl_out(lessonDir, "already exists in the current working directory")
    # Make sure only lesson file is of correct type
    existing_lesson <- grep("^lesson[.]?[A-Za-z]*$", 
                            list.files(lessonDir), value=TRUE)
    ok <- identical(existing_lesson, "lesson")
    if(!ok) stop("Existing lesson is not yaml!")
  }
  swirl_out("Opening lesson for editing...")
  file.edit(lessonFile)
  return(lessonFile)
}

make_lesson.rmd <- function(lesson, course) {
  # Make course directory name
  courseDir <- gsub(" ", "_", course)
  # Create path to lesson directory
  lessonDir <- file.path(courseDir, gsub(" ", "_", lesson))
  # Create lesson file with proper extension
  lessonFile <- file.path(lessonDir, "lesson.Rmd")
  # Check if lesson directory exists 
  if(!file.exists(lessonDir)) {
    swirl_out("Creating directory", lessonDir, 
              "in your current working directory...")
    dir.create(lessonDir, recursive=TRUE)
    writeLines(c(
      "# Put initialization code in this file. The variables you create", 
      "# here will show up in the user's workspace when he or she begins", 
      "# the lesson."), file.path(lessonDir, "initLesson.R"))
    writeLines("# Put custom tests in this file.", 
               file.path(lessonDir,"customTests.R"))
    writeLines(c(paste("Course:", course),
                 paste("Lesson:", lesson),
                 "Author: Your name goes here",
                 "Type: Standard",
                 "Organization: Your organization goes here (optional)",
                 paste("Version:", packageVersion("swirl")),
                 paste(rep("=", 60), collapse="")),
               lessonFile)
  } else {
    swirl_out(lessonDir, "already exists in the current working directory")
    # Make sure only lesson file is of correct type
    existing_lesson <- grep("^lesson[.]?[A-Za-z]*$", 
                            list.files(lessonDir), value=TRUE)
    ok <- identical(existing_lesson, "lesson.Rmd")
    if(!ok) stop("Existing lesson is not rmd!")
  }
  swirl_out("Opening lesson for editing...")
  file.edit(lessonFile)
  return(lessonFile)
}
