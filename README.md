swirlify
========

[![Build Status](https://travis-ci.org/swirldev/swirlify.png?branch=master)](https://travis-ci.org/swirldev/swirlify)

swirlify is a comprehensive toolbox for swirl instructors. For more information on swirl, visit [our website](http://swirlstats.com) and/or our [GitHub repository](https://github.com/swirldev/swirl).

Install swirlify
----------------

```
library(devtools)
install_github("rstudio/shiny") # Get dev version of shiny
install_github("swirldev/swirlify")
```

Use the content authoring tool (recommended)
-----------------------------------------------------

```
library(swirlify)
swirlify("Lesson Name Here", "Course Name Here")
```

![swirlify app](https://dl.dropboxusercontent.com/u/14555519/Screenshot%202014-05-01%2023.52.36.png)

Author content in R Markdown (old method)
-------------------------------------------------

```
library(swirlify)
author_lesson("Lesson Name Here", "Course Name Here", new_course=TRUE)
```

NOTE: swirlify is still in development and subject to large and frequent changes.
