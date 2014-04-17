# User Interface
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("T-test simulation"),
  
  # Sidebar with inputs
  sidebarPanel(   
    sliderInput(inputId = "Nsim", label = "Number of simulation", min=10, max=500, value = 100),
    sliderInput(inputId = "n", label = "Number of observations in each group", min=3, max=100, value = 10),
    sliderInput(inputId = "delta", label = "True difference in means (sd=1)", min=0.001, max=5, value = 0.5)
  ),
  
  # Main panel with outputs
  mainPanel(
    imageOutput("sim.histogram")
  )  
  
))
