swirlify
========

swirlify is a comprehensive toolbox for swirl instructors. For more information on swirl, visit [our website](http://swirlstats.com) or our [GitHub repository](https://github.com/swirldev/swirl).

This package is still in development and subject to change as we continue to improve the content authoring process for swirl instructors. However, most changes will affect only the authoring workflow and not the format of the content produced. If we ever make changes to the formatting of content, we'll make every effort to maintain backwards compatibility or provide tools to update existing content to the new format.

## Install swirlify

You'll be installing the development versions of swirl and swirlify. To do so, you need a recent version of devtools, which you can get with `install.packages("devtools")`.

```
devtools::install_github(c("swirldev/swirl", "swirldev/swirlify"))
```

## 2 ways to author interactive swirl content

#### 1. YAML Writer (Recommended)

This is the authoring method that we are actively developing. You can find more detailed information on the [instructors page](http://swirlstats.com/instructors.html) of our website.

```
library(swirlify)
hlp() # List of options
new_lesson("Lesson Name Here", "Course Name Here")
```

![yaml writer](https://dl.dropboxusercontent.com/u/14555519/yaml-writer-screenshot.png)

#### 2. Authoring App

This is a [Shiny](http://shiny.rstudio.com/) app that we developed a while back. You are welcome to use it if you prefer, but we highly recommend you give the other method a try first. It's likely this method will be deprecated at some point in the future.

```
library(swirlify)
swirlify("Lesson Name Here", "Course Name Here")
```

![swirlify app](https://dl.dropboxusercontent.com/u/14555519/Screenshot%202014-05-01%2023.52.36.png)

## Important note regarding R Markdown

We've deprecated the R Markdown authoring tools in favor of the YAML tools outlined above. If you've previously written content in R Markdown, this will not impact swirl's ability to run those lessons. However, if you'd like to update your R Markdown lessons to YAML, you can use [this script](https://github.com/swirldev/swirl_misc/blob/master/rmd2yaml.R) to automate the process.
