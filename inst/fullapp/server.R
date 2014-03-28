library(shiny)
library(shinyAce)

shinyServer(function(input, output, session) {

  counter <- 0
  
  observe({
    if(input$add == counter) {
      return()
    }
    
    # User pressed Add, so increment counter
    counter <<- counter + 1
    
    temp <- paste0(input$ace, input$textout, "\n\n")
    
    updateAceEditor(session, "ace", theme="twilight", mode="yaml",
                    value=temp)
    
  })
  
  observe({
    if(input$done == 0) {
      return()
    }
    
    stopApp(input$ace)
  })
  
})