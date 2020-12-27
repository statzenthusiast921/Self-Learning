

bivmInitial <- function(y, Kernel, lambda) {
  N <- nrow(Kernel)  
  tmpPdev <- NULL
  for (i in 1:N) {
    cat(i, "")
    Ka <- Kernel[,i]
    Kp <- Kernel[i,i]
    tmpResult <- bklr.kp(y=y, Ka=Ka, Kp=Kp, lambda=lambda, trace=F)
    tmpPdev[i] <- tmpResult$pdev
  }
  index <- order(tmpPdev)[1]
  list(index=index, tmpPdev=tmpPdev)
}

bivm <- function(wt, z1, z2, newka, newkp, pKinv, oldKa, lambda) {
  newkp <- c(0, newkp)
  p1 <- length(newkp)
  newka2 <- newka*wt
  z0 <- sum(newka2*z1)
  a <- t(oldKa)%*%newka2 + lambda*newkp[-p1]
  b <- sum(newka*newka2) + lambda*newkp[p1]

  tmpA <- as.vector(pKinv %*% a)
  B <- b-sum(a*tmpA)
  if (abs(B) < .Machine$double.eps*10000)
    return(list(alpha=NULL, add=F))
  B <- pKinv + outer(tmpA, tmpA)/B
  alpha <- B%*%(z2-z0*a/b)
  alpha0 <- (z0-sum(a*alpha))/b
  alpha <- c(alpha, alpha0)
  return(list(alpha=alpha, add=T))
}

bklr.kp <- function(y, Ka, Kp, lambda, eps = 0.001, maxit = 20, trace = T) {
  Kp <- rbind(0, cbind(0, Kp))
  Ka <- cbind(1, Ka)
  N <- length(y)
  p <- ncol(Ka)

  ybar <- mean(y)
  mu <- rep(ybar, N)
  beta0 <- log(ybar/(1 - ybar))
  beta <- c(beta0, rep(0, p - 1))
  eta <- rep(beta0, N)
  wt <- mu*(1 - mu)

  g1 <- t(Ka) %*% (wt*eta)
  g2 <- t(Ka) %*% (y - mu)
  pdev <- care.dev(mu, y)

  dbeta <- 1
  dpdev <- 1
  grad <- 1
  iter <- 0
  while ((dbeta > eps || dpdev > eps || grad > eps) && (iter < maxit)) {
    beta.old <- beta
    pdev.old <- pdev

    tmpRes <- bkreg(g1, g2, wt, lambda, Ka, Kp, pdev.old, y)
    if (tmpRes$solve == F) {
      cat("Singularity occured.\n")
      return(list(solve = F))
    }
    pdev <- tmpRes$pdev
    beta <- tmpRes$beta
    eta <- tmpRes$fit
    junk <- care.exp(eta)
    mu <- junk/(1 + junk)
    wt <- mu*(1 - mu)

    g1 <- t(Ka) %*% (wt * eta) + lambda * (Kp %*% beta)
    g2 <- t(Ka) %*% (y - mu) - lambda * (Kp %*% beta)
    dbeta <- sum((beta.old - beta)^2)/sum(beta.old^2)
    dpdev <- abs((pdev.old - pdev)/pdev.old)
    grad <- mean(g2^2)
    iter <- iter + 1
    if(trace) {
      cat("Iteration:", iter, "\n")
      cat("dbeta:", signif(dbeta, 3), "\n")
      cat("dpdev:", signif(dpdev, 3), "\n")
      cat("grad:", signif(grad, 3), "\n")
    }
  }
  pKinv <- tmpRes$invK
  z1 <- eta + (y - mu) * care.deriv(mu)
  tmpWZ <- wt * z1
  z2 <- t(Ka) %*% tmpWZ
  list(fit = eta, mu = mu, alpha = beta, pKinv = pKinv, z1 = z1,
       z2 = z2, wt = wt, Ka = Ka, pdev = pdev, solve = T)
}

bkreg <- function(g1, g2, wt, lambda, Ka, D, pdev.old, y) {
  K <- t(Ka) %*% (Ka * as.vector(wt)) + lambda * D
  tmpQR <- qr(K)
  if (tmpQR$rank < ncol(K)) {
    cat("Rank of K:", tmpQR$rank, "\n")
    cat("Col. of K:", ncol(K), "\n")
    return(list(solve = F))
  }
  j <- 0
  repeat {
    cat("j:", j, "\n")
    tmpg <- g1 + g2/2^j
    beta <- qr.solve(tmpQR, tmpg)
    tmppdev <- care.pdev(beta, Ka, D, y, lambda)
    j <- j + 1
    if (tmppdev < pdev.old || j > 10)
      break
  }
  invK <- qr.solve(tmpQR)
  fit <- Ka %*% beta
  list(solve = T, beta = beta, fit = fit, invK = invK, pdev = tmppdev)
}

care.deriv <- function(mu) {
  d <- mu * (1 - mu)
  if(any(tiny <- (d < .Machine$double.eps))) {
    warning("Fitted probabilities of 0 or 1")
    d[tiny] <- .Machine$double.eps
  }
  1/d
}

