eQTL analysis for deepwater rice by QTLVizR
========
In our eQTL paper, we employed the customized version of [QTLVizR](https://github.com/tiaho/QTL-Visualization) for the visual inspection of phQTLs and for transcript profiling in a chromosomal context. The tool is a web-based application software originally developed by Maloof Lab at the University of California at Davis. The implementation is based on R/shiny; it renders visualization highly dynamic. 

An example app on the web created by Julin Moloof's lab:
  [http://phytonetworks.org/apps/qtl-visualization/](http://phytonetworks.org/apps/qtl-visualization/)
  
  
Installation
------------
```R
install.packages("devtools")

library(shiny)
runGitHub("QTL-Visualization", "afukushima")
```

Note: Before running, you should upgrade your installed packages in R>=3.4. See [http://shiny.rstudio.com/articles/upgrade-R.html](http://shiny.rstudio.com/articles/upgrade-R.html).
  

Our paper's summary
------------
To avoid low oxygen, oxygen deficiency or oxygen deprivation, deepwater rice cultivated in flood planes can develop elongated internodes in response to submergence. Knowledge of the gene regulatory networks underlying rapid internode elongation is important for an understanding of the evolution and adaptation of major crops in response to flooding. To elucidate the genetic and molecular basis controlling their deepwater response we used microarrays and performed expression quantitative trait loci (eQTL) and phenotypic QTL (phQTL) analyses of internode samples of 85 recombinant inbred line (RIL) populations of non-deepwater (Taichung 65)- and deepwater rice (Bhadua). After evaluating the phenotypic response of the RILs exposed to submergence, confirming the genotypes of the populations, and generating 188 genetic markers, we identified 10,047 significant eQTLs comprised of 2,902 _cis_-eQTLs and 7,145 _trans_-eQTLs and three significant eQTL hotspots on chromosomes 1, 4, and 12 that affect the expression of many genes. The hotspots on chromosomes 1 and 4 located at different position from phQTLs detected in this study and other previous studies. We then regarded the eQTL hotspots as key regulatory points to infer causal regulatory networks of deepwater response including rapid internode elongation. Our results suggest that the downstream regulation of the eQTL hotspots on chromosomes 1 and 4 is independent, and that the target genes are partially regulated by _SNORKEL1_ and _SNORKEL2_ genes (_SK1/2_), key ethylene response factors. Subsequent bioinformatic analyses, including gene ontology-based annotation and functional enrichment analysis and promoter enrichment analysis, contribute to enhance our understanding of SK1/2-dependent and independent pathways. One remarkable observation is that the functional categories related to photosynthesis and light signaling are significantly over-represented in the candidate target genes of SK1/2. The combined results of these investigations together with genetical genomics approaches using structured populations with a deepwater response are also discussed in the context of current molecular models concerning the rapid internode elongation in deepwater rice. This study provides new insights into the underlying genetic architecture of gene expression regulating the response to flooding in deepwater rice and will be an important community resource for analyses on the genetic basis of deepwater responses.


Methods
------------
For eQTL mapping, we performed standard quality control, pre-processing of multiple probe-sets assigned to a single gene, and variance filtering. We used 12,264 e-traits in further eQTL mapping to increase the statistical power (Bourgon et al., 2010). Normalized microarray data were used for eQTL mapping with the R package “eqtl” (Cubillos et al., 2012b). 

For phQTL mapping, we used the R package “qtl” (Arends et al., 2010). LOD thresholds were obtained using 1,000 permutations for a significance level of 5%. A global permutation threshold (GPT) was used for determining a genome-wide threshold for statistically significant eQTLs. The significance level for the GPT was set at 0.05. 

To identify differentially expressed genes (DEGs) between deepwater and non-deepwater phenotypes, we calculated log2-mean expression fold-change of each gene in deepwater type (TIL ≥ 20 cm; Bhadua and 44 RILs) compared to that of non-deepwater type (TIL < 20 cm; T65 and 41 RILs). For the calculation, we used the R package LIMMA (Smyth, 2005); it features false discovery rate (FDR) correction for multiple testing (Benjamini and Hochberg, 1995). The plot on our modified QTLVizR represents log2-foldchange (deepwater/non-deepwater phenotypes). The foldchange values represented by increasingly bright shades of magenta and cyan indicate, respectively, up-regulation and down-regulation in RILs with deepwater phenotype (TIL ≥ 20 cm).

You can see the location of _SK1/2_ genes is consistent with that of phQTLs for TIL (on chromosome 12). The peak of eQTLs for the expression of _SK1/2_ was detected as cis-eQTL in the region where their own genes were located.


Documents
------------
For details, see Kuroha et al. "eQTLs Regulating Transcript Variations Associated with Rapid Internode Elongation in Deepwater Rice", Front Plant Sci 8:1753 (2017). [doi:10.3389/fpls.2017.01753](https://doi.org/10.3389/fpls.2017.01753)


Abbreviations
------------
TIL, total internode length; PH, plant height; NEI, number of elongated internodes; QTL, quantitative trait locus; eQTL, expression QTL; phQTL, phenotypic QTL; and LOD, logarithm of the odds.


License
------------
This web-app is free software; a copy of the GNU General Public License, version 3, is available at [http://www.r-project.org/Licenses/GPL-3](http://www.r-project.org/Licenses/GPL-3)
