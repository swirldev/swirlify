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
#' @examples 
#' \dontrun{
#' 
#' # Set lesson beforehand
#' set_lesson()
#' swirlify()
#' 
#' # Start a new lesson in your current directory
#' swirlify("Lesson 1", "My Course")
#' 
#' }
swirlify <- function(lesson_name = NULL, course_name = NULL){
  if(is.null(lesson_name) && is.null(course_name)){
    lesson_fp <- getOption("swirlify_lesson_file_path")
    if(!is.null(lesson_fp) && file.exists(lesson_fp)){
      startApp()
    } else {
      stop("Swirlify cannot find the lesson you are trying to work on. ", 
           "Please provide arguments for both lesson_name and course_name to start a new lesson, ",
           "or choose a lesson to work on using set_lesson.")
    }
  } else if(!is.null(lesson_name) && !is.null(course_name)){
    lesson <- get_lesson(lesson_name, course_name)
    if(is.na(lesson)){
      new_lesson(lesson_name, course_name, open_lesson = FALSE)
    } else {
      set_lesson(lesson, open_lesson = FALSE, silent = TRUE)
    }
    startApp()
  } else {
    stop("Please provide arguments for both lesson_name and course_name to start a new course.")
  }
  invisible()
}

startApp <- function(){
  appDir <- system.file("swirlify-app", package = "swirlify")
  
  app_results <- list()
  app_results <- runApp(appDir, display.mode = "normal")
  
  if(isTRUE(app_results$demo)){
    course_path <- getOption("swirlify_course_dir_path")
    course_name <- getOption("swirlify_course_name")
    lesson_name <- getOption("swirlify_lesson_name")
    install_course_directory(course_path)
    app_results$demo_num <- ifelse(app_results$demo_num < 1, 1, app_results$demo_num)
    swirl("test", test_course = course_name, test_lesson = lesson_name, 
          from = app_results$demo_num)
  }
  invisible()
}

get_lesson <- function(lesson_name, course_name){
  lesson_name <- make_pathname(lesson_name)
  course_name <- make_pathname(course_name)
  lessons <- file.path(getwd(), course_name, lesson_name, c("lesson.yaml", "lesson"))
  Filter(file.exists, lessons)[1]
}