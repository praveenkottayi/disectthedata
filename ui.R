library(shiny)
library(shinythemes)

narrowSidebar <- HTML('<style>.span16 {min-width: 265px; max-width: 265px; }</style>')

# Define UI for dataset viewer application
fluidPage(
  theme = shinytheme("superhero"), #superhero
  # Application title.
  titlePanel("TCS : Demo data analytics"),
  

  sidebarLayout(
    sidebarPanel( tags$head(narrowSidebar),
      
      selectInput("dataset", "Choose a dataset:", 
                  choices = c("rock", "pressure", "cars")),
                  #choices = list.files(pattern = ".csv")) ,
      
      #############################################
      helpText("-----------------------------------"), 
      
      numericInput("obs", "Histogram of which attribute to view:", 1),
      
      helpText("Note: After updating , please open histogram tab"),
      
      submitButton("View Histogram"),
      
      sliderInput("Attributes",
                  "Number of bins for histogram:",
                  min = 1,
                  max = 100,
                  value = 10),
      #############################################
      helpText("-----------------------------------"),
      selectInput("scatterplotX", "Choose X-axis:", 
                  choices = 1:5),
      
      selectInput("scatterplotY", "Choose Y-axis:", 
                  choices = 1:5),
      
      submitButton("View Scatter plot"),
      
      #############################################
      
      
      
      width = 3
    ),
    
   
    
    # Show a summary of the dataset and an HTML table with the
    # requested number of observations. Note the use of the h4
    # function to provide an additional header above each output
    # section.
    mainPanel(
      tabsetPanel(
        
        tabPanel("Sample data",
                 h4("Observations"),
                 tableOutput("view")),
        
        tabPanel("Summary",
        h4("Summary"),
        verbatimTextOutput("summary"),
        h4("number of attributes"),
        verbatimTextOutput("numberofattributes")),
        
        
        
        
        tabPanel("Exploratory: Histogram",
        plotOutput("histogram")),
        
        tabPanel("Exploratory: Scatterplot",
                 plotOutput("scatterplot"),
                 h4("Correlation coefficient "),
                 verbatimTextOutput("correlation")
                 
                 
        ),
        
        tabPanel("correlation matrix",
                 plotOutput("corrmat")
                 
                 
                 
        )
      
    )
  )
)
)