swirlify
========

[![Build Status](https://travis-ci.org/swirldev/swirlify.png?branch=master)](https://travis-ci.org/swirldev/swirlify)

swirlify is a comprehensive toolbox for swirl instructors. For more information on swirl, visit [our website](http://swirlstats.com) and/or our [GitHub repository](https://github.com/swirldev/swirl).

This package is still in development and subject to change as we continue to improve the content authoring process for swirl instructors. However, most changes will affect only the authoring workflow and not the format of the content produced. If we ever make changes to the formatting of content, we'll make every effort to maintain backwards compatibility and/or provide tools to update existing content to the new format.

Now, go write some awesome interactive content!

Install swirlify via devtools
----------------

You'll be installing the swirlify package directly from this GitHub repository. To do so, you'll need a recent version of devtools, which you can get with `install.packages("devtools")`.

```
devtools::install_github("swirldev/swirlify")
```

Use the authoring app (recommended)
-----------------------------------------------------

```
library(swirlify)
swirlify("Lesson Name Here", "Course Name Here")
```

Example authoring session:

![swirlify app](https://dl.dropboxusercontent.com/u/14555519/Screenshot%202014-05-01%2023.52.36.png)

Author content in R Markdown (old method)
-------------------------------------------------

```
library(swirlify)
author_lesson("Lesson Name Here", "Course Name Here", new_course=TRUE)
```
