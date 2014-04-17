# Server Computation (input -> output)

shinyServer(function(input, output) {
  output$greeting <- renderText(paste0("Hello ", input$name, "!"))
})
