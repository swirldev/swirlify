#' Create new lesson in the YAML format.
#'
#' Creates a new lesson and possibly a new course in your working directory. If
#' the name you provide for \code{course_name} is not a directory in your
#' working directory, then a new course directory will be created. However if
#' you've already started a course with the name you provide for \code{course_name}
#' and that course is in your working directory, then a new lesson will be created
#' inside of that course with the name you provide for \code{lesson_name}.
#'
#' @param lesson_name The name of the lesson.
#' @param course_name The name of the course.
#' @param open_lesson If \code{TRUE} the new \code{lesson.yaml} file will open
#' for editing via \code{\link[utils]{file.edit}}. The default value is \code{TRUE}.
#' @importFrom utils packageVersion
#' @export
#' @examples
#' \dontrun{
#' # Make sure you have your working directory set to where you want to
#' # create the course.
#' setwd(file.path("~", "Developer", "swirl_courses"))
#' 
#' # Make a new course with a new lesson
#' new_lesson("How to use pnorm", "Normal Distribution Functions in R")
#' 
#' # Make a new lesson in an existing course
#' new_lesson("How to use qnorm", "Normal Distribution Functions in R")
#' }
new_lesson <- function(lesson_name, course_name, open_lesson = TRUE) {
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
  cat("",
      file = file.path(lessonDir, "dependson.txt"))

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
  if(open_lesson){
    file_edit(lesson_file)
  }
  message("If the lesson file doesn't open automatically, you can open it now to begin editing...")
  # Set options
  set_swirlify_options(lesson_file)
}

# #' List of available functions
# #'
# #' @export
# #' @examples
# #' \dontrun{
# #' swirlify_help()
# #' }
# swirlify_help <- function(){
#   utils <-
#     c("new_lesson(lesson_name, course_name) -- Create a new lesson.",
#       "set_lesson(path_to_yaml) -- Select an existing lesson you want to
#       work on. Omit path_to_yaml argument to select file interactively.",
#       "get_lesson() -- See what lesson you are currently working on.",
#       "demo_lesson() -- Demo current lesson from the beginning in swirl.",
#       "demo_lesson(from) or demo_lesson(from, to) -- See ?demo_lesson.",
#       "count_questions() -- Count the number of questions in current lesson.",
#       "find_questions(regex) -- Get question numbers for questions matching regex.",
#       "add_to_manifest() -- Add current lesson to course manifest.",
#       "test_lesson() -- Run comprehensive tests on the current lesson.",
#       "test_course() -- Run comprehensive tests on the current course.")
#   rule("Utilities")
#   message(paste0(" * ", utils, collapse="\n"))
#   questions <-
#     c("wq_message() -- Just text output, no question.",
#       "wq_command() -- Command line question.",
#       "wq_multiple() -- Multiple choice question.",
#       "wq_script() -- Question requiring submission of an R script.",
#       "wq_numerical() -- Question requiring exact numerical answer.",
#       "wq_text() -- Question requiring a short text answer.",
#       "wq_figure() -- Display a figure in the plotting window.",
#       "wq_video() -- Open a link to a video on a webpage.")
#   rule("Append question")
#   message(paste0(" * ", questions, collapse="\n"))
#   invisible()
# }

