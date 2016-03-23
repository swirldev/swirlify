library(shiny)
library(shinyAce)

shinyUI(navbarPage("swirlify 0.5",
  tabPanel("Editor",
    fluidRow(
      column(6,
        selectInput("qt", label = h3("Question Type"), 
          choices = c("Message", "Command", "Multiple Choice",
            "Figure", "Script", "Video", "Numerical",
            "Text"), 
          selected = "Message"),
        uiOutput("ui"),
        submitButton("Add Question")
      ),
      column(6,
        aceEditor("ace")
      )
    )
  ),
  tabPanel("Help")
))