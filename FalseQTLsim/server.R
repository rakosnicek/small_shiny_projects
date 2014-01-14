require(shiny)
require(QTLRel)
require(qtl)

scanone.qtlrel <- function(cross) {
  tmp <- lapply(cross$geno, function(x) x[[1]])
  A <- t(do.call("cbind", tmp))
  K2 <- matrix(0, nind(cross), nind(cross))
  countmar <- sum(nmar(cross))
  for (i in 1:(nind(cross)-1))
    for (j in (i+1):nind(cross))
      K2[i,j] <-K2[j,i] <- 1-sum(abs(A[,i]-A[,j]))/(2*countmar)
  diag(K2) <- 1
  
  o <- estVC(y=cross$pheno$Y, v=list(AA=K2, DD=NULL, HH=NULL, AD=NULL, MH=NULL, EE=diag(nind(cross))))

  scanOne(y=cross$pheno$Y, gdat=t(A), vc=o)
}

lodplot <- function(nchr, chrlen, nmar, nind, her, ctype, ylim, button, itype, qtlpos, qtlsize) {
  
  # set random number generation to number of button clicks 
  set.seed(round(1000*button*pi %% 100000))

  # generate random map and random fake cross
  map <- sim.map(len=rep(chrlen, nchr), n.mar=nmar)
  fake <- sim.cross(map, type=ctype, n.ind=nind, model = NULL)
  
  # genetic is proportional to A-fouder genome
  genetic <- apply(sapply(fake$geno,function(x) apply(x[[1]], 1, sum)), 1, sum)
  noise <- rnorm(nind, sd=sd(genetic) * sqrt(100/her-1))
  fake$pheno <- data.frame(Y = genetic + noise)
  
  # add QTL
  mnumber <- round((nchr*nmar-1)*qtlpos)
  qtlchr <- mnumber %/% nmar + 1
  qtlchrpos <- mnumber %% nmar + 1
  fake$pheno$Y <- fake$pheno$Y + (fake$geno[[qtlchr]][[1]][,qtlchrpos]==1)*sd(fake$pheno$Y)*sqrt(qtlsize)
  #fake$pheno$Y <- fake$pheno$Y + (fake$geno[[11]][[1]][,1]==1)*sd(fake$pheno$Y)*sqrt(3/4)
  
  # make scanone lod-plot
  if (itype=="qtl") {
    fake <- calc.genoprob(fake)
    output.scanone <- scanone(fake)    
  } else {
    pv <- scanone.qtlrel(fake)
    output.scanone <- scanone(calc.genoprob(fake))
    output.scanone[,3] <-  pv$p/(2 * log(10))
  }
  plot(output.scanone, ylim=ylim)

  fake
}

shinyServer(function(input, output) {
  
  output$lodplot <- renderPlot({        
    # make genotype plot
    lodplot(as.integer(input$nchr), as.numeric(input$chrlen), 
            as.integer(input$nmr), as.integer(input$nind), as.numeric(input$her), 
            input$ctype, input$ylim, input$button, input$itype, input$qtlpos, input$qtlsize)
  })
  
})
