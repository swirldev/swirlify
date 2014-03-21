swirlify
========

[![Build Status](https://travis-ci.org/swirldev/swirlify.png?branch=master)](https://travis-ci.org/swirldev/swirlify)

swirlify is a comprehensive toolbox for swirl instructors. For more information on swirl, visit [our website](http://swirlstats.com) and/or our [GitHub repository](https://github.com/swirldev/swirl).

Please note that we're in the process of integrating the content authoring tools that previously lived in the swirl package. For now, the documentation on the [Instructors page](http://swirlstats.com/instructors.html) of our website still applies, except that you must have the swirlify package loaded to use the `author_lesson()` function.

Install swirlify
----------------

```
library(devtools)
install_github("swirldev/swirlify")
```

Author content in R Markdown (traditional method)
-------------------------------------------------

```
library(swirlify)
author_lesson("Lesson Name Here", "Course Name Here", new_course=TRUE)
```

Use the content authoring tool (experimental feature)
-----------------------------------------------------

**IMPORTANT: The content authoring tool currently requires RStudio.**

```
library(swirlify)
swirlify("Lesson Name Here", "Course Name Here")
```

NOTE: swirlify is still in development and subject to large and frequent changes.