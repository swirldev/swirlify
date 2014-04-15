# Creates skeleton for new course/lesson.
make_skeleton <- function(lesson, course) {
  # Course directory name
  courseDirName <- gsub(" ", "_", course)
  # Lesson directory name
  lessonDirName <- gsub(" ", "_", lesson)
  # Full path to lesson directory
  lessonDirPath <- file.path(getwd(), courseDirName, lessonDirName)
  # Check if lesson directory exists  
  if(!file.exists(lessonDirPath)) {
    message("Creating directory:\n\n", sQuote(lessonDirName))
    dir.create(lessonDirPath, recursive=TRUE)
    writeLines(c(
      "# Put initialization code in this file. The variables you create", 
      "# here will show up in the user's workspace when he or she begins", 
      "# the lesson."), file.path(lessonDirPath, "initLesson.R"))
    writeLines("# Put custom tests in this file.", 
               file.path(lessonDirPath,"customTests.R"))
  } else {
    stop("\n\nLesson directory already exists:\n\n", lessonDirPath)
  }
  # Return full path to lesson file
  # NOTE: If we add .yaml, the file won't open with file.edit()
  lessonPath <- file.path(lessonDirPath, "lesson")
  return(lessonPath)
}

#' Save the lesson YAML to options.
#' 
#' This function is for internal use only, but is made public
#' so that it is accessible from the content authoring app.
#' 
#' @param lesson lesson name
#' @param course course name
#' @param author your name
#' @param organization your organization's name
#' @importFrom shinyAce aceEditor updateAceEditor
#' @export
setMeta <- function(lesson, course, author, organization) {
  if(is.null(author)) author <- "Your name goes here"
  if(is.null(organization)) organization <- "Your organization goes here (optional)"
  options(swirlify_lesson_name = lesson,
          swirlify_course_name = course,
          swirlify_author = author,
          swirlify_organization = organization)
  invisible()
}

#' Author lesson using content authoring app.
#' 
#' @param lesson lesson name
#' @param course course name
#' @param author your name
#' @param organization your organization's name
#' 
#' @examples
#' \dontrun{
#' 
#' swirlify("Linear Regression", Statistics 101")
#' }
#' @import shiny
#' @import swirl
#' @importFrom methods loadMethod
#' @export
swirlify <- function(lesson, course, author=NULL, organization=NULL) {
  # Save course/lesson metadata to options for in-app access
  setMeta(lesson, course, author, organization)
  # Create course skeleton
  lessonPath <- make_skeleton(lesson, course)
  # Run authoring app
  x <- runApp(system.file("fullapp", package="swirlify"))
  # Write lesson to file
  message("\nWriting output to ", sQuote(lessonPath), "...\n")
  writeLines(x[[1]], lessonPath)
  
  if(isTRUE(x$test)) {
    # Course directory name
    courseDirName <- gsub(" ", "_", course)
    # Install course
    install_course_directory(courseDirName)
    # Run lesson in "test" mode
    swirl("test", test_course=course, test_lesson=lesson)
  }
  message("\nOpening lesson for editing...")
  file.edit(lessonFile)
  invisible()
}
