#!/usr/bin/env Rscript

library(shiny)
library(ggplot2)
library(data.table)
args <- commandArgs(trailingOnly = TRUE)
INPUT <- as.character(args[1])
HYB <- as.character(args[2])
GENE <- as.character(args[3])
FASTA <- as.character(args[4])
VARNA <- as.character(args[5])
GENE2 <- as.character(args[6])
FASTA2 <- as.character(args[7])

data <- data.table::fread(INPUT,header=T,sep="\t")
colnames(data) <- c("x", "y", "uncapped_count")
quant <- quantile(data$uncapped_count, probs=0.95)
data$count <- ifelse(data$uncapped_count > quant, quant, data$uncapped_count)

Fold_type <- c("Short-Ranged Intramolecular (<500nt Apart)", "Long-Ranged Intramolecular", "Intermolecular", "Homodimer")

ui <- fluidPage(
  fluidRow(
    column(width = 4,
           plotOutput("plot1", height = 400,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush",
                        resetOnNew = TRUE
                      )
           )
    ),
    column(width = 4,
           plotOutput("plot2", height = 400,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot2_brush",
                        resetOnNew = TRUE
                      )
           )
    ),
    column(width = 4,
           plotOutput("plot3", height = 400)
    ),
    fluidRow(
      column(width = 4, align = "center",
             h4("Selected Interaction"),
             verbatimTextOutput("click_info")
      ),
      column(width = 4, align = "center",
             h4("Highlighted Interactions"),
             verbatimTextOutput("brush_info")
      ),
      column(width = 4, align = "center",
             h4("Magnified Interaction"),
             verbatimTextOutput("brush_info2")
      )
    ),
    titlePanel(h4("RNA Secondary Structure Folding Using Selected Coordinates", align = "center")),
    fluidRow(
      column(width = 4, wellPanel(
        radioButtons("type", "Type of RNA-RNA Interaction", Fold_type))),
      column(width = 4, wellPanel(
        textInput("x_coord", "X Start Coordinate"),
        conditionalPanel("input.type === 'Long-Ranged Intramolecular' || input.type === 'Intermolecular'",
                         textInput("y_coord", "Y Start Coordinate"),
        ))),
      column(width = 4, align = "center", wellPanel(
        sliderInput("len", "RNA Length For Folding", value = 200, min = 50, max = 1000, step = 50, ticks = FALSE)))
    ),
    fluidRow(
      column(width = 12, align = "center",
             actionButton("fold", "Fold RNA!", class = "btn-success btn-lg", style = 'font-size:150%')
      )
    )
  )
)

