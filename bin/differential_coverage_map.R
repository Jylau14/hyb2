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
data$count2 <- ifelse(data$logpadj > 3, 3, ifelse(data$logpadj < -3, -3, data$logpadj))
titleID <- paste0(gsub(pattern="\\_significant.padj_heatmap.txt$","",INPUT))

#plot differential coverage map, save as pdf
dcm <- ggplot(data, aes(x,y))+
  geom_tile(aes(fill=count2), show.legend=TRUE)+
  guides(fill = guide_colourbar(barwidth = 0.5, barheight = 10, ticks.colour = "black" ,title = "log padj", title.position = "right", 
                                title.theme = element_text(angle = 270, size = 9.5), title.vjust = 0, title.hjust = 0.5,
                                label.position = "left", label.theme = element_text(angle = 270, size = 9), label.vjust = 0, label.hjust = 0.5))+
  scale_fill_gradientn(colours=c("blue", "white", "red"), breaks = c(-3,0,3), labels = c(3,0,3)) +
  theme_bw()+theme(aspect.ratio = 1)+
  labs(title = POS,subtitle= NEG, x="3'-5' Chimera (nt)",y="5'-3' Chimera (nt)")+
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))+10))+
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))+10))+
  theme(plot.title=element_text(size=10, color="red"),plot.subtitle=element_text(size=10,color="blue"))+
  theme(text=element_text(size=9.5), axis.text=element_text(size=9))+
  theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90, vjust = 0, hjust = 0.5))+
  theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
ggsave(filename = paste0(titleID,'.pdf'), plot = dcm, units = "cm", height = 17, width = 18)

