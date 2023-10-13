#!/usr/bin/env Rscript
#plots viewpoint graph based on *gplot input
#run on terminal viewpoint_graph.R input.gplot 
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])


# read data
data <- data.table::fread(INPUT,header=F,sep="\t")
colnames(data) <- c('Nucleotide_position', 'Chimera_count')

# plot bar chart
vp <- ggplot(data, aes(x=Nucleotide_position, y=Chimera_count))+
  geom_bar(stat="identity", color="grey")+
  theme_bw()+
  scale_x_continuous(expand = c(0, 0))+
  labs(title = (gsub(pattern="\\.gplot$","_viewpoint",INPUT)))+
  theme(plot.title=element_text(size=10),text=element_text(size=9.5))+
  theme(plot.margin = unit(c(0.1, 0.1, 0, 0), "cm"))
# save as pdf
ggsave(filename = paste0(gsub(pattern="\\.gplot$","_viewpoint",INPUT),".pdf"), plot = vp, units = "cm", height = 12, width = 18)
