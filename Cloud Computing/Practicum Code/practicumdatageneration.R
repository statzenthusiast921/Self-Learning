mixture.ex <- function(seed = .Random.seed, sigma = sqrt(5), offset
                       = 1, nint = 80, n1=50, n2=50, replicate=1)
{
### n: number of obs in each class
  set.seed(seed)
  means1 <- matrix(rnorm(20), 10, 2)
  means1[, 1] <- means1[, 1] + offset
  x1 <- matrix(rnorm(2*n1), n1, 2)
  which1 <- sample(1:10, n1, replace = T)
  x1 <- x1/sigma + means1[which1,  ]
  means2 <- matrix(rnorm(20), 10, 2)
  means2[, 2] <- means2[, 2] + offset
  x2 <- matrix(rnorm(2*n2), n2, 2)
  which2 <- sample(1:10, n2, replace = T)
  x2 <- x2/sigma + means2[which2,  ]
  x <- rbind(x1, x2)
  y <- rep(c(F, T), c(n1, n2))
  if (replicate > 1) {
    for (k in 1:(replicate-1)) {
      x1 <- matrix(rnorm(2*n1), n1, 2)
      which1 <- sample(1:10, n1, replace = T)
      x1 <- x1/sigma + means1[which1,  ]
      x <- rbind(x, x1)
      x2 <- matrix(rnorm(2*n2), n2, 2)
      which2 <- sample(1:10, n2, replace = T)
      x2 <- x2/sigma + means2[which2,  ]
      x <- rbind(x, x2)
      y <- c(y, rep(c(F, T), c(n1, n2)))
    }
  }
  xnew <- data.matrix(expand.grid(x1 = (px1 <- pretty(x[, 1], nint)), x2
                                  = (px2 <- pretty(x[, 2], nint))))
  d1 <- d2 <- double(nrow(xnew))
  for(i in 1:10) {
    d1 <- d1 + (dnorm(xnew[, 1], means1[i, 1], 1/sigma) * dnorm(
                                                                xnew[, 2], means1[i, 2], 1/sigma))/10
    d2 <- d2 + (dnorm(xnew[, 1], means2[i, 1], 1/sigma) * dnorm(
                                                                xnew[, 2], means2[i, 2], 1/sigma))/10
  }
  pred4 <- d2/(d1 + d2)
  marginal <- d1 + d2
  marginal <- marginal/sum(marginal)
  list(x = x, y = y, xnew = xnew, prob = pred4, marginal = marginal, px1
       = px1, px2 = px2)
}

radial.kernel <- function(x, y, param.kernel = 1)
{
  n <- nrow(x)
  p <- ncol(x)
  normx <- drop((x^2) %*% rep(1, p))
  normy <- drop((y^2) %*% rep(1, p))
  if(is.vector(y))
    a <- x %*% y
  else a <- x %*% t(y)
  a <- (-2 * a + normx) + outer(rep(1, n), normy, "*")
  exp( - a/(2 * param.kernel) )
}
