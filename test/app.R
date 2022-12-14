# Packages ----
library(shiny)  # Required to run any Shiny app
library(neurobase)
library(glue)

#Deploy: https://www.shinyapps.io/admin/#/dashboard

# ui.R ----
ui <- fluidPage(
  titlePanel("Visualise Voxel-level data"),
  sidebarLayout(
    sidebarPanel(
      # Input: Select  template ----
      selectInput(inputId = "template", 
                  label = "Select .nii brain template on which to display results:", 
                  choices = c("MNI152_T1_1mm_brain","MNI152NLin2009cAsym 1mm","MNI52Lin 2mm","MNI152NLin2009cAsym 2mm"), selected = "MNI152_T1_1mm_brain"),
      # Input: Select overlay  ----
      selectizeInput(inputId = 'file0', 
                     label = 'Select .nii overlay on which to display to display on overlay:', 
                     choices = c("Example1"),
                     options = list(
                       placeholder = 'Please select an option below',
                       onInitialize = I('function() { this.setValue("NULL"); }')
                     )),
      # Input: Or upload a file a file ----
      fileInput(inputId = "file1", 
                label = "Or upload your own .nii overlay on which to display to display on overlay:",
                multiple = FALSE,
                accept = c(".gz", ".nii.gz")),
      # Horizontal line ----
      tags$hr(),
      sliderInput(inputId = "threshold", 
                  label = "Threshold overlay (Keep top X% of voxels)", 
                  min=0.01, max=0.99, value= c(0.5)),
      sliderInput(inputId = "slice_x", 
                  label = "Slice X", 
                  min=1, max=100, value= c(70)),
      sliderInput(inputId = "slice_y", 
                  label = "Slice Y", 
                  min=1, max=100, value= c(50)),
      sliderInput(inputId = "slice_z", 
                  label = "Slice Z", 
                  min=1, max=100, value= c(80)),
      radioButtons(inputId = "view", 
                   label = "Select views", 
                   choices = c("Orthographic", "Axial")), #ortho2 cant do one view
      textInput(inputId = "text", 
                label = "4. Enter some text to be displayed", "")
    ),
    mainPanel(plotOutput("plot"), verbatimTextOutput("code"))
  )
)

# server.R ----
server <- function(input, output) { 
  template <- reactive({
    req(input$template)
    readnii(paste0('/Users/sidchopra/Dropbox/Sid/R_files/RepoNeuroVis/data/',input$template, '.nii.gz'))
  })
  overlay_effect <- reactive({
    if (is.null(input$file0) && is.null(input$file1)) {
      return(NULL)
    }
    if(!is.null(input$file1) && is.null(input$file0)) {
      reset(id = input$file0, asis = FALSE)
      inFile <- input$file1
      # need to fix, as people might want to uplod .nii files as well. fileInput seems to strip .nii.etc # see https://github.com/tidyverse/readxl/issues/85 
      file.copy(inFile$datapath,
                paste(inFile$datapath, ".nii.gz", sep="")) 
      mask <- readnii(paste(inFile$datapath, ".nii.gz", sep=""))
      mask[abs(mask)<quantile(abs(mask), input$threshold)] <- NA
      return(mask)
    }
    if(!is.null(input$file0) && is.null(input$file1)) {
      mask <- readnii(paste0('data/MNI152_effect_size.nii.gz'))
      mask[abs(mask)<quantile(abs(mask), input$threshold)] <- NA
      return(mask)
    }
  })
  
  view <- reactive({
    if(input$view == 'Orthographic') {return(c(1,3))}
    if(input$view == 'Axial') {return(c(1,1))}
  })
  output$plot <- renderPlot({
    ortho2(x          =   template(),   #Specify the background template
           y          =   overlay_effect(),     #Specify the effect you want to overlay on the template
           crosshairs = F, #Remove the cross-hairs
           bg         = "white",   #Make the background white 
           NA.x       = T,       #Do not display NA values
           col.y      = viridis::inferno(n=500), #Select the color scale. 
           xyz        = c(input$slice_x,input$slice_y,input$slice_z), #set the x y & z slice you want to visualize
           useRaster  = T,     #Sometimes using Raster makes for clearer plots
           ycolorbar  = TRUE,  #Add a color bar
           mfrow      =   view() 
    )  
  })
  output$code<- renderText({
    glue("## you need the following package(s) to generate the plot:\n",
         "library(neurobase)\n\n",
         '## the code below read in your .nii or .nii.gz files in R:\n',
         '## remember to chage the file paths to where your .nii files are locally stored',
         "template = readnii('/file/path/to/template.nii.gz')\n",
         "overlay = readnii('/file/path/to/overlay.nii.gz')\n\n",
         "## the code below will threshold our overlay file to top X% of voxels:\n",
         "overlay[abs(overlay)<quantile(abs(overlay), {input$threshold})] <- NA \n\n",
         "## the code below generates the voxel plot:\n",
         "ortho2(  x = template,   #Specify the background template   
               y          = overlay,    #Specify the effect you want to overlay on the template
               crosshairs = FALSE,      #Remove the cross-hairs
               bg         = 'white',    #Make the background white 
               NA.x       = TRUE,       #Do not display NA values
               col.y      = viridis::inferno(n=500), #Select the color scale. 
               xyz        = c({input$slice_x},{input$slice_y},{input$slice_z}), #set the x y & z slice you want to visualize
               useRaster  = TRUE,     #Sometimes using Raster makes for clearer plots
               ycolorbar  = TRUE,     #Add a color bar
               mfrow      =   (1,3)") #fix view
    
  })
}

#https://github.com/gertstulp/ggplotgui/blob/master/R/ggplot_shiny.R


# Run the app ----
shinyApp(ui = ui, server = server)