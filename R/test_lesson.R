#' Run tests on a lesson
#'
#' Run basic tests on all questions in the current lesson.
#'
#' @export
#' @examples
#' \dontrun{
#' # Set a lesson interactively
#' set_lesson()
#' 
#' # Run tests on that lesson
#' test_lesson()
#' }
test_lesson <- function(){
  lesson_file_check()
  test_lesson_by_name()
}

#' Run tests on a course
#'
#' Run basic tests on all questions in the lessons listed in the \code{MANIFEST}.
#' See \code{\link{add_to_manifest}} for information about the \code{MANIFEST}
#' file.
#'
#' @export
#' @examples
#' \dontrun{
#' # To test a course, set any lesson in that course as the current lesson
#' set_lesson()
#' 
#' # Run tests on every lesson in that course listed in the MANIFEST
#' test_course()
#' }
test_course <- function(){
  lesson_file_check()
  
  if(!any(file.exists(file.path(getOption("swirlify_course_dir_path"), c("LICENSE.txt", "LICENSE", "LICENCE.txt", "LICENCE"))))){
    message("It seems this course does not contian a LICENSE.txt file.\nYou can easily add a license with add_license().\n")
  }
  
  manifest_path <- file.path(getOption("swirlify_course_dir_path"), "MANIFEST")
  if(!file.exists(manifest_path)){
    stop("It seems there's no MANIFEST file for this course.\nPlease add one using add_to_manifest().")
  }
  yaml_list <- file.path(getOption("swirlify_course_dir_path"), 
                         readLines(manifest_path), "lesson.yaml")
  for(lesson in yaml_list){
    # Check to see if `lesson.yaml` or just `lesson` exists
    # If neither exists warn the user and go on to the next lesson
    if(!file.exists(lesson)){
      lesson <- sub(".yaml$", "", lesson)
      if(!file.exists(lesson)){
        message("Could not find expected lesson file:\n", lesson, ".yaml")
        next()
      }
    }
    
    set_lesson(path_to_yaml = lesson, open_lesson = FALSE, silent = TRUE)
    test_lesson_by_name()
  }
}

# Test all cmd and mult questions of any lesson of current course.
#' @importFrom yaml yaml.load_file
test_lesson_by_name <- function(){
  message(paste("##### Begin testing:", getOption("swirlify_lesson_name"), "#####"))
#   .e <- environment(swirl:::any_of_exprs)
#   attach(.e)
#   on.exit(detach(.e))
#   e <- new.env()
  
  course_dir_path <- getOption("swirlify_course_dir_path")
  lesson_dir_path <- getOption("swirlify_lesson_dir_path")
  les <- yaml.load_file(getOption("swirlify_lesson_file_path"))
  
#   for (R_file in c("customTests.R", "initLesson.R")){
#     R_file_path <- file.path(lesson_dir_path, R_file)
#     if(file.exists(R_file_path)) source(R_file_path,local = e)
#   }
  
  qn <- 0 # question number
  scripts_warned_already <- FALSE
  for (question in les){
    if(question$Class == "meta"){
      for(i in c("Course", "Lesson", "Author", "Type", "Version")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in the meta question.")
      }
    } else if(question$Class == "cmd_question"){
      for(i in c("Output", "CorrectAnswer", "AnswerTests", "Hint")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
#       ne$val <- eval(parse(text=question$CorrectAnswer), envir = ne)
#       ne$expr <- parse(text = question$CorrectAnswer)[[1]]
#       if(!eval(parse(text=question$AnswerTests), envir = e)){
#         message("CorrectAnswer/AnswerTests mismatch in question ", qn,".")
#       }
    } else if(question$Class == "figure"){
      for(i in c("Output", "Figure", "FigureType")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
      
      if(!is.null(question$Figure)){
        fig <- file.path(getOption("swirlify_lesson_dir_path"), question$Figure)
        if(!file.exists(fig)){
          message("Could not find figure-creating script '", question$Figure,
                  "'")
        }
      }
    } else if(question$Class == "text"){
      for(i in c("Output")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
    } else if(question$Class == "mult_question"){
      for(i in c("Output", "AnswerChoices", "CorrectAnswer", "AnswerTests", "Hint")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
#       e$val <- as.character(question$CorrectAnswer)
#       if(!eval(parse(text = question$AnswerTests), envir = e)){
#         message("CorrectAnswer/AnswerTests mismatch in question ", qn,".")
#       }
    } else if(question$Class == "exact_question"){
      for(i in c("Output", "CorrectAnswer", "AnswerTests", "Hint")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
    } else if(question$Class == "script"){
      for(i in c("Output", "Script", "AnswerTests", "Hint")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
      
      # Check for the existense of a scripts directory for this lesson
      scripts_path <- file.path(getOption("swirlify_lesson_dir_path"), "scripts")
      if(!file.exists(scripts_path) && !scripts_warned_already){
        message("Please create a directory called 'scripts' in the lesson
                directory for ", getOption("swirlify_lesson_name"), ".")
        scripts_warned_already <- TRUE
      }
      
      if(!is.null(question$Script) && !scripts_warned_already){
        script <- question$Script
        
        # Check for the existence of the script.R file.
        if(!file.exists(file.path(scripts_path, script))){
          message("Could not find script '", script, "' for lesson '", 
                  getOption("swirlify_lesson_name"), "' question number ",
                  qn, ".")
        }
        
        # Check for the existence of the script-correct.R file.
        script_correct <- paste0(sub(".R$", "", script), "-correct.R")
        if(!file.exists(file.path(scripts_path, script_correct))){
          message("Could not find script '", script_correct, "' for lesson '", 
                  getOption("swirlify_lesson_name"), "' question number ",
                  qn, ".")
        }
      }
    } else if(question$Class == "text_question"){
      for(i in c("Output", "CorrectAnswer", "AnswerTests", "Hint")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
    } else if(question$Class == "video"){
      for(i in c("Output", "VideoLink")){
        if(is.null(question[[i]])) message("Please provide a value for the ",
                                                  i, " key in question ", qn, ".")
      }
    } else {
      message("Question ", qn, ": a question of class '", question$Class,
              "' is not officially supported by swirl.")
    }
    
    qn <- qn + 1
  }
  
  message("##### End testing: ", getOption("swirlify_lesson_name"), " #####\n")
}
