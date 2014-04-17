# Server Computation (input -> output)

minimal.sample <- function(power, sig.level, delta, type, alternative, strict) {
  output <- power.t.test(power=power, sig.level=sig.level, delta=delta, type=type, alternative=alternative, strict=strict)
  return(output)
}

shinyServer(function(input, output) {
  output$sample.calculation <- renderPrint(minimal.sample(power = input$power,
                                          sig.level = input$sig.level,
                                          delta = input$delta,
                                          type = input$type,
                                          alternative = input$alternative,               
                                          strict = input$strict))
})
