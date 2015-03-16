require(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(""),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    div(HTML('<p><img src="network.gif" width="200px"></p>')),
    hr(),
    
    sliderInput("ac", "r(A,C)", 
                min = 0, max = 1, value = 0.8, step= 0.05),
    hr(),
    
    sliderInput("bc", "r(B,C)", 
                min = 0, max = 1, value = 0.8, step= 0.05),
    hr(),
    
    sliderInput("cz", "r(C,Z)", 
                min = 0, max = 1, value = 0.7, step= 0.05),
    hr(),
    
    sliderInput("ax", "r(A,X)", 
                min = 0, max = 1, value = 0.9, step= 0.05),
    hr(),
    
    sliderInput("by", "r(B,Y)", 
                min = 0, max = 1, value = 0.9, step= 0.05),
    hr(),
    
    div(a("Petr Simecek", href="https://github.com/simecek/small_shiny_projects"))
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    
    h3("Calculated correlations:"),
    
    textOutput("rAB"), br(),
    textOutput("rXZ"),
    textOutput("rYZ"), 
    textOutput("rXY"), br(),
    
    textOutput("rXYgZ")
  )    
  
))