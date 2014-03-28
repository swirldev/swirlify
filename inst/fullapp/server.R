library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {
  
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
    
    unit <- paste0(input$ace, "- Class: ", input$class, "\n  ",
                   paste0(names(unit), ": ", unit, collapse="\n  "),
                   "\n\n")
    
    updateAceEditor(session, "ace", theme="vibrant_ink", mode="yaml",
                    value=unit)
    
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