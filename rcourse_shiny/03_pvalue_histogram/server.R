# Server Computation (input -> output)

simulate.p <- function(Nsim, n, delta) {
  pvalues <- rep(NA, Nsim)
  for (i in 1:Nsim) {
    sample1 <- rnorm(n)
    sample2 <- rnorm(n) + delta
    pvalues[i] <- t.test(sample1, sample2)$p.value
  }
  return(pvalues)
}

shinyServer(function(input, output) {
  output$sim.histogram <- renderPlot(hist(simulate.p(Nsim = input$Nsim,
                                          n = input$n,
                                          delta = input$delta), main="Histogram of p-values"))
})
