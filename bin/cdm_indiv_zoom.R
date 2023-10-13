#!/usr/bin/env Rscript
#plots zoomed in contact density map based on input_entire.txt and coordinates
#run on terminal cdm_indiv_zoom.R input_entire.txt x_start x_end y_start y_end upper_quantile(0.95) plot_title
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])
x1 <- as.integer(args[2])
x2 <- as.integer(args[3])
y1 <- as.integer(args[4])
y2 <- as.integer(args[5])
LIMIT <- as.numeric(args[6])
GENE_1 <- as.character(args[7])
GENE_2 <- as.character(args[8])
TITLE <- as.character(args[9])

# read data
data <- data.table::fread(INPUT,header=T,sep="\t")

# set ID name, upper quantile limit
data$ID <- gsub(pattern="\\.entire.txt$","",INPUT)
quant <- quantile(data$count, probs=LIMIT)
data$count2 <- ifelse(data$count > quant, quant, data$count)
Title <- ifelse(!is.na(TITLE), TITLE, data$ID[1])

cdm <- ggplot(data, aes(x,y))+
  geom_tile(aes(fill=count2), show.legend=TRUE)+
  scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000", limits=c(0,ceiling(quant)), breaks=c(as.integer(round(quant*0.25)),as.integer(round(quant/2)),as.integer(round(quant*0.75)),as.numeric(ceiling(quant))))+
  theme_bw()+theme(aspect.ratio = 1)+
  labs(title= "Contact Density Map", subtitle = Title,x=paste0(GENE_1, " (nt)"),y=paste0(GENE_2," (nt)"))+
  scale_x_continuous(expand = c(0, 0), limits = c(x1, x2), breaks = c(c(x1+20), c(x2-20)), labels=c(x1, x2))+
  scale_y_continuous(expand = c(0, 0), limits = c(y1, y2), breaks = c(c(y1+20), c(y2-20)), labels=c(y1, y2))+
  theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
  theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90))+
  guides(fill=guide_legend(title="chimera count",label.position="bottom"))+
  theme(legend.position="bottom")+
  theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
ggsave(filename = paste0(Title,'_',x1,'-',x2,'_',y1,'-',y2,'.pdf'), plot = cdm, units = "cm", height = 18, width = 18)
