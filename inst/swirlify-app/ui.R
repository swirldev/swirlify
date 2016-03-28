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
        actionButton("add", "Add Question")
      ),
      column(6,
        aceEditor("ace", value = readChar(getOption("swirlify_lesson_file_path"),
                  file.info(getOption("swirlify_lesson_file_path"))$size), mode = "yaml",
                  debounce = 100),
        actionButton("save", "Save Lesson"),
        actionButton("demo", "Demo Lesson")
      )
    )
  ),
  tabPanel("Options",
           h2("Auto-fill"),
           checkboxGroupInput("autofill", label = NULL,
                              c("Output", "Correct Answer",
                                "Answer Tests", "Hint",
                                "Answer Choices", "Figure",
                                "Script", "URL"),
                              c("Output", "Correct Answer",
                                "Answer Tests", "Hint",
                                "Answer Choices", "Figure",
                                "Script", "URL"),
                              ),
           actionButton("selectall", "Select All"),
           actionButton("selectnone", "Select None")
           ),
  tabPanel("Help")
))