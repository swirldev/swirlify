makechunk <- function(item) {
  out <- c("```{r, strip.white = TRUE}", item, "```")
  paste0(out, collapse="\n")
}

makechunk_silent <- function(item) {
  out <- c("```{r, strip.white = TRUE, echo=FALSE, message=FALSE}", item, "```")
  paste0(out, collapse="\n")
}

#' @importFrom stringr str_split
makemult <- function(item) {
  answers <- unlist(str_split(item, ";"))
  answers <- str_trim(answers)
  nums <- paste0(seq(length(answers)), ".")
  paste(nums, answers, collapse="\n")
}

makemd <- function(unit) UseMethod("makemd")

makemd.default <- function(unit) {
  stop("No unit class specified!", unit)
}

makemd.text <- function(unit) {
  paste(unit[['Output']],
        sep="\n\n")
}

makemd.cmd_question <- function(unit) {
  paste(unit[['Output']],
        makechunk(unit[['CorrectAnswer']]),
        sep="\n\n")
}

makemd.mult_question <- function(unit) {
  paste(unit[['Output']],
        makemult(unit[['AnswerChoices']]),
        unit[['CorrectAnswer']],
        sep="\n\n")
}

makemd.script <- function(unit) {
  # Get correct script contents
  script_name <- unit[["Script"]]
  correct_script_name <- paste0(tools::file_path_sans_ext(script_name),
                                "-correct.R")
  path2les <- getOption("swirlify_lesson_dir_path")
  script_path <- file.path(path2les, "scripts", correct_script_name)
  script_contents <- readLines(script_path, warn = FALSE)
  paste(unit[["Output"]],
        makechunk(script_contents),
        sep = "\n\n")
}

#' Turn a swirl lesson into a pretty webpage
#'
#' Note that \code{swirl2html()} is an experimental feature. This
#' it is subject to change based on our own experience and the
#' feedback we receive from course authors like you.
#'
#' At present, this function only accepts a swirl lesson
#' formatted in YAML. It detects the lesson you are working on
#' automatically via \code{getOption('swirlify_lesson_file_path')},
#' converts it to R Markdown (Rmd), then generates a stylized html
#' document and opens it in your default browser. To prevent clutter,
#' the Rmd files are not kept by default, but they can be kept
#' by setting \code{keep_rmd = TRUE}.
#'
#' The output is formatted to be a readable, standalone tutorial.
#' This means that information contained in the swirl lesson such as
#' answer tests and hints are excluded from the Rmd/html output.
#'
#' @param dest_dir destination directory (i.e. where to put the output files).
#' If not set, default is the lesson directory.
#' @param keep_rmd should the Rmd file be kept after the html is
#' is produced? Default is \code{FALSE}.
#'
#' @importFrom yaml yaml.load_file
#' @export
swirl2html <- function(dest_dir = NULL, keep_rmd = FALSE) {
  if(!is.logical(keep_rmd)) {
    stop("Argument keep_rmd must be TRUE or FALSE!")
  }
  if(!require(rmarkdown)) {
    stop("You must install the rmarkdown package to use this feature!")
  }
  # Check that a lesson is set
  lesson_file_check()
  # Get course directory and confirm destination dir
  course_dir <- getOption('swirlify_course_dir_path')
  # If no dest dir is specified, use the lesson dir
  if(is.null(dest_dir)) {
    dest_dir <- getOption("swirlify_lesson_dir_path")
  }
  # Check that dest_dir is valid
  if(!file.exists(dest_dir)) {
    stop(dest_dir, " does not exist!")
  }
  # Expand path
  dest_dir <- normalizePath(dest_dir)
  # Install course
  install_course_directory(course_dir)
  # Set path to lesson file
  lessonPath <- getOption('swirlify_lesson_file_path')
  # Set rmd file name
  rmd_filename <- paste0(getOption("swirlify_lesson_dir_name"), ".Rmd")
  # Set destination file for Rmd
  destrmd <- file.path(dest_dir, rmd_filename)
  # Load yaml
  les <- yaml.load_file(lessonPath)
  # Get and remove meta
  meta <- unlist(les[1])
  les <- les[-1]
  # Write meta to document header
  cat('---',
      paste('title:', meta['Lesson']),
      'output:',
      '  html_document:',
      '    theme: spacelab',
      '---\n',
      sep="\n", file=destrmd)
  # Get initLesson.R info and write init chunk w/ no echo
  initpath <- file.path(dirname(lessonPath), "initLesson.R")
  # Get and write initialization code if initLesson.R exists
  if(file.exists(initpath)) {
    initcode <- paste0(readLines(initpath, warn=FALSE), collapse="\n")
    initcode <- c("suppressPackageStartupMessages(library(swirl))\n", initcode)
    cat(makechunk_silent(initcode), "\n\n", file=destrmd, append=TRUE)
  }
  # Write the rest of the content
  for(unit in les) {
    class(unit) <- unit[['Class']]
    out <- paste(makemd(unit), "\n\n")
    cat(out, file=destrmd, append=TRUE)
    invisible()
  }
  message("Opening R Markdown file...")
  file.edit(destrmd)
  message("Knitting html...")
  rmarkdown::render(destrmd)
  # Path to html document
  html_filename <- paste0(getOption("swirlify_lesson_dir_name"), ".html")
  desthtml <- file.path(dest_dir, html_filename)
  # If keep_rmd is FALSE, remove rmd file
  if(!keep_rmd) file.remove(destrmd)
  message("Opening html document...")
  browseURL(desthtml)
}

#' @rdname swirl2html
#' @inheritParams swirl2html
#' @param course_dir path to course directory. If none is specified,
#' default is the course directory for the lesson you are currently
#' working on.
#' @export
course2html <- function(course_dir = NULL, dest_dir = NULL, keep_rmd = FALSE) {
  if(is.null(course_dir)) {
    lesson_file_check()
    course_dir <- getOption("swirlify_course_dir_path")
  }
  if(!file.exists(course_dir)) {
    stop(course_dir, " does not exist!")
  }
  # Get course paths
  course_dir <- normalizePath(course_dir)
  courses <- list.files(course_dir, full.names = TRUE)
  # Remove MANIFEST if one exists
  manifest_path <- file.path(course_dir, "MANIFEST")
  courses <- setdiff(courses, manifest_path)
  for(crs in courses) {
    lesson_path <- file.path(crs, 'lesson.yaml')
    set_lesson(lesson_path)
    swirl2html(dest_dir = dest_dir, keep_rmd = keep_rmd)
  }
}
