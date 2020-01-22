# autoSim.R

nVals <- seq(10000, 10000, by=10000)
for (n in nVals) {
  oFile <- paste("n", n, ".txt", sep="")
  sysCall <- paste("nohup Rscript runSim.R n=", n, " > ", oFile, sep="")
  system(sysCall, wait=F)
  print(paste("sysCall=", sysCall, sep=""))
