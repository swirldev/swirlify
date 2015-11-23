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

zz <- file(file.path(path, "test.log"), open = "wt")
sink(zz)
sink(zz, type = "message")

test_lesson()

sink(type = "message")
sink()

correct_output <- c("##### Begin testing: Test Lesson #####",
                    "##### End testing: Test Lesson #####", "")

test_that("test_lesson() passes with well-formed lesson", {
  expect_true(all(correct_output %in% readLines(file.path(path, "test.log"))))
})

unlink(getOption("swirlify_course_dir_path"), recursive = TRUE, force = TRUE)
