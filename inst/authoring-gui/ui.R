library(shiny)

shinyUI(bootstrapPage(
  
  # Lesson name will go here
  headerPanel("swirl content authoring tool"),
  
  # Select unit class
  sidebarPanel(
    
    tags$link(
      rel = "stylesheet", 
      href = "http://fonts.googleapis.com/css?family=Source+Sans+Pro"
    ),
    
    tags$style("body { font-family: 'Source Sans Pro', sans-serif; }",
               "h1 { color: #3399ff; }",
               "button { font-family: inherit; }",
               "textarea { font-family: 'Courier New'; }",
               "select { font-family: inherit; }",
               "#addit { color: #3399ff; }",
               "#done { color: black; }",
               "#test { color: #32cd32; }",
               "#help { color: red; }"
    ),
    
    tags$h4("Instructions:"),
    
    helpText(tags$ol(tags$li("Select a content type."),
                     tags$li("Complete the form."),
                     tags$li("Press the ", strong("Add it!"), " button."),
                     tags$li("Press the ", strong("Test it!"), 
                             " button to run your lesson in swirl."),
                     tags$li("Repeat steps 1-4 until satisfied."),
                     tags$li("Press", strong("I'm done!"), 
                             " to exit the authoring tool."),
                     tags$li("Press", strong("Help me!"), 
                             " to get more help."))),
    
    hr(),
    
    helpText(tags$em(tags$sm(
      "NOTE: If you're using a Mac, make sure Smart Quotes",
      "are disabled by right-clicking inside of one of the",
      "form fields below, and unchecking the Smart",
      "Quotes option (under Substitutions).",
      "It's also possible to turn this feature off globally",
      "from System Preferences."))),
    
    hr(),
    
    # Select unit class
    selectInput("class", "Content type:",
                choices = c("Text" = "text", 
                            "Question - R Command" = "cmd_question",
                            "Question - Multiple Choice" = "mult_question",
                            "Question - Exact Numerical" = "exact_question",
                            "Question - Text" = "text_question",
                            "Video" = "video", 
                            "Figure" = "figure")
    ),
        
    textOutput("description")
  ),
  
  # Display appropriate form based on unit class
  mainPanel(
    
    # Output current unit class selected for testing purposes
    # 		verbatimTextOutput("unitClass"),
    
    # Text form
    conditionalPanel(
      condition = "input.class == 'text'",
      tags$textarea(id="text_output", rows=3, cols=40, 
                    placeholder="Text output")
    ),
    
    # Command question form
    conditionalPanel(
      condition = "input.class == 'cmd_question'",
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
    conditionalPanel(
      condition = "input.class == 'mult_question'",
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
    conditionalPanel(
      condition = "input.class == 'exact_question'",
      tags$textarea(id="num_output", rows=3, cols=40, 
                    placeholder="Question"),
      tags$textarea(id="num_correct_answer", rows=3, cols=40,
                    placeholder="Correct answer (a decimal number or integer)"),
      tags$textarea(id="num_hint", rows=3, cols=40, 
                    placeholder="Hint")
    ),
    
    # Text question
    conditionalPanel(
      condition = "input.class == 'text_question'",
      tags$textarea(id="textq_output", rows=3, cols=40, 
                    placeholder="Question"),
      tags$textarea(id="textq_correct_answer", rows=3, cols=40,
                    placeholder="Correct answer (in words)"),
      tags$textarea(id="textq_hint", rows=3, cols=40, 
                    placeholder="Hint")
    ),
    
    # Video form
    conditionalPanel(
      condition = "input.class == 'video'",
      tags$textarea(id="video_output", rows=3, cols=40, 
                    placeholder="Would you like to watch a video about <insert topic here> ?"),
      tags$textarea(id="video_link", rows=3, cols=40, 
                    placeholder="Video URL (http://youtu.be/S1tBTlrx0JY)")
    ),
    
    # Figure form
    conditionalPanel(
      condition = "input.class == 'figure'",
      tags$textarea(id="fig_output", rows=3, cols=40, 
                    placeholder="Text output"),
      tags$textarea(id="figure", rows=3, cols=40, 
                    placeholder="my_figure.R"),
      selectInput("figure_type", "Figure type:",
                  choices = c("New" = "new", "Additional" = "add"))
    ),
    
    # Button to add unit
    actionButton("addit", "Add it!"),
    
    # Button to test lesson
    actionButton("test", "Test it!"),
    
    # Button to close the authoring tool
    actionButton("done", "I'm done!"),
    
    # Help button
    actionButton("help", "Help me!")
  )
))