# Write a single unit using shiny GUI
write_unit <- function(lessonFile) {
  # Returns unit info, "done" if done, or "test" if testing
  vals <- shiny::runApp(system.file("authoring-gui", package="swirlify"),
                        launch.browser = rstudio::viewer)
  # If "done" or "test" then user is done
  if(identical(vals, "done") || identical(vals, "test")) {
    return(vals)
  }
  # Write unit info to file
  cat(paste0("\n- ", paste0(names(vals), ": ", vals, collapse="\n  "), "\n"),
      file=lessonFile, append=TRUE)
  # Return TRUE if user not done yet
  return(TRUE)
}

make_lesson <- function(lesson, course) {
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
    stop(lessonDir, " already exists in the current working directory")
  }
  message("\nOpening lesson for editing...")
  file.edit(lessonFile)
  return(lessonFile)
}

#' Author lesson using content authoring tool
#' 
#' @param lesson lesson name
#' @param course course name
#' @param viewer run in RStudio viewer pane?
#' @examples
#' \dontrun{
#' 
#' swirlify("Linear Regression", Statistics 101")
#' }
#' @import shiny
#' @import swirl
#' @importFrom methods loadMethod
#' @export
swirlify <- function(lesson, course, author=NULL, organization=NULL, viewer=FALSE) {
  
  setMeta(lesson, course, author, organization)
  
  if(!is.logical(viewer)) {
    stop("Argument 'viewer' must be TRUE or FALSE!")
  }
  if(viewer) {
    # Create course skeleton and open new lesson file
    lessonFile <- make_lesson(lesson, course)
    # Initialize result
    result <- TRUE
    # Loop until user is done
    while(isTRUE(result)) {
      result <- write_unit(lessonFile)
    }
  } else {
    # Create course skeleton and open new lesson file
    lessonFile <- make_lesson(lesson, course)
    
    # Run authoring app
    x <- runApp(system.file("fullapp", package="swirlify"))
    # Write lesson to file
    message("\nWriting output to ", sQuote(lessonFile), "...\n")
    writeLines(x[[1]], lessonFile)
    # TODO: For backwards compatability - need to redesign
    result <- x[[2]]
  }
  
  # TODO: Fix this condition - it's a compatibility hack
  if(identical(result, "test") || isTRUE(result)) {
    # Make course directory name
    courseDir <- gsub(" ", "_", course)
    # Install course
    install_course_directory(courseDir)
    # Run lesson in "test" mode
    swirl("test", test_course=course, test_lesson=lesson)
  }
  invisible()
}

#' Set the lesson YAML in options
#' 
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