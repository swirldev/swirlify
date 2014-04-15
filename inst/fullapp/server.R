library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {
  
  existingLesson <- observe({
    x <- input$existing
    if(is.null(x)) return(NULL)
    les <- paste(readLines(x$datapath, warn=FALSE), collapse="\n")
    updateAceEditor(session, "ace", theme="vibrant_ink", mode="yaml",
                    wordWrap=TRUE, value=les)
  })

  # Return the appropriate description
  output$description <- renderText({
    switch(input$class,
       "text" = "Text output is displayed to the user in the console.",
       "cmd_question" = paste("A command question requires the user to enter a",
                              "valid R expression at the prompt. If an incorrect",
                              "answer is given, a hint is displayed before",
                              "repeating the question."),
       "mult_question" = paste("A multiple choice question requires the user to",
                               "select one correct answer from a list of choices.",
                               "If an incorrect",
                               "answer is given, a hint is displayed before",
                               "repeating the question."),
       "exact_question" = paste("An exact numerical question requires the user to",
                                "enter an integer or decimal number. There is a",
                                "small tolerance for error. If an incorrect",
                                "answer is given, a hint is displayed before",
                                "repeating the question."),
       "text_question" = paste("A text question requires the user to enter a", 
                               "one- or two-word answer. If an incorrect",
                               "answer is given, a hint is displayed before",
                               "repeating the question."),
       "video" = paste("A video unit asks the user if he or she would like to",
                       "watch an online video on a particular topic, and if so,", 
                       "a browser window is opened to display it."),
       "figure" = paste("A figure unit displays a plot to the user. The code to",
                        "generate each plot must be placed in its own R script",
                        "in the lesson directory.")
    )
  })
  
  output$ui <- renderUI({
    if (is.null(input$class))
      return()
    
    # Depending on input$class, we'll generate a different
    # UI component and send it to the client.
    switch(input$class,
       
       # Text form
       "text" = wellPanel(
         tags$textarea(id="text_output", rows=3, cols=40, 
                       placeholder="Text output")
       ),
       
       # Command question form
       "cmd_question" = wellPanel(
         tags$textarea(id="cmd_output", rows=3, cols=40, 
                       placeholder="Question"),
         tags$textarea(id="cmd_correct_answer", rows=3, cols=40,
                       placeholder="Correct answer (a valid R expression)"),
         tags$textarea(id="cmd_answer_tests", rows=3, cols=40, 
                       placeholder="Answer tests (leave blank for default test)"),
         tags$textarea(id="cmd_hint", rows=3, cols=40, 
                       placeholder="Hint")
       ),
       
       # Multiple choice question form
       "mult_question" = wellPanel(
         tags$textarea(id="mult_output", rows=3, cols=40, 
                       placeholder="Question"),
         tags$textarea(id="mult_answer_choices", rows=3, cols=40,
                       placeholder="Answer choices (separated by semicolons)"),
         tags$textarea(id="mult_correct_answer", rows=3, cols=40,
                       placeholder="Correct answer (must match exactly one answer choice)"),
         tags$textarea(id="mult_hint", rows=3, cols=40, 
                       placeholder="Hint")
       ),
       
       # Numeric question
       "exact_question" = wellPanel(
         tags$textarea(id="num_output", rows=3, cols=40, 
                       placeholder="Question"),
         tags$textarea(id="num_correct_answer", rows=3, cols=40,
                       placeholder="Correct answer (a decimal number or integer)"),
         tags$textarea(id="num_hint", rows=3, cols=40, 
                       placeholder="Hint")
       ),
       
       # Text question
       "text_question" = wellPanel(
         tags$textarea(id="textq_output", rows=3, cols=40, 
                       placeholder="Question"),
         tags$textarea(id="textq_correct_answer", rows=3, cols=40,
                       placeholder="Correct answer (in words)"),
         tags$textarea(id="textq_hint", rows=3, cols=40, 
                       placeholder="Hint")
       ),
       
       # Video form
       "video" = wellPanel(
         tags$textarea(id="video_output", rows=3, cols=40, 
                       placeholder="Would you like to watch a video about <insert topic here> ?"),
         tags$textarea(id="video_link", rows=3, cols=40, 
                       placeholder="Video URL (http://youtu.be/S1tBTlrx0JY)")
       ),
       
       # Figure form
       "figure" = wellPanel(
         tags$textarea(id="fig_output", rows=3, cols=40, 
                       placeholder="Text output"),
         tags$textarea(id="figure", rows=3, cols=40, 
                       placeholder="my_figure.R"),
         selectInput("figure_type", "Figure type:",
                     choices = c("New" = "new", "Additional" = "add"))
       )
    )
  })
  
  counter <- 0
  
  observe({
    if(input$add == counter) {
      return()
    }
    
    # User pressed Add, so increment counter
    counter <<- counter + 1
    
    # Set up new unit
    unit <- switch(input$class,
       
       "text" = list(
         Output = input$text_output),
       
       "cmd_question" = list(
         Output = input$cmd_output,
         CorrectAnswer = input$cmd_correct_answer,
         AnswerTests = ifelse(identical(input$cmd_answer_tests, ""), 
                              paste0("omnitest(correctExpr=\'", 
                                     input$cmd_correct_answer, "\')"),
                              input$cmd_answer_tests),
         Hint = input$cmd_hint),
       
       "mult_question" = list(
         Output = input$mult_output,
         AnswerChoices = input$mult_answer_choices,
         CorrectAnswer = input$mult_correct_answer,
         AnswerTests = paste0('omnitest(correctVal="',
                              input$mult_correct_answer,
                              '")'),
         Hint = input$mult_hint),
       
       "exact_question" = list(
         Output = input$num_output,
         CorrectAnswer = input$num_correct_answer,
         AnswerTests = paste0('omnitest(correctVal="',
                              input$num_correct_answer,
                              '")'),
         Hint = input$num_hint),
       
       "text_question" = list(
         Output = input$textq_output,
         CorrectAnswer = input$textq_correct_answer,
         AnswerTests = paste0('omnitest(correctVal="',
                              input$textq_correct_answer,
                              '")'),
         Hint = input$textq_hint),
       
       "video" = list(
         Output = input$video_output,
         VideoLink = input$video_link),
       
       "figure" = list(
         Output = input$fig_output,
         Figure = input$figure,
         FigureType = input$figure_type)
    )
    
    content <- paste0(input$ace, "- Class: ", input$class, "\n  ",
                   paste0(names(unit), ": ", unit, collapse="\n  "),
                   "\n\n")
    
    updateAceEditor(session, "ace", theme="vibrant_ink", mode="yaml",
                    value=content)
    
    cat(content, file=getOption("swirlify_lesson_path"))   
  })
  
  # Return content without 'test' flag
  observe({
    if(input$done == 0) {
      return()
    }
    
    stopApp(list(input$ace, test=FALSE))
  })
  
  # Return content with 'test' flag
  observe({
    if(input$test == 0) {
      return()
    }
    stopApp(list(input$ace, test=TRUE))
  })
  
  # Just open help page, don't exit
  observe({
    if(input$help == 0) {
      return()
    }
    # Open browser help
    browseURL("http://swirlstats.com/instructors.html")
  })
})