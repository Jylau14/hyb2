#!/usr/bin/env Rscript
library("DESeq2")
#parsing command line options
args <- commandArgs(trailingOnly = TRUE)
TABLE <- as.character(args[1])
NAMES <- as.character(args[2])
MIN <- as.numeric(args[3])

#read files
countData <- read.table( TABLE, header=TRUE, sep="\t", na.strings="NA", dec=".", strip.white=TRUE, comment.char="", row.names=1 )
colData <- read.table( NAMES, header=FALSE, sep="\t", na.strings="NA", dec=".", strip.white=TRUE, comment.char="", row.names=1 )

#ensure countData and colData contain the same IDs
countData2 <- as.data.frame(countData[,(which(colnames(countData)[]==rownames(colData)[1]))])
for (i in 2:nrow(colData)) {
  match_count <- countData[,(which(colnames(countData)[]==rownames(colData)[i]))]
  countData2 <- cbind(countData2,match_count)
}
rownames(countData2) <- rownames(countData)
colnames(countData2) <- rownames(colData)

#ensure data read as integers
for (i in 1:ncol(countData2)) {
  countData2[,i] <- as.integer(as.character(countData2[,i]))
}
countData2[is.na(countData2)] <- 0

#DESeq2
colnames(colData)<-c("conditions")
all(rownames(colData) %in% colnames(countData2))
all(rownames(colData) == colnames(countData2))
dds <- DESeqDataSetFromMatrix(countData = round(countData2), colData = colData, design = ~ conditions)
dds <- dds[ rowSums(counts(dds)) > MIN, ]
dds<-DESeq(dds)
res<-results(dds, contrast=c("conditions","condition_one","condition_two"), alpha=0.01)
write.table(file=paste0("DESeq_",(gsub(pattern="\\.table.txt$","",TABLE)),".txx"), res[order(res$padj),], sep="\t")
