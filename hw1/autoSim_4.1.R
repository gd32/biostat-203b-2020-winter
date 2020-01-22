# autoSim.R

for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

nVals = seq(100, 500, by=100)
distTypes = c("gaussian", "t1", "t5")

seed=203
rep=100

for (dist in distTypes){
  for (n in nVals) {
    arg = paste("n=", n, " dist=", shQuote(shQuote(dist)), " seed=", seed, " rep=", rep, sep="")
    oFile = paste("n", n, "_dist_", dist, ".txt", sep="")
    sysCall = paste("nohup Rscript runSim_4.1.R ", arg, " > ", oFile, sep="")
    system(sysCall, wait=F)
    print(paste("sysCall=", sysCall, sep=""))
  }
}