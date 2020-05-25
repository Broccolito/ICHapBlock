library(LDheatmap)
library(dplyr)
library(genetics)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

ui = dashboardPagePlus(
  header = dashboardHeaderPlus(title = "ICHapBlock", titleWidth = 400),
  sidebar = dashboardSidebar(div(
    br(),
    actionGroupButtons(inputIds = c("haps_file_dir","sample_file_dir"),
                       labels = list(".haps Dir",".sample Die"),
                       status = "primary"),
    fixedRow(
      column(1),
      column(11,textOutput(outputId = "dir1")),
      br(),
      column(1),
      column(11,textOutput(outputId = "dir2"))
    ),
    
    sliderInput(inputId = "adjacency", label = "Adjacency",
                min = 5, max = 80, value = 10),
    textInput(inputId = "SNP", label = "SNP", placeholder = "2:46588031"),
    textInput(inputId = "noted_SNPs", label = "Noted SNPs", 
              placeholder = "2:46588031,rs7597758"),
    textInput(inputId = "plot_title", label = "Plot Title", 
              placeholder = "Pairwise LD in r^2", value = "Pairwise LD in r^2"),
    textInput(inputId = "file_name", label = "File Name",
              placeholder = "LD Heatmap.png", value = "LD Heatmap.png"),
    actionGroupButtons(inputIds = c("generate_input_file","plot_ldheatmap"),
                       labels = list("Generate Input File","Plot LD Heatmap"),
                       status = "primary"),
    br(),br(),br(),
    div(style = "padding-left: 18px",
        a("See Tutotial", href="Tutorial.html")
    )
  ),width = 400),
  body = dashboardBody(
    sliderInput(inputId = "img_size",label = "Image Size (px)",
                min = 400, max = 2000, value = 600),
    downloadButton(outputId = "download_image",label = "Download Image"),
    uiOutput(outputId = "heatmap_plot")
  )
)

server = function(input, output, session) {
  
  source("get_ldheatmap_input.R")
  source("plot_ldheatmap.R")
  fn <<- ""
  
  output$download_image = downloadHandler(
    filename = function(){
      as.character(input$file_name)
    },
    content = function(con){
      file.copy(from = isolate(paste0("www/",input$file_name)),
                to = con)
    }
  )
  
  observeEvent(input$plot_ldheatmap,{
    
    if(input$file_name == fn){
      showModal(modalDialog(title = "Identical File Name ...",
                            "Please assign a unique file name for each analysis... "))
    }else{
      fn <<- input$file_name
      
      tryCatch({
        showModal(modalDialog(title = "Generating LD heatmap ...",
                              "Save LD heatmap as a png file... "))
        noted_SNPs = gsub(" ","",input$noted_SNPs)
        noted_SNPs = gsub(";",",",noted_SNPs)
        plot_ldheatmap(adjacency = input$adjacency,
                       SNP = input$SNP,
                       noted_SNPs = noted_SNPs,
                       file_name = input$file_name,
                       plot_title = input$plot_title)
        removeModal()
      },error = function(e){
        showModal(modalDialog(title = "An Error Occurred ...",
                              "Please make sure all inputs required by the LD plot are given... "))
      })
      
      output$heatmap_plot = renderUI({
        div(
          br(),
          img(src = isolate(input$file_name), width = input$img_size, align = "center")
        )
      })
    }
    
  })
  
  observeEvent(input$generate_input_file, {
    showModal(modalDialog(title = "Generating LD heatmap input file ...",
                          "Converting .haps and .sample files to LD heatmap input... "))
    ldheatmap_input <<- get_ldheatmap_input(haps_file = haps_file,
                                            sample_file = sample_file)
    removeModal()
    showModal(modalDialog(title = "Calculating Object size ...",
                          "Object size has to be smaller than system RAM ... "))
    obj_size = round(as.numeric(object.size(ldheatmap_input))/1e6,0)
    showModal(modalDialog(title = "Object Size",
                          paste0(obj_size," Mb LD heatmap object generated.")))
  })
  
  observeEvent(input$haps_file_dir,{
    haps_file <<- choose.files(multi = FALSE)
    output$dir1 = renderText({
      paste0("HAPS file dir: ",haps_file, "\n") 
    })
  })
  
  observeEvent(input$sample_file_dir,{
    sample_file <<- choose.files(multi = FALSE)
    output$dir2 = renderText({
      paste0("SAMPLE file dir: ",sample_file)
    })
  })
  
  onSessionEnded(function(){
    stopApp()
  })
}

shinyApp(ui, server)