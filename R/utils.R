# This function was 'borrowed' from hadley/devtools
# check whether the specified file ends with newline
ends_with_newline <- function(path) {
  conn <- file(path, open = "rb", raw = TRUE)
  on.exit(close(conn))
  seek(conn, where = -1, origin = "end")
  lastByte <- readBin(conn, "raw", n = 1)
  lastByte == 0x0a
}

# Takes a plain English name and turns it into a more proper 
# file/directory name

#' @importFrom stringr str_trim
make_pathname <- function(name) {
  gsub(" ", "_", str_trim(name))
}

# Borrowed from hadley/devtools
rule <- function(title = "") {
  width <- getOption("width") - nchar(title) - 1
  message("\n", title, paste(rep("-", width, collapse = "")), "\n")
}