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
    cat(lesson_dir_name, "\n", file = man_path, append = TRUE, sep = "")
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
  cat(lesson_dir_name, "\n", file = man_path, append = TRUE, sep = "")
  ensure_file_ends_with_newline(man_path)
  invisible(man_path)
}

ensure_file_ends_with_newline <- function(path){
  if(!ends_with_newline(path)) {
    cat("\n", file = path, append = TRUE)
  }
}
