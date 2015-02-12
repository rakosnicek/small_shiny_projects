library(shiny)
library(ggvis)

shinyUI(fluidPage(
  flowLayout(
      ggvisOutput("myplot1"),
      ggvisOutput("myplot2"), 
      textInput("selected", "Selected row:", "2")
  )
))