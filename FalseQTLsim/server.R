require(shiny)
require(MASS)
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
  
  o <- estVC(y=cross$pheno$Y, v=list(AA=2*K2, DD=NULL, HH=NULL, AD=NULL, MH=NULL, EE=diag(nind(cross))))

  scanOne(y=cross$pheno$Y, gdat=t(A), vc=o)
}

scanone.regress <- function(cross) {
  require(regress)
  tmp <- lapply(cross$geno, function(x) x[[1]])
  A <- t(do.call("cbind", tmp))
  K2 <- matrix(0, nind(cross), nind(cross))
  countmar <- sum(nmar(cross))
  for (i in 1:(nind(cross)-1))
    for (j in (i+1):nind(cross))
      K2[i,j] <-K2[j,i] <- 1-sum(abs(A[,i]-A[,j]))/(2*countmar)
  diag(K2) <- 1
  
  fit <- regress(cross$pheno$Y ~ 1, ~K2)
  cross$pheno$Y <- cross$pheno$Y - fit$predicted
  scanone(cross)
}

lodplot <- function(nchr, chrlen, nmar, nind, her, ctype, ylim, button, itype, htype, qtlpos, qtlsize, trhold) {
  
  # set random number generation to number of button clicks 
  set.seed(round(1000*button*pi %% 100000))

  # generate random map and random fake cross
  map <- sim.map(len=rep(chrlen, nchr), n.mar=nmar)
  fake <- sim.cross(map, type=ctype, n.ind=nind, model = NULL)
  
  if (htype=="kinship") {
    # genetic is proportional to A-fouder genome
    genetic <- apply(sapply(fake$geno,function(x) apply(x[[1]], 1, sum)), 1, sum)
  } else {
    # calculate kinship matrix
    tmp <- lapply(fake$geno, function(x) x[[1]])
    A <- t(do.call("cbind", tmp))
    K2 <- matrix(0, nind(fake), nind(fake))
    countmar <- sum(nmar(fake))
    for (i in 1:(nind(fake)-1))
      for (j in (i+1):nind(fake))
        K2[i,j] <-K2[j,i] <- 1-sum(abs(A[,i]-A[,j]))/(2*countmar)
    diag(K2) <- 1
    
    genetic <- mvrnorm(n = 1, rep(0,nind), K2)
  }
  noise <- rnorm(nind, sd=sqrt(100/her-1))
  fake$pheno <- data.frame(Y = genetic + noise)
  
  # add QTL
  mnumber <- round((nchr*nmar-1)*qtlpos)
  qtlchr <- mnumber %/% nmar + 1
  qtlchrpos <- mnumber %% nmar + 1
  fake$pheno$Y <- fake$pheno$Y + (fake$geno[[qtlchr]][[1]][,qtlchrpos]==1)*sd(fake$pheno$Y)*sqrt(qtlsize)
  
  # make scanone lod-plot
  fake <- calc.genoprob(fake)
  if (itype=="qtl") {
    output.scanone <- scanone(fake)    
  } else {
    if (itype=="QTLRel") {
      pv <- scanone.qtlrel(fake)
      output.scanone <- scanone(calc.genoprob(fake))
      output.scanone[,3] <-  pv$p/(2 * log(10))
    } else {
      output.scanone <- scanone.regress(fake)
    }  
  }
  plot(output.scanone, ylim=ylim)

  if (trhold) {
    threshold <- summary(scanone(fake, n.perm = 100, verbose=FALSE), alpha=0.05)
    abline(h = threshold, col="red", lty=2)
  }
  
  
}

shinyServer(function(input, output) {
  
  output$lodplot <- renderPlot({        
    # make genotype plot
    lodplot(as.integer(input$nchr), as.numeric(input$chrlen), 
            as.integer(input$nmr), as.integer(input$nind), as.numeric(input$her), 
            input$ctype, input$ylim, input$button, input$itype, input$htype, input$qtlpos, input$qtlsize, input$trhold)
  })
  
})
