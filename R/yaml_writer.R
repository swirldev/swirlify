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

#' List of available functions
#'
#' @export
swirlify_help <- function(){
  utils <-
    c("new_lesson(lesson_name, course_name) -- Create a new lesson.",
      "set_lesson(path2yaml) -- Select an existing lesson you want to
      work on. Omit path2yaml argument to select file interactively.",
      "get_lesson() -- See what lesson you are currently working on.",
      "test_lesson() -- Test current lesson from the beginning in swirl.",
      "test_lesson(from) or test_lesson(from, to) -- See ?test_lesson.",
      "count_units() -- Count the number of units in current lesson.",
      "find_units(regex) -- Get unit numbers for units matching regex.",
      "add_to_manifest() -- Add current lesson to course manifest.")
  rule("Utilities")
  message(paste0(" * ", utils, collapse="\n"))
  units <-
    c("wq_message() -- Just text output, no question.",
      "wq_command() -- Command line question.",
      "wq_multiple() -- Multiple choice question.",
      "wq_script() -- Question requiring submission of an R script.",
      "wq_numerical() -- Question requiring exact numerical answer.",
      "wq_text() -- Question requiring a short text answer.",
      "wq_figure() -- Display a figure in the plotting window.",
      "wq_video() -- Open a link to a video on a webpage.")
  rule("Append Unit")
  message(paste0(" * ", units, collapse="\n"))
  invisible()
}

