context("Test test_course()")

path <- tempdir()

setwd(path)

new_lesson("Test Lesson 1", "Test Course", open_lesson = FALSE)
add_license(author = "Test Author")
add_to_manifest()
wq_command("0", "0", "0", "0")
wq_message("0")

new_lesson("Test Lesson 2", "Test Course", open_lesson = FALSE)
add_to_manifest()
wq_command("0", "0", "0", "0")
wq_message("0")

test_lesson_2_path <- file.path(getOption("swirlify_lesson_dir_path"), "lesson.yaml")

# Overwrite lesson.yaml for Test Lesson 2
# replacing "Test Course" with "Inconsistent Course Name"
updated_yaml <- sub("Test Course", "Inconsistent Course Name", 
                     readLines(test_lesson_2_path))
cat(updated_yaml, file = test_lesson_2_path, sep = "\n")

new_lesson("Test Lesson 3", "Test Course", open_lesson = FALSE)
add_to_manifest()
wq_command("0", "0", "0", "0")
wq_message("0")


zz <- file(file.path(path, "test.log"), open = "wt")
sink(zz)
sink(zz, type = "message")

test_course()

sink(type = "message")
sink()

correct_output <- c("##### Begin testing: Test Lesson 1 #####",
                    "##### End testing: Test Lesson 1 #####",
                    "",
                    "##### Begin testing: Test Lesson 2 #####",
                    "Course name 'Inconsistent Course Name' for Test Lesson 2",
                    "is inconsistent with the (directory) course name: 'Test Course'",
                    "##### End testing: Test Lesson 2 #####",
                    "",
                    "##### Begin testing: Test Lesson 3 #####",
                    "##### End testing: Test Lesson 3 #####")

test_that("test_course() passes with message about inconsistent course name", {
  expect_true(all(correct_output %in% readLines(file.path(path, "test.log"))))
})

unlink(getOption("swirlify_course_dir_path"), recursive = TRUE, force = TRUE)