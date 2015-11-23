library(digest)
context("Pack/unpack a course")

path <- tempdir()
oldwd <- getwd()

setwd(path)
set.seed(4) #increase with version number

let_num <- c(letters, LETTERS, rep(0:9, 2))
for(i in 1:5){
  lessn <- paste(c(sample(let_num, 4, replace = TRUE), " ",
                   sample(let_num, 5, replace = TRUE)), collapse = "")
  new_lesson(paste(lessn, i), "New Course", open_lesson = FALSE)
  wq_ <- list("wq_command()",
              "wq_figure()",
              "wq_message()",
              "wq_multiple()",
              "wq_numerical()",
              "wq_script()",
              "wq_text()",
              "wq_video()")
  qs <- sample(1:8, 20, replace = TRUE)
  for(j in qs){
    eval(parse(text = wq_[[j]]))
  }
  add_to_manifest()
}

add_license("test", year = 0000)
swc_path <- pack_course()
setwd(oldwd)

original_files <- list.files(file.path(path, "New_Course"), full.names = TRUE, recursive = TRUE)
original_file_digests <- sapply(original_files, digest, algo = "sha1", file = TRUE)
unlink(file.path(path, "New_Course"), recursive = TRUE, force = TRUE)

unpacked_course_path <- unpack_course(swc_path)
unpacked_files <- list.files(unpacked_course_path, full.names = TRUE, recursive = TRUE)
unpacked_file_digests <- sapply(unpacked_files, digest, algo = "sha1", file = TRUE)

test_that("Courses are the same before packing and after unpacking.", {
  expect_true(all(original_file_digests %in% unpacked_file_digests))
})

unlink(file.path(path, "New_Course"), recursive = TRUE, force = TRUE)
unlink(file.path(path, "New_Course.swc"), recursive = TRUE, force = TRUE)
