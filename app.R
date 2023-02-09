library(shiny)
library(shinyLP)
library(xtable)
library(htmlTable)
library(faq)
#library(rsconnect)
#deployApp()


#Directions
df <- data.frame(
  question = c("What is this?",
               "Why should I use this?",
               "How should I use this?",
               "Are there other brain vis packages/library I can use?"),
  answer = c("<p><font color='black' face='Verdana, Geneva, sans-serif' size='+1'>
             This FAQ page links to two web-apps that help you create R and Python
             code templates for visualizing human brain imaging data. These apps let
             you choose basic visual properties for your visualization and generate
             code that you can edit and use in R or Python to create the visualization.
             You can use these apps to create visualizations for voxel, region, vertex,
             and edge-level data</p>",
             "<p><font color='black' face='Verdana, Geneva, sans-serif' size='+1'>
            Visualizing data from human brain research is important for better understanding
            and sharing scientific findings. In the past, brain visualizations were created
            using graphical user interfaces where users manually adjusted settings. This process
            was often not reproducible, tedious, and impractical for large datasets. Nowadays,
            most brain data analyses are done in programming environments such as R, Python,
            and MATLAB, and there are tools available to create brain visualizations using code.
            However, these tools can be challenging for beginners to access. This web app
            provides code templates as a starting point for beginners to create their own
            visualizations.</p>",
             "<p><font color='black' face='Verdana, Geneva, sans-serif' size='+1'>
             Once you know what type of data you want to plot (voxel, region, vertex, or edge),
            go to the appropriate tab and change the available settings to see what options are
            available. Only a few options are provided on purpose, so you can explore more options
            in your own programming environment. You can copy the generated code and paste it
            into your programming environment. After editing the file and data paths, you can
            start creating your own visualizations and share your code with your paper.</p>",
             "<p><font color='black' face='Verdana, Geneva, sans-serif' size='+1'>
             Yes! These web-apps only use a limited set of tools. There are many more options
            available. Check out the table in this repository for more options in
            R, Python, and MATLAB: https://github.com/sidchop/RepoNeuroVis. </p>")
)

  # Include a fliudPage above the navbar to incorporate a icon in the header
  # Source: http://stackoverflow.com/a/24764483
 ui <-  fluidPage(jumbotron("BrainCode", "Generate code templates for programmatic human brain visualizations in R and Python.",
                      button = FALSE),

           # tags$style(HTML('
          #            .thumbnail {
          #            height: 500px;}')),
            fluidRow(
              column(6, thumbnail_label(image = 'R_logo.png', label = '',
                                        content = 'Generate brain visualization code templates for R!',
                                        button_link = 'https://sidchop.shinyapps.io/braincoder/', button_label = 'Click me')
              ),
              column(6,thumbnail_label(image = 'py_logo.svg', label = '',
                                        content = 'Generate brain visualization code templates for Python!',
                                        button_link = 'https://sidchop.shinyapps.io/braincodepy/', button_label = 'Click me')),
           #   column(4, thumbnail_label(image = ' ', label = '?',
            #                            content = 'Learn more about code-based brain visualizations!',
            #                            button_link = 'https://github.com/sidchop/RepoNeuroVis/blob/main/manuscript.pdf', button_label = 'Click me'))

            ),
          hr(),
            fluidRow(
              column(6, panel_div(class_type = "primary", panel_title = "FAQ",
                                  content = faq(df, width = 700))),
              column(6, panel_div("success", "Feedback",
                                  HTML("These apps are still in development and
                                  I would love feedback! Please first read the FAQ section then either raise create an issue on the GitHub page or
                                  Email Me: <a href='mailto:sidhant.chopra@yale.edu?Subject=Shiny%20Help' target='_top'>Sidhant Chopra</a>"))))
            )

server <- function(input, output, session) {



 }
# Define server logic
shinyApp(ui = ui, server = server)



#HTML(print(xtable(df, align="lll"),
#type="html", html.table.attributes=""))
