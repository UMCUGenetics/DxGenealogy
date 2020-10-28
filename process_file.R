library(dendextend)
library(igraph)
library(ggplot2)
library(gridExtra)
library(grid)

pdf("pdf_output.pdf")
grid.newpage()

args<-commandArgs(TRUE)
file <- read.csv(args[1], header=TRUE)
file <- file[,c(1,2,3,6)]
colnames(file) <- c("Sample1", "Sample2", "TRIBES_cM", "TRIBES_EstDegree")
file
samples <- c()
for(i in file$Sample1){
	if(! i %in% samples){
    		samples <- c(samples, i)}
}
samples
samples_2 <- c()
for(i in file$Sample2){
        if(! i %in% samples_2){
                samples_2 <- c(samples_2, i)}
}
samples_2

unique <- c()
for(i in samples){
	if(!i %in% samples_2){
		unique <- c(unique, i)}
}

unique
for(i in samples_2){
unique <- c(unique, i)}
unique

entries <- length(unique)
entries

size_matrix <- (entries * entries)
size_matrix


matrix <- matrix(1:size_matrix, nrow=entries, ncol=entries)
rownames(matrix) <- unique
colnames(matrix) <- unique
#matrix

for(i in matrix){
k <- arrayInd(i, dim(matrix))
#print(i)
names <- mapply(`[[`, dimnames(matrix), k)
data <- subset(file, (Sample1==names[1] & Sample2 ==names[2]) | (Sample2==names[1] & Sample1 == names[2]))
if(length(data$Sample1)==0){
          matrix[k[1],k[2]] <- 1
        }else{
          matrix[k[1],k[2]] <- data$TRIBES_cM
        }
if(names[1]==names[2]){
          matrix[k[1], k[2]] <- 0}
}

#matrix
format(matrix, digits = 2)
matrix
print(dist(matrix), method="single")
avg_cM <- (hclust(dist(matrix, method="manhattan"), method="single"))
dendo <- as.dendrogram(avg_cM)
dendo <- color_branches(dendo,4)
dendo%>% set("branches_lwd", 3) %>% plot( edgePar=list(col=1, lwd=3), horiz=F,ylab="Distance") 
title("Cluster dendogram based on cM TRIBES")
mtext(text = "Sample", side = 1, line = 1, col = "black", adj = -.05)

print(dist(matrix), method="average")
avg_cM <- (hclust(dist(matrix, method="manhattan"), method="average"))
dendo <- as.dendrogram(avg_cM)
dendo <- color_branches(dendo,4)
dendo%>% set("branches_lwd", 3) %>% plot( edgePar=list(col=1, lwd=3), horiz=F,ylab="Distance") 
title("Cluster dendogram based on cM TRIBES")
mtext(text = "Sample", side = 1, line = 1, col = "black", adj = -.1)

print(dist(matrix), method="complete")
avg_cM <- (hclust(dist(matrix, method="manhattan"), method="complete"))
dendo <- as.dendrogram(avg_cM)
dendo <- color_branches(dendo,4)
dendo%>% set("branches_lwd", 3) %>% plot( edgePar=list(col=1, lwd=3), horiz=F,ylab="Distance") 
title("Cluster dendogram based on cM TRIBES")
mtext(text = "Sample", side = 1, line = 1, col = "black", adj = -.1)
dev.off()
