#!/usr/bin/env Rscript
#plots contact density map using all *entire.txt in the directory, normalizing the contrast
#run on terminal contact_density_map.R gene_of_interest upper_quantile(0.95)
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
GENE <- as.character(args[1])
LIMIT <- as.numeric(args[2])

# read all files using $GENE".entire.txt" pattern with content
input <- intersect(list.files(pattern=c(GENE)), list.files(pattern=c('.entire.txt')))
input <- input[which(file.info(input)$size>150)]

# read all files into lists in list, labelling each with ID
data<- list()
x=0
for (i in 1:(length(input))){
  if (x <= (length(input))){
    x=x+1
    data[[i]] <- data.table::fread((input[x]),header=T,sep="\t")
#    colnames(data[[i]]) <- c("x", "y", "count")
    data[[i]]$ID <- gsub(pattern="\\.entire.txt$","",input[x])
  }
}

# for (i in 1:(length(input))){
#     assign(paste0('data',i),data[[i]])
# }

#turn lists in list into dataframe
#calculate upper limit for setting contrast
all_data <- do.call(rbind.data.frame,data)
quant <- quantile(all_data$count, probs=LIMIT)
all_data$count2 <- ifelse(all_data$count > quant, quant, all_data$count)

#loop through datasets and plot contact density map, save as pdf
for (i in unique(all_data$ID)){
  cdm <- ggplot(all_data[which(all_data$ID==i),], aes(x,y))+
    geom_tile(aes(fill=count2), show.legend=TRUE)+
    scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000", limits=c(0,ceiling(quant)), breaks=c(as.integer(round(quant*0.25)),as.integer(round(quant/2)),as.integer(round(quant*0.75)),as.numeric(ceiling(quant))))+
    theme_bw()+theme(aspect.ratio = 1)+
    labs(title= "Contact Density Map",subtitle = i,x="3'-5' chimera (nt)",y="5'-3' chimera (nt)")+
    scale_x_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))))+ 
    scale_y_continuous(expand = c(0, 0), limits = c(0, max(max(data$x),max(data$y))))+
    theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
    theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90))+
    guides(fill=guide_legend(title="chimera count",label.position="bottom"))+
    theme(legend.position="bottom")+
    theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
  ggsave(filename = paste0(i,'.pdf'), plot = cdm, units = "cm", height = 18, width = 18)
}
  
