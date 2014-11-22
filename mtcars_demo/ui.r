library(shiny)
shinyUI(fluidPage(
  titlePanel("demo of two plots"),
  flowLayout(
      ggvisOutput("myplot1"),
      ggvisOutput("myplot2"), 
      textInput("selected", "Selected row:", "2")
  )
))