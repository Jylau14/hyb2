#!/usr/bin/env Rscript
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])
LIMIT <- as.numeric(args[2])
GENE_1 <- as.character(args[3])
GENE_2 <- as.character(args[4])
TITLE <- as.character(args[5])

# read data
data <- data.table::fread(INPUT,header=T,sep="\t")
# colnames(data) <- c("x", "y", "count")
data$ID <- gsub(pattern="\\.contact.txt$","",INPUT)
quant <- quantile(data$count, probs=LIMIT)
data$count2 <- ifelse(data$count > quant, quant, data$count)
Title <- ifelse(!is.na(TITLE), TITLE, data$ID[1])

#plot contact density map, save as pdf
cdm <- ggplot(data, aes(x,y))+
  geom_tile(aes(fill=count2), show.legend=TRUE)+
  scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000", limits=c(0,ceiling(quant)), breaks=c(as.integer(round(quant*0.25)),as.integer(round(quant/2)),as.integer(round(quant*0.75)),as.numeric(ceiling(quant))))+
  theme_bw()+theme(aspect.ratio = 1)+
  labs(title="Contact Density Map", subtitle = Title,x=paste0(GENE_1, " (nt)"),y=paste0(GENE_2," (nt)"))+
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(data$x)))+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(data$y)))+
  theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
  theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90))+
  guides(fill=guide_legend(title="chimera count",label.position="bottom"))+
  theme(legend.position="bottom")+
  theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
ggsave(filename = paste0(Title,'.pdf'), plot = cdm, units = "cm", height = 18, width = 18)