#' Test the current lesson in swirl
#'
#' @param from Unit number to begin with. Defaults to beginning of lesson.
#' @param to Unit number to end with. Defaults to end of lesson.
#' @importFrom yaml yaml.load_file
#' @importFrom stringr str_detect str_extract
#' @importFrom swirl swirl
#' @export
#' @examples
#' \dontrun{
#' # Test current lesson from beginning through end
#' test_lesson()
#' # Test current lesson from unit 5 through end
#' test_lesson(5)
#' # Test current lesson from unit 8 through unit 14
#' test_lesson(8, 14)
#' }
test_lesson <- function(from=NULL, to=NULL) {
  # Check that we're working on a lesson
  lesson_file_check()
  # If yaml.load_file fails, provide more helpful feedback
  handle_err <- function(err) {
    # Intercept error message
    err_mes <- err$message
    # Check if its about 'mapping values', e.g. `:`
    if(str_detect(err_mes, "mapping values")) {
      # Get line and column numbers
      place <- str_extract(err_mes, "line [0-9]+, column [0-9]+$")
      err_mes <- paste0("It seems you're using a special character (maybe a colon?) at ",
                        place,
                        ". If so, you should put double quotes around the entire block of text."
      )
    }
    if(str_detect(err_mes, "expected key")) {
      # Get line and column numbers
      place <- str_extract(err_mes, "line [0-9]+, column [0-9]+$")
      err_mes <- paste0("It appears that you might have an issue with quotes around ",
                        place,
                        ". If so, you should make sure that all of your double and single quotes match up okay."
      )
    }
    stop(err_mes)
  }
  # Try reading the lesson in using yaml.load_file
  lesson_path <- getOption("swirlify_lesson_file_path")
  temp <- tryCatch(yaml.load_file(lesson_path),
                   error = handle_err
                   )
  # Check that there's something there besides the meta
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
  template <- "\n- Class: text
  \tOutput: {{{output}}}\n"
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
#' }
wq_multiple <- function(output = "ask the multiple choice question here", 
                        answer_choices = c("ANS", "2", "3"),
                        correct_answer = "ANS",
                        answer_tests = "omnitest(correctVal= 'ANS')",
                        hint = "hint"){
  lesson_file_check()
  answer_choices <- paste(answer_choices, collapse = ";")
  template <- "\n- Class: mult_question
  \tOutput: {{{output}}}
  \tAnswerChoices: {{{answer_choices}}}
  \tCorrectAnswer: {{{correct_answer}}}
  \tAnswerTests: {{{answer_tests}}}
  \tHint: {{{hint}}}\n"
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
#' }
wq_command <- function(output = "explain what the user must do here",
                       correct_answer = "EXPR or VAL",
                       answer_tests = "omnitest(correctExpr='EXPR', correctVal=VAL)",
                       hint="hint"){
  lesson_file_check()
  template <- "\n- Class: cmd_question
  \tOutput: {{{output}}}
  \tCorrectAnswer: {{{correct_answer}}}
  \tAnswerTests: {{{answer_tests}}}
  \tHint: {{{hint}}}\n"
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
#' @param script 
#' @importFrom whisker whisker.render
#' @export
wq_script <- function(output = "explain what the user must do here",
                      answer_tests = "custom_test_name()",
                      hint="hint",
                      script = "script-name.R"){
  lesson_file_check()
  template <- "\n- Class: script
  \tOutput: {{{output}}}
  \tAnswerTests: {{{answer_tests}}}
  \tHint: {{{hint}}}
  \tScript: {{{script}}}\n"
  cat(whisker.render(template, list(output = output, answer_tests = answer_tests,
                                    script = script, hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for video unit
#'
#' @importFrom whisker whisker.render
#' @export
wq_video <- function(){
  lesson_file_check(output = "Would you like to watch a short video about ___?",
                    video_link = "'http://address.of.video'")
  if(grepl("^'", video_link) && grepl("'$", video_link) ||
       grepl('^"', video_link) && grepl('"$', video_link)){
    video_link <- paste0("'", video_link, "'")
  }
  template <- "\n- Class: video
  \tOutput: {{{output}}}
  \tVideoLink: {{{video_link}}}\n"
  cat(whisker.render(template, list(output = output, video_link = video_link)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for figure unit
#'
#' @importFrom whisker whisker.render
#' @export
wq_figure <- function(output = "explain the figure here",
                      figure = "sourcefile.R",
                      figure_type = "new"){
  lesson_file_check()
  if(!(figure_type %in% c("new", "add"))){
    stop('figure_type must be either "new" or "add"')
  }
  template <- "\n- Class: figure
  \tOutput: {{{output}}}
  \tFigure: {{{figure}}}
  \tFigureType: {{{figure_type}}}\n"
  cat(whisker.render(template, list(output = output, figure = figure,
                                    figure_type = figure_type)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for exact numerical question
#'
#' @importFrom whisker whisker.render
#' @export
wq_numerical <- function(output = "explain the question here",
                         correct_answer = "42",
                         answer_tests = "omnitest(correctVal=42)",
                         hint = "hint"){
  lesson_file_check()
  template <- "\n- Class: exact_question
  \tOutput: {{{output}}}
  \tCorrectAnswer: {{{correct_answer}}}
  \tAnswerTests: {{{answer_tests}}}
  \tHint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output,
                                    correct_answer = correct_answer,
                                    answer_tests = answer_tests,
                                    hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Template for text question
#'
#' @importFrom whisker whisker.render
#' @export
wq_text <- function(output = "explain the question here",
                    correct_answer = "answer",
                    answer_tests = "omnitest(correctVal='answer')",
                    hint = "hint"){
  lesson_file_check()
  template <- "\n- Class: text_question
  \tOutput: {{{output}}}
  \tCorrectAnswer: {{{correct_answer}}}
  \tAnswerTests: {{{answer_tests}}}
  \tHint: {{{hint}}}\n"
  cat(whisker.render(template, list(output = output, correct_answer = correct_answer,
                                    answer_tests = answer_tests, hint = hint)),
      file=getOption("swirlify_lesson_file_path"), append=TRUE)
  invisible()
}

#' Select an existing lesson you want to work on
#'
#' @param path2yaml Optional, full path to YAML lesson file. If not
#' specified, then you will be prompted to select file interactively.
#' @param open_lesson Should the lesson be opened automatically?
#' Default is \code{TRUE}.
#' @param silent Should the lesson be set silently? Default is
#' \code{FALSE}.
#' @export
set_lesson <- function(path2yaml = NULL, open_lesson = TRUE,
                       silent = FALSE) {
  if(!is.logical(open_lesson)) {
    stop("Argument 'open_lesson' must be logical!")
  }
  if(!is.logical(silent)) {
    stop("Argument 'silent' must be logical!")
  }
  options(swirlify_lesson_file_path = NULL)
  lesson_file_check(path2yaml)
  if(!silent) {
    message("\nThis lesson is located at ", getOption("swirlify_lesson_file_path"))
    message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...\n")
  }
  if(open_lesson) {
    file.edit(getOption("swirlify_lesson_file_path"))
  }
  invisible()
}

#' See what lesson you are currently working on
#'
#' @export
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

#' Count number of units in current lesson
#'
#' @importFrom yaml yaml.load_file
#' @export
count_units <- function() {
  lesson_file_check()
  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
  message("Current lesson has ", length(les) - 1, " units")
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

#' Get unit numbers for any units matching a regular expression
#'
#' @importFrom yaml yaml.load_file
#' @importFrom stringr str_detect
#' @param regex The regular expression to look for in the lesson.
#' This gets passed along to \code{stringr::str_detect}, so the
#' same rules apply.
#' @export
find_units <- function(regex) {
  if(!is.character(regex)) {
    stop("Argument 'regex' must be a character string!")
  }
  lesson_file_check()
  les <- yaml.load_file(getOption('swirlify_lesson_file_path'))
  les <- les[-1]
  matches <- sapply(les, function(unit) any(str_detect(unlist(unit), regex)))
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
#' MANIFEST file does not exist, lessons are listed alphabetically.
#'
#' @return MANIFEST file path, invisibly
#' @importFrom stringr str_detect
#' @export
add_to_manifest <- function() {
  lesson_file_check()
  man_path <- find_manifest()
  lesson_dir_name <- getOption("swirlify_lesson_dir_name")
  # See if it's already listed
  man_contents <- readLines(man_path, warn = FALSE)
  found <- str_detect(man_contents, lesson_dir_name)
  if(any(found)) {
    message("\nLesson '", lesson_dir_name, "' already listed in the course manifest!\n")
    return(invisible(man_path))
  }
  # Make sure file ends with blank line
  if(!ends_with_newline(man_path)) {
    cat("\n", file = man_path, append = TRUE)
  }
  cat(lesson_dir_name, "\n", file = man_path, append = TRUE)
  invisible(man_path)
}

# Find the location of the MANIFEST file
find_manifest <- function() {
  course_dir_path <- getOption("swirlify_course_dir_path")
  man_path <- file.path(course_dir_path, "MANIFEST")
  if(!file.exists(man_path)) {
    message("\nMANIFEST file does not exist yet. Creating it now.")
  }
  man_path
}

# Borrowed from hadley/devtools
rule <- function(title = "") {
  width <- getOption("width") - nchar(title) - 1
  message("\n", title, paste(rep("-", width, collapse = "")), "\n")
}
