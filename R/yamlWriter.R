#' Create new yaml lesson using yamlWriter
#' 
#' @param lessonName Name of lesson
#' @param courseName Name of course
#' @export
newYaml <- function(lessonName, courseName){
  lessonDir <- file.path(gsub(" ", "_", courseName), 
                         gsub(" ", "_", lessonName))
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
  lessonFile <- file.path(lessonDir, "lesson.yaml")
  writeLines(c("- Class: meta", 
               paste("  Course:", courseName),
               paste("  Lesson:", lessonName),
               "  Author: your name goes here",
               "  Type: Standard",
               "  Organization: your organization's name goes here",
               paste("  Version:", packageVersion("swirl"))),
             lessonFile)
  file.edit(lessonFile) # May not work due to .yaml extension
  message("If the lesson file doesn't open automatically, you can open it now to begin editing...")
  # Set options
  options(lessonFile = lessonFile)
}

#' yamlWriter help
#' 
#' @export
hlp <- function(){
  print("newYaml(lessonName, courseName) -- create a new yaml lesson")
  print("txt -- just text, no question")
  print("qmult -- multiple choice question")
  print("qcmd -- command line question")
  print("vid -- video")
  print("fig -- figure")
  print("qx -- question requiring exact numerical answer")
  print("qtxt -- question requiring a short text answer")
}

#' template for output without a question
#' 
#' @export
txt <- function(){
  lessonFileCheck()
  cat("\n- Class: text
  Output: put your text output here\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for multiple choice question
#' 
#' @export
qmult <- function(){
  lessonFileCheck()
  cat("\n- Class: mult_question  
  Output: ask the multiple choice question here
  AnswerChoices: ANS;2;3
  CorrectAnswer: ANS
  AnswerTests: omnitest(correctVal= 'ANS')
  Hint: hint\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for R command question
#' 
#' @export
qcmd <- function(){
  lessonFileCheck()
  cat("\n- Class: cmd_question
  Output: explain what the user must do here
  CorrectAnswer: EXPR or VAL
  AnswerTests: omnitest(correctExpr='EXPR', correctVal=VAL)
  Hint: hint\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for video unit
#' 
#' @export
vid <- function(){
  lessonFileCheck()
  cat("\n- Class: video
  Output: Would you like to watch a short video about ___?
  VideoLink: 'http://address.of.video'\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for figure unit
#' 
#' @export
fig <- function(){
  lessonFileCheck()
  cat("\n- Class: figure
  Output: explain the figure here
  Figure: sourcefile.R
  FigureType: new or add\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for exact numerical question
#' 
#' @export
qx <- function(){
  lessonFileCheck()
  cat("\n- Class: exact_question
  Output: explain the question here
  CorrectAnswer: n
  AnswerTests: omnitest(correctVal=n)
  Hint: hint\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Template for text question
#' 
#' @export
qtxt <- function(){
  lessonFileCheck()
  cat("\n- Class: text_question
  Output: explain the question here
  CorrectAnswer: answer
  AnswerTests: omnitest(correctVal='answer')
  Hint: hint\n", 
      file=getOption("lessonFile"), append=TRUE)
  invisible()
}

#' Set or change lesson you want to work on
#' 
#' @export
setLesson <- function() {
  options(lessonFile = NULL)
  lessonFileCheck()
  message("This lesson is located at ", getOption("lessonFile"))
  message("\nIf the lesson file doesn't open automatically, you can open it now to begin editing...")
  invisible()
}

#' Checks that you are working on a lesson
#' 
#' @export
lessonFileCheck <- function(){
  while(is.null(getOption("lessonFile")) || 
          !file.exists(getOption("lessonFile"))) {
    course <- gsub(" ", "_", readline("Course name? "))
    lesson <- gsub(" ", "_", readline("Lesson name? "))  
    options(lessonFile = file.path(course, lesson, "lesson.yaml"))
  }
}