# Write a single unit using shiny GUI
write_unit <- function(lesson, lessonFile) UseMethod("write_unit") 

write_unit.default <- function(lesson, lessonFile) {
  stop("Invalid lesson type! Must specify 'yaml', 'rmd', etc.")
}

write_unit.yaml <- function(lesson, lessonFile) {
  # Returns unit info, "done" if done, or "test" if testing
  vals <- shiny::runApp(system.file("authoring-gui", package="swirlify"),
                        launch.browser = rstudio::viewer)
  # If "done" or "test" then user is done
  if(identical(vals, "done") || identical(vals, "test")) {
    return(vals)
  }
  # Write unit info to file
  cat(paste0("\n- ", paste0(names(vals), ": ", vals, collapse="\n  "), "\n"),
      file=lessonFile, append=TRUE)
  # Return TRUE if user not done yet
  return(TRUE)
}

write_unit.rmd <- function(lesson, lessonFile) {
  stop("You've reached write_unit.rmd!")
}

