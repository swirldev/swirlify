library(shiny)

shinyServer(function(input, output) {
  
  # When select button is pressed, it's value increments to 1
  observe({
    if(input$select == 0) {
      return()
    }
  
    file_path <- file.choose()
    file.copy(file_path, "~/Desktop/")
  })
})
