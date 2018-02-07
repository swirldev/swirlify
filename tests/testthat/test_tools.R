context("Test tools")

temp_dir <- tempdir()

test_that("swirl_courses_dir() is working", {
  swirl_options(swirl_courses_dir = temp_dir)
  expect_equal(temp_dir, swirl_courses_dir())
  
  swirl_options(swirl_courses_dir = NULL)
  expect_true(!is.null(swirl_courses_dir()))
})

test_that("make_pathname() is working", {
  expect_equal(make_pathname("Developing Data Products"), 
               "Developing_Data_Products")
  expect_equal(make_pathname(c("R Programming", "Exploratory Data Analysis")),
               c("R_Programming", "Exploratory_Data_Analysis"))
})