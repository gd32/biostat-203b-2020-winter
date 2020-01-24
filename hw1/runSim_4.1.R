for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

#set the random seed
set.seed(seed)

#initialize MSE
mseSampAvg = 0
msePrimeAvg = 0

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

for (r in 1:rep){
  # parse distribution information
  if (dist == "gaussian"){
    # simulate data
    x=rnorm(n)
  }
  else if (dist == "t1"){
    x = rt(n, df=1)
  }
  else if (dist == "t5"){
    x = rt(n, df=5)
  }
  else {
    # print error message if wrong distribution entered
    stop("Wrong distribution specified. Try 'gaussian', 't1', or 't5'")
  }
  mseSampAvg = mseSampAvg + mean(x)^2
  msePrimeAvg = msePrimeAvg + estMeanPrimes(x)^2
}

print(msePrimeAvg/rep)
print(mseSampAvg/rep)

