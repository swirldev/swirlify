library(shiny)

shinyUI(bootstrapPage(
  
  # Lesson name will go here
  headerPanel("add dataset"),
  
  # Select unit class
  sidebarPanel(
    
    actionButton("select", "Select file!")
  )
))