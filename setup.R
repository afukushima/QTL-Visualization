## setup.R
## eQTL analysis for deepwater rice

allele_data <- read.csv("data3/allele_specific_limma.csv")
eqtl_data <- read.csv("data3/rice.coord.csv")
phenotype_data <- read.csv("data3/uki_real_traits.csv")
annotation_data <- read.csv("data3/RiceXPro_annotation.csv")

# extracts the physical location from the phenotypic data
phenotype_data$phy_pos <- as.numeric(phenotype_data$pos)

# converts the chromosome vaue from Axx to x
phenotype_data$chr <- as.numeric(phenotype_data$chr)

# assigns background colors to the phenotype data, based on chromosome
phenotype_data$background.color <- "1"
phenotype_data$background.color[(phenotype_data$chr %% 2) == 0] <- "0"

# merges some data frames together to get the desired data frame for plotting the expression graph
exp_data <- merge(x = allele_data, y = eqtl_data, by.x = "gene_name", by.y = "tx_name")

# merges some data frames with annotation
expression_data <- merge(x = exp_data, y = annotation_data, by.x = "gene_name", by.y = "ProbeName")

# converts the chromosome vaue from Axx to x
expression_data$tx_chrom <- as.numeric(expression_data$tx_chrom)

# converts the physical position from bases to megabases
expression_data$tx_start <- round(expression_data$tx_start / 1000000, digits = 3)
expression_data$tx_end <- round(expression_data$tx_end / 1000000, digits = 3)
