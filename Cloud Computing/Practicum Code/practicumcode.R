source("practicumcodebklr-bivm.r")
source("practicumdatageneration.R")

data <- mixture.ex(seed =1234)
attach(data)
options(object.size=100000000)
## bayes.error
bayes.error <- sum(marginal*(prob*I(prob<0.5)+(1-prob)*I(prob>=.5)))

lambda <- 1
sigma <- 0.7
## radial kernel with sigma^2=0.7
kernel <- radial.kernel(x, x, param.kernel=sigma)
kernel.te <- radial.kernel(xnew, x, param.kernel=sigma)

## initialize
ini <- bivmInitial(y=y, Kernel=kernel, lambda=lambda)
N <- nrow(kernel)
total <- 1:N
base <- ini$index
rest <- total[-base]

## using S-M scheme
seqPdev <- NULL
seqTestErr <- NULL
seqTestDev <- NULL
i <- 1
repeat{
  cat("i:", i, "\n")
  Ka <- kernel[ , base]
  Kp <- kernel[base, base]
  
  junk <- bklr.d(y=y, Ka=Ka, Kp=Kp, lambda=lambda)
  if (junk$solve == F) {
    cat("Reached singular model.\n")
    break
  }
  z1 <- junk$z1
  z2 <- junk$z2
  wt <- junk$wt
  pKinv <- junk$pKinv
  oldKa <- junk$Ka

  seqPdev[i] <- junk$pdev
  junk.te <- bklr.predict(junk$alpha, kernel.te[ , base])
  seqTestErr[i] <- sum(marginal*(prob*I(junk.te$fit<0)+(1-prob)*I(junk.te$fit>0)))
  seqTestDev[i] <- sum(marginal*(-prob*junk.te$fit + log(1+exp(junk.te$fit))))

  if (i == N) {
    cat("Reached full model.\n")
    break
  }
  
  tmpPdev <- NULL
  for (j in 1:length(rest)) {
    cat("j", j, "\n")
    tmpAdd <- rest[j]
    tmpBase <- c(base, tmpAdd)
    newka <- kernel[ , tmpAdd]
    newkp <- newka[tmpBase]
    
    tmp <- bivm(wt, z1, z2, newka, newkp, pKinv, oldKa, lambda)
    if (tmp$add == F) {
      cat("Point", tmpAdd, "not to be added.\n")
      tmpPdev[j] <- Inf
    }
    else {   
      tmpKa <- cbind(1, kernel[, tmpBase])
      tmpKp <- rbind(0, cbind(0, kernel[tmpBase, tmpBase]))
      tmpPdev[j] <-care.pdev(tmp$alpha, tmpKa, tmpKp, y, lambda)
    }
  }

  ## compare the deviance, update base and rest
  tmpInd <- order(tmpPdev)[1]
  if (tmpPdev[tmpInd] == Inf) {
    cat("No point to be added.\n")
    break
  }
  else {
    tmpPick <- rest[tmpInd]
    base <- c(base, tmpPick)
    rest <- total[-base]
  }
  i <- i + 1
}

postscript(file = "practicumoutput.ps", width = 8, height = 8, pointsize = 10,
           horizontal=T)
par(mfrow=c(1,2))
plot(seqPdev, xlab="# of Import Points", ylab="Regularized Deviance",
     cex.lab=1.5)
title("Lambda = 1")
plot(seqTestErr, xlab="# of Import Points", ylab="Misclassification Rate",
     cex.lab=1.5)
title("Lambda = 1")
dev.off()

