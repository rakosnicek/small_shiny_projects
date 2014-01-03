require(shiny)
require(qtl)

lodplot <- function(nchr, chrlen, nmar, nind, her, ctype, ylim, button) {
  
  # set random number generation to number of button clicks 
  set.seed(round(1000*button*pi %% 100000))
  
  # generate random map and random fake cross
  map <- sim.map(len=rep(chrlen, nchr), n.mar=nmar)
  fake <- sim.cross(map, type=ctype, n.ind=nind, model = NULL)
  
  # genetic is proportional to A-fouder genome
  genetic <- apply(sapply(fake$geno,function(x) apply(x[[1]], 1, sum)), 1, sum)
  noise <- rnorm(nind, sd=sd(genetic) * sqrt(100/her-1))
  fake$pheno <- data.frame(Y = genetic + noise)
  
  # make scanone lod-plot
  fake <- calc.genoprob(fake)
  plot(scanone(fake), ylim=ylim)

}

shinyServer(function(input, output) {
  
  output$lodplot <- renderPlot({        
    # make genotype plot
    lodplot(as.integer(input$nchr), as.numeric(input$chrlen), 
            as.integer(input$nmr), as.integer(input$nind), as.numeric(input$her), 
            input$ctype, input$ylim, input$button)
  })
  
})
