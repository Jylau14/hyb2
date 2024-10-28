#!/usr/bin/env Rscript
library(dplyr)
library(ggplot2)
library(gridExtra)
library(data.table)

# Input command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Parse numeric limits from the first four arguments
x1 <- as.integer(args[1])
x2 <- as.integer(args[2])
y1 <- as.integer(args[3])
y2 <- as.integer(args[4])
LIMIT <- as.numeric(args[5])

# Remaining arguments are the directories for .forTable.txt files
input_dirs <- args[6:length(args)]  # Capture all remaining arguments

# List files for reading
input <- unlist(lapply(input_dirs, function(dir) {
  for_table_files <- list.files(pattern = '\\.forTable.txt$')
  intersect(for_table_files, list.files(pattern = paste0(args[6:length(args)], collapse = "|")))
}))

# Convert to .contact.txt file names
input <- gsub(pattern = "\\.forTable.txt$", ".contact.txt", input)

# Check if input files exist
if (length(input) == 0) {
  stop("No input files found.")
}

# Read data
data <- lapply(input, function(file) {
  df <- data.table::fread(file, header = TRUE, sep = "\t")
  colnames(df) <- c("x", "y", "count")
  df$ID <- gsub(pattern = "\\.contact.txt$", "", file)
  return(df)
})

# Combine data
all_data <- do.call(rbind.data.frame, data)

# Calculate upper limit for setting contrast
all_data <- na.omit(all_data)  # Remove NAs if any
quant <- quantile(all_data$count, probs = LIMIT)

# Loop through datasets and plot contact density map
cdm <- list()
for (i in unique(all_data$ID)) {
  cdm[[i]] <- ggplot(all_data[all_data$ID == i, ], aes(x, y)) +
    geom_tile(aes(fill = pmin(count, quant)), show.legend = FALSE) +
    scale_fill_gradient(na.value = "#ffffff", low = "#ffffff", high = "#000000", limits = c(0, ceiling(quant))) +
    theme_bw() + theme(aspect.ratio = 1) +
    labs(title = i, x = "3'-5' chimera (nt)", y = "5'-3' chimera (nt)") +
    scale_x_continuous(expand = c(0, 0), limits = c(x1, x2), breaks = c(x1 + 25, x2 - 45), labels = c(x1, x2)) +
    scale_y_continuous(expand = c(0, 0), limits = c(y1, y2), breaks = c(y1 + 25, y2 - 45), labels = c(y1, y2)) +
    theme_void() +
    theme(axis.text = element_text(size = 7)) +
    theme(panel.background = element_rect(colour = "black", size = 0.5)) +
    theme(plot.title = element_text(size = 8))
}

# Combine plots and save
com <- do.call("grid.arrange", c(cdm, nrow = 1))
ggsave(filename = paste0(x1, x2, y1, y2, ".pdf"), plot = com, units = "cm", height = 8, width = (length(cdm) * 8))

