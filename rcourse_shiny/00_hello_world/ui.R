# User Interface
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Minimal Shiny App"),
  
  # Sidebar with inputs
  sidebarPanel(   
    textInput(inputId = "name", label = "Your name:", value = "World")
  ),
  
  # Main panel with outputs
  mainPanel(
    textOutput("greeting")
  )  
  
))
