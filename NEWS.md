# swirlify 0.2.3

* Normalize file paths using `normalizePath()` in case user specifies a relative path to a lesson, then changes their working directory.

* Allow user to specify path to YAML lesson as an argument to `set_lesson()`.

* Update `hlp()` menu.

# swirlify 0.2.2

* Add check to `testit()` to make sure that the lesson being tested is listed in the course `MANIFEST`, if one exists in the course directory.

* Add commented out `AUTO_DETECT_NEWVAR <- FALSE` to customTests.R template created by `new_yaml()`. Setting this variable equal to `FALSE` can prevent double evaluation of printing and plotting commands.

* Update `hlp()` output to include `count_units()` and `testit(from, to)`.

# swirlify 0.2.1

* Add `swirl2html()` to convert swirl lessons formatted in YAML to R markdown (Rmd) and html files. The output is a stylized webpage that acts as a standalone tutorial based on the original swirl lesson.

# swirlify 0.2

* Add a more bare bones YAML authoring toolset initiated by `new_yaml()`. `hlp()` gives a list of related functions. We plan to integrate this new approach more closely with existing swirlify functions, but it functions well as is.
