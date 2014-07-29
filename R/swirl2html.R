makechunk <- function(item) {
  paste("```{r}", item, "```", sep="\n")
}

makechunk_noecho <- function(item) {
  paste("```{r, echo=FALSE}", item, "```", sep="\n")
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
#' document and opens it in your default browser.
#' 
#' The output is formatted to be a readable, standalone tutorial. 
#' This means that information contained in the swirl lesson such as 
#' answer tests and hints are excluded from the Rmd/html output.
#' 
#' @param destDir destination directory (i.e. where to put the R 
#' markdown (Rmd) and html output files)
#' 
#' @importFrom yaml yaml.load_file
#' @export
swirl2html <- function(destDir) {
  if(!require(rmarkdown)) {
    stop("You must install the rmarkdown package to use this feature!")
  }
  # Check that a lesson is set
  lesson_file_check()
  # Set path to lesson file
  lessonPath <- getOption('swirlify_lesson_file_path')
  # Set destination file for Rmd
  destrmd <- file.path(destDir, "lesson.Rmd")
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
    initcode <- paste(readLines(initpath, warn=FALSE), collapse="\n")
    initcode <- paste("suppressPackageStartupMessages(library(swirl))", 
                      initcode, sep="\n")
    cat(makechunk_noecho(initcode), "\n\n", file=destrmd, append=TRUE)
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
  desthtml <- file.path(destDir, "lesson.html")
  message("Opening html document...")
  browseURL(desthtml)
}
