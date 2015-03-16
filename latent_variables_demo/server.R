library(shiny)

options(digits = 3)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$rAB <- renderText({paste("r(A,B) =", input$ac * input$bc)})
  
  output$rXZ <- renderText({paste("r(X,Z) = r(A,X) * r(A,C) * r(C,Z) =", 
                                  format(input$ax * input$ac * input$cz, digits=4))})
  output$rYZ <- renderText({paste("r(Y,Z) = r(B,Y) * r(B,C) * r(C,Z) =", 
                                  format(input$by * input$bc * input$cz, digits=4))})
  output$rXY <- renderText({paste("r(X,Y) = r(A,X) * r(A,C) * r(B,C) * r(B,Y) =", 
                                  format(input$ax * input$ac * input$bc * input$by, digits=4))})
  
  output$rXYgZ <- renderText({paste("r(X,Y|Z) = [r(X,Y) - r(X,Z) * r(Y,Z)] / [sqrt(1-r(X,Z)^2)*sqrt(1-r(Y,Z)^2)] =", 
                                    format((input$ax * input$ac * input$bc * input$by - 
                                       input$ax * input$ac * input$cz * input$by * input$bc * input$cz)/
                                       sqrt((1-(input$ax * input$ac * input$cz)^2)*(1-(input$by * input$bc * input$cz)^2)), digits=4) )})
  
})