# ui.R

library(shiny)

# creates the data used for the trait select input
phenotype_data <- read.csv("data3/uki_real_traits.csv")  ## eQTL analysis for deepwater rice
num_traits <- length(names(phenotype_data)) - 3
trait_names <- list()
for (i in 1:num_traits){
  trait_names[i] = i
}
names(trait_names) <- names(phenotype_data)[4:length(names(phenotype_data))]

shinyUI(fluidPage(
  titlePanel("eQTL analysis for deepwater rice by QTLVizR"),
  
  sidebarLayout(
    sidebarPanel(     
      selectInput("traits", label = h5("Plot which trait?"), 
                                    choices = list("TIL" = 1,
                                                    "Plant_height (PH)" = 2,
                                                    "NEI" = 3),
                                    selected = 1),
      br(),
      selectInput("chromosome", label = h5("Plot which chromosome(s)?"), 
                  choices = list("All" = 0,
                                 "Chromosome 1" = 1,
                                 "Chromosome 2" = 2,
                                 "Chromosome 3" = 3,
                                 "Chromosome 4" = 4,
                                 "Chromosome 5" = 5,
                                 "Chromosome 6" = 6,
                                 "Chromosome 7" = 7,
                                 "Chromosome 8" = 8,
                                 "Chromosome 9" = 9,
                                 "Chromosome 10" = 10,
                                 "Chromosome 11" = 11,
                                 "Chromosome 12" = 12
                                 ),
                  selected = 12),
      br(),
      selectInput("ex_graph", label = h5("Plot t-statistic or log2 (fold change)"), 
                  choices = list("t-statistic" = 1,
                                 "log2 (fold change)" = 2),
                  selected = 2),
      br(),
      conditionalPanel(condition = "input.chromosome != 0", uiOutput("slider_pos"), uiOutput("slider_k")),
      br(),
      downloadButton('download_table', 'Download Table for Genes in View'),
      br(),
      br(),
      br(),
      p("QTLvizR is a web application to help visualize quantitative trait loci (QTL). This app was originally from QTLvizR (https://github.com/tiaho/QTL-Visualization).", style = "font-family: 'times'; font-size: 14pt"),
      a(href="https://github.com/tiaho/QTL-Visualization", "QTLvizR GitHub"),
      p("This app allows the users to select physiological traits from a drop down menu.
      The app shows the support for a phenotypic QTL (phQTL) for every genotyped marker across the organism's genome.
      The user can sub-select specific chromosomes, or intervals along a chromosome to focus attention on.
      At the same time, QTL's for gene expression QTL (eQTL) for genes falling within the user defined genomic interval are also visualized.
      This allows the user to quickly examine a genomic region for co-occurrence of phQTL and eQTL.", style = "font-family: 'times'; font-size: 12pt"),
      p("For details, see Kuroha et al. eQTLs Regulating Transcript Variations Associated with Rapid 
      Internode Elongation in Deepwater Rice, Front Plant Sci 8:1753 (2017).", style = "font-family: 'times'; font-size: 12pt"),
      a(href="https://doi.org/10.3389/fpls.2017.01753", "doi: 10.3389/fpls.2017.01753")
      ),
    
    
    mainPanel(
      plotOutput("qtl_graph"),
      br(),
      br(),
      conditionalPanel(condition = "input.chromosome != 0", plotOutput("expression_graph")),
      br(),
      br(),
      "Top k Differentially Expressed Genes",
      tableOutput("table")
    )
  )
    
))