#!/usr/bin/env Rscript
#plots contact density map from 1 input
#run on terminal contact_density_map_indiv.R input.contact.txt upper_quantile(0.95) plot_title
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])
LIMIT <- as.numeric(args[2])
TITLE <- as.character(args[3])

# read data
data <- data.table::fread(INPUT,header=T,sep="\t")
# colnames(data) <- c("x", "y", "count")

# set ID name, upper quantile limit
data$ID <- gsub(pattern="\\.contact.txt$","",INPUT)
quant <- quantile(data$count, probs=LIMIT)
data$count2 <- ifelse(data$count > quant, quant, data$count)
Title <- ifelse(!is.na(TITLE), TITLE, data$ID[1])

#plot contact density map, save as pdf
cdm <- ggplot(data, aes(x,y))+
  geom_tile(aes(fill=count2), show.legend=TRUE, na.rm=TRUE)+
  guides(fill = guide_colourbar(barwidth = 0.5, barheight = 10, ticks.colour = "white" ,title = "Chimera Count", title.position = "right", 
                                title.theme = element_text(angle = 270, size = 9.5), title.vjust = 0, title.hjust = 0.5,
                                label.position = "left", label.theme = element_text(angle = 270, size = 9), label.vjust = 0, label.hjust = 0.5))+
  scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000")+
  theme_bw()+theme(aspect.ratio = 1)+
  labs(title="Contact Density Map", subtitle = Title,x="Arm 1 (nt)",y="Arm 2 (nt)")+
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(data$x)))+
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(data$x)))+
  theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
  theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90, vjust = 0, hjust = 0.5))+
  theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
ggsave(filename = paste0(Title,'.pdf'), plot = cdm, units = "cm", height = 17, width = 18)

