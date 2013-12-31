require(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(""),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    sliderInput("age", "Věk stromku:", 
                min = 1, max = 9, value = 5, step= 1),
    br(),
    
    sliderInput("age2", "Věk váš:", 
                min = 1, max = 100, value = 18, step= 1),
    br(),
    
    checkboxInput("Xmas", "ať je vánoční", FALSE),
    checkboxInput("drunk", "jsem opilý", FALSE),
    checkboxInput("math", "jsem matematik", FALSE),
    checkboxInput("myth", "globální oteplování neexistuje", FALSE),
    br(), br(),
    
    div(HTML('<p><img src="logo2.png" width="100%"></p>')),
    br(),
    
    div(a("Petr Šimeček", href="http://applyr.blogspot.com"),
        ", inspired by ",
        a("Wiekvoet", href="http://wiekvoet.blogspot.com/2013/12/merry-christmas.html"),
        ", powered by ", a("R", href="http://www.r-project.org/"),
        " and ",a("Shiny", href="http://www.rstudio.com/shiny/"),
        ", source on ", a("Github", href="https://github.com/rakosnicek"))
    
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
 
        div(HTML(paste0('<font face="Bookman", size=7><u>',
             textOutput("wish"),
             '</u></font>')), align="center"),
        br(),br(),
        div(plotOutput("treeplot", width="600px", height="600px"), align="center")
  )    
    
))
