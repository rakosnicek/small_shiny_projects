# User Interface
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("T-test Sample Size Calculator"),
  
  # Sidebar with inputs
  sidebarPanel(   
    textInput(inputId = "power", label = "Power of test (1 minus Type II error probability)", value = "0.9"),
    textInput(inputId = "sig.level", label = "Significance level (Type I error probability)", value = "0.05"),
    textInput(inputId = "delta", label = "True difference in means (sd=1)", value = "1")
  ),
  
  # Main panel with outputs
  mainPanel(
    h3(textOutput("sample.calculation"))
  )  
  
))
