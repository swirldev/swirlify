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

diacritics_greek_cyrillic <- data.frame(
  user = rep("Sëãń Çroøšż", 6),
  course_name = rep("Στατιστική", 6),
  lesson_name = rep("Введение", 6),
  question_number = rep(2:3, 3),
  correct = rep(TRUE, 6),
  attempt = rep(1, 6),
  skipped = rep(FALSE, 6),
  datetime = c(1465226419.39813, 1465226423.01385, 1465226839.61722, 
               1465226846.03171, 1465226867.85347, 1465226895.93299),
  stringsAsFactors = FALSE
)

cr_path <- system.file(file.path("test", "correct_responses.csv"), 
                       package = "swirlify")
dgc_path <- system.file(file.path("test", "diacritics_greek_cyrillic.csv"), 
                        package = "swirlify")
cr <- google_form_decode(cr_path)
dgc <- google_form_decode(dgc_path)

test_that("Google Forms can be Properly Decoded.", {
  expect_equal(cr, rbind(correct_responses,
                         correct_responses,
                         correct_responses))
})

test_that("Google Forms with diacritics can be Properly Decoded.", {
  skip_on_os("windows")
  locale <- Sys.getlocale()
  us_utf8_long <- "en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8"
  us_utf8_short <- "en_US.UTF-8"
  if(locale != us_utf8_long && locale != us_utf8_short){
    testthat::skip("Locale is not en_US.UTF-8")
  }
  expect_equal(dgc, rbind(diacritics_greek_cyrillic,
                          diacritics_greek_cyrillic,
                          diacritics_greek_cyrillic))
})

# # Google form encode
# library(base64enc)
# library(tibble)
# library(readr)
# 
# cr_file <- tempfile()
# dgc_file <- tempfile()
# 
# write.csv(correct_responses, file = cr_file, row.names = FALSE)
# write.csv(diacritics_greek_cyrillic, file = dgc_file, row.names = FALSE)
# 
# encoded_cr <- base64encode(cr_file)
# encoded_dgc <- base64encode(dgc_file)
# 
# write_csv(
#   tribble(
#     ~Timestamp, ~Submission,
#     "2016/06/06 11:21:49 AM AST", encoded_cr,
#     "2016/06/06 11:27:29 AM AST", encoded_cr,
#     "2016/06/06 11:28:18 AM AST", encoded_cr
#   ), "inst/test/correct_responses.csv"
# )
# 
# write_csv(
#   tribble(
#     ~Timestamp, ~Submission,
#     "2016/06/06 11:21:49 AM AST", encoded_dgc,
#     "2016/06/06 11:27:29 AM AST", encoded_dgc,
#     "2016/06/06 11:28:18 AM AST", encoded_dgc
#   ), "inst/test/diacritics_greek_cyrillic.csv"
# )