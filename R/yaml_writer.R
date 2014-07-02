#' Create new yaml lesson using yaml_writer
#' 
#' @param lesson_name Name of lesson
#' @param course_name Name of course
#' @export
new_yaml <- function(lesson_name, course_name){
  lessonDir <- file.path(gsub(" ", "_", course_name), 
                         gsub(" ", "_", lesson_name)) 
  if(file.exists(lessonDir)) {
    lessonDir <- normalizePath(lessonDir)
    stop("Lesson already exists in ", lessonDir)
  }
  dir.create(lessonDir, recursive=TRUE)
  lessonDir <- normalizePath(lessonDir)
  message("Creating new lesson in ", lessonDir)
  writeLines("# Put initialization code in this file.", 
             file.path(lessonDir, "initLesson.R"))
  writeLines("# Put custom tests in this file.", 
             file.path(lessonDir, "customTests.R"))
  # The yaml faq, http://www.yaml.org/faq.html, encourages
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

#' yaml_writer help
#' 
#' @export
hlp <- function(){
  opts <- 
    c("new_yaml(lesson_name, course_name) -- create a new yaml lesson",
      "set_lesson() -- select an existing lesson you want to work on",
      "testit() -- test current lesson from the beginning in swirl",
      "testit(from, to) -- test specific portion of current lesson in swirl (?testit)",
      "count_units() -- count the number of units in current lesson",
      "txt() -- just text, no question",
      "qmult() -- multiple choice question",
      "qcmd() -- command line question",
      "fig() -- figure",
      "qx() -- question requiring exact numerical answer",
      "qtxt() -- question requiring a short text answer")
  message(paste0(seq(length(opts)), ". ", opts, collapse="\n"))
  invisible()
}

#' Test the current lesson in swirl
#' 
#' @param from Unit number to begin with. Defaults to beginning of lesson.
#' @param to Unit number to end with. Defaults to end of lesson.
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
#' @export
set_lesson <- function() {
  options(swirlify_lesson_file_path = NULL)
  lesson_file_check()
  message("\nThis lesson is located at ", getOption("swirlify_lesson_file_path"))
  message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...")
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
  message("Current lesson has ", length(les), " units")
}

# Checks that you are working on a lesson
lesson_file_check <- function(){
  while(is.null(getOption("swirlify_lesson_file_path")) || 
          !file.exists(getOption("swirlify_lesson_file_path"))) {
    message("\nPress Enter to select the yaml file for the lesson you want to work on...")
    readline()
    lesson_file <- file.choose() 
    set_swirlify_options(lesson_file)
  }
}

set_swirlify_options <- function(lesson_file_path) {
  # Get values
  lesson_dir_path <- dirname(lesson_file_path)
  lesson_dir_name <- basename(lesson_dir_path)
  lesson_name <- gsub("_", " ", lesson_dir_name)
  course_dir_path <- dirname(lesson_dir_path)
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
