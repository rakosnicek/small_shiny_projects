
set.seed(123)
require(qtl)

lodplot <- function(nchr=20, chrlen=100, nmar=10, nind=250, her=50, ctype="f2") {
  
  # generate random map and random fake cross
  map <- sim.map(len=rep(chrlen, nchr), n.mar=nmar)
  fake <- sim.cross(map, type=ctype, n.ind=nind, model = NULL)
  
  # genetic is proportional to A-fouder genome
  genetic <- apply(sapply(fake$geno,function(x) apply(x[[1]], 1, sum)), 1, sum)
  noise <- rnorm(nind, sd=sd(genetic) * sqrt(100/her-1))
  fake$pheno <- data.frame(Y = genetic + noise)
  
  # make scanone lod-plot
  return(fake)
}

tmp <- lapply(fake$geno, function(x) x[[1]])
A <- t(do.call("cbind", tmp))
K <- cor(A)
K2 <- matrix(0,250, 250)
for (i in 1:249)
  for (j in (i+1):250)
    K2[i,j] <-K2[j,i] <- 1-sum(abs(A[,i]-A[,j]))/400
diag(K2) <- 1

lod <- rep(0,200)
for (i in 1:200)
  lod[i] <- (logLik(lm(fake$pheno$Y ~ factor(A[i,]))) - logLik(lm(fake$pheno$Y ~ 1)))/log(10)
plot(lod, scanone(fake)[,3])

require(regress)
lodK <- rep(0,200)
for (i in 1:200)
  lodK[i] <- (regress(fake$pheno$Y ~ factor(A[i,]), ~K2)$llik - regress(fake$pheno$Y ~ 1, ~K2)$llik)/log(10)

plot(lod)
plot(lodK)
plot(lod,lodK)

fake2 <- fake
fake2$pheno$Y <- fake$pheno$Y + (A[95,]==1)*sd(fake$pheno$Y)*sqrt(3/4)
plot(scanone(fake2))

lod <- rep(0,200)
for (i in 1:200)
  lod[i] <- (logLik(lm(fake2$pheno$Y ~ factor(A[i,]))) - logLik(lm(fake$pheno$Y ~ 1)))/log(10)
plot(lod, scanone(fake)[,3])

require(regress)
lodK <- rep(0,200)
for (i in 1:200)
  lodK[i] <- (regress(fake2$pheno$Y ~ factor(A[i,]), ~K2)$llik - regress(fake2$pheno$Y ~ 1, ~K2)$llik)/log(10)
plot(lodK)

output <- NULL

while (TRUE) {
  print("Dalsi")
  Y <- lodplot()
  tmp <- lapply(Y$geno, function(x) x[[1]])
  M <- t(do.call("cbind", tmp))
  K <- matrix(0,250, 250)
  for (i in 1:249)
    for (j in (i+1):250)
      K[i,j] <-K[j,i] <- 1-sum(abs(M[,i]-M[,j]))/400
  diag(K) <- 1

  Y2 <- Y
  Y2$pheno$Y <- Y$pheno$Y + (M[95,]==1)*sd(Y$pheno$Y)
  
  stat <- function(y,M,K)  {
    lodK <- rep(0,200)
    for (i in 1:200) {
      lodK[i] <- (regress(y ~ factor(M[i,]), ~K)$llik - regress(y ~ 1, ~K)$llik)/log(10)
    }  
    output <- max(lodK)
    attr(output, "lods") <- lodK
    return(output)
  }
  
  res1 <- stat(Y$pheno$Y,M,K)
  res2 <- stat(Y2$pheno$Y,M,K)

pdf("c:\\temp\\lm_vs_regress.pdf", width=8, height=8)  
  par(mfrow=c(2,2))
  
  tmp<-scanone(Y)
  plot(tmp, main="No QTL, lm", ylim=c(0,5.5))
  #trhold <- summary(scanone(Y, n.perm=1000))[1]
  abline(h=trhold,lty=2, col="red")
  
  trhold3 <- 6.156481
  tmp[,3] <- attr(res1,"lods")
  plot(tmp, main="No QTL, regress", ylim=c(0,10))
  abline(h=trhold3,lty=2, col="red")

  tmp<-scanone(Y2)
  plot(tmp, main="QTL on Chr10, lm", ylim=c(0,5.5))
  #trhold2 <- summary(scanone(Y, n.perm=1000))[1]
  abline(h=trhold2,lty=2, col="red")
  
  tmp[,3] <- attr(res2,"lods")
  plot(tmp, main="QTL on Chr10, regress", ylim=c(0,10))
  abline(h=trhold3,lty=2, col="red")
dev.off()
  
  par
  
  res <- cbind(c(stat(Y$pheno$Y,M,K),
    stat(Y2$pheno$Y,M,K),
    quantile(replicate(100,stat(sample(Y$pheno$Y),M,K)),0.95),
    quantile(replicate(100,stat(sample(Y2$pheno$Y),M,K)),0.95)))
  output <- cbind(output,res)
}  
  