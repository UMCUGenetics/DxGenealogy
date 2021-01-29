## ----setup----------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(igraph)
library(ggplot2)
library(gridExtra)
library(grid)


## -------------------------------------------------------------------------------------------------
args<-commandArgs(TRUE)
#pdf_path = "pdfr.pdf"
pdf(args[3])
TRIBES <- read.csv(args[1], header=TRUE)
TRIBES <- TRIBES[,c(1,2,3,6)] # Only keep necessary columns
colnames(TRIBES) <- c("Sample1", "Sample2", "cM_TRIBES", "EstDegree_TRIBES")  # Add column names
TRIBES$EstDegree_TRIBES[TRIBES$EstDegree_TRIBES=="PO"] <- 1   # Change character value to a number
TRIBES
#write.table(TRIBES, "TRIBES.tsv", sep = "\t", row.names = FALSE)  # Write table to file


## -------------------------------------------------------------------------------------------------
Somalier <- read.table(args[2], sep="\t")
Somalier <- Somalier[,1:3]  # Only keep necessary columns
colnames(Somalier) <- c("Sample1", "Sample2", "Relatedness_somalier") # Change colnames
Somalier

## -------------------------------------------------------------------------------------------------
merged <- merge(Somalier, TRIBES, by=c("Sample1","Sample2"), all.x = TRUE )   # Merge the somalier and TRIBES frame
merged <- transform(merged, EstDegree_TRIBES = as.numeric(EstDegree_TRIBES))  # Make Est_degree a numeric colomn.
merged["EstDegree_TRIBES"][is.na(merged["EstDegree_TRIBES"])] <- 12     # If value is NA in TRIBES column, make value 12
merged["cM_TRIBES"][is.na(merged["cM_TRIBES"])] <- 1 
merged
grid.newpage()
grid.table(merged[1:20,])
grid.newpage()
grid.table(merged[20:nrow(merged),])
grid.newpage()
grid.newpage()

#write.table(merged, "merged.tsv", sep = "\t", row.names = FALSE)  # Write frame to file


## -------------------------------------------------------------------------------------------------
samples <- c()   # Create samples vector
for(i in merged$Sample1){   # For entry in column Sample 1
    if(! i %in% samples){   # if entry not in the vector:
    samples <- c(samples, i)}   # Add entry to vector
  }
samples <- c(samples, "GPCA041B1")  # Add GPCA041B1 to vector (because it is only found in Sample2)
samples

## -------------------------------------------------------------------------------------------------
matrix2 <- matrix(1:64, nrow = 8, ncol = 8) # Create matrix 8x8
matrix2

## -------------------------------------------------------------------------------------------------
colnames(matrix2) <- samples  # Change columnnames with entries from samples vector
rownames(matrix2) <- samples  # Change rownames with entries from samples vector
matrix2 

## -------------------------------------------------------------------------------------------------
for(i in matrix2){  #For every entry in the matrix
k <- arrayInd(i, dim(matrix2))  # Get location of row and column of entry
names <- mapply(`[[`, dimnames(matrix2), k)   # Get col & rownames at location k
# Create subset where samples correspond with samples in the merged frame
data <- subset(merged, (Sample1==names[1] & Sample2 ==names[2]) | 
                 (Sample2==names[1] & Sample1 == names[2]))   
if(length(data$Sample1)==0){  # If no match is found
          matrix2[k[1],k[2]] <- 12
        }else{
          matrix2[k[1],k[2]] <- data$EstDegree_TRIBES   # If match found add value
        }
if(names[1]==names[2]){   # If the names are the same
          matrix2[k[1], k[2]] <- 0}   # Degree becomes 0
}

## -------------------------------------------------------------------------------------------------
print(matrix2)
grid.table(matrix2[,1:4])
grid.newpage()
grid.table(matrix2[,5:ncol(matrix2)])

## -------------------------------------------------------------------------------------------------
print(dist(matrix2), method="average")
avg <- (hclust(dist(matrix2), method="average"))  # Create distance matrix

## -------------------------------------------------------------------------------------------------
?as.dendrogram
plot(as.dendrogram(avg), edgePar=list(col=1, lwd=3), horiz=F)   # Plot dendogram

## -------------------------------------------------------------------------------------------------
matrix <- matrix(1:64, nrow = 8, ncol = 8)
matrix
colnames(matrix) <- samples
rownames(matrix) <- samples
matrix


## -------------------------------------------------------------------------------------------------
for(i in matrix){
k <- arrayInd(i, dim(matrix))
#print(i)
names <- mapply(`[[`, dimnames(matrix), k)
data <- subset(merged, (Sample1==names[1] & Sample2 ==names[2]) | (Sample2==names[1] & Sample1 == names[2]))
if(length(data$Sample1)==0){
          matrix[k[1],k[2]] <- 1
        }else{
          matrix[k[1],k[2]] <- data$cM_TRIBES
        }
if(names[1]==names[2]){
          matrix[k[1], k[2]] <- 0}
}


## -------------------------------------------------------------------------------------------------
print(dist(matrix), method="average")
avg_cM <- (hclust(dist(matrix), method="average"))


## -------------------------------------------------------------------------------------------------
?as.dendrogram
plot(as.dendrogram(avg_cM), edgePar=list(col=1, lwd=3), horiz=F) 

## -------------------------------------------------------------------------------------------------
print(dist(matrix), method="average")
avg_cM <- (hclust(dist(matrix, method="euclidean"), method="average"))
plot(as.dendrogram(avg_cM), edgePar=list(col=1, lwd=3), horiz=F) 

## -------------------------------------------------------------------------------------------------
print(dist(matrix), method="average")
avg_cM <- (hclust(dist(matrix, method="manhattan"), method="average"))
plot(as.dendrogram(avg_cM), edgePar=list(col=1, lwd=3), horiz=F) 


## -------------------------------------------------------------------------------------------------
g <- graph.edgelist(as.matrix(merged[,1:2]), directed=FALSE)
plot(g, edge.width = (1- merged$cM_TRIBES)*5, edge.label=ifelse(format(round((1-merged$cM_TRIBES)*5), nsmall = 0) > 0, format(round((1-merged$cM_TRIBES)), nsmall = 6), NA))


## -------------------------------------------------------------------------------------------------
merged
merged["1-cM"]<- 1 - merged$cM_TRIBES 
merged

## -------------------------------------------------------------------------------------------------
sub <- subset(merged, select = c(Sample1, Sample2, cM_TRIBES, `1-cM`))
sub
grid.newpage()
grid.table(sub[1:15,])
grid.newpage()
grid.table(sub[16:nrow(sub),])
dev.off()
purl("dendogram.Rmd")

