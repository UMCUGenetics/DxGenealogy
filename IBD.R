args<-commandArgs(TRUE)
file <- read.table(args[1], header=FALSE, sep="\t")
#file
file <- file[,c(1,3,5,6,7)]
file
colnames(file) <- c("Sample1","Sample2","Chromosome", "Start", "End")
file
