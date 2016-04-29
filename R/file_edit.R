# Same arguments as file.edit. Works with RStudio's editor.
file_edit <- function(path, title = file, editor = getOption("editor"),
                      fileEncoding = ""){
  # Not in RStudio
  if(Sys.getenv("RSTUDIO") != "1"){
    file.edit(path, title, editor, fileEncoding)
  } else {
    # The following code is graciously borrowed from the 
    # RStudio source code. Retrived 2016-04-20. See
    # https://github.com/rstudio/rstudio/blob/d5ab5dfa53c057a289179826a94622b715146e79/src/cpp/session/modules/SessionSource.R#L296-L307
    
#     .edit_file <<- function(path){
#       # call rstudio fileEdit function
#       path <- path.expand(path)
#       cmd <- paste0("invisible(.Call('rs_fileEdit', '", path, "'))")
#       eval(parse(text=cmd))
#     }
#     .edit_file(path)
    edit(path)
  }
}