context("Test google_form_decode()")

correct_responses <- data.frame(
  user = rep("sean", 6),
  course_name = rep("Google Forms Course", 6),
  lesson_name = rep("Lesson 1", 6),
  question_number = rep(2:3, 3),
  correct = rep(TRUE, 6),
  attempt = rep(1, 6),
  skipped = rep(FALSE, 6),
  datetime = c(1465226419.39813, 1465226423.01385, 1465226839.61722, 
               1465226846.03171, 1465226867.85347, 1465226895.93299),
  stringsAsFactors = FALSE
)

csv_path <- system.file(file.path("test", "responses.csv"), package = "swirlify")
csv_responses <- google_form_decode(csv_path)

test_that("Google Forms can be Properly Decoded.", {
  expect_equal(correct_responses, csv_responses)
})