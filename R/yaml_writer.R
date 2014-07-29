#' Create new lesson in the YAML format.
#' 
#' This is the recommended method for creating new content.
#' 
#' @param lesson_name Name of lesson
#' @param course_name Name of course
#' @export
new_lesson <- function(lesson_name, course_name) {
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
  file.edit(lesson_file)
  message("If the lesson file doesn't open automatically, you can open it now to begin editing...")
  # Set options
  set_swirlify_options(lesson_file)
}

#' Replaced by \code{\link{new_lesson}}.
#' 
#' @export
new_yaml <- function(){
  message("\nThis function has been replaced by new_lesson(). Please use that instead.\n")
}
  
#' List of available functions
#' 
#' @export
hlp <- function(){
  opts <- 
    c("new_lesson(lesson_name, course_name) -- Create a new lesson.",
      "set_lesson(path2yaml) -- Select an existing lesson you want to 
      work on. Omit path2yaml argument to select file interactively.",
      "testit() -- Test current lesson from the beginning in swirl.",
      "testit(from, to) -- Test specific portion of current lesson 
      in swirl (?testit).",
      "count_units() -- Count the number of units in current lesson.",
      "txt() -- Just text output, no question.",
      "qcmd() -- Command line question.",
      "qmult() -- Multiple choice question.",
      "qscript() -- Question requiring submission of an R script.",
      "qx() -- Question requiring exact numerical answer.",
      "qtxt() -- Question requiring a short text answer.",
      "fig() -- Display a figure in the plotting window.")
  message(paste0(seq(length(opts)), ". ", opts, collapse="\n"))
  invisible()
}

#' Test the current lesson in swirl
#' 
#' @param from Unit number to begin with. Defaults to beginning of lesson.
#' @param to Unit number to end with. Defaults to end of lesson.
#' @importFrom yaml yaml.load_file
#' @export 
#' @examples
#' \dontrun{
#' # Test current lesson from beginning through end
#' testit()
#' # Test current lesson from unit 5 through end
#' testit(5)
#' # Test current lesson from unit 8 through unit 14
#' testit(8, 14)
#' }
testit <- function(from=NULL, to=NULL) {
  # Check that we're working on a lesson
  lesson_file_check()
  # Check that there's something there besides the meta
  temp <- yaml.load_file(getOption("swirlify_lesson_file_path"))
  if(length(temp) <= 1) stop("There's nothing to test yet!")
  # Check that if MANIFEST exists, lesson is listed
  path2man <- file.path(getOption("swirlify_course_dir_path"), "MANIFEST")
  if(file.exists(path2man)) {
    manifest <- readLines(path2man, warn=FALSE)
    if(!(getOption('swirlify_lesson_dir_name') %in% manifest)) {
      stop("Please add '", getOption('swirlify_lesson_dir_name'),
           "' to the MANIFEST file in your course directory!")
    }
  }
  # Install course
  install_course_directory(getOption("swirlify_course_dir_path"))
  # Run lesson in "test" mode
  suppressPackageStartupMessages(
    swirl("test", 
          test_course=getOption("swirlify_course_name"), 
          test_lesson=getOption("swirlify_lesson_name"),
          from=from, 
          to=to))
  invisible()
}