#' Template for output without a question
#'
#' @param output Text that is displayed to the user.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_message()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_message("Welcome to a course on the central limit theorem.")
#' }
wq_message <- function(output = "put your text output here"){
  lesson_file_check()
  template <- "\n- Class: text\n  Output: {{{output}}}\n"
  cat(whisker.render(template, list(output=output)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible() 
}

#' Template for multiple choice question
#'
#' @param output Text that is displayed to the user.
#' @param answer_choices A vector of strings containing a user's choices.
#' @param correct_answer A string that designates the correct answer.
#' @param answer_tests An internal function from \code{swirl} for testing the 
#' user's choice. See \code{\link[swirl]{AnswerTests}}.
#' @param hint A string that is printed to the console if the user answers this
#' question incorrectly.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_multiple()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_multiple("Which of the following is not a planet in our solar system?",
#'  c("Venus", "Saturn", "Pluto"), "Pluto", "omnitest(correctVal= 'Pluto')",
#'    "It's the smallest celestial body you can choose.")
#' }
wq_multiple <- function(output = "ask the multiple choice question here", 
                        answer_choices = c("ANS", "2", "3"),
                        correct_answer = "ANS",
                        answer_tests = "omnitest(correctVal= 'ANS')",
                        hint = "hint"){
  lesson_file_check()
  answer_choices <- paste(answer_choices, collapse = ";")
  template <- "\n- Class: mult_question
  Output: {{{output}}}
  AnswerChoices: {{{answer_choices}}}
  CorrectAnswer: {{{correct_answer}}}
  AnswerTests: {{{answer_tests}}}
  Hint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output, answer_choices = answer_choices,
                                    correct_answer = correct_answer, answer_tests = answer_tests,
                                    hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for R command question
#'
#' @param output Text that is displayed to the user.
#' @param correct_answer A string that designates the correct answer, in this
#' case an R expression or a value.
#' @param answer_tests An internal function from \code{swirl} for testing the 
#' user's choice. See \code{\link[swirl]{AnswerTests}}.
#' @param hint A string that is printed to the console if the user answers this
#' question incorrectly.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_command()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_command("Assign the value 5 to the variable x.",
#'  "x <- 5", "omnitest(correctExpr='x <- 5')", "Just type: x <- 5")
#' }
wq_command <- function(output = "explain what the user must do here",
                       correct_answer = "EXPR or VAL",
                       answer_tests = "omnitest(correctExpr='EXPR', correctVal=VAL)",
                       hint="hint"){
  lesson_file_check()
  template <- "\n- Class: cmd_question
  Output: {{{output}}}
  CorrectAnswer: {{{correct_answer}}}
  AnswerTests: {{{answer_tests}}}
  Hint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output, correct_answer = correct_answer,
                                    answer_tests = answer_tests, hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for R script question
#'
#' @param output Text that is displayed to the user.
#' @param answer_tests An internal function from \code{swirl} for testing the 
#' user's choice. See \code{\link[swirl]{AnswerTests}}.
#' @param hint A string that is printed to the console if the user answers this
#' question incorrectly.
#' @param script The name of the script template to be opened. This template
#' should be in a directory called \code{scripts} located inside the lesson
#' directory.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_script()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_script("Write a function that adds three numbers.",
#'  "add_three_test()", "Something like: add3 <- function(x, y, z){x+y+z}", 
#'  "add-three.R")
#' }
wq_script <- function(output = "explain what the user must do here",
                      answer_tests = "custom_test_name()",
                      hint="hint",
                      script = "script-name.R"){
  lesson_file_check()
  template <- "\n- Class: script
  Output: {{{output}}}
  AnswerTests: {{{answer_tests}}}
  Hint: {{{hint}}}
  Script: {{{script}}}\n"
  cat(whisker.render(template, list(output = output, answer_tests = answer_tests,
                                    script = script, hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for video question
#' 
#' The \code{url} provided for \code{video_link} can be a link to any website.
#' 
#' @param output Text that is displayed to the user.
#' @param video_link A link to a url. Please make sure to use \code{http://} or
#' \code{https://}.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_video()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_video("Now Roger will show you the basics on YouTube.",
#'  "https://youtu.be/dQw4w9WgXcQ")
#' }
wq_video <- function(output = "Would you like to watch a short video about ___?",
                     video_link = "http://address.of.video"){
  lesson_file_check()
#   if(grepl("^'", video_link) && grepl("'$", video_link) ||
#        grepl('^"', video_link) && grepl('"$', video_link)){
#     video_link <- paste0("'", video_link, "'")
#   }
  template <- "\n- Class: video
  Output: {{{output}}}
  VideoLink: {{{video_link}}}\n"
  cat(whisker.render(template, list(output = output, video_link = video_link)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for figure questions
#'
#' @param output Text that is displayed to the user.
#' @param figure An R script that produces a figure that is displayed in the R
#' plotting window.
#' @param figure_type Either \code{"new"} or \code{"add"}. \code{"new"} idicates
#' that a new plot should be displayed, while \code{"add"} indicates that
#' features are being added to a plot that is already displayed.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_figure()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_figure("Here we can see the curve of the normal distribution.",
#'  "normalplot.R", "new")
#' }
wq_figure <- function(output = "explain the figure here",
                      figure = "sourcefile.R",
                      figure_type = "new"){
  lesson_file_check()
  if(!(figure_type %in% c("new", "add"))){
    stop('figure_type must be either "new" or "add"')
  }
  template <- "\n- Class: figure
  Output: {{{output}}}
  Figure: {{{figure}}}
  FigureType: {{{figure_type}}}\n"
  cat(whisker.render(template, list(output = output, figure = figure,
                                    figure_type = figure_type)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for exact numerical question
#' 
#' @param output Text that is displayed to the user.
#' @param correct_answer The numerical answer to the question.
#' @param answer_tests An internal function from \code{swirl} for testing the 
#' user's choice. See \code{\link[swirl]{AnswerTests}}.
#' @param hint A string that is printed to the console if the user answers this
#' question incorrectly.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_numerical()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_numerical("The golden ratio is closest to what integer?",
#'  "2", "omnitest(correctVal=2)", "It's greater than 1 and less than 3.")
#' }
wq_numerical <- function(output = "explain the question here",
                         correct_answer = "42",
                         answer_tests = "omnitest(correctVal=42)",
                         hint = "hint"){
  lesson_file_check()
  template <- "\n- Class: exact_question
  Output: {{{output}}}
  CorrectAnswer: {{{correct_answer}}}
  AnswerTests: {{{answer_tests}}}
  Hint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output,
                                    correct_answer = correct_answer,
                                    answer_tests = answer_tests,
                                    hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for text question
#'
#' @param output Text that is displayed to the user.
#' @param correct_answer The answer to the question in the form of a string.
#' @param answer_tests An internal function from \code{swirl} for testing the 
#' user's choice. See \code{\link[swirl]{AnswerTests}}.
#' @param hint A string that is printed to the console if the user answers this
#' question incorrectly.
#' @importFrom whisker whisker.render
#' @export
#' @examples
#' \dontrun{
#' # While writing a new lesson by hand just use:
#' wq_text()
#' 
#' # If converting from another format to a swirl course you may want to sue the
#' # API:
#' wq_text("Where is the Johns Hopkins Bloomberg School of Public Health located?",
#'  "Baltimore", "omnitest(correctVal='Baltimore')", "North of Washington, south of Philadelphia.")
#' }
wq_text <- function(output = "explain the question here",
                    correct_answer = "answer",
                    answer_tests = "omnitest(correctVal='answer')",
                    hint = "hint"){
  lesson_file_check()
  template <- "\n- Class: text_question
  Output: {{{output}}}
  CorrectAnswer: {{{correct_answer}}}
  AnswerTests: {{{answer_tests}}}
  Hint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output, correct_answer = correct_answer,
                                    answer_tests = answer_tests, hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Select an existing lesson to work on
#' 
#' Choose a lesson to work on with swirlify by specifying the path to the
#' \code{lesson.yaml} file or interactively choose a lesson file.
#'
#' @param path_to_yaml Optional, full path to YAML lesson file. If not
#' specified, then you will be prompted to select file interactively.
#' @param open_lesson Should the lesson be opened automatically?
#' Default is \code{TRUE}.
#' @param silent Should the lesson be set silently? Default is
#' \code{FALSE}.
#' @export
#' @examples
#' \dontrun{
#' # Set the lesson interactively
#' set_lesson()
#' 
#' # You can also specify the path to the \code{yaml} file you wish to work on.
#' set_lesson(file.path("~", "R_Programming", "Functions", "lesson.yaml"))
#' }
set_lesson <- function(path_to_yaml = NULL, open_lesson = TRUE,
                       silent = FALSE) {
  if(!is.logical(open_lesson)) {
    stop("Argument 'open_lesson' must be logical!")
  }
  if(!is.logical(silent)) {
    stop("Argument 'silent' must be logical!")
  }
  options(swirlify_lesson_file_path = NULL)
  lesson_file_check(path_to_yaml)
  if(!silent) {
    message("\nThis lesson is located at ", getOption("swirlify_lesson_file_path"))
    message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...\n")
  }
  if(open_lesson) {
    file_edit(getOption("swirlify_lesson_file_path"))
  }
  invisible()
}

#' See what lesson you are currently working on
#' 
#' Prints the current lesson and course that you are working on to the console
#'
#' @export
#' @examples
#' \dontrun{
#' get_current_lesson()
#' }
get_current_lesson <- function() {
  lesson_file_check()
  message("\nYou are currently working on...\n")
  message("Lesson: ", getOption("swirlify_lesson_name"))
  message("Course: ", getOption("swirlify_course_name"))
  message("\nThis lesson is located at ",
          getOption("swirlify_lesson_file_path"),
          "\n")
  invisible()
}

#' Count number of questions in current lesson
#' 
#' Returns and prints the number of questions in the current lesson.
#'
#' @importFrom yaml yaml.load_file
#' @return Number of questions as an integer, invisibly
#' @export
#' @examples
#' \dontrun{
#' count_questions()
#' }
count_questions <- function() {
  lesson_file_check()
  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
  message("Current lesson has ", length(les) - 1, " questions")
  invisible(length(les) - 1)
}

# Count number of units in current lesson
#
# @importFrom yaml yaml.load_file
# @export
#count_units <- function() {
#  lesson_file_check()
#  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
#  les <- les[-1]
#  message("Current lesson has ", length(les), " units")
#}

#' Get question numbers for any questions matching a regular expression
#'
#' @importFrom yaml yaml.load_file
#' @importFrom stringr str_detect
#' @param regex The regular expression to look for in the lesson.
#' This gets passed along to \code{stringr::str_detect}, so the
#' same rules apply. See \code{\link[stringr]{str_detect}}.
#' @return A vector of integers representing question numbers.
#' @export
#' @examples
#' \dontrun{
#' set_lesson()
#' find_questions("plot")
#' find_questions("which")
#' }
find_questions <- function(regex) {
  if(!is.character(regex)) {
    stop("Argument 'regex' must be a character string!")
  }
  lesson_file_check()
  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
  les <- les[-1]
  matches <- sapply(les, function(question) any(str_detect(unlist(question), regex)))
  which(matches)
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

#' Add current lesson to course manifest
#'
#' The MANIFEST file located in the course directory allows you to specify
#' the order in which you'd like the lessons to be listed in swirl. If the
#' MANIFEST file does not exist, lessons are listed alphabetically. Invisibly
#' returns the path to the MANIFEST file.
#'
#' @return MANIFEST file path, invisibly
#' @importFrom stringr str_detect
#' @export
#' @examples
#' \dontrun{
#' # Check what lesson you're working on, then add it to the MANIFEST
#' get_current_lesson()
#' add_to_manifest()
#' }
add_to_manifest <- function() {
  lesson_file_check()
  
  course_dir_path <- getOption("swirlify_course_dir_path")
  lesson_dir_name <- getOption("swirlify_lesson_dir_name")
  man_path <- file.path(course_dir_path, "MANIFEST")
  if(!file.exists(man_path)){
    cat(lesson_dir_name, "\n", file = man_path, append = TRUE)
    ensure_file_ends_with_newline(man_path)
    return(invisible(man_path))
  }
  
  # See if it's already listed
  man_contents <- readLines(man_path, warn = FALSE)
  found <- str_detect(man_contents, lesson_dir_name)
  if(any(found)) {
    message("\nLesson '", lesson_dir_name, "' already listed in the course manifest!\n")
    return(invisible(man_path))
  }
  
  # Make sure file ends with blank line
  cat(lesson_dir_name, "\n", file = man_path, append = TRUE)
  ensure_file_ends_with_newline(man_path)
  invisible(man_path)
}

ensure_file_ends_with_newline <- function(path){
  if(!ends_with_newline(path)) {
    cat("\n", file = path, append = TRUE)
  }
}

#' @importFrom whisker whisker.render
#' @importFrom utils file.edit
file_edit <- function(path){
  if(Sys.getenv("RSTUDIO") == "1"){
    message("\n##### Edit lesson file with: file.edit(lp()) #####\n")
  } else {
    file.edit(path)
  }
}

#' Get lesson path
#' 
#' Find the path to the \code{lesson.yaml} file you're working on.
#' 
#' @return A string, the path to the current \code{lesson.yaml} file.
#' @export
#' @examples 
#' \dontrun{
#' lp()
#' }
lp <- function() {
  lesson_file_check()
  getOption("swirlify_lesson_file_path")
}