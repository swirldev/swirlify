# swirlify 0.5.0

* Removed `lp()`.

* Deprecated `testit()`. `testit()` will be removed in swirlify 0.6.

* Added `demo_lesson()` which replaces `testit()`. 

* Added `google_form_decode()` to help course authors evaluate their students'
progress in a swirl couse.

* Added `swirlify()` which starts a Shiny app for authoring swirl lessons.

# swirlify 0.4

* Removed `swirlify_help()`.

* Changed `demo_lesson()` to `testit()`, although it will be changed back before
swirlify 0.5. This was done because of compatibility issues with swirl.

* Added `lp()` for quickly finding the file path to the current lesson.yaml.

# swirlify 0.3.3

* `test_lesson()` and `test_course()` now check for proper lesson formatting.

* Added tests for packing and unpacking a lesson.

# swirlify 0.3.2

* Added `add_license()` for easy course licensing.

* Changed `count_units()` to `count_questions()`.

* Changed `test_lesson()` to `demo_lesson()`.

# swirlify 0.3.1

* Removed shiny authoring tool. Development of this tool will continue as a
separate project.

* Added `pack_course()` and `unpack_course()` to help with sharing courses in
the `.swc` file format.

* Changed the API for all of the question writing functions which now start
with the prefix `wq_`. This is meant to be used with tab-completion to make
writing lessons easier.

* Changed `swirl2html()` to `lesson_to_html()`.

* Changed `hlp()` to `swirlify_help()`.

# swirlify 0.3.0.99

* Fix typo in `swirl2html()` documentation.

# swirlify 0.3

* Deprecate `author_lesson()`, which is the old R Markdown approach. We me eventually introduce a more efficient R Markdown style that is neatly integrated with the current YAML approach.

* Change `new_yaml()` to `new_lesson()` with notice to user.

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
