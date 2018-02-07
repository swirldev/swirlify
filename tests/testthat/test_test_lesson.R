context("Test test_lesson()")

path <- tempdir()
oldwd <- getwd()
  
setwd(path)
  
new_lesson("Test Lesson", "Test Course", open_lesson = FALSE)
wq_command("0", "0", "0", "0")
wq_figure("0", "0.R", "new")
writeLines("plot(0, 0)", file.path(getOption("swirlify_lesson_dir_path"), "0.R"))
wq_message("0")
wq_multiple("0", c("0", "1", "2"), "0", "0", "0")
wq_numerical("0", "0", "0", "0")
wq_script("0", "0", "0", "s.R")
scripts <- file.path(getOption("swirlify_lesson_dir_path"), "scripts")
dir.create(scripts, showWarnings = FALSE)
writeLines("test", file.path(scripts, "s.R"))
writeLines("test", file.path(scripts, "s-correct.R"))
wq_text("0", "0", "0", "0")
wq_video("0", "0")
  
message_output <- capture_messages(test_lesson())
  
correct_output <- c("##### Begin testing: Test Lesson #####\n", 
                    "##### End testing: Test Lesson #####\n\n")

test_that("test_lesson() passes with well-formed lesson", {
  expect_identical(message_output, correct_output)
})

setwd(oldwd)
unlink(getOption("swirlify_course_dir_path"), recursive = TRUE, force = TRUE)