server <- function(input, output, session) {
  ranges <- reactiveValues(x = NULL, y = NULL)
  ranges2 <- reactiveValues(x = NULL, y = NULL)
  
  output$plot1 <- renderPlot({
    ggplot(data, aes(x,y))+
      geom_tile(aes(fill=count), show.legend=F)+
      guides(fill = guide_colourbar(barwidth = 0.5, barheight = 10, ticks.colour = "white" ,title = "Chimera Count", title.position = "right",
                                    title.theme = element_text(angle = 270, size = 9.5), title.vjust = 0, title.hjust = 0.5,
                                    label.position = "left", label.theme = element_text(angle = 270, size = 9), label.vjust = 0, label.hjust = 0.5))+
      scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000")+
      theme_bw()+theme(aspect.ratio = 1)+
      labs(title="Contact Density Map", subtitle = INPUT,x="3'-5' Chimera (nt)",y="5'-3' Chimera (nt)")+
      scale_x_continuous(expand = c(0, 0), limits = c(0, max(data$x)+10))+
      scale_y_continuous(expand = c(0, 0), limits = c(0, max(data$x)+10))+
      theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
      theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90, vjust = 0, hjust = 0.5))+
      theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
  }, res = 96)
  
  output$plot2 <- renderPlot({
    ggplot(data, aes(x,y))+
      geom_tile(aes(fill=count), show.legend=F)+
      guides(fill = guide_colourbar(barwidth = 0.5, barheight = 10, ticks.colour = "white" ,title = "Chimera Count", title.position = "right",
                                    title.theme = element_text(angle = 270, size = 9.5), title.vjust = 0, title.hjust = 0.5,
                                    label.position = "left", label.theme = element_text(angle = 270, size = 9), label.vjust = 0, label.hjust = 0.5))+
      scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000")+
      theme_bw()+theme(aspect.ratio = 1)+
      labs(title="Contact Density Map", subtitle = INPUT,x="3'-5' Chimera (nt)",y="5'-3' Chimera (nt)")+
      theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
      theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90, vjust = 0, hjust = 0.5))+
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)+
      theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
  }, res = 96)
  
  output$plot3 <- renderPlot({
    ggplot(data, aes(x,y))+
      geom_tile(aes(fill=count), show.legend=F)+
      guides(fill = guide_colourbar(barwidth = 0.5, barheight = 10, ticks.colour = "white" ,title = "Chimera Count", title.position = "right",
                                    title.theme = element_text(angle = 270, size = 9.5), title.vjust = 0, title.hjust = 0.5,
                                    label.position = "left", label.theme = element_text(angle = 270, size = 9), label.vjust = 0, label.hjust = 0.5))+
      scale_fill_gradient(na.value ="#ffffff", low = "#ffffff",high="#000000")+
      theme_bw()+theme(aspect.ratio = 1)+
      labs(title="Contact Density Map", subtitle = INPUT,x="3'-5' Chimera (nt)",y="5'-3' Chimera (nt)")+
      theme(plot.title=element_text(size=10),plot.subtitle=element_text(size=10),text=element_text(size=9.5), axis.text=element_text(size=9))+
      theme(panel.grid.minor = element_blank(), axis.text.y = element_text(angle = 90, vjust = 0, hjust = 0.5))+
      coord_cartesian(xlim = ranges2$x, ylim = ranges2$y, expand = FALSE)+
      theme(plot.margin = unit(c(0.1, 0, 0, 0), "cm"))
  }, res = 96)
  
  output$click_info <- renderPrint({
    (nearPoints(data, input$plot1_click)[order(-count),])
  })
  
  output$brush_info <- renderPrint({
    brushedPoints(data, input$plot1_brush)[order(-count),]
  })
  
  output$brush_info2 <- renderPrint({
    brushedPoints(data, input$plot2_brush)[order(-count),]
  })
  
  observe({
    brush <- input$plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  observe({
    brush2 <- input$plot2_brush
    if (!is.null(brush2)) {
      ranges2$x <- c(brush2$xmin, brush2$xmax)
      ranges2$y <- c(brush2$ymin, brush2$ymax)
      updateTextInput(session, "x_coord", value=round(brush2$xmin, digits = 0))
      updateTextInput(session, "y_coord", value=round(brush2$ymin, digits = 0))
      
    } else {
      ranges2$x <- NULL
      ranges2$y <- NULL
    }
  })
  observeEvent(input$fold, {
    if (input$type == "Short-Ranged Intramolecular (<500nt Apart)") {system(paste0("hyb2_fold -i ", HYB, " -a ", GENE, " -1 ", FASTA, " -x ", input$x_coord, " -l ", input$len, " -j ", VARNA, " -0 1"))}
    else if (input$type == "Long-Ranged Intramolecular") system(paste("hyb2_fold -i ", HYB, " -a ", GENE, " -1 ", FASTA, " -x ", input$x_coord, " -y ", input$y_coord, " -l ", input$len, " -j ", VARNA, " -0 1"))
    else if (input$type == "Intermolecular") system(paste("hyb2_fold -i ", HYB, " -a ", GENE, " -b ", GENE2, " -1 ", FASTA, " -2 ", FASTA2, " -x ", input$x_coord, " -y ", input$y_coord," -l ", input$len, " -j ", VARNA, " -0 1"))
    else if (input$type == "Homodimer") system(paste("hyb2_fold -i ", HYB, " -a ", GENE, " -b ", GENE2, " -1 ", FASTA, " -x ", input$x_coord, " -l ", input$len, " -j ", VARNA, " -0 1"))
  })
}

shinyApp(ui, server)

# old_path <- Sys.getenv("PATH")
# Sys.setenv(PATH = paste(old_path, "/datastore/home/ljianyo/bin", sep = ":"))
