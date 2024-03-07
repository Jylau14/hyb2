#!/usr/bin/env Rscript
#plots zoomed in contact density map only for outputs from plot_differential_map, for an independent script, use cdm_indiv_zoom.R
library(dplyr)
library(ggplot2)
library(gridExtra)

#input command line arguements
args <- commandArgs(trailingOnly = TRUE)
x1 <- as.integer(args[1])
x2 <- as.integer(args[2])
y1 <- as.integer(args[3])
y2 <- as.integer(args[4])
LIMIT <- as.numeric(args[5])
a1 <- as.character(args[6])
a2 <- as.character(args[7])
a3 <- as.character(args[8])
a4 <- as.character(args[9])
b1 <- as.character(args[10])
b2 <- as.character(args[11])
b3 <- as.character(args[12])
b4 <- as.character(args[13])
for (i in 1:13) {
  if (is.na(args[i])) {
    args[i] <- 'NOTSPECIFIED'
  }
}
#list files for reading
input <- c(intersect(list.files(pattern=c(args[6])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[7])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[8])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[9])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[10])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[11])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[12])), list.files(pattern=c('.forTable.txt'))),
           intersect(list.files(pattern=c(args[13])), list.files(pattern=c('.forTable.txt'))))
input <- gsub(pattern="\\.forTable.txt$",".entire.txt",input)
#read data
data<- list()
x=0
for (i in 1:(length(input))){
  if (x <= (length(input))){
    x=x+1
    data[[i]] <- data.table::fread((input[x]),header=T,sep="\t")
    colnames(data[[i]]) <- c("x", "y", "count")
    data[[i]]$ID <- gsub(pattern="\\.entire.txt$","",input[x])
  }
}

#calculate upper limit for setting contrast
all_data <- do.call(rbind.data.frame,data)
quant <- quantile(all_data$count, probs=LIMIT)
all_data$count2 <- ifelse(all_data$count > quant, quant, all_data$count)

#loop through datasets and plot contact density map, save as pdf
cdm<- list()
for (i in unique(all_data$ID)){
  cdm[[i]] <- ggplot(all_data[which(all_data$ID==i),], aes(x,y))+
    geom_tile(aes(fill=count2), show.legend=FALSE)+
    scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000", limits=c(0,ceiling(quant)), breaks=c(0,ceiling(quant)))+
    theme_bw()+theme(aspect.ratio = 1)+
    labs(title = i,x="3'-5' chimera (nt)",y="5'-3' chimera (nt)")+
    scale_x_continuous(expand = c(0, 0), limits = c(x1, x2), breaks = c(c(x1+25), c(x2-45)), labels=c(x1, x2))+
    scale_y_continuous(expand = c(0, 0), limits = c(y1, y2), breaks = c(c(y1+25), c(y2-45)), labels=c(y1, y2))+
    theme_void()+
    theme(axis.text=element_text(size=7))+
    theme(panel.background = element_rect(colour = "black", size=0.5))+
    theme(plot.title=element_text(size=8))
}
com <- do.call("grid.arrange", c(cdm,nrow=1))
ndata=length(cdm)
ggsave(filename = paste0(x1,x2,y1,y2,".pdf"), plot = com, units = "cm", height = 8, width = c(ndata*8))