care.exp <- function(x, thresh = 100) {
  about36 <-  - log(.Machine$double.eps)
  thresh <- max(c(thresh, about36))
  if( any(abs(x) > thresh) )
    warning("Fitted values over thresh")
  x[x > thresh] <- thresh
  x[x < ( - thresh)] <-  - thresh
  exp(x)
}

care.pdev <- function(alpha, Ka, Kp, y, lambda) {
  fit <- Ka %*% alpha
  junk <- care.exp(fit)
  mu <- junk/(1 + junk)
  dev <- care.dev(mu, y)
  penalty <- lambda / 2 * (t(alpha) %*% Kp %*% alpha)
  pdev <- dev + penalty
  pdev
}

care.dev <- function(mu, y) {
  dev <- y * log(mu) + (1 - y) * log(1 - mu)
  if(any(small <- mu * (1 - mu) < .Machine$double.eps)) {
    warning("Fitted values close to 0 or 1")
    smu <- mu[small]
    sy <- y[small]
    smu <- ifelse(smu < .Machine$double.eps, .Machine$double.eps,
                  smu)
    onemsmu <- ifelse((1 - smu) < .Machine$double.eps,
                      .Machine$double.eps, 1 - smu)
    dev[small] <- sy * log(smu) + (1 - sy) * log(onemsmu)
  }
  -sum(dev)
}

bklr.predict <- function(alpha, kernel, y = NULL)
{
  eta <- cbind(1, kernel) %*% alpha
  junk <- care.exp(eta)
  mu <- junk/(1 + junk)
  if (is.null(y))
    return( list(mu = mu, fit = eta, dev = NULL) )
  dev <- care.dev(mu, y)
  list(mu = mu, fit = eta, dev = dev)
}

bklr.d <- function(y, Ka, Kp, lambda, eps = 0.001, maxit = 20, trace = T,
                   full = T) {
  Ka.old <- cbind(1, Ka)
  eig <- eigen(Kp, symmetric=T)
  if (full == T) {
    d <- abs(eig$values)
    d[d < .Machine$double.eps] <- .Machine$double.eps
    U <- eig$vec %*% diag(1/sqrt(d))    
  }
  else {
    d <- eig$val[eig$val > sqrt(.Machine$double.eps)]
    U <- eig$vec[, eig$val > sqrt(.Machine$double.eps)] %*% diag(1/sqrt(d))
  }
  Ka <- cbind(1, Ka %*% U)
  p <- ncol(Ka)
  bigU <- rbind(c(1, rep(0,p-1)), cbind(0, U))
  Kp <- rbind(0, cbind(0, diag(p-1)))
  N <- length(y)
  
  ybar <- mean(y)
  mu <- rep(ybar, N)
  beta0 <- log(ybar/(1 - ybar))
  beta <- c(beta0, rep(0, p - 1))
  eta <- rep(beta0, N)
  wt <- mu*(1 - mu)

  g1 <- t(Ka) %*% (wt*eta)
  g2 <- t(Ka) %*% (y - mu)
  pdev <- care.dev(mu, y)

  dbeta <- 1
  dpdev <- 1
  grad <- 1
  iter <- 0
  while ((dbeta > eps || dpdev > eps || grad > eps) && (iter < maxit)) { 
    beta.old <- beta
    pdev.old <- pdev
    
    tmpRes <- bkreg(g1, g2, wt, lambda, Ka, Kp, pdev.old, y)
    if (tmpRes$solve == F) {
      cat("Singularity occured.\n")
      return(list(solve = F))
    }
    pdev <- tmpRes$pdev
    beta <- tmpRes$beta
    eta <- tmpRes$fit
    junk <- care.exp(eta)
    mu <- junk/(1 + junk)
    wt <- mu*(1 - mu)

    g1 <- t(Ka) %*% (wt * eta) + lambda * (Kp %*% beta)
    g2 <- t(Ka) %*% (y - mu) - lambda * (Kp %*% beta)
    dbeta <- sum((beta.old - beta)^2)/sum(beta.old^2)
    dpdev <- abs((pdev.old - pdev)/pdev.old)
    grad <- mean(g2^2)
    iter <- iter + 1
    if(trace) {
      cat("Iteration:", iter, "\n")
      cat("dbeta:", signif(dbeta, 3), "\n")
      cat("dpdev:", signif(dpdev, 3), "\n")
      cat("grad:", signif(grad, 3), "\n")
    }
  }
  alpha <- bigU %*% beta
  if (full == T) {
    z1 <- eta + (y - mu) * care.deriv(mu)
    tmpWZ <- wt * z1
    z2 <- t(Ka) %*% tmpWZ
    z2 <- c(z2[1], U %*% diag(d) %*% z2[-1])
    pKinv <- bigU %*% tmpRes$invK %*% t(bigU)
  }
  else {
    z1 <- NULL
    z2 <- NULL
    pKinv <- NULL
  }
  list(fit = eta, mu = mu, alpha = alpha, pdev = pdev, solve = T, pKinv = pKinv, z1 = z1, z2 = z2, wt = wt, Ka = Ka.old)
}

my.predict.svm <- function(object, kernel) {
  fit <- kernel %*% object$coefs - object$rho
  result <- fit < 0
  list(fit = fit, result = result)
}







