# get_directory = function(){
#   args <- commandArgs(trailingOnly = FALSE)
#   file <- "--file="
#   rstudio <- "RStudio"
#   
#   match <- grep(rstudio, args)
#   if(length(match) > 0){
#     return(dirname(rstudioapi::getSourceEditorContext()$path))
#   }else{
#     match <- grep(file, args)
#     if (length(match) > 0) {
#       return(dirname(normalizePath(sub(file, "", args[match]))))
#     }else{
#       return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
#     }
#   }
# }
# 
# wd = get_directory()
# setwd(wd)

get_ldheatmap_input = function(haps_file, sample_file){
  
  cat("Loading phased genome files... \n")
  haps = read.delim(file = haps_file, header = FALSE, sep = " ")
  sams = read.delim(file = sample_file, header = TRUE, sep = " ")[-1,] %>%
    dplyr::select(ID_1) %>%
    unlist() %>%
    as.character() %>%
    sapply(function(x){unlist(strsplit(x,"_"))[1]}) %>%
    sapply(function(x){gsub("X15024P002","",x)}) %>%
    sapply(function(x){c(paste0(x,c("_pat","_mat")))}) %>%
    unlist() %>%
    as.vector()
  haps = as.data.frame(haps) %>%
    dplyr::mutate_if(is.factor, as.character)
  colnames(haps) = c("chr","rs","loc","ref","alt",sams)
  
  sams = sapply(sams, function(x){unlist(strsplit(x,"_"))[1]})
  names(sams) = NULL
  sams = unique(sams)
  
  hap = dplyr::select(haps,-(chr:alt)) %>%
    dplyr::mutate_all(function(x){ifelse(x==0,haps$ref,haps$alt)})
  
  hap = dplyr::mutate(hap,A01 = paste(A01_pat, A01_mat,sep = "/"))
  
  cat("Converting phased genome file to LDheatmap input file...\n")
  for(s in sams){
    eval(parse(text = paste0("hap = dplyr::mutate(hap,",
                             s," = paste(",s,"_pat,",
                             s,"_mat,sep = '/'))")))
    cat(paste0(s, " Procesed...\n"))
  }
  
  cat("Gathering location and SNP info...\n")
  hap = dplyr::select(hap, -ends_with("_mat"),-ends_with("_pat"))
  hap = as.data.frame(t(hap),row.names = names(hap))
  names(hap) = haps$rs
  
  ldheatmap_input = list(gdat = hap,
                         gdis = haps$loc)
  return(ldheatmap_input)
  
}




