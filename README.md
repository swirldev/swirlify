swirlify
========

swirlify is a comprehensive toolbox for swirl instructors. For more information on swirl, visit [our website](http://swirlstats.com) or our [GitHub repository](https://github.com/swirldev/swirl).

This package is still in development and subject to change as we continue to improve the content authoring process for swirl instructors. However, most changes will affect only the authoring workflow and not the format of the content produced. If we ever make changes to the formatting of content, we'll make every effort to maintain backwards compatibility or provide tools to update existing content to the new format.

## Install swirlify

You'll be installing the development versions of swirl and swirlify. To do so, you need a recent version of devtools, which you can get with `install.packages("devtools")`.

```
devtools::install_github(c("swirldev/swirl", "swirldev/swirlify"))
```

## 3 ways to author interactive swirl content:

#### 1. YAML Writer

```
library(swirlify)
hlp() # List of options
new_yaml("Lesson Name Here", "Course Name Here")
```

![yaml writer](https://dl.dropboxusercontent.com/u/14555519/Screenshot%202014-06-25%2016.16.27.png)

#### 2. Authoring App

```
library(swirlify)
swirlify("Lesson Name Here", "Course Name Here")
```

Example authoring session:

![swirlify app](https://dl.dropboxusercontent.com/u/14555519/Screenshot%202014-05-01%2023.52.36.png)

#### 3. R Markdown (old method)

```
library(swirlify)
author_lesson("Lesson Name Here", "Course Name Here", new_course=TRUE)
```
