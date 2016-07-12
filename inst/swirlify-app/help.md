# Welcome to swirlify!

For the full swirlify documentation please visit http://swirlstats.com/swirlify/.

# Using this App

The purpose of this app is to help you write a `lesson.yaml` file for a swirl
lesson. Each of the eight kinds of questions you can ask in a swirl lesson are
detailed below. Each question has a template that you can select in the 
drop-down menu under the "Question Type" heading in the **Editor** tab. Fill in
the template and then click the **Add Question** button to have the question
appear in the `lesson.yaml` file. To save the changes you've made to the
`lesson.yaml` file click the **Save Lesson** button. You can jump right into
your lesson by clicking the **Demo Lesson** button.

# Types of Questions

## The Meta Question

The first question in every `lesson.yaml` is always the meta question which
contains general information about the course. Below is an example of the meta
question:

```
- Class: meta
  Course: My Course
  Lesson: My Lesson
  Author: Dr. Jennifer Bryan
  Type: Standard
  Organization: The University of British Columbia
  Version: 2.5
```
The meta question will not be displayed to a student. The only fields you should
modify are `Author` and `Organization` fields.

## Message Questions

Message questions display a string of text in the R console for the student to 
read. Once the student presses enter, swirl will move on to the next question.

Add a message question using `wq_message()`. 

Here's an example message question:

```
- Class: text
  Output: Welcome to my first swirl course!
```

The student will see the following in the R console:

```
| Welcome to my first swirl course!

...
```

## Command Questions

Command questions prompt the student to type an expression into the R console.

- The `CorrectAnswer` is entered into the console if the student uses the `skip()`
function. 
- The `Hint` is displayed to the student if they don't get the question right.
- The `AnswerTests` determine whether or not the student answered the question
correctly. See the answer testing section for more information.

Add a message question using `wq_command()`. 

Here's an example command question:

```
- Class: cmd_question
  Output: Add 2 and 2 together using the addition operator.
  CorrectAnswer: 2 + 2
  AnswerTests: omnitest(correctExpr='2 + 2')
  Hint: Just type 2 + 2.
```

The student will see the following in the R console:

```
| Add 2 and 2 together using the addition operator.

>
```

## Multiple Choice Questions

Multiple choice questions present a selection of options to the student. These
options are presented in a different order every time the question is seen.

- The `AnswerChoices` should be a semicolon separated string of choices that
the student will have to choose from.

Add a message question using `wq_multiple()`. 

Here's an example multiple choice question:

```
- Class: mult_question
  Output: What is the capital of Canada?
  AnswerChoices: Toronto;Montreal;Ottawa;Vancouver
  CorrectAnswer: Ottawa
  AnswerTests: omnitest(correctVal='Ottawa')
  Hint: This city contains the Rideau Canal.
```

The student will see the following in the R console:

```
| What is the capital of Canada?

1: Toronto
2: Montreal
3: Ottawa
4: Vancouver
```

## Figure Questions

Figure questions are designed to show graphics to the student.

- `Figure` is an R script located in the lesson folder that will draw the figure.
- `FigureType` must be either `new` or `add`.
    - `new` specifies that a new figure is being drawn.
    - `add` specifies that more features are being added to a figure that
    already has been drawn, for example if you were adding a line or a legend to
    a plot that had been drawn in a preceding figure question.
    
Add a message question using `wq_figure()`. 

Here's an example figure question:

```
- Class: figure
  Output: Look at this figure!
  Figure: draw.R
  FigureType: new
```

The student will see the following in the R console:

```
| Look at this figure!

...
```

The student will also see the figure in the appropriate graphics device.

## Video/URL Questions

Video/URL questions give students the choice to open a URL in their web browser.

- `VideoLink` is the URL that will be opened in the student's web browser.

Add a message question using `wq_video()`. 

Here's an example video/URL question:

```
- Class: video
  Output: Do you want to go to Google?
  VideoLink: https://www.google.com/
```

The student will see the following in the R console:

```
| Do you want to go to Google?

Yes or No?
```

## Numerical Questions

Numerical questions ask the student to type an exact number into the R console.

Add a message question using `wq_numerical()`. 

Here's an example numerical question:

```
- Class: exact_question
  Output: How many of the Rings of Power were forged by the elven-smiths of
    Eregion?
  CorrectAnswer: 19
  AnswerTests: omnitest(correctVal = 19)
  Hint: Three Rings for the Elven-kings under the sky, Seven for the Dwarf-lords
  in their halls of stone, Nine for Mortal Men doomed to die...
```

The student will see the following in the R console:

```
| How many of the Rings of Power were forged by the elven-smiths of Eregion?

>
```

## Text Questions

Text questions ask the student to type an phrase into the R console.

Add a message question using `wq_text()`. 

Here's an example text question:

```
- Class: text_question
  Output: What is the name of the programming language invented by 
    John Chambers?
  CorrectAnswer: 'S'
  AnswerTests: omnitest(correctVal = 'S')
  Hint: What comes after R in the alphabet?
```

The student will see the following in the R console:

```
| What is the name of the programming language invented by John Chambers?

ANSWER:
```

## Script Questions

Script questions might be the hardest questions to write, however the payoff
in a student's understanding of how R works is proportional. Script questions
require that you write a custom answer test in order to evaluate the correctness
of a script that a student has written. Writing custom answer tests is covered
thoroughly in the answer testing section.

- `Script` is an R script that will be opened once the student reaches this
question. You should include this script in a subdirectory of the lesson folder
called "scripts". You should also
include in the "scripts directory" a version of this script that passes the 
answer test. The name of the
file for the correct version of the script shoud end in `-correct.R`. So if the
name of the script that the student will need to edit is `script.R` there should
be a corresponding `script-correct.R`.

Add a message question using `wq_script()`. 

Here's an example script question:

```
- Class: script
  Output: Write a function that calculates the nth fibonacci number.
  AnswerTests: test_fib()
  Hint: You could write this function recursively!
  Script: fib.R
```

The student will see the following in the R console:

```
| Write a function that calculates the nth fibonacci number.

>
```

Here's an example `fib.R`:

```
# Write a function that returns the nth fibonacci number. Think about
# what we just reviewed with regard to writing recurisive functions.

fib <- function(n){
  # Write your code here.
}
```

Here's an example `fib-correct.R`:

```
# Write a function that returns the nth fibonacci number. Think about
# what we just reviewed with regard to writing recurisive functions.

fib <- function(n){
  if(n == 0 || n == 1){
    return(n)
  } else {
    return(fib(n-2) + fib(n-1))
  }
}
```

Here's an example `customTests.R` which includes `test_fib()`:

```
test_fib <- function() {
  try({
    func <- get('fib', globalenv())
    t1 <- identical(func(1), 1)
    t2 <- identical(func(20), 6765)
    t3 <- identical(sapply(1:12, func), c(1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144))
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}
```
