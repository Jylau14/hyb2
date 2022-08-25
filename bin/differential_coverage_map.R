#!/usr/bin/env Rscript
#plots differential coverage map using reformatted DESeq_run.R output 
#run on terminal input_significant.padj_heatmap.txt 1st_condition_data_name 2nd_condition_data_name
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])
POS <- as.character(args[2])
NEG <- as.character(args[3])

# read data
data <- data.table::fread(INPUT,header=T,sep="\t")
#colnames(data) <- c("x", "y", "logpadj", "log2FoldChange", "padj")
data$count2 <- ifelse(data$logpadj > 5, 5, ifelse(data$logpadj < -5, -5, data$logpadj))
titleID <- paste0(gsub(pattern="\\_significant.padj_heatmap.txt$","",INPUT))

#plot differential coverage map, save as pdf
dcm <- ggplot(data, aes(x,y))+
  geom_tile(aes(fill=count2), show.legend=TRUE)+
  scale_fill_gradientn(colours=c("blue", "white", "red"), limits=c(-5,5), breaks=c(-5, 0, 5)) +
  theme_bw()+theme(aspect.ratio = 1)+
  labs(title = POS,subtitle= NEG, x="3'-5' chimera (nt)",y="5'-3' chimera (nt)")+
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))))+
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))))+
  theme(plot.title=element_text(size=10, color="red"),plot.subtitle=element_text(size=10,color="blue"))+
  theme(text=element_text(size=9.5), axis.text=element_text(size=9))+
  theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90))+
  guides(fill=guide_legend(title="log padj",label.position="bottom"))+
  theme(legend.position="bottom")+
  theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
ggsave(filename = paste0(titleID,'.pdf'), plot = dcm, units = "cm", height = 18, width = 18)

