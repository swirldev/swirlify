library(shiny)

shinyServer(function(input, output, session) {
  observeEvent(input$make_test_mult, {
    updateAceEditor(session, "ace_answer_tests", 
                    paste0("omnitest(correctVal='",input$ace_correct_answer ,"')"))
  })
  
  observeEvent(input$make_test_cmd, {
    updateAceEditor(session, "ace_answer_tests", 
                    paste0("omnitest(correctExpr='",input$ace_correct_answer ,"')"))
  })
  
  observeEvent(input$demo, {
    cat(input$ace, file = getOption("swirlify_lesson_file_path"))
    stopApp(list(demo = TRUE, demo_num = input$demo_num))
  })
  
  observeEvent(input$save, {
    cat(input$ace, file = getOption("swirlify_lesson_file_path"))
    updateAceEditor(session, "ace", 
      value = readChar(getOption("swirlify_lesson_file_path"),
        file.info(getOption("swirlify_lesson_file_path"))$size)
    )
  })
  
  observeEvent(input$add, {
    cat(input$ace, file = getOption("swirlify_lesson_file_path"))
    
    if(input$qt == "Message"){
      wq_message(input$ace_output)
    } else if(input$qt == "Command"){
      wq_command(input$ace_output, input$ace_correct_answer, 
                 input$ace_answer_tests, input$ace_hint)
    } else if(input$qt == "Multiple Choice"){
      wq_multiple(input$ace_output, input$ace_answer_choices, 
                  input$ace_correct_answer, 
                  input$ace_answer_tests, input$ace_hint)
    } else if(input$qt == "Figure"){
      wq_figure(input$ace_output, input$ace_fig, input$figure_type)
    } else if(input$qt == "Script"){
      wq_script(input$ace_output, input$ace_answer_tests, 
                input$ace_hint, input$ace_script)
    } else if(input$qt == "Video"){
      wq_video(input$ace_output, input$ace_url)
    } else if(input$qt == "Numerical"){
      wq_numerical(input$ace_output, 
                   input$ace_correct_answer, 
                   input$ace_answer_tests, input$ace_hint)
    } else if(input$qt == "Text"){
      wq_text(input$ace_output, 
              input$ace_correct_answer, 
              input$ace_answer_tests, input$ace_hint)
    }
    
    updateAceEditor(session, "ace", 
      value = readChar(getOption("swirlify_lesson_file_path"),
        file.info(getOption("swirlify_lesson_file_path"))$size))
  })
  
  observeEvent(input$selectnone, {
    updateCheckboxGroupInput(session, inputId = "autofill", 
                             choices = c("Output", "Correct Answer",
                               "Answer Tests", "Hint",
                               "Answer Choices", "Figure",
                               "Script", "URL"))
  })
  
  observeEvent(input$selectall, {
    updateCheckboxGroupInput(session, inputId = "autofill", 
                             choices = c("Output", "Correct Answer",
                                         "Answer Tests", "Hint",
                                         "Answer Choices", "Figure",
                                         "Script", "URL"),
                             selected = c("Output", "Correct Answer",
                                          "Answer Tests", "Hint",
                                          "Answer Choices", "Figure",
                                          "Script", "URL"))
  })
  
  output$ui <- renderUI({
    if (is.null(input$qt))
      return()
    
    boilerplate <- c("Output" = "Type your text output here.",
                     "Correct Answer" = "Expression or Value",
                     "Answer Tests" = "omnitest(correctExpr='EXPR', correctVal=VAL)",
                     "Hint" = "Type a hint.",
                     "Answer Choices" = "ANS;2;3",
                     "Figure" = "sourcefile.R",
                     "Script" = "script-name.R",
                     "URL" = "http://address.of.video")
    
    for(i in names(boilerplate)){
      if(!(i %in% input$autofill)){
        boilerplate[i] <- ""
      }
    }
    
    switch(input$qt,
           "Message" = list(h4("Output"), 
                            aceEditor("ace_output", 
                                      height = "120px", 
                                      value = boilerplate["Output"],
                                      debounce = 500)
                            ),
           
           "Command" = list(h4("Output"), 
                            aceEditor("ace_output", 
                                      height = "120px", 
                                      value = boilerplate["Output"],
                                      debounce = 500),
                            h4("Correct Answer"),
                            aceEditor("ace_correct_answer", 
                                      height = "30px", 
                                      value = boilerplate["Correct Answer"],
                                      debounce = 500),
                            h4("Answer Tests"),
                            aceEditor("ace_answer_tests", 
                                      height = "30px", 
                                      value = boilerplate["Answer Tests"],
                                      debounce = 500),
                            actionButton("make_test_cmd", "Make Answer Test from Correct Answer"),
                            h4("Hint"),
                            aceEditor("ace_hint", 
                                      height = "120px", 
                                      value = boilerplate["Hint"],
                                      debounce = 500)
                            ),
           
           "Multiple Choice" = list(h4("Output"), 
                                    aceEditor("ace_output", 
                                              height = "120px", 
                                              value = boilerplate["Output"],
                                              debounce = 500),
                                    h4("Answer Choices"),
                                    aceEditor("ace_answer_choices", 
                                              height = "30px", 
                                              value = boilerplate["Answer Choices"],
                                              debounce = 500),
                                    h4("Correct Answer"),
                                    aceEditor("ace_correct_answer", 
                                              height = "30px", 
                                              value = boilerplate["Correct Answer"],
                                              debounce = 500),
                                    h4("Answer Tests"),
                                    aceEditor("ace_answer_tests", 
                                              height = "30px", 
                                              value = boilerplate["Answer Tests"],
                                              debounce = 500),
                                    actionButton("make_test_mult", "Make Answer Test from Correct Answer"),
                                    h4("Hint"),
                                    aceEditor("ace_hint", 
                                              height = "120px", 
                                              value = boilerplate["Hint"],
                                              debounce = 500)
                                    ),
           
           "Numerical" = list(h4("Output"), 
                              aceEditor("ace_output", 
                                        height = "120px", 
                                        value = boilerplate["Output"],
                                        debounce = 500),
                              h4("Correct Answer"),
                              aceEditor("ace_correct_answer", 
                                        height = "30px", 
                                        value = boilerplate["Correct Answer"],
                                        debounce = 500),
                              h4("Hint"),
                              aceEditor("ace_hint", 
                                        height = "120px", 
                                        value = boilerplate["Hint"],
                                        debounce = 500)
                              ),
           
           "Text" = list(h4("Output"), 
                         aceEditor("ace_output", 
                                   height = "120px", 
                                   value = boilerplate["Output"],
                                   debounce = 500),
                         h4("Correct Answer"),
                         aceEditor("ace_correct_answer", 
                                   height = "30px", 
                                   value = boilerplate["Correct Answer"],
                                   debounce = 500),
                         h4("Hint"),
                         aceEditor("ace_hint", 
                                   height = "120px", 
                                   value = boilerplate["Hint"],
                                   debounce = 500)
                         ),
           
           "Video" = list(h4("Output"), 
                          aceEditor("ace_output", 
                                    height = "120px", 
                                    value = boilerplate["Output"],
                                    debounce = 500),
                          h4("URL"),
                          aceEditor("ace_url", 
                                    height = "30px", 
                                    value = boilerplate["URL"],
                                    debounce = 500)
           ),
           
           "Figure" = list(
             h4("Output"),
             aceEditor("ace_output", 
                       height = "120px", 
                       value = boilerplate["Output"],
                       debounce = 500),
             h4("Figure"),
             aceEditor("ace_fig", 
                       height = "30px", 
                       value = boilerplate["Figure"],
                       debounce = 500),
             selectInput("figure_type", "Figure type:",
                         choices = c("New" = "new", "Additional" = "add"))
           ),
           
           "Script" = list(
             h4("Output"),
             aceEditor("ace_output", 
                       height = "120px", 
                       value = boilerplate["Output"],
                       debounce = 500),
             h4("Answer Tests"),
             aceEditor("ace_answer_tests", 
                       height = "30px", 
                       value = boilerplate["Answer Tests"],
                       debounce = 500),
             h4("Hint"),
             aceEditor("ace_hint", 
                       height = "120px", 
                       value = boilerplate["Hint"],
                       debounce = 500),
             h4("Script"),
             aceEditor("ace_script", 
                       height = "30px", 
                       value = boilerplate["Script"],
                       debounce = 500)
           )
    )
  })
})