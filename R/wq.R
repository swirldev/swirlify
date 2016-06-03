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
