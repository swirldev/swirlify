#' Create an \code{.swc} file of the course you are working on
#' 
#' "Pack" the course you are working on into a single compressed file that is
#' easy to share. Invisibly returns the path to the \code{.swc} file.
#' 
#' @param export_path Optional, full path to the directory you want the swirl 
#' course file to be exported to. If not specified, then the file will appear
#' in the same directory as the course directory.
#' @return A string, the path to the new \code{.swc} file, invisibly.
#' @export
#' @examples
#' \dontrun{
#' # Set any lesson in the course you want to pack
#' set_lesson()
#' 
#' # Pack the course
#' pack_course()
#' 
#' # Export the .swc file to a directory that you specify
#' pack_course(file.path("~", "Desktop"))
#' }
pack_course <- function(export_path = NULL){
  if(is.null(export_path)){
    if(is.null(getOption("swirlify_course_dir_path"))){
      message("It looks like you haven't set a lesson.")
      message("Use the set_lesson() function to set any lesson in the course you wish to pack.")
      return()
    }
    export_path <- dirname(getOption("swirlify_course_dir_path"))
  }
  files <- list.files(getOption("swirlify_course_dir_path"), recursive = TRUE)
  files_full_path <- list.files(getOption("swirlify_course_dir_path"), recursive = TRUE, full.names = TRUE)
  pack <- list(name = getOption("swirlify_course_dir_name"), files = list())
  for(i in 1:length(files)){
    pack$files[[i]] <- list(path = unlist(str_split(files[i], .Platform$file.sep)),
                            raw_file = readBin(files_full_path[i], "raw", n = file.size(files_full_path[i])),
                            endian = .Platform$endian)
  }
  swc_path <- file.path(export_path, paste0(getOption("swirlify_course_dir_name"), ".swc"))
  saveRDS(pack, swc_path)
  message("Your course was successfully packed!")
  message(paste("Your packed course can be found at:", swc_path))
  invisible(swc_path)
}

#' Unpack an \code{.swc} file into a swirl course
#' 
#' Invisibly returns the path to the unpacked course directory.
#' 
#' @param file_path Optional, full path to the \code{.swc} file you wish to unpack.
#' If not specified, you will be prompted to choose a file interactively.
#' @param export_path Optional, full path to the directory where the swirl course
#' should be exported. If not specified, the course will appear in the same
#' directory as the \code{.swc} file.
#' @return A string, the path to the unpacked course directory, invisibly.
#' @export
#' @examples
#' \dontrun{
#' # Unpack a course and interactively choose a .swc file
#' unpack_course()
#' 
#' # Unpack a course where the .swc file is explicitly specified
#' unpack_course(file.path("~", "Desktop", "R_Programming.swc"))
#' 
#' # Unpack a course and specify where the .swc file is located and where the
#' # course should be exported.
#' unpack_course(file.path("~", "Desktop", "R_Programming.swc"),
#'  file.path("~", "Developer", "swirl"))
#' }
unpack_course <- function(file_path=file.choose(), export_path=dirname(file_path)){
  # Remove trailing slash
  export_path <- sub(paste0(.Platform$file.sep, "$"), replacement = "", export_path)
  
  pack <- readRDS(file_path)
  course_path <- file.path(export_path, pack$name)
  if(file.exists(course_path) && interactive()){
    response <- ""
    while(response != "Y"){
      response <- select.list(c("Y", "n"), title = paste(course_path, "already exists.\nAre you sure you want to overwrite it? [Y/n]"))
      if(response == "n") return(invisible(course_path))
    }
  }
  dir.create(course_path)
  for(i in 1:length(pack$files)){
    
    # Make file's ultimate path
    if(length(pack$files[[i]]$path) >= 2){
      lesson_file_path <- Reduce(function(x, y){file.path(x, y)}, pack$files[[i]]$path[2:length(pack$files[[i]]$path)], pack$files[[i]]$path[1])
    } else {
      lesson_file_path <- pack$files[[i]]$path
    }
    file_path <- file.path(course_path, lesson_file_path)
    
    # If the directory the file needs to be in does not exist, create the dir
    if(!file.exists(dirname(file_path))){
      dir.create(dirname(file_path), showWarnings = FALSE, recursive = TRUE)
    }
    
    writeBin(pack$files[[i]]$raw_file, file_path, endian = pack$files[[i]]$endian)
  }
  message("Your course was successfully unpacked!")
  message(paste("Your unpacked course can be found at:", course_path))
  invisible(course_path)
}
