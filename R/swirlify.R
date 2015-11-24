# Creates skeleton for new course/lesson.
#' @importFrom utils packageVersion
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

# Save the lesson YAML to options.
# 
# This function is for internal use only, but is made public
# so that it is accessible from the content authoring app.
# 
# @param lesson lesson name
# @param course course name
# @param author your name
# @param organization your organization's name
# @importFrom shinyAce aceEditor updateAceEditor
# @export
# setMeta <- function(lesson, course, author, organization) {
#   if(is.null(lesson)) lesson <- "Lesson name here"
#   if(is.null(course)) course <- "Course name here"
#   if(is.null(author)) author <- "Your name here"
#   if(is.null(organization)) organization <- "Your organization name here (optional)"
#   options(swirlify_lesson_name = lesson,
#           swirlify_course_name = course,
#           swirlify_author = author,
#           swirlify_organization = organization)
#   invisible()
# }

# Author lesson using content authoring app.
# 
# @param lesson lesson name
# @param course course name
# @param author your name
# @param organization your organization's name
# 
# @examples
# \dontrun{
# 
# swirlify("Linear Regression", Statistics 101")
# }
# @import shiny
# @import swirl
# @importFrom methods loadMethod
# @export
# swirlify <- function(lesson, course, author=NULL, organization=NULL) {
#   # Save course/lesson metadata to options for in-app access
#   setMeta(lesson, course, author, organization)
#   # Create course skeleton
#   lessonPath <- make_skeleton()
#   # Save lesson path to options
#   options(swirlify_lesson_path = lessonPath)
#   # Run authoring app
#   x <- runApp(system.file("fullapp", package="swirlify"))
#   # Write lesson to file
#   message("\nWriting lesson to ", lessonPath, " ...")  
#   writeLines(x[[1]], lessonPath)
#   
#   if(isTRUE(x$test)) {
#     # Course directory name
#     courseDirName <- gsub(" ", "_", course)
#     # Install course
#     install_course_directory(courseDirName)
#     # Run lesson in "test" mode
#     swirl("test", test_course=course, test_lesson=lesson)
#   }
#   invisible()
# }
