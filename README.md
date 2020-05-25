# ICHapBlock
ICHapBlock uses R shiny and shinydashboard to visualize haploblocks in human genome.



### Usage

- Install R

  [R for Windows]https://cran.r-project.org/bin/windows/base/old/3.5.3/

  [R for Mac]https://cran.r-project.org/bin/macosx/

  In Ubuntu:

  ```bash
  sudo apt-get install r-base
  ```

- Install Shiny and required packages in R

  In R, type in:

  ```R
  install.packages("shiny")
  install.packages("LDheatmap")
  install.packages("dplyr")
  install.packages("genetics")
  install.packages("shiny")
  install.packages("shinydashboard")
  install.packages("shinydashboardPlus")
  install.packages("shinyWidgets")
  library("shiny")
  ```

- Run Github Instance

  ```R
  runGitHub(repo = "ICHapBlock", username = "Broccolito")
  ```



### License

MIT



### Contributor

| Name      | Email           |
| --------- | --------------- |
| Wanjun Gu | wag001@ucsd.edu |



### Reference

Delaneau, O.; Coulonges, C.; Zagury, J.-F. Shape-IT: New Rapid and Accurate Algorithm for Haplotype Inference. *BMC Bioinformatics* **2008**, *9*, 540.

Shin, J.-H.; Blay, S.; McNeney, B.; Graham, J. LDheatmap: An R Function for Graphical Display of Pairwise Linkage Disequilibria Between Single Nucleotide Polymorphisms. *Journal of Statistical Software, Code Snippets* **2006**, *16* (3), 1–9.