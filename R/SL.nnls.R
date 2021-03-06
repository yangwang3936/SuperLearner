# SL-wrapper for Non-negative least squares algorithm
# Same functionality as the method.NNLS metalearner, but 
# in the SL-wrapper format

SL.nnls <- function(Y, X, newX, family, obsWeights, ...) {
  .SL.require("nnls")
  fit.nnls <- nnls::nnls(sqrt(obsWeights)*as.matrix(X), sqrt(obsWeights)*Y) 
  initCoef <- coef(fit.nnls)
  initCoef[is.na(initCoef)] <- 0
  if (sum(initCoef) > 0) {
    coef <- initCoef/sum(initCoef)
  } else {
    warning("All algorithms have zero weight", call. = FALSE)
    coef <- initCoef
  }
  pred <- crossprod(t(as.matrix(newX)), coef)
  fit <- list(object = fit.nnls)
  class(fit) <- "SL.nnls"
  out <- list(pred = pred, fit = fit)
  return(out)
}

predict.SL.nnls <- function(object, newdata, ...) {
  initCoef <- coef(object$object)
  initCoef[is.na(initCoef)] <- 0
  if (sum(initCoef) > 0) {
    coef <- initCoef/sum(initCoef)
  } else {
    warning("All algorithms have zero weight", call. = FALSE)
    coef <- initCoef
  }
  pred <- crossprod(t(as.matrix(newdata)), coef)
  return(pred)
}
