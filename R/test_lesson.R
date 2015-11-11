#' Test all cmd and mult questions of a lesson.
#'
#' @param lesson_dir_name The directory name of the lesson. Defaults to current lesson.
#' @export
test_lesson <- function(lesson_dir_name = NULL){
  if (is.null(lesson_dir_name)) {
    lesson_dir_name <- getOption("swirlify_lesson_dir_name")
  }
  test_lesson_by_name(lesson_dir_name)
}

#' Test all cmd and mult questions of current course.
#'
#' @export
test_course <- function(){
  course_path <- getOption("swirlify_course_dir_path")
  lesson_list <- list.dirs(course_path, recursive = FALSE,full.names = FALSE)
  lesson_list <- grep("^[^\\.]",lesson_list, value = T)
  for (lesson in lesson_list){
    test_lesson_by_name(lesson)
  }
}

# Test all cmd and mult questions of any lesson of current course.
test_lesson_by_name <- function(lesson_dir_name){
  
  message(paste("##### Begin testing:", lesson_dir_name, "#####\n"))
  .e <- environment(swirl:::any_of_exprs)
  attach(.e)
  on.exit(detach(.e))
  e <- new.env()
  
  course_dir_path <- getOption("swirlify_course_dir_path")
  lesson_dir_path <- file.path(course_dir_path, lesson_dir_name)
  les <- yaml.load_file(file.path(lesson_dir_path, "lesson.yaml"))
  
  for (R_file in c("customTests.R", "initLesson.R")){
    R_file_path <- file.path(lesson_dir_path, R_file)
    if(file.exists(R_file_path)) source(R_file_path,local = e)
  }
  
  for (question in les){
    if(!is.null(question$CorrectAnswer)){
      print(paste(">", question$CorrectAnswer))
      switch(question$Class,
             "cmd_question" = {
               suppressWarnings({
                 e$val <- eval(parse(text=question$CorrectAnswer), envir = e)
                 e$expr <- parse(text = question$CorrectAnswer)[[1]]
                 stopifnot(eval(parse(text=question$AnswerTests), envir = e))
               })
             },
             "mult_question" = {
               e$val <- as.character(question$CorrectAnswer)
               stopifnot(eval(parse(text = question$AnswerTests), envir = e))
             })
    }
  }
  
  message(paste("----- Testing:", lesson_dir_name, ", done. -----\n"))
}
