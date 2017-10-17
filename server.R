# server.R

library(ggplot2)
library(reshape2)
library(grid)
library(scales)

source("setup.R")

shinyServer(function(input, output, session) {
  ##################################################
  ## slider_pos input
  ##################################################
  output$slider_pos <- renderUI({
    qtlChr <- subset(phenotype_data, chr == input$chromosome)
    max_phy_pos <- max(qtlChr$phy_pos, 1)
    sliderInput("region", label = h5("Display a region of the chromosome?"),
     min = 0, max = max_phy_pos, value = c(0, max_phy_pos), step = 0.001)
  })

  ##################################################
  ## slider_k input
  ##################################################
  output$slider_k <- renderUI({
    sliderInput("k", label = h5("Display top k genes? (Default: k = 20)"),
                min = 0, max = 300, value = 20, step = 10)
  })
  
  
  ##################################################
  # qtl graph
  ##################################################
  output$qtl_graph <- renderPlot({
    
    # determines the trait that is inputted
    trait_num = input$traits[1]
#     trait_pos <- grep(trait_num, names(phenotype_data))
    trait_pos <- as.numeric(trait_num) + 3
    lod <- phenotype_data[, trait_pos]
    trait <- rep(names(phenotype_data)[trait_pos], length(lod))
    
    # extracts the needed info from phenotype_data
    qtlData <- subset(phenotype_data, select = c(chr, pos, phy_pos, background.color))
    qtlData <- cbind(qtlData, lod, trait)
    
    # if there's a second trait selected...
    if (length(input$traits) > 1){
      # determines the trait that is inputted
      trait_num2 = input$traits[2]
      trait_pos2 <- grep(trait_num2, names(phenotype_data))
      lod <- phenotype_data[, trait_pos2]
      trait <- rep(trait_num2, length(lod))

      # extracts the needed info from phenotype_data
      qtlData2 <- subset(phenotype_data, select = c(chr, pos, phy_pos, background.color))
      qtlData2 <- cbind(qtlData2, lod, trait)

      qtlData <- rbind(qtlData, qtlData2)
    }
    
    # if there's a third trait selected...
    if (length(input$traits) > 2){
      # determines the trait that is inputted
      trait_num3 = input$traits[3]
      trait_pos3 <- grep(trait_num3, names(phenotype_data))
      lod <- phenotype_data[, trait_pos3]
      trait <- rep(trait_num3, length(lod))
      
      # extracts the needed info from phenotype_data
      qtlData3 <- subset(phenotype_data, select = c(chr, pos, phy_pos, background.color))
      qtlData3 <- cbind(qtlData3, lod, trait)
      
      qtlData <- rbind(qtlData, qtlData3)
    }
    
    # subsets the data depending on chromosome selected
    if (input$chromosome == 0){
      # do nothing
    } else {
      qtlData <- subset(qtlData, chr == input$chromosome)
    }     
    
    # extracts the max lod value for the data set
      peak <- max(qtlData$lod)
    
    # start of the plot
    qtl_plot <- ggplot(qtlData)
    
    # determines the color of the background; depends if all chromosomes are plotted, or just one
    # plots a certain region only for single chromosomes (changes xlim)
    if (input$chromosome == 0){
      qtl_plot <- qtl_plot +
        scale_fill_manual(values = c("1" = "gray90", "0" = "white"))
    } else {
      qtl_plot <- qtl_plot +
        scale_fill_manual(values = c("1" = "white", "0" = "white")) +
        scale_x_continuous(limits = c(input$region[1], input$region[2]))
    }
    
    # rest of the plot
    qtl_plot <- qtl_plot +
      facet_grid(~ chr, scales = "free_x", space = "free_x") +
      geom_rect(aes(fill = background.color), xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
      geom_line(aes(x = phy_pos, y = lod, color = as.factor(trait)), size = 2) +
      geom_hline(yintercept = 3, color = "red", size = 1) +
      geom_segment(aes(x = phy_pos, xend = phy_pos), y = (peak * -0.02), yend = (peak * -0.05)) +
      scale_y_continuous(expand = c(0, 0), limits = c((peak * -0.06), max (5, peak))) +
      ggtitle("LOD Curves for phQTLs") +
      xlab("Chromosome Position (Mb)") +
      ylab("LOD Score") +
      theme(axis.text = element_text(size=12),
            axis.text.x = element_text(angle = 90),
            axis.title = element_text(size=16),
            axis.title.y = element_text(vjust = 2),
            axis.line=element_line(),
            title = element_text(size=16),
            legend.position = "top",
            plot.margin = unit(c(0, 0, 0, 0.55), "cm"),
            ##panel.margin = unit(0, "cm"))
            panel.spacing = unit(0, "cm"))
    
    if (length(input$traits) == 1){
      qtl_plot <- qtl_plot +
                    scale_colour_manual(name = "Trait", values = "black")
    } else if (length(input$traits) == 2){
      qtl_plot <- qtl_plot +
                    scale_colour_manual(name = "Trait", values =c("black", "blue"))
    } else if (length(input$traits) == 3){
      qtl_plot <- qtl_plot +
                    scale_colour_manual(name = "Trait", values =c("black","blue", "green"))
    }

    qtl_plot <- qtl_plot + guides(fill=FALSE)

    # plots the graph
    qtl_plot
    
  })
  
  ##################################################
  # expression graph
  ##################################################
  output$expression_graph <- renderPlot({
    print(input$region[1])
    print(input$region[2])
    
    # subsets the data depending on chromosome selected
    data4plotting <- subset(expression_data, tx_chrom == input$chromosome & tx_start >= input$region[1] & tx_end <= input$region[2],
                            select = c("tx_start", "tx_end", "t_stat", "fold_change"))
    t_limits <- c(-max(abs(data4plotting$t_stat),na.rm=TRUE), max(abs(data4plotting$t_stat),na.rm=TRUE))
    fc_limits <- c(-max(abs(data4plotting$fold_change),na.rm=TRUE), max(abs(data4plotting$fold_change),na.rm=TRUE))

    if (input$ex_graph == 1){ # t-statistic
      expression_plot <- ggplot(data4plotting) +
                          geom_point(aes(tx_start, t_stat, color = t_stat)) +
                          ## scale_colour_gradientn(colours = c("red", "red1", "red2", "red3", "black", "blue3", "blue2", "blue1", "blue"), name = "t-statistic", limits=t_limits) +
                          scale_colour_gradientn(colours = c("cyan", "cyan1", "cyan2", "cyan3", "black", "magenta3", "magenta2", "magenta1", "magenta"), name = "t-statistic", limits=t_limits) +
                          ylab("t-statistic")
    } else { # fold change
      expression_plot <- ggplot(data4plotting) +
                          geom_point(aes(tx_start, fold_change, color = fold_change)) +
                          ## scale_colour_gradientn(colours = c("red", "red1", "red2", "red3", "red4", "black", "blue4", "blue3", "blue2", "blue1", "blue"), name = "log2 (fold change)",limits=fc_limits) +
                          scale_colour_gradientn(colours = c("cyan", "cyan1", "cyan2", "cyan3", "cyan4", "black", "magenta4", "magenta3", "magenta2", "magenta1", "magenta"), name = "log2 (fold change)",limits=fc_limits) +    
                          ylab("log2 (fold change)")
                          
                          
    }
    expression_plot +
      xlab("Chromosome Position (Mb)") +
      theme(axis.text = element_text(size=12),
            axis.title = element_text(size=16),
            title = element_text(size=16),
            legend.position = "top")
  })
  
  ##################################################
  # generates the dataset for users to download - complete list of genes in the region that they are viewing
  ##################################################
  download_data <- reactive({
    if (input$chromosome == 0){
        data <- expression_data
    } else{
      data_in_region <- subset(expression_data, tx_start >= input$region[1] & tx_end <= input$region[2])
      data <- subset(data_in_region, tx_chrom == input$chromosome)
    }
  })
  
  # allows user to download the full gene table
  output$download_table <- downloadHandler(
    filename = function() {
      if (input$chromosome == 0){
        c("all_chr.csv")
      } else {
        paste("chr", input$chromosome, "_pos", input$region[1], ":", input$region[2], ".csv", sep="")
      }
    },
    content = function(file) {
      write.csv(download_data(), file)
    }
  )
  
  # generates the data for the table. outputs gene name, relative expressions for both alleles, physical position, chromosome, t-statistic, and fold change
  # or just gene name, position, and expression?
  # only shows top 10 upregulated and top 10 downregulated genes
  table_data <- reactive({
    selected.data <- subset(expression_data, select = c(gene_name, t_stat, fold_change, tx_chrom, tx_start, tx_end, LocusName, RiceXPro))
    if (input$chromosome == 0) {
        data <- selected.data
    } else {
      data_in_region <- subset(selected.data, tx_start >= input$region[1] & tx_end <= input$region[2])
      data <- subset(data_in_region, tx_chrom == as.numeric(input$chromosome))
    }
    if (input$ex_graph == 1){ # t-statistic
      sorted_data <- data[order(data$t_stat),]
    } else {
      sorted_data <- data[order(data$fold_change),]
    }
    sorted_data$tx_chrom = as.character(sorted_data$tx_chrom)
    top10downregulated <- head(sorted_data, n=input$k/2)
    top10upregulated <- tail(sorted_data, n=input$k/2)
    final_table <- rbind(top10downregulated, top10upregulated)
    colnames(final_table)[4] <- "chr"
    colnames(final_table)[5] <- "start"
    colnames(final_table)[6] <- "end"
    unique(final_table) # ensures there are no duplicates (in case the gene list < 10)
  })
  
  # shows the data previously retreived in a table
  output$table <- renderTable({
    table_data()
    }, include.rownames = FALSE)
    
})
