plot_ldheatmap = function(adjacency = 10,
                          SNP = "2:46588031",
                          noted_SNPs = c("2:46588031"),
                          file_name = "LD Heatmap.png",
                          plot_title = "Pairwise LD in r^2"){
  not.genotype = function(x){
    return(!is.genotype(x))
  }
  file_name = paste0("www/",file_name)
  
  index = which(names(ldheatmap_input$gdat) == SNP)
  plotting_range = c(index - adjacency, index + adjacency)
  gdat = ldheatmap_input$gdat[,plotting_range[1]:plotting_range[2]] %>%
    mutate_if(not.genotype,as.genotype)
  gdis = ldheatmap_input$gdis[plotting_range[1]:plotting_range[2]]
  png(filename = file_name, width = 7, height = 7, units = "in", res = 1200)
  plt = LDheatmap(gdat = gdat,
                  genetic.distances = gdis,          
                  LDmeasure = "r",
                  title = plot_title, 
                  add.map = TRUE,
                  SNP.name = noted_SNPs,
                  color = heat.colors(20), 
                  name="myLDgrob",
                  add.key = TRUE)
  graphics.off()
}