#' template for output without a question
#' 
#' @export
txt <- function(){
  lesson_file_check()
  cat("\n- Class: text
  Output: put your text output here\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for multiple choice question
#' 
#' @export
qmult <- function(){
  lesson_file_check()
  cat("\n- Class: mult_question  
  Output: ask the multiple choice question here
  AnswerChoices: ANS;2;3
  CorrectAnswer: ANS
  AnswerTests: omnitest(correctVal= 'ANS')
  Hint: hint\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for R command question
#' 
#' @export
qcmd <- function(){
  lesson_file_check()
  cat("\n- Class: cmd_question
  Output: explain what the user must do here
  CorrectAnswer: EXPR or VAL
  AnswerTests: omnitest(correctExpr='EXPR', correctVal=VAL)
  Hint: hint\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for R script question
#' 
#' @export
qscript <- function(){
  lesson_file_check()
  cat("\n- Class: script
  Output: explain what the user must do here
  AnswerTests: custom_test_name()
  Hint: hint
  Script: script-name.R\n",
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for video unit
#' 
#' @export
vid <- function(){
  lesson_file_check()
  cat("\n- Class: video
  Output: Would you like to watch a short video about ___?
  VideoLink: 'http://address.of.video'\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for figure unit
#' 
#' @export
fig <- function(){
  lesson_file_check()
  cat("\n- Class: figure
  Output: explain the figure here
  Figure: sourcefile.R
  FigureType: new or add\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for exact numerical question
#' 
#' @export
qx <- function(){
  lesson_file_check()
  cat("\n- Class: exact_question
  Output: explain the question here
  CorrectAnswer: n
  AnswerTests: omnitest(correctVal=n)
  Hint: hint\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for text question
#' 
#' @export
qtxt <- function(){
  lesson_file_check()
  cat("\n- Class: text_question
  Output: explain the question here
  CorrectAnswer: answer
  AnswerTests: omnitest(correctVal='answer')
  Hint: hint\n", 
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Select an existing lesson you want to work on
#' 
#' @param path2yaml Optional, full path to YAML lesson file. If not
#' specified, then you will be prompted to select file interactively.
#' @export
set_lesson <- function(path2yaml = NULL) {
  options(swirlify_lesson_file_path = NULL)
  lesson_file_check(path2yaml)
  message("\nThis lesson is located at ", getOption("swirlify_lesson_file_path"))
  message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...\n")
  file.edit(getOption("swirlify_lesson_file_path"))
  invisible()
}

#' Count number of units in current lesson
#' 
#' @importFrom yaml yaml.load_file
#' @export
count_units <- function() {
  lesson_file_check()
  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
  message("Current lesson has ", length(les) - 1, " units")
}

# Checks that you are working on a lesson
lesson_file_check <- function(path2yaml = NULL){
  while(is.null(getOption("swirlify_lesson_file_path")) || 
          !file.exists(getOption("swirlify_lesson_file_path"))) {
    if(!is.null(path2yaml)) {
      if(file.exists(path2yaml)) {
      lesson_file <- path2yaml
      } else {
      stop("There is no YAML lesson file at the specified file path!")
      }
    } else {
      message("\nPress Enter to select the YAML file for the lesson you want to work on...")
      readline()
      lesson_file <- file.choose()
    }
    lesson_file <- normalizePath(lesson_file)
    set_swirlify_options(lesson_file)
  }
  # Append empty line to lesson file if necessary
  append_empty_line(getOption("swirlify_lesson_file_path"))
}

set_swirlify_options <- function(lesson_file_path) {
  # Get values
  lesson_dir_path <- normalizePath(dirname(lesson_file_path))
  lesson_dir_name <- basename(lesson_dir_path)
  lesson_name <- gsub("_", " ", lesson_dir_name)
  course_dir_path <- normalizePath(dirname(lesson_dir_path))
  course_dir_name <- basename(course_dir_path)
  course_name <- gsub("_", " ", course_dir_name)
  # Set options
  options(swirlify_lesson_file_path = lesson_file_path,
          swirlify_lesson_dir_path = lesson_dir_path, 
          swirlify_lesson_dir_name = lesson_dir_name, 
          swirlify_lesson_name = lesson_name,
          swirlify_course_dir_path = course_dir_path, 
          swirlify_course_dir_name = course_dir_name, 
          swirlify_course_name = course_name)
}

# Checks for empty line at end of lesson and appends one if necessary
append_empty_line <- function(lesson_file_path) {
  les <- readLines(lesson_file_path, warn = FALSE)
  if(les[length(les)] != "") {
    # writeLines() automatically includes empty line at end of file
    writeLines(les, lesson_file_path)
  }
}
