library(shiny)
library(shinyAce)

modes <- getAceModes()

themes <- getAceThemes()

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
shinyUI(
  pageWithSidebar(
  # Application title
  headerPanel("swirlify authoring tool"),
  
  sidebarPanel(
    textInput("textout", "Text: "),
    actionButton("add", "Add it!"),
    actionButton("done", "I'm done!")
  ),
  
  # Show the simple table
  mainPanel(
    aceEditor("ace", theme="twilight", mode="yaml",
              value=paste("- Class: meta",
              "  Course: your course name here",
              "  Lesson: Your lesson name here",
              "  Author: Your name goes here",
              "  Type: Standard",
              "  Organization: Your organization goes here (optional)",
              "  Version: 5.5.5\n\n", sep="\n")
              )
  )
))