library(shiny)

pal1 <- c("royalblue3","orangered3", 'green', 'darkgreen', 'brown', "springgreen", "gold")
pal2 <- c("peachpuff3","slategray3", 'yellow4', 'khaki3', 'rosybrown4', "yellow3", "orange3")

# recursively plots the tree
segplot <- function(tree, Xmas, pal) {
  if (is.null(tree)) return()
  segments(tree$x0,tree$y0,tree$x1,tree$y1,
           col=tree$col,
           lwd=tree$lwd)
  segplot(tree$branch1, Xmas, pal)
  segplot(tree$branch2, Xmas, pal)
  segplot(tree$extend, Xmas, pal)
  if (Xmas & runif(1)<0.1/3^tree$depth & is.null(tree$extend)) 
    points(x=tree$x1, y=tree$y1, col=sample(pal[1:2], 1), pch=19, cex=2)
}

# add one step to branching
grow <- function(tree, math, crippled, pal) {
  if (is.null(tree) ) return(NULL)
  
  tree$lwd = tree$lwd*1.2
  
  if (tree$lwd>2.5) tree$col <- pal[5]
  if (is.null(tree$extend)) {
    tree$extend <- list(
      x0=tree$x1,
      y0=tree$y1,
      x1=tree$x1*math + rnorm(1,1-0.3*math,.03)*(tree$x1*(!math)+tree$x1-tree$x0),
      y1=tree$y1*math*(1+0.2*(tree$x1==tree$x0)) -0.2*tree$y1*crippled+ (rnorm(1,.98-0.5*math,.02)+.02*(tree$x1==tree$x0))*(tree$y1*(!math)+tree$y1-tree$y0),
      branch1=NULL,
      branch2=NULL,
      extend=NULL,
      lwd=1,
      depth=tree$depth,
      col=tree$col
    )
    length=sqrt((tree$x1-tree$x0)^2 + (tree$y1-tree$y0)^2)
    angle <- asin((tree$x1-tree$x0)/length)
    branch <- list(
      x0=0,
      y0=0,
      branch1=NULL,
      branch2=NULL,
      extend=NULL,
      lwd=1,
      depth=tree$depth,
      col=tree$col
    )
    shift <- rnorm(2,.5,.1)
    branch$x0 <- shift[1]*tree$x1+(1-shift[1])*tree$x0
    branch$y0 <- shift[1]*tree$y1+(1-shift[1])*tree$y0
    length=length*rnorm(1,.5-0.05*math,.05)
    if (!math) co <- runif(1,.35,.45) else co <- pi/2
    branch$x1 <- branch$x0+sin(angle+co)*length
    branch$y1 <- branch$y0+cos(angle+co)*length
    tree$branch1 <- branch
    branch$x0 <- shift[2]*tree$x1+(1-shift[2])*tree$x0
    branch$y0 <- shift[2]*tree$y1+(1-shift[2])*tree$y0
    if (!math) co <- runif(1,.35,.45) else co <- pi/2
    branch$x1 <- branch$x0+sin(angle-co)*length
    branch$y1 <- branch$y0+cos(angle-co)*length
    tree$branch2 <- branch    
  } else {
    tree$branch1 <- grow(tree$branch1, math, crippled, pal)
    tree$branch2 <- grow(tree$branch2, math, crippled, pal)
    tree$extend <- grow(tree$extend, math, crippled, pal)
  }
  tree$depth <- tree$depth+1
  if (tree$depth>2)  tree$col <- pal[3]
  if (tree$depth>4)  tree$col <- pal[4]
  if (tree$depth>6)  tree$col <- pal[5]
  
  tree
}

tree.height <- function(tree) {
  h = max(tree$y0, tree$y1)
  if (!is.null(tree$branch1)) h = max(h, tree.height(tree$branch1))
  if (!is.null(tree$branch2)) h = max(h, tree.height(tree$branch2))
  if (!is.null(tree$extend)) h = max(h, tree.height(tree$extend))
  h
}

mytreeplot <- function(N, seed, double, math, Xmas, crippled) {
  
  if (!crippled) {
    pal <- pal1
  } else {
    pal <- pal2
  }
  
  set.seed(seed)
  tree <- list(x0=0,y0=0,x1=0,y1=1,
               branch1=NULL,branch2=NULL,extend=NULL,
               lwd=1,depth=0,col=pal[6])
  for (i in 1:N) tree <- grow(tree, math, crippled, pal)
  par(mar=c(0,0,0,0))
  if (double) par(mfrow=c(1,2))
  
  # drawing tree(s)
  plot(x=c(-3,3), y=c(0,10.5), type='n', axes=FALSE, xlab="", ylab="")
  set.seed(seed)
  segplot(tree, Xmas, pal)
  if (Xmas) {
    h = min(tree.height(tree), 10.6)
    xstar = c(0, 0.0725, 0.2975, 0.1175, 0.1825, 0, -0.1825, -0.1175, -0.2975, -0.0725)
    ystar = c(0.31525, 0.10025, 0.10025, -0.03475, -0.24975, -0.14725, -0.24975, -0.03475, 0.10025, 0.10025)
    polygon(x=xstar/1.75^(!double), y=ystar+h, border=pal[7], col=pal[7])
  }  
  if (double) {
    plot(x=c(-3,3),y=c(0,10.5),type='n',axes=FALSE,xlab="",ylab="")
    set.seed(seed)
    segplot(tree, Xmas, pal)
    if (Xmas) polygon(x=xstar/1.75^(!double), y=ystar+h, border=pal[7], col=pal[7])
  }  
}

mywish <- function(math) {
  if (math) {
    return("PF 11111011110")
  } else {
    return("Pour Féliciter 2014")
  }
}

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$wish <- renderText(mywish(input$math))
  
  output$treeplot <- renderPlot({        
    # make genotype plot
    mytreeplot(as.integer(input$age), round(as.integer(input$age2)*1000*pi), input$drunk, input$math, input$Xmas, input$myth)
  })

})
