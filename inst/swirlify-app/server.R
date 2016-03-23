library(shiny)

shinyServer(function(input, output, session) {
  output$ui <- renderUI({
    if (is.null(input$qt))
      return()
    
    switch(input$qt,
           "Message" = textInput("output", "Output", width = "100%", placeholder = "Type your text output here."),
           "Command" = list(
             textInput("output", "Output", width = "100%", placeholder = "Explain what the user must do here."),
             textInput("correct_answer", "Correct Answer", width = "100%", placeholder = "Expression or Value"),
             textInput("answer_tests", "Answer Tests", width = "100%", value = "omnitest(correctExpr='EXPR', correctVal=VAL)"),
             textInput("hint", "Hint", width = "100%", placeholder = "A hint.")
           )
    )
  })
  

  
})