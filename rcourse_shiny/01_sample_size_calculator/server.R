# Server Computation (input -> output)

minimal.sample <- function(power, sig.level, delta) {
  n <- power.t.test(power=power, sig.level=sig.level, delta=delta)$n
  output <- paste("Minimal number of observations in each group:", ceiling(n))
  return(output)
}

shinyServer(function(input, output) {
  output$sample.calculation <- renderText(minimal.sample(power = as.numeric(input$power),
                                              sig.level = as.numeric(input$sig.level),
                                              delta = as.numeric(input$delta)))
})
