# User Interface
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Better T-test Sample Size Calculator"),
  
  # Sidebar with inputs
  sidebarPanel(   
    sliderInput(inputId = "power", label = "Power of test (1 minus Type II error probability)", min=0.5, max=1, value = 0.9, step=0.01),
    sliderInput(inputId = "sig.level", label = "Significance level (Type I error probability)", min=0, max=0.5, value = 0.05, step=0.01),
    sliderInput(inputId = "delta", label = "True difference in means (sd=1)", min=0.001, max=5, value = 1),
    selectInput(inputId = "type", label = "Type of t test", choices = c("two.sample", "one.sample", "paired"), selected = "two.sample"),
    radioButtons(inputId = "alternative", label = "One- or two-sided test", choices = c("two.sided", "one.sided"), selected = "two.sided"),
    checkboxInput(inputId = "strict", label = "Use strict interpretation in two-sided case", value = FALSE)
  ),
  
  # Main panel with outputs
  mainPanel(
    verbatimTextOutput("sample.calculation")
  )  
  
))
