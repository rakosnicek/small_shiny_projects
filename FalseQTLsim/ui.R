library(qtl)
library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel(""),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    # cross type
    radioButtons("ctype", "Cross type:",
                 list("Intercross " = "f2",
                      "Backcross" = "bc",
                      "Sib-mating RIS" = "risib")),
    br(),
    
    #Number of chromosomes
    sliderInput("nchr", "Number of chromosomes:", 
                min=2, max=30, value=20, step=1),
    
    # Length of chromosome
    sliderInput("chrlen", "Length of chromosome in cM:", 
                min = 10, max = 200, value = 100),
    
    # Number of markers
    sliderInput("nmr", "Number of markers:",
                min = 2, max = 100, value = 10),
    
    # Number of individuals
    sliderInput("nind", "Number of individuals:", 
                min = 10, max = 1000, value = 250),
    
    
    # Heretability
    sliderInput("her", "Heretability (% explained by genetic factors):",  
                min = 1, max = 99, value = 50),
    
    # Ylim
    sliderInput("ylim", "Range of y-axis:",  
                min = 0, max = 10, value = c(0,5)),
    br(),
    
    actionButton("button", "Update View")
  ),
  
  # Show a table summarizing the values entered
  mainPanel(
    div(plotOutput("lodplot", width="800px", height="500px"), align="center")
  )
))
